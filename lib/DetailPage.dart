import 'package:api_example_flutter/post_model.dart';
import 'package:flutter/material.dart';


class DetailPage extends StatelessWidget{
  Articles thisArticle;

  DetailPage(this.thisArticle);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sports'),
      ),
      body: Column(
        children: [
          Image.network('${thisArticle.urlToImage}'),
          Text('${thisArticle.title}', style: TextStyle(fontSize: 25),),
          Text('${thisArticle.content}', style: TextStyle(fontSize: 25),),

        ],
      ),
    );
  }
}