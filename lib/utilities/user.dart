import 'package:hive/hive.dart';
part 'user.g.dart';

@HiveType(typeId: 1)
class User {
  User({required this.name, required this.age, required this.gender});

  @HiveField(0)
  String name;

  @HiveField(1)
  int age;

  @HiveField(2)
  String gender;

  @override
  String toString() {
    return '$name $age $gender';
  }
}