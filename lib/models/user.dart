import 'package:hive/hive.dart';

part 'user.g.dart'; // Generated file

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  String username;

  @HiveField(2)
  String email;

  User({required this.userId, required this.username, required this.email});
}