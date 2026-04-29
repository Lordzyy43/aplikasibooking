class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phone; // Pakai ? karena kadang user belum isi nomor HP
  final String? avatarUrl;
  final int walletBalance;
  final int points;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatarUrl,
    this.walletBalance = 0, // Default 0 jika tidak ada data
    this.points = 0, // Default 0 jika tidak ada data
  });

  // Fungsi tambahan: Agar gampang convert dari data API (JSON) nantinya
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      avatarUrl: json['avatar_url'],
      walletBalance: json['wallet_balance'] ?? 0,
      points: json['points'] ?? 0,
    );
  }
}
