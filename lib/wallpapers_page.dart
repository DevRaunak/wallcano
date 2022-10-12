import 'dart:convert';

import 'package:api_example_flutter/detail_wallpaper_page.dart';
import 'package:api_example_flutter/wallpaper_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

class WallpaperPage extends StatefulWidget {
  @override
  State<WallpaperPage> createState() => _WallpaperPageState();
}

class _WallpaperPageState extends State<WallpaperPage> {
  var myKey = "563492ad6f91700001000001e3b48b07221244d8b5914a10e4185b46";

  var searchController = TextEditingController();

  var arrItems = ['item1', 'item2', 'item3', 'item4'];

  late Future<WallpaperModel> wallpapers;

  @override
  void initState() {
    super.initState();
    wallpapers = getWallpaper('car');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 240,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Extended App Bar'),
              background: Image.network(
                  'https://images.pexels.com/photos/9452131/pexels-photo-9452131.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800'),
              centerTitle: true,
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            titleSpacing: 2,
            pinned: true,
            floating: true,
            snap: true,
            elevation: 5,
            actions: [
              PopupMenuButton(
                tooltip: 'Settings',
                splashRadius: 134,
                position: PopupMenuPosition.over,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(21)
                ),
                itemBuilder: (context) =>
                    arrItems.map((e) =>
                        PopupMenuItem(child: Text(e),enabled: true,)).toList(),
              )
            ],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(21),
                    bottomRight: Radius.circular(21)),
                side: BorderSide(color: Colors.white, width: 2)),
          ),
        ],
        body: FutureBuilder<WallpaperModel>(
          future: wallpapers,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print('${snapshot.data!.photos![0].src!.portrait}');
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                              hintText: 'Search..',
                              suffixIcon: InkWell(
                                onTap: () {
                                  wallpapers = getWallpaper(
                                      searchController.text.toString());
                                  setState(() {});
                                },
                                child: Icon(Icons.search),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(21))),
                        ),
                      ))
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailWallpaperPage(
                                      '${snapshot.data!.photos![index].src!.portrait}'),
                                ));
                          },
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(21),
                              child: Image.network(
                                  '${snapshot.data!.photos![index].src!.portrait}')),
                        ),
                      ),
                      itemCount: snapshot.data!.photos!.length,
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return CircularProgressIndicator();
          },
        ),
      ),
      drawer: myDrawer(),
    );
  }

  Future<WallpaperModel> getWallpaper(String myQuery) async {
    var myURL = "https://api.pexels.com/v1/search?query=$myQuery&color=orange";

    var response =
        await http.get(Uri.parse(myURL), headers: {'Authorization': myKey});

    if (response.statusCode == 200) {
      var news = jsonDecode(response.body);
      return WallpaperModel.fromJson(news);
    } else {
      print("Could not fetch Wallpapers due to ${response.statusCode}");
      return WallpaperModel();
    }
  }
}

class myDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.elliptical(43, 34),
              topRight: Radius.elliptical(35, 70))),
    );
  }
}
