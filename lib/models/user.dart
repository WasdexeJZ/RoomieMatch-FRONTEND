class User {
//   static User? _instance;
  final String id;
  String? name;
  String email;

  User({required this.id, this.name, required this.email});

//   User? getInstance(String inputId, String inputName, String inputEmail) {
//     if (_instance == null) {
//       User(id: inputId, name: inputName, email: inputEmail);
//     }

//     return _instance;
//   }

//   void clearInstance() {
//     _instance = null;
//   }

  String get getId => id;
  String get getName => name ?? "";
  String get getEmail => email;

  set setName(String name) {
    this.name = name;
  }

  set setEmail(String email) {
    this.email = email;
  }
}
