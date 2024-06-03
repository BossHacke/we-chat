part of '../model.dart';

@JsonSerializable(explicitToJson: true)
// ignore: must_be_immutable
class Message extends Equatable {
  Message({
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
  late String toId;
  @JsonKey(name: 'msg')
  late String msg;
  @JsonKey(name: 'read')
  late String read;
  @JsonKey(name: 'type')
  late Type type;
  @JsonKey(name: 'fromId')
  late String fromId;
  @JsonKey(name: 'sent')
  late String sent;
  Map<String, dynamic> toJson() => _$MessageToJson(this);

  @override
  List<Object?> get props => [toId, msg, read, type, fromId, sent];
}

enum Type { text, image }
