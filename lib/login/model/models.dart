class User {
  final String email;
  final String password;  
  final String userId;   

  User({required this.email, required this.password, required this.userId});

  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],       
      password: json['password'] , 
      userId: json['_id'] ,      
    );
  }

 
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      '_id': userId,                     
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
