import 'dart:io';
import 'package:rpc/rpc.dart';
import 'package:recipr_api/recipr_api.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:elastic_dart/elastic_dart.dart';

final ApiServer _apiServer = new ApiServer(prettyPrint: true);
final Db db = new Db("mongodb://localhost:27017");
final ElasticSearch es = new ElasticSearch("http://localhost:9200");

main() async {
  _apiServer.addApi(new ReciprApi(db, es));
  _apiServer.enableDiscoveryApi();

  HttpServer server = await HttpServer.bind(InternetAddress.ANY_IP_V4, 1337);
  server.listen(_apiServer.httpRequestHandler);
}