library recipr_api;

import 'dart:io';
import 'dart:async';
import 'package:rpc/api.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:elastic_dart/elastic_dart.dart';
import 'dart:convert';

part 'handler.dart';
part 'models/recipe.dart';
part 'handler/recipe.dart';

@ApiClass(
    version: 'v1',
    name: 'recipr'
)
class ReciprApi {

  Db db;
  ElasticSearch es;
  RecipeHandler recipeHandler;

  ReciprApi(this.db, this.es){
    recipeHandler = new RecipeHandler(db, es);
  }

  @ApiMethod(method: 'GET', path: 'recipe/{id}')
  Future<Recipe> getRecipe(int id) => recipeHandler.getById(id);

  @ApiMethod(method: 'PUT', path: 'recipe/add')
  Future<Recipe> createRecipe(Recipe recipe) => recipeHandler.create(recipe);

  @ApiMethod(method: 'GET', path: 'recipe/search/{search}')
  Future<List<Recipe>> searchRecipe(String search) => recipeHandler.search(search);
}
