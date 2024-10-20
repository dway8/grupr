import 'dart:io';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:grupr/core/resources/data_state.dart';

abstract class BaseRepository {
  Future<DataState<TDomain>> handleRequest<TModel, TDomain>(
      Future<HttpResponse<TModel>> Function() request,
      TDomain Function(TModel) transform,
      {required String requestType}) async {
    try {
      print('Making "$requestType" request');
      final httpResponse = await request();

      if (httpResponse.response.statusCode == HttpStatus.ok ||
          httpResponse.response.statusCode == HttpStatus.created) {
        return DataSuccess(transform(httpResponse.data));
      } else {
        print(
            'Request failed: $requestType - Status: ${httpResponse.response.statusCode}, Message: ${httpResponse.response.statusMessage}');
        return DataFailed(
          DioException(
            error: httpResponse.response.statusMessage,
            response: httpResponse.response,
            type: DioExceptionType.badResponse,
            requestOptions: httpResponse.response.requestOptions,
          ),
        );
      }
    } on DioException catch (e) {
      print('DioException occurred during $requestType: ${e.message}');
      return DataFailed(e);
    } on SocketException catch (e) {
      print('SocketException occurred during $requestType: ${e.message}');
      return DataFailed(
        DioException(
          error: 'Please check your internet connection',
          type: DioExceptionType.connectionError,
          requestOptions: RequestOptions(),
        ),
      );
    } catch (e) {
      print('Unexpected error occurred during $requestType: $e');
      return DataFailed(
        DioException(
          error: e.toString(),
          type: DioExceptionType.unknown,
          requestOptions: RequestOptions(),
        ),
      );
    }
  }
}
