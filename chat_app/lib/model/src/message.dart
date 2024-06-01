part of '../model.dart';

@JsonSerializable(explicitToJson: true)
class Message extends Equatable {
  const Message({
    required this.toId,
    required this.fromId,
    required this.msg,
    required this.read,
    required this.sent,
    required this.type,
  });
  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
  @JsonKey(name: 'toId')
  final String? toId;
  @JsonKey(name: 'msg')
  final String? msg;
  @JsonKey(name: 'read')
  final String? read;
  @JsonKey(name: 'type')
  final Type? type;
  @JsonKey(name: 'fromId')
  final String? fromId;
  @JsonKey(name: 'sent')
  final String? sent;
  Map<String, dynamic> toJson() => _$MessageToJson(this);

  @override
  List<Object?> get props => [toId, msg, read, type, fromId, sent];
}

enum Type { text, image }
