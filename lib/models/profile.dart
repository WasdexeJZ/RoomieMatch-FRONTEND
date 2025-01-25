import 'package:hive/hive.dart';

part 'profile.g.dart'; // Generated file

@HiveType(typeId: 2)
class Profile {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  String firstName = "";

  @HiveField(2)
  String lastName = "";

  @HiveField(3)
  int age = 0;

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
  
  Profile({required this.userId, });
}