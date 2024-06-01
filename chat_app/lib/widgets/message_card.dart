import 'package:chat_app/apis/api.dart';
import 'package:chat_app/helper/my_date.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/model/model.dart';
import 'package:flutter/material.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({required this.message, super.key});

  final Message message;
  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return Apis.user.uid == widget.message.fromId
        ? _greenMessage()
        : _blueMessage();
  }

  //sender or another user message
  Widget _blueMessage() {
    if (widget.message.read!.isEmpty) {
      Apis.updateMessageReadStatus(widget.message);
    }
    return Row(
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width * .04),
            margin: EdgeInsets.symmetric(
              vertical: mq.height * .01,
              horizontal: mq.width * .04,
            ),
            decoration: BoxDecoration(
              //spell:ignore ARGB
              color: const Color.fromARGB(255, 221, 245, 255),
              border: Border.all(color: Colors.lightBlue),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Text(widget.message.msg!),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: mq.width * .04),
          child: Text(
            MyDate.getFormattedTime(
                context: context, time: widget.message.sent!),
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }

  //out or user message
  Widget _greenMessage() {
    return Row(
      children: [
        Row(
          children: [
            SizedBox(
              width: mq.width * .04,
            ),
            const Icon(
              Icons.done_all_rounded,
              color: Colors.blue,
              size: 20,
            ),
            const SizedBox(
              width: 2,
            ),
            Text(
              MyDate.getFormattedTime(
                  context: context, time: widget.message.sent!),
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ],
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width * .04),
            margin: EdgeInsets.symmetric(
              vertical: mq.height * .01,
              horizontal: mq.width * .04,
            ),
            decoration: BoxDecoration(
              //spell:ignore ARGB
              color: const Color.fromARGB(255, 221, 245, 255),
              border: Border.all(color: Colors.lightGreen),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
            ),
            child: Text(widget.message.msg!),
          ),
        ),
      ],
    );
  }
}
