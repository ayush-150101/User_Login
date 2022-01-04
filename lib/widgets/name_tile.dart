import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:user_login/register_user.dart';
import 'package:user_login/user_info.dart';
import 'package:user_login/utilities/user.dart';

class NameTile extends StatefulWidget {
  String name;
  NameTile({Key? key,required this.name}) : super(key: key);

  @override
  _NameTileState createState() => _NameTileState();
}

class _NameTileState extends State<NameTile> {

  bool signIn = false;
  bool loaded = false;
  late Box<dynamic> box;

  Future<void> loadDataFromDB() async {


    box = await Hive.openBox('testBox');

    print(box.containsKey(widget.name));

    if(box.containsKey(widget.name)) {
      signIn = true;
    } else {
      signIn = false;
    }

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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
          borderRadius: BorderRadius.circular(20),
          elevation: 20,
          child: loaded?GestureDetector(
            onTap: () {
              if(signIn){
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    UserInfo(name: widget.name),
                  ),);
              }else{
                setState(() {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            RegisterUser(name: widget.name,)
                    ),);

                });
              }
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              width: MediaQuery.of(context).size.width * 0.8,
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10,0,0,0),
                    child: Row(
                      children: [
                        const Icon(Icons.person),
                        const SizedBox(width: 5,),
                        Text(widget.name,style: const TextStyle(color: Colors.black,fontSize: 18,letterSpacing: 2),),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,0,10,0),
                    child: ElevatedButton(onPressed: () {
                      if(signIn){
                        setState(() {
                          signIn = !signIn;
                          box.delete(widget.name);
                        });
                      }else{
                        setState(() {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RegisterUser(name: widget.name,)
                            ),);

                        });
                      }
                    }, child: Text(signIn?'Sign Out':'Sign In',style: const TextStyle(fontSize: 18,color: Colors.white),),),
                  )
                ],
              )
            ),
          ):const Center(child: CircularProgressIndicator(),),
      ),
    );
  }
}
