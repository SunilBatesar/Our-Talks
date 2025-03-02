class UserModel {
  final String? userID;
  final String userName;
  final String name;
  final String createdAt;
  final String lastActive;
  final String email;
  final String? userDP;
  final String? banner;
  final String? about;
  final String? pushToken;
  final bool isOnline;
  final List<String>? friends;
  final List<String>? chatroom;
  final String? dob;
  final String? gender;
  final List<String>? blockedUsers;

  const UserModel({
    this.userID,
    required this.userName,
    required this.name,
    required this.createdAt,
    required this.lastActive,
    required this.email,
    this.userDP,
    this.banner,
    this.about,
    this.pushToken,
    this.isOnline = false,
    this.friends,
    this.chatroom,
    this.dob,
    this.gender,
    this.blockedUsers,
  });

  UserModel.fromJson(Map<String, dynamic> json, this.userID)
      : userName = json['userName'] ?? '',
        name = json['name'] ?? '',
        createdAt = json['createdAt'] ?? '',
        lastActive = json['lastActive'] ?? '',
        email = json['email'] ?? '',
        userDP = json['userDP'] ?? '',
        banner = json['banner'] ?? '',
        about = json['about'] ?? '',
        pushToken = json['pushToken'] ?? '',
        isOnline = json['isOnline'] ?? false,
        friends = (json['friends'] as List<dynamic>?)?.cast<String>(),
        chatroom = (json['chatroom'] as List<dynamic>?)?.cast<String>(),
        dob = json['dob'] ?? '',
        gender = json['gender'] ?? '',
        blockedUsers = (json['blockedUsers'] as List<dynamic>?)?.cast<String>();

  Map<String, dynamic> toJson() => {
        'userName': userName,
        'name': name,
        'createdAt': createdAt,
        'lastActive': lastActive,
        'email': email,
        'userDP': userDP ?? '',
        'banner': banner ?? '',
        'about': about ?? '',
        'pushToken': pushToken ?? '',
        'isOnline': isOnline,
        'friends': friends ?? [],
        'chatroom': chatroom ?? [],
        'dob': dob ?? '',
        'gender': gender ?? '',
        'blockedUsers': blockedUsers ?? [],
      };

  UserModel copyWith({
    String? userID,
    String? userName,
    String? name,
    String? createdAt,
    String? lastActive,
    String? email,
    String? userDP,
    String? banner,
    String? about,
    String? pushToken,
    bool? isOnline,
    List<String>? friends,
    List<String>? chatroom,
    String? dob,
    String? gender,
    List<String>? blockedUsers,
  }) {
    return UserModel(
      userID: userID ?? this.userID,
      userName: userName ?? this.userName,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
      email: email ?? this.email,
      userDP: userDP ?? this.userDP,
      banner: banner ?? this.banner,
      about: about ?? this.about,
      pushToken: pushToken ?? this.pushToken,
      isOnline: isOnline ?? this.isOnline,
      friends: friends ?? this.friends,
      chatroom: chatroom ?? this.chatroom,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      blockedUsers: blockedUsers ?? this.blockedUsers,
    );
  }
}
