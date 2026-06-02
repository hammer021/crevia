class LoginModel {
  final String userName;
  final String token;
  final String email;
  final String userId;
  final int is_verif_nohp;
  final bool kasir;
  final String nohp;
  final String no_ang;

  LoginModel(this.userName, this.token, this.email, this.userId, this.kasir,
      this.is_verif_nohp, this.nohp, this.no_ang);

  LoginModel.fromJson(Map<String, dynamic> json)
      : userName = json['user_id'] ?? '',
        token = json['access_token'] ?? '',
        email = json['user_id'] ?? '',
        userId = json['user_id'] ?? '',
        kasir = json['kasir'] ?? '',
        is_verif_nohp = json['is_verif_nohp'] ?? 0,
        no_ang = json['no_ang'] ?? '',
        nohp = json['nohp'] ?? '';

  Map<String, dynamic> toJson() => {
        'user_id': userName,
        'access_token': token,
        'kasir': kasir,
        'is_verif_nohp': is_verif_nohp,
        'nohp': nohp,
        'no_ang': no_ang,
      };
}
