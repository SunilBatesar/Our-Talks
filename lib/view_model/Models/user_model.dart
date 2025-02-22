class UserModel {
  final String userID;
  final String userName;
  final String image;
  final String about;
  final String name;
  final String createdAt;
  final String lastActive;
  final String email;
  final String pushToken;
  final bool isOnline;

  const UserModel({
    required this.userID,
    required this.userName,
    required this.image,
    required this.about,
    required this.name,
    required this.createdAt,
    required this.lastActive,
    required this.email,
    required this.pushToken,
    this.isOnline = false,
  });

  UserModel.fromJson(Map<String, dynamic> json, this.userID)
      : userName = json['userName'] ?? '',
        image = json['image'] ?? '',
        about = json['about'] ?? '',
        name = json['name'] ?? '',
        createdAt = json['createdAt'] ?? '',
        lastActive = json['lastActive'] ?? '',
        email = json['email'] ?? '',
        pushToken = json['pushToken'] ?? '',
        isOnline = json['isOnline'] ?? false;

  Map<String, dynamic> toJson() => {
        'userName': userName,
        'image': image,
        'about': about,
        'name': name,
        'createdAt': createdAt,
        'lastActive': lastActive,
        'email': email,
        'pushToken': pushToken,
        'isOnline': isOnline,
      };

  UserModel copyWith({
    String? userID,
    String? userName,
    String? image,
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
      image: image ?? this.image,
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
