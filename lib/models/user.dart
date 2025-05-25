class User {
  int id;
  String username;
  String email;
  String first_name;
  String last_name;
  //String role;
  String rol;
  String estado;
  //bool is_staff;
  //bool is_superuser;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.first_name,
    required this.last_name,
    //required this.role,
    required this.rol,
    required this.estado,
    //required this.is_staff,
    //required this.is_superuser,
  });

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        username = json['username'],
        email = json['email'],
        first_name = json['first_name'],
        last_name = json['last_name'],
        //role = json['role'],
        rol = json['rol'],
        estado = json['estado'];
  //is_staff = json['is_staff'],
  //is_superuser = json['is_superuser'];
}
