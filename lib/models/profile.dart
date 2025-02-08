import 'package:hive/hive.dart';

part 'profile.g.dart'; // Generated file

@HiveType(typeId: 2)
class Profile {
  @HiveField(0)
  String firstName = "";

  @HiveField(1)
  String lastName = "";

  @HiveField(2)
  int age = 0;

  @HiveField(3)
  String gender = "";

  @HiveField(4)
  String latitude = "";

  @HiveField(5)
  String longitude = "";

  @HiveField(6)
  int budget = 0;
  
  @HiveField(7)
  String job = "";
  
  @HiveField(8)
  String allergies = "";
  
  Profile();
}