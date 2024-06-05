import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/apis/api.dart';
import 'package:chat_app/helper/my_date.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/model/model.dart';
import 'package:chat_app/pages/chat/chat_page.dart';
import 'package:chat_app/widgets/profile_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatUserCard extends StatefulWidget {
  const ChatUserCard({required this.user, super.key});

  final ChatUser user;
  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  Message? _message;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: 4),
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
          onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatPage(
                    user: widget.user,
                  ),
                ),
              ),
          child: StreamBuilder(
            stream: Apis.getLastMessage(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
              if (list.isNotEmpty) {
                _message = list[0];
              }
              return ListTile(
                leading: InkWell(
                  onTap: () => showDialog(
                    context: context,
                    builder: (_) => ProfileDialog(
                      user: widget.user,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height * .03),
                    child: CachedNetworkImage(
                      width: mq.height * .055,
                      height: mq.height * .055,
                      imageUrl: widget.user.image,
                      //spell:ignore Cupertino
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => const CircleAvatar(
                        child: Icon(CupertinoIcons.person),
                      ),
                    ),
                  ),
                ),
                title: Text(widget.user.name),
                subtitle: Text(
                  _message != null
                      ? _message!.type == Type.image
                          ? 'image'
                          : _message!.msg
                      : widget.user.about,
                  maxLines: 1,
                ),
                trailing: _message == null
                    ? null
                    : _message!.read.isEmpty &&
                            _message!.fromId != Apis.user.uid
                        ? Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              color: Colors.greenAccent.shade400,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          )
                        : Text(
                            MyDate.getLastMessageTime(
                                context: context, time: _message!.sent),
                            style: const TextStyle(color: Colors.black54),
                          ),
              );
            },
          )),
    );
  }
}
