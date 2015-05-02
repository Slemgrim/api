part of recipr_api;

class RecipeHandler extends AbstractHandler {

  DbCollection recipes;

  RecipeHandler(Db db, ElasticSearch es): super(db, es){
    recipes = db.collection('recipes');
  }

  Future<Recipe> create(Recipe recipe) async {
    await db.open();

    int count = await recipes.count();
    recipe.id = ++count;

    recipes.insert(recipe.toMap());
    db.close();

    es.bulk([
      {"index": {"_index": Recipe.INDEX, "_type": "recipe", "_id": recipe.id} },
      recipe.toMap(),
    ]);

    return recipe;
  }

  Future<Recipe> getById(int id) async {
    Completer completer = new Completer();
    await db.open();

    var result = await recipes.findOne({'_id': id});

    if(result == null){
      throw new NotFoundError('recipe not found');
    }

    completer.complete(new Recipe.fromJson(result));

    db.close();
    return completer.future;
  }

  Future<List<Recipe>> search(String search) async {
    List<Recipe> recipes = new List<Recipe>();

    Map result = await es.search(index: Recipe.INDEX, query: {
      "query": {
        "match": {"title": search}
      }
    });

    result['hits']['hits'].forEach((recipe){
      recipes.add(new Recipe.fromJson(recipe['_source']));
    });

    return recipes;
  }
}