import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:user_login/home_screen.dart';
import 'package:user_login/register_user.dart';
import 'package:user_login/utilities/user.dart';

class UserInfo extends StatefulWidget {
  String name;
  UserInfo({Key? key,required this.name}) : super(key: key);

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {

  late Box<dynamic> box;
  List<String> data = [];
  bool loaded = false;

  Future<void> loadDataFromDB() async {

    box = await Hive.openBox('testBox');

    var temp = box.get(widget.name);

    String s = temp.toString();

    print('DATA: $s');

    data = s.split(" ");

    setState(() {
      loaded = true;
    });

  }

  @override
  void initState(){
    super.initState();
    loadDataFromDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    HomeScreen(DBLoaded: true,),
          ),),
          child: Icon(Icons.arrow_back_sharp,color: Colors.white,),
        ),
        title: const Text('User Screen'),
      ),

      body:loaded? Center(
        child: SingleChildScrollView(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              const SizedBox(height: 30,),

              const Icon(Icons.person,size: 60,),

              const SizedBox(height: 20,),

              Text(data[0],style: const TextStyle(color: Colors.black, fontSize: 30.0),),

              const SizedBox(height: 50,),

              Text("Age: ${data[1]} Years",style: const TextStyle(color: Colors.black, fontSize: 30.0),),
              const SizedBox(height: 20,),
              Text(data[2],style: const TextStyle(color: Colors.black, fontSize: 30.0),),




            ],
          ),
        ),
      ):const Center(child: CircularProgressIndicator(),),
    );
  }
}
