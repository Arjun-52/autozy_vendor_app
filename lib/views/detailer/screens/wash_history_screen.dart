import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_styles.dart';
import '../../../viewmodels/wash_history_viewmodel.dart';

class WashHistoryScreen extends StatefulWidget {
  const WashHistoryScreen({super.key});

  @override
  State<WashHistoryScreen> createState() => _WashHistoryScreenState();
}

class _WashHistoryScreenState extends State<WashHistoryScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WashHistoryViewModel>().fetchHistory(refresh: true);
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final vm = context.read<WashHistoryViewModel>();
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      vm.fetchHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<WashHistoryViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Wash History",
          style: AppStyles.subHeading,
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => vm.fetchHistory(refresh: true),
        child: _buildBody(vm),
      ),
    );
  }

  Widget _buildBody(WashHistoryViewModel vm) {
    if (vm.isLoading && vm.records.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      );
    }

    if (vm.error != null && vm.records.isEmpty) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 16),
              const Text(
                "Failed to load history",
                style: AppStyles.subHeading,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => vm.fetchHistory(refresh: true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      );
    }

    if (vm.records.isEmpty) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.history_toggle_off,
                size: 64,
                color: AppColors.textPrimary.withOpacity(0.4),
              ),
              const SizedBox(height: 16),
              const Text(
                "No completed washes found",
                style: AppStyles.subHeading,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "Your completed wash history will appear here.",
                style: AppStyles.caption.copyWith(color: AppColors.textPrimary.withOpacity(0.6)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: vm.records.length + (vm.isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == vm.records.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary))),
          );
        }

        final record = vm.records[index];
        final isCNA = record.status?.toLowerCase() == 'cna';

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE9E9E9), width: 1),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF161616).withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    record.vehicle ?? 'Unknown Vehicle',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isCNA
                          ? Colors.orange.withOpacity(0.1)
                          : const Color(0xff008847).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isCNA ? Colors.orange : const Color(0xff008847),
                      ),
                    ),
                    child: Text(
                      isCNA ? 'CNA' : 'Completed',
                      style: TextStyle(
                        color: isCNA ? Colors.orange : const Color(0xff008847),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (record.completedAt != null || record.serviceDate != null)
                Text(
                  record.completedAt ?? record.serviceDate ?? '',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xff7E8392),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              if (isCNA && record.cnaStatus != null) ...[
                const SizedBox(height: 8),
                Text(
                  "Reason: ${record.cnaStatus}",
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
