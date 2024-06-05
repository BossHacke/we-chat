// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatUser _$ChatUserFromJson(Map<String, dynamic> json) => ChatUser(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      about: json['about'] ?? '',
      createdAt: json['createdAt'] ?? '',
      email: json['email'] ?? '',
      isOnline: json['isOnline'] ?? '',
      lastActive: json['lastActive'] ?? '',
      pushToken: json['pushToken'] ?? '',
    );

Map<String, dynamic> _$ChatUserToJson(ChatUser instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'about': instance.about,
      'createdAt': instance.createdAt,
      'isOnline': instance.isOnline,
      'lastActive': instance.lastActive,
      'email': instance.email,
      'pushToken': instance.pushToken,
    };

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      toId: json['toId'].toString(),
      fromId: json['fromId'].toString(),
      msg: json['msg'].toString(),
      read: json['read'].toString(),
      sent: json['sent'].toString(),
      type: json['type'].toString() == Type.image.name ? Type.image : Type.text,
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'toId': instance.toId,
      'msg': instance.msg,
      'read': instance.read,
      'type': instance.type.name,
      'fromId': instance.fromId,
      'sent': instance.sent,
    };
