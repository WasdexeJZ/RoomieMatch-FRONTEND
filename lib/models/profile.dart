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
  String birthday = "00/00/0000";

  @HiveField(4)
  String gender = "";

  @HiveField(5)
  String latitude = "";

  @HiveField(6)
  String longitude = "";

  @HiveField(7)
  int budget = 0;
  
  @HiveField(8)
  String job = "";
  
  @HiveField(9)
  String allergies = "";
  
  Profile();
}