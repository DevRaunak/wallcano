import 'package:flutter/material.dart';
import 'package:wallpaper/wallpaper.dart';

class DetailWallpaperPage extends StatelessWidget{
  var url;
  DetailWallpaperPage(this.url);

  late Stream<String> progressString;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
              height: double.infinity,
              child: Image.network(url, fit: BoxFit.fill,)),
          Padding(
            padding: const EdgeInsets.all(45.0),
            child: InkWell(
              onTap: (){
                Navigator.pop(context);
              },
                child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20,)),
          ),
          Positioned(
            bottom: 11,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(onPressed: () async{
            prepareWallpaper(url, context);
          }, child: Text('Set Wallpaper'),),
                ),
              ))
        ],
      ),
    );
  }
  
  
  void prepareWallpaper(String url, BuildContext context){

    //Download
    progressString = Wallpaper.imageDownloadProgress(url);

    progressString.listen((data) {
      print("Data Received $data");
    }, onDone: (){
      print('Download Complete!');
      setWallpaper(context);
    }, onError: (error){
      print(error);
    });
  }

}

 void setWallpaper(BuildContext context) async{
  var width = MediaQuery.of(context).size.width;
  var height = MediaQuery.of(context).size.height;

  await Wallpaper.homeScreen(
    options: RequestSizeOptions.RESIZE_FIT,
    width: width,
    height: height
  );

  print('Wallpaper is set!!');

 }