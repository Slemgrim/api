part of recipr_api;

class Recipe {

  static const INDEX = 'recipes';

  int id;

  @ApiProperty(required: true)
  String title;

  String slug;

  Recipe(){

  }

  Recipe.fromJson(Map map){
    id = map['_id'];
    title = map['title'];
    slug = map['slug'];
  }

  Map toMap(){
   return {
     '_id': id,
     'title': title,
     'slug': slug
    };
  }
}