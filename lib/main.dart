import 'dart:convert';

import 'package:api_example_flutter/DetailPage.dart';
import 'package:api_example_flutter/post_model.dart';
import 'package:api_example_flutter/wallpapers_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: WallpaperPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  var searchController = TextEditingController();

  var arrCat = [
    'business',
    'entertainment',
    'general',
    'health',
    'science',
    'sports',
    'technology'
  ];

  late Future<NewsModel> futureNews;

  @override
  void initState() {
    super.initState();
    futureNews = getNews('india', 2);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("API"),
        ),
        body: FutureBuilder<NewsModel>(
          future: futureNews,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print('Res: ${snapshot.data.toString()}');
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 7,
                            child: TextField(
                              controller: searchController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: 'Search',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11)
                                )
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                              child: InkWell(
                                onTap: (){
                                  var searchQuery = searchController.text.toString();
                                  futureNews = getNews(searchQuery, 2);
                                  setState((){

                                  });
                                },
                                  child: Icon(Icons.search)))
                        ],
                      ),
                    ),
                    /*Wrap(
                      crossAxisAlignment: WrapCrossAlignment.end,
                      children: arrCat
                          .map((cat) => InkWell(
                        onTap: (){
                          futureNews = getNews(cat, 1);
                          setState((){

                          });
                        },
                        child: Card(
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('$cat'),
                            )),
                      ))
                          .toList(),
                    ),*/
                    Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetailPage(snapshot.data!.articles![index]),
                                    ));
                              },
                              child: Card(
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                          borderRadius: BorderRadius.circular(21),
                                          child: Visibility(
                                            visible: snapshot.data!.articles![index]
                                                    .urlToImage !=
                                                null,
                                            child: Image.network(
                                                '${snapshot.data!.articles![index].urlToImage}'),
                                          )),
                                      ListTile(
                                        leading: Text('${index + 1}'),
                                        title: Text(
                                            '${snapshot.data!.articles![index].title}'),
                                        subtitle: Text(
                                            '${snapshot.data!.articles![index].description}'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          itemCount: snapshot.data!.articles!.length,
                        ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return CircularProgressIndicator();
          },
        ));
  }

  Future<NewsModel> getNews(String value, int flag) async {
    var myURL = "";
    if(flag==1) {
      myURL = "https://newsapi.org/v2/top-headlines?country=in&category=$value&apiKey=aca5d188019243e480b7ad7b7cbfdc9c";
    } else {
    myURL = 'https://newsapi.org/v2/everything?q=$value&from=2022-08-20&sortBy=publishedAt&apiKey=aca5d188019243e480b7ad7b7cbfdc9c';
    }

    var response = await http.get(Uri.parse(myURL));

    if (response.statusCode == 200) {
      var news = jsonDecode(response.body);
      return NewsModel.fromJson(news);
    } else {
      print("Could not fetch News due to ${response.statusCode}");
      return NewsModel();
    }
  }
}
