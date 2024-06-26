//spell:ignore cupertino
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/apis/api.dart';
import 'package:chat_app/generator/assets.gen.dart';
import 'package:chat_app/helper/dialogs.dart';
import 'package:chat_app/model/model.dart';
import 'package:chat_app/pages/auth/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../../main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({required this.user, super.key});

  final ChatUser user;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String? _image;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //spell:ignore unfocus
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.red,
            onPressed: () async {
              Dialogs.showProgressBar(context);

              await Apis.updateActiveStatus(false);

              await Apis.auth.signOut().then(
                (value) async {
                  await GoogleSignIn().signOut().then(
                    (value) {
                      //for hiding progress dialog
                      Navigator.pop(context);
                      //for moving to homepage
                      Navigator.pop(context);

                      Apis.auth = FirebaseAuth.instance;

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginPage(),
                        ),
                      );
                    },
                  );
                },
              );
            },
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          ),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
            child: ListView(
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: mq.width,
                      height: mq.height * .03,
                    ),
                    Stack(
                      children: [
                        _image != null
                            ? ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(mq.height * .1),
                                child: Image.file(
                                  File(_image!),
                                  width: mq.height * .2,
                                  height: mq.height * .2,
                                  fit: BoxFit.cover,
                                ),
                              )
                            :
                            // image from server
                            ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(mq.height * .1),
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  width: mq.height * .2,
                                  height: mq.height * .2,
                                  imageUrl: widget.user.image,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  //spell:ignore Cupertino
                                  errorWidget: (context, url, error) =>
                                      const CircleAvatar(
                                    child: Icon(CupertinoIcons.person),
                                  ),
                                ),
                              ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: MaterialButton(
                            elevation: 1,
                            color: Colors.white,
                            shape: const CircleBorder(),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.blue,
                            ),
                            onPressed: () => _showBottomSheet(),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: mq.width,
                      height: mq.height * .03,
                    ),
                    Text(
                      widget.user.email,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: mq.width,
                      height: mq.height * .05,
                    ),
                    TextFormField(
                      initialValue: widget.user.name,
                      onSaved: (value) => Apis.me.name = value ?? '',
                      validator: (value) => value != null && value.isNotEmpty
                          ? null
                          : 'Required Field',
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.blue,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'eg. Happy Happy',
                        label: const Text('Name'),
                      ),
                    ),
                    SizedBox(
                      width: mq.width,
                      height: mq.height * .02,
                    ),
                    TextFormField(
                      initialValue: widget.user.about,
                      onSaved: (value) => Apis.me.about = value ?? '',
                      validator: (value) => value != null && value.isNotEmpty
                          ? null
                          : 'Required Field',
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.info,
                          color: Colors.blue,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        hintText: 'eg. Feeling Happy',
                        label: const Text('About'),
                      ),
                    ),
                    SizedBox(
                      width: mq.width,
                      height: mq.height * .05,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          Apis.updateUserInfo().then(
                            (value) => Dialogs.showSnackbar(
                                context, 'Profile update success'),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        minimumSize: Size(mq.width * .4, mq.height * .06),
                      ),
                      icon: const Icon(
                        Icons.edit,
                        size: 28,
                      ),
                      label: const Text(
                        'UPDATE',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //bottom sheet for picking a profile picture for user
  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (_) {
        return ListView(
          padding:
              EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .05),
          shrinkWrap: true,
          children: [
            const Text(
              'Profile Picture',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: mq.height * .02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: const CircleBorder(),
                    fixedSize: Size(mq.width * .3, mq.height * .15),
                  ),
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    //pick an image
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 80,
                    );
                    if (image != null) {
                      setState(() {
                        _image = image.path;
                      });
                      Apis.updateProfilePicture(
                        File(_image!),
                      );
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    }
                  },
                  child: Image(
                    image:
                        Assets.packages.common.assets.images.gallery.provider(),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: const CircleBorder(),
                    fixedSize: Size(mq.width * .3, mq.height * .15),
                  ),
                  child: Image(
                    image:
                        Assets.packages.common.assets.images.camera.provider(),
                  ),
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    //pick an image
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 80,
                    );
                    if (image != null) {
                      setState(() {
                        _image = image.path;
                      });
                      Apis.updateProfilePicture(
                        File(_image!),
                      );
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
