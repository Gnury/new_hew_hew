class User {
  final String? fullName;
  final int? userId;
  final String? imageUrl;
  final int? coins;

  User({
    this.coins,
    this.fullName,
    this.userId,
    this.imageUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    fullName: json["full_name"],
    userId: json["user_id"],
    coins: json["coins"],
    imageUrl: json["image_url"],
  );

  Map<String, dynamic> toJson() => {
    "full_name": fullName,
    "user_id": userId,
    "coins": coins,
    "image_url": imageUrl,
  };
}
