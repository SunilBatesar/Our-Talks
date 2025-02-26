class UserModel {
  final String? userID;
  final String userName;
  final String? userDP;
  final String? banner;
  final String? about;
  final String name;
  final String createdAt;
  final String lastActive;
  final String email;
  final String? pushToken;
  final bool isOnline;

  const UserModel({
    this.userID,
    required this.userName,
    this.userDP,
    this.banner,
    this.about,
    required this.name,
    required this.createdAt,
    required this.lastActive,
    required this.email,
    this.pushToken,
    this.isOnline = false,
  });

  UserModel.fromJson(Map<String, dynamic> json, this.userID)
      : userName = json['userName'] ?? '',
        userDP = json['userDP'] ?? '',
        banner = json['banner'] ?? '',
        about = json['about'] ?? '',
        name = json['name'] ?? '',
        createdAt = json['createdAt'] ?? '',
        lastActive = json['lastActive'] ?? '',
        email = json['email'] ?? '',
        pushToken = json['pushToken'] ?? '',
        isOnline = json['isOnline'] ?? false;

  Map<String, dynamic> toJson() => {
        'userName': userName,
        'userDP': userDP ?? '',
        'banner': banner ?? '',
        'about': about ?? '',
        'name': name,
        'createdAt': createdAt,
        'lastActive': lastActive,
        'email': email,
        'pushToken': pushToken ?? '',
        'isOnline': isOnline,
      };

  UserModel copyWith({
    String? userID,
    String? userName,
    String? userDP,
    String? banner,
    String? about,
    String? name,
    String? createdAt,
    String? lastActive,
    String? email,
    String? pushToken,
    bool? isOnline,
  }) {
    return UserModel(
      userID: userID ?? this.userID,
      userName: userName ?? this.userName,
      userDP: userDP ?? this.userDP,
      banner: banner ?? this.banner,
      about: about ?? this.about,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
      email: email ?? this.email,
      pushToken: pushToken ?? this.pushToken,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}
