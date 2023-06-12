class User {
  String? id;
  String? email;
  String? name;
  String? password;
  String? otp;
  String? datereg;

  User({this.id, this.email, this.name, this.password, this.otp, this.datereg});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    password = json['password'];
    otp = json['otp'];
    datereg = json['datereg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['name'] = name;
    data['password'] = password;
    data['otp'] = otp;
    data['datereg'] = datereg;
    return data;
  }
}
