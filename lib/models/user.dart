import 'package:hive/hive.dart';

part 'user.g.dart'; // Generated file

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  String email;

  @HiveField(2)
  String username;

  User({required this.userId, required this.email, required this.username});
}