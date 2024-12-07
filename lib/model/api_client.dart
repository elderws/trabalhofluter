import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'Hino.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: "http://overclock.kinghost.net:21055")
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET("/hinos")
  Future<List<Hino>> fetchHinos();
}