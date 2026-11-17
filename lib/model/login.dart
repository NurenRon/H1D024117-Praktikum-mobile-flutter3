class Login {
  int? code;
  bool? status;
  String? token;
  int? userID;
  String? userEmail;

  Login({this.code, this.status, this.token, this.userID, this.userEmail});

  factory Login.fromJson(Map<String, dynamic> obj) {
    final data = obj['data'];
    if (obj['code'] == 200 && data is Map<String, dynamic>) {
      final user = data['user'] as Map<String, dynamic>?;
      return Login(
        code: int.tryParse(obj['code'].toString()),
        status: obj['status'] as bool?,
        token: data['token']?.toString(),
        userID: user != null ? int.tryParse(user['id'].toString()) : null,
        userEmail: user?['email']?.toString(),
      );
    }
    return Login(
      code: int.tryParse(obj['code'].toString()),
      status: obj['status'] as bool?,
    );
  }
}
