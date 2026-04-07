import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';

part 'new_api_service.g.dart';

/// New API Service using Dio and Retrofit
/// Currently set up for future API integration
@RestApi()
abstract class NewApiService {
  factory NewApiService() => _NewApiService(ApiClient().dio);

  /// Authentication endpoints
  @POST('/auth/send-otp')
  Future<dynamic> sendOtp(@Body() Map<String, dynamic> data);

  @POST('/auth/verify-otp')
  Future<dynamic> verifyOtp(@Body() Map<String, dynamic> data);

  /// Jobs/Inspections endpoints
  @GET('/jobs')
  Future<dynamic> getJobs();

  @GET('/inspections')
  Future<dynamic> getInspections();

  @POST('/jobs/{id}/status')
  Future<dynamic> updateJobStatus(
    @Path('id') String id,
    @Body() Map<String, dynamic> data,
  );

  @POST('/inspections/{id}/approve')
  Future<dynamic> approveInspection(@Path('id') String id);

  @POST('/inspections/{id}/flag')
  Future<dynamic> flagInspection(@Path('id') String id);

  @POST('/inspections/{id}/photos')
  Future<dynamic> addPhoto(@Path('id') String id);

  /// Team/Supervisor endpoints
  @GET('/team/members')
  Future<dynamic> getTeamMembers();

  @POST('/team/members/{id}/status')
  Future<dynamic> updateMemberStatus(
    @Path('id') String id,
    @Body() Map<String, dynamic> data,
  );

  @GET('/alerts')
  Future<dynamic> getAlerts();

  /// Dashboard endpoints
  @GET('/dashboard/stats')
  Future<dynamic> getDashboardStats();
}
