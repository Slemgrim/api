part of recipr_api;

abstract class AbstractHandler {
  Db db;
  ElasticSearch es;

  AbstractHandler(this.db, this.es);
}