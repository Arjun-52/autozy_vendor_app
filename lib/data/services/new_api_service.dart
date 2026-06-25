import 'dart:io';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import '../../core/network/api_client.dart';

import '../../core/constants/api_endpoints.dart';

part 'new_api_service.g.dart';

/// New API Service using Dio and Retrofit
/// Currently set up for future API integration
@RestApi()
abstract class NewApiService {
  factory NewApiService() => _NewApiService(ApiClient().dio);

  @POST(ApiEndpoints.uploadImage)
  @MultiPart()
  Future<dynamic> uploadImage(@Part(name: 'file') File file);

  /// Authentication endpoints
  @POST(ApiEndpoints.sendOtp)
  Future<dynamic> sendOtp(@Body() Map<String, dynamic> data);

  @POST(ApiEndpoints.verifyOtp)
  Future<dynamic> verifyOtp(@Body() Map<String, dynamic> data);

  @POST(ApiEndpoints.refreshToken)
  Future<dynamic> refreshToken(@Body() Map<String, dynamic> data);

  /// Jobs/Inspections endpoints
  @GET('/jobs')
  Future<dynamic> getJobs();

  @GET('/inspections')
  Future<dynamic> getInspections();

  @GET('/api/v1/inspections/queue')
  Future<dynamic> getInspectionQueue();

  @GET(ApiEndpoints.specialistJobs)
  Future<dynamic> getSpecialistJobs(@Query('date') String date);

  @POST('/api/v1/specialist/jobs/{id}/accept')
  Future<dynamic> acceptSpecialistJob(@Path('id') String id);

  @POST('/api/v1/specialist/jobs/{id}/start')
  Future<dynamic> startSpecialistJob(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @POST('/api/v1/specialist/jobs/{id}/before-photos')
  Future<dynamic> uploadSpecialistBeforePhotos(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @POST('/api/v1/specialist/jobs/{id}/after-photos')
  Future<dynamic> uploadSpecialistAfterPhotos(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @POST('/api/v1/specialist/jobs/{id}/complete')
  Future<dynamic> completeSpecialistJob(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @GET(ApiEndpoints.addonServices)
  Future<dynamic> getAddonServices();

  @GET(ApiEndpoints.myAddonBookings)
  Future<dynamic> getMyAddonBookings(
    @Query('page') int page,
    @Query('limit') int limit,
  );

  @GET(ApiEndpoints.adminServiceRecords)
  Future<dynamic> getAdminServiceRecords();

  @GET(ApiEndpoints.adminInspections)
  Future<dynamic> getAdminInspections();

  @GET(ApiEndpoints.washHistory)
  Future<dynamic> getWashHistory(
    @Query('page') int page,
    @Query('limit') int limit,
  );

  @GET('/api/v1/inspections/subscription/{subscriptionId}')
  Future<dynamic> getInspectionBySubscription(
    @Path('subscriptionId') String subscriptionId,
  );

  @POST('/jobs/{id}/status')
  Future<dynamic> updateJobStatus(
    @Path('id') String id,
    @Body() Map<String, dynamic> data,
  );

  @POST('/inspections/{id}/flag')
  Future<dynamic> flagInspection(@Path('id') String id);

  @POST('/inspections/{id}/photos')
  Future<dynamic> addPhoto(@Path('id') String id);

  @POST('/api/v1/inspections/{id}/claim')
  Future<dynamic> claimInspection(@Path('id') String id);

  @POST('/api/v1/inspections/{id}/start')
  Future<dynamic> startInspection(@Path('id') String id);

  @POST('/api/v1/inspections/{id}/complete')
  Future<dynamic> completeInspection(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @POST('/api/v1/inspections/{id}/fail')
  Future<dynamic> failInspection(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @POST('/api/v1/service/{id}/comments')
  Future<dynamic> addComment(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @POST(ApiEndpoints.staffAttendance)
  Future<dynamic> markAttendance(@Body() Map<String, dynamic> body);

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
