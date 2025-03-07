class UserModel {
  final String? userID;
  final String userName;
  final String name;
  final String createdAt;
  final String lastActive;
  final String email;
  String? userDP;
  String? banner;
  final String? about;
  final String? pushToken;
  final bool isOnline;
  final bool pravacy;
  final List<String>? friends;
  final List<String>? chatroom;
  final List<String>? serachuserlist;
  final String? dob;
  final String? gender;
  final List<String>? blockedUsers;

  UserModel({
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
    this.pravacy = false,
    this.friends,
    this.chatroom,
    this.serachuserlist,
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
        pravacy = json['pravacy'] ?? false,
        friends = (json['friends'] as List<dynamic>?)?.cast<String>(),
        chatroom = (json['chatroom'] as List<dynamic>?)?.cast<String>(),
        serachuserlist =
            (json['serachuserlist'] as List<dynamic>?)?.cast<String>(),
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
        'pravacy': pravacy,
        'friends': friends ?? [],
        'chatroom': chatroom ?? [],
        'serachuserlist': serachuserlist ?? [],
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
    bool? pravacy,
    List<String>? friends,
    List<String>? chatroom,
    List<String>? serachuserlist,
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
      pravacy: pravacy ?? this.pravacy,
      friends: friends ?? this.friends,
      chatroom: chatroom ?? this.chatroom,
      serachuserlist: serachuserlist ?? this.serachuserlist,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      blockedUsers: blockedUsers ?? this.blockedUsers,
    );
  }
}

// REALTIME DATA SAVE USER MODEL
class RealTimeUserModel {
  String? id;
  bool isOnline;
  String? lastSeen;
  RealTimeUserModel({this.id, this.isOnline = false, this.lastSeen});

  Map<String, dynamic> toJson() {
    return {
      "isOnline": isOnline,
      "lastSeen": lastSeen,
    };
  }

  Map<String, dynamic> toJsonOnlyOnlineValue() {
    return {
      "isOnline": isOnline,
    };
  }

  RealTimeUserModel.fromJson(Map<String, dynamic> json)
      : isOnline = json["isOnline"] ?? false,
        lastSeen = json["lastSeen"] ?? "";
}
