class User {
  final String email;
  final String password;  // It's better to store a hashed password securely
  final String userId;    // Store _id as userId

  User({required this.email, required this.password, required this.userId});

  // Factory constructor to create a User instance from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],         // Default to an empty string if null
      password: json['password'] ,   // Default to an empty string if null
      userId: json['_id'] ,          // Map _id to userId
    );
  }

  // Convert the User instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      '_id': userId,                      // Convert userId back to _id for JSON
    };
  }
}


class AuthResponse {
  final String token;


  AuthResponse(
      {required this.token,});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'],

     
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      
    };
  }
}
