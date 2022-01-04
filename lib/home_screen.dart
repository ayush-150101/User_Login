import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:user_login/widgets/name_tile.dart';
import 'package:user_login/utilities/user.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';


class HomeScreen extends StatefulWidget {
  bool DBLoaded;
  HomeScreen({Key? key,required this.DBLoaded}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List jsonData;
  List<NameTile> tiles = [];
  bool dataLoaded = false;

  void loadDB() async{
    var path = await getApplicationDocumentsDirectory();
    Hive
      ..init(path.path)
      ..registerAdapter(UserAdapter());

  }


  ///Loading data from json file stored in local storage
  Future<void> loadJsonData() async {



    var jsonText = await rootBundle.loadString('assets/user_data.json');
    setState(() => jsonData = json.decode(jsonText));

    //print(jsonData[0]['users']);

    /*jsonData[0]['users'].forEach((element) {
      print(element['name']);
    });*/
    //print(jsonData);
  }

  void loadData() async{
    await getPermissions();
    await loadJsonData();

   // print(jsonData);

    jsonData[0]['users'].forEach((element) {
      tiles.add(NameTile(name: element['name']));
    });
    
    setState(() {
      dataLoaded = true;
    });
  }

   Future<void> getPermissions() async{
    await [
      Permission.storage,
    ].request();
  }

  @override
  void initState() {
    super.initState();
    loadData();
    widget.DBLoaded?null:loadDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Login Page'),
      ),
      
      body: dataLoaded?ListView.builder(
          itemCount: tiles.length,
          itemBuilder: (context, index){
            return  tiles[index];
          }

      ):const Center(child: CircularProgressIndicator()),
    );
  }
}
