class Admin {
  final String? adminEmail;
  final bool isAdmin = true;

  const Admin({
    required this.adminEmail,
});

  factory Admin.fromJson(Map<String, dynamic> json/*,{required String uid}*/) => Admin(
    adminEmail: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "admin_email" : adminEmail,
    "is_admin" : isAdmin,
  };
}