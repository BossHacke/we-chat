// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatUser _$ChatUserFromJson(Map<String, dynamic> json) => ChatUser(
      id: json['id'] as String,
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
      'image': instance.image,
      'about': instance.about,
      'name': instance.name,
      'createdAt': instance.createdAt,
      'isOnline': instance.isOnline,
      'lastActive': instance.lastActive,
      'email': instance.email,
      'pushToken': instance.pushToken,
    };
