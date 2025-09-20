part of 'models.dart';

class AuthExceptionModel extends Equatable {
  const AuthExceptionModel({
    this.message,
    this.errors,
  });

  final String? message;
  final AuthErrors? errors;

  factory AuthExceptionModel.fromJson(Map<String, dynamic> json) =>
      AuthExceptionModel(
        message: json["message"],
        errors: json["errors"] == null
            ? null
            : AuthErrors.fromJson(json["errors"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "errors": errors?.toJson(),
      };

  @override
  List<Object?> get props => [message, errors];
}

class AuthErrors {
  final List<String>? name;
  final List<String>? password;
  final List<String>? email;
  final List<String>? username;
  final List<String>? dateOfBirth;
  final List<String>? profilePic;

  AuthErrors({
    this.name,
    this.password,
    this.email,
    this.username,
    this.dateOfBirth,
    this.profilePic,
  });

  factory AuthErrors.fromJson(Map<String, dynamic> json) => AuthErrors(
        name: json["name"] == null
            ? []
            : List<String>.from(json["name"]!.map((x) => x)),
        password: json["password"] == null
            ? []
            : List<String>.from(json["password"]!.map((x) => x)),
        email: json["email"] == null
            ? []
            : List<String>.from(json["email"]!.map((x) => x)),
        username: json["username"] == null
            ? []
            : List<String>.from(json["username"]!.map((x) => x)),
        dateOfBirth: json["dateofbirth"] == null
            ? []
            : List<String>.from(json["dateofbirth"]!.map((x) => x)),
        profilePic: json["profile_pic"] == null
            ? []
            : List<String>.from(json["profile_pic"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? [] : List<dynamic>.from(name!.map((x) => x)),
        "password":
            password == null ? [] : List<dynamic>.from(password!.map((x) => x)),
        "email": email == null ? [] : List<dynamic>.from(email!.map((x) => x)),
        "username":
            username == null ? [] : List<dynamic>.from(username!.map((x) => x)),
        "dateofbirth": dateOfBirth == null
            ? []
            : List<dynamic>.from(dateOfBirth!.map((x) => x)),
        "profile_pic": profilePic == null
            ? []
            : List<dynamic>.from(profilePic!.map((x) => x)),
      };
}
