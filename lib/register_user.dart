import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:user_login/register_user.dart';
import 'package:user_login/user_info.dart';
import 'package:user_login/utilities/user.dart';

class RegisterUser extends StatefulWidget {
  String name;
  RegisterUser({Key? key,required this.name}) : super(key: key);

  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {

  List<String> genders = ["Male","Female","Other"];
  String? _currentSelectedValue;

  String gender = "";
  String age = "";

  bool _genderValidate = true;
  bool _ageValidate = true;

  late Box<dynamic> box;

  Future<void> loadDataFromDB() async {


    box = await Hive.openBox('testBox');


  }

  void register(){
    if(gender == "") {
      setState(() {
        _genderValidate = false;
      });
    }
    if(age == "") {
      setState(() {
        _ageValidate = false;
      });
    }

    if(gender!="" && age!=""){
      setState(() {
        _genderValidate = true;
        _ageValidate = true;
      });

      User user = User(
        name: widget.name,
        age: int.parse(age),
        gender: gender,
      );

      box.put(widget.name, user);
      print(box.get(widget.name));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
          UserInfo(name: widget.name),
        ),);

    }
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
        title: const Text('Register User'),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            SizedBox(height: 30,),

             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 const Icon(Icons.person,size: 30,),
                 const SizedBox(width: 5,),
                 Text(widget.name,style: const TextStyle(color: Colors.black, fontSize: 30.0),),
               ],
             ),

            SizedBox(height: 30,),

             Padding(
              padding: const EdgeInsets.all(8.0),
              child: FormField<String>(
                builder: (FormFieldState<String> state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                        labelStyle: const TextStyle(color: Colors.black, fontSize: 16.0),
                        errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 16.0),
                        labelText: 'Enter Age',
                        errorText: _ageValidate?null:'Field can\'t be empty',
                        hintStyle: const TextStyle(color: Colors.black, fontSize: 12.0),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
                    isEmpty: _currentSelectedValue == '',
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value){
                        age = value;
                      },
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 10,),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FormField<String>(
                builder: (FormFieldState<String> state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                        labelStyle: const TextStyle(color: Colors.black, fontSize: 16.0),
                        errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 16.0),
                        labelText: 'Please select gender',
                        errorText: _genderValidate?null:'Field can\'t be empty',
                        hintStyle: const TextStyle(color: Colors.black, fontSize: 12.0),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
                    isEmpty: _currentSelectedValue == '',
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _currentSelectedValue,
                        isDense: true,
                        onChanged: (String? newValue) {
                          setState(() {
                            _currentSelectedValue = newValue!;
                            gender = newValue;
                            state.didChange(newValue);
                          });
                        },
                        items: genders.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 10,),

            ElevatedButton(onPressed: () => register(), child: const Text('REGISTER',style: TextStyle(letterSpacing: 2,color: Colors.white),))

          ],
        ),
      ),
    );
  }
}
