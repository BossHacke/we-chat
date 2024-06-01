part of '../model.dart';

@JsonSerializable(explicitToJson: true)
// ignore: must_be_immutable
class ChatUser extends Equatable {
  ChatUser({
    required this.id,
    required this.name,
    required this.image,
    required this.about,
    required this.createdAt,
    required this.email,
    required this.isOnline,
    required this.lastActive,
    required this.pushToken,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) =>
      _$ChatUserFromJson(json);
  @JsonKey(name: 'id')
  late String? id;
  @JsonKey(name: 'name')
  late String? name;
  @JsonKey(name: 'image')
  late String? image;
  @JsonKey(name: 'about')
  late String? about;
  @JsonKey(name: 'createdAt')
  late String? createdAt;
  @JsonKey(name: 'isOnline')
  late bool isOnline;
  @JsonKey(name: 'lastActive')
  late String? lastActive;
  @JsonKey(name: 'email')
  late String? email;
  @JsonKey(name: 'pushToken')
  late String? pushToken;
  Map<String, dynamic> toJson() => _$ChatUserToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        image,
        about,
        createdAt,
        isOnline,
        lastActive,
        email,
        pushToken
      ];
  // id = json['id'];
  // name = json['name'];
  // image = json['image'];
  // about = json['about'];
  // createdAt = json['createdAt'];
  // isOnline = json['isOnline'];
  // lastActive = json['lastActive'];
  // email = json['email'];
  // pushToken = json['pushToken'];

  // Map<String, dynamic> toJson() {
  //   late data = <String, dynamic>{};
  //   data['id'] = id;
  //   data['name'] = name;
  //   data['image'] = image;
  //   data['about'] = about;
  //   data['createdAt'] = createdAt;
  //   data['isOnline'] = isOnline;
  //   data['lastActive'] = lastActive;
  //   data['email'] = email;
  //   data['pushToken'] = pushToken;
  //   return data;
  // }
}
