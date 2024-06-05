import 'package:chat_app/apis/api.dart';
import 'package:chat_app/helper/dialogs.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/model/model.dart';
import 'package:chat_app/pages/profile/profile_page.dart';
import 'package:chat_app/widgets/chat_user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Apis.getSelfInfo();
    // Apis.updateActiveStatus(true);
    SystemChannels.lifecycle.setMessageHandler((message) {
      if (Apis.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          Apis.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          Apis.updateActiveStatus(false);
        }
      }
      return Future.value(message);
    });
  }

  List<ChatUser> list = [];

  final List<ChatUser> search = [];
  bool isSearch = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //spell:ignore unfocus
      onTap: () => FocusScope.of(context).unfocus(),
      // ignore: deprecated_member_use
      child: WillPopScope(
        onWillPop: () {
          if (isSearch) {
            setState(() {
              isSearch = !isSearch;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            //spell:ignore Cupertino
            automaticallyImplyLeading: false,
            leading: const Icon(
              CupertinoIcons.home,
            ),
            title: isSearch
                ? TextField(
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: 'Name, Email,...'),
                    //spell:ignore autofocus
                    autofocus: true,
                    style: const TextStyle(
                      fontSize: 17,
                      letterSpacing: 0.5,
                    ),
                    onChanged: (value) {
                      //Search logic
                      search.clear();

                      for (var i in list) {
                        if (i.name
                                .toLowerCase()
                                .contains(value.toLowerCase()) ||
                            i.email
                                .toLowerCase()
                                .contains(value.toLowerCase())) {
                          search.add(i);
                        }
                      }
                    },
                  )
                : const Text('Chat app'),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    isSearch = !isSearch;
                  });
                },
                icon: Icon(
                  isSearch ? CupertinoIcons.clear_circled_solid : Icons.search,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProfilePage(
                        user: Apis.me,
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.more_vert,
                ),
              ),
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton(
              onPressed: () {
                _addChatUserDialog();
              },
              child: const Icon(
                Icons.add_comment_rounded,
              ),
            ),
          ),
          body: StreamBuilder(
            stream: Apis.getMyUsersId(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.active:
                case ConnectionState.done:
                  return StreamBuilder(
                    //spell:ignore firestore
                    stream: Apis.getAllUsers(
                      snapshot.data?.docs.map((e) => e.id).toList() ?? [],
                    ),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                          list = data
                                  ?.map((e) => ChatUser.fromJson(e.data()))
                                  .toList() ??
                              [];
                          if (list.isNotEmpty) {
                            return ListView.builder(
                              itemCount: isSearch ? search.length : list.length,
                              padding: EdgeInsets.only(top: mq.height * .01),
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return ChatUserCard(
                                    user:
                                        isSearch ? search[index] : list[index]);
                              },
                            );
                          } else {
                            return const Center(
                              child: Text(
                                'No Connections Found!',
                                style: TextStyle(fontSize: 20),
                              ),
                            );
                          }
                      }
                    },
                  );
              }
            },
          ),
        ),
      ),
    );
  }

  // for adding new chat user
  void _addChatUserDialog() {
    String email = '';

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),

              //title
              title: const Row(
                children: [
                  Icon(
                    Icons.person_add,
                    color: Colors.blue,
                    size: 28,
                  ),
                  Text('  Add User')
                ],
              ),

              //content
              content: TextFormField(
                maxLines: null,
                onChanged: (value) => email = value,
                decoration: InputDecoration(
                    hintText: 'Email Id',
                    prefixIcon: const Icon(Icons.email, color: Colors.blue),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),

              //actions
              actions: [
                //cancel button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.blue, fontSize: 16))),

                //add button
                MaterialButton(
                    onPressed: () async {
                      //hide alert dialog
                      Navigator.pop(context);
                      if (email.isNotEmpty) {
                        await Apis.addChatUser(email).then((value) {
                          if (!value) {
                            Dialogs.showSnackbar(
                                context, 'User does not Exists!');
                          }
                        });
                      }
                    },
                    child: const Text(
                      'Add',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ))
              ],
            ));
  }
}
