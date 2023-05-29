import 'dart:async';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'edit_profile.dart'; // Import the edit_profile.dart file

class Profile extends StatelessWidget {
  const Profile({
    super.key,
  });

  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserProvider>.value(
        value: Provider.of<UserProvider>(context),
        child: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            return FutureBuilder<AppUser?>(
              future: userProvider
                  .getUserFromJson(FirebaseAuth.instance.currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('An error occurred: ${snapshot.error}'),
                  );
                } else {
                  final appUser = snapshot.data;
                  return Scaffold(
                    appBar: _appBar(),
                    body: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const CircleAvatar(
                            radius: 50.0,
                            backgroundImage: NetworkImage(
                              'https://www.w3schools.com/w3images/avatar2.png',
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            '${appUser?.name}',
                            style: const TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            'email: ${appUser?.email}',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            'Date Joined: ${DateFormat.MMMM('en_US').format(appUser?.dateJoined as DateTime)} ${DateFormat.y().format(appUser?.dateJoined as DateTime)}',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            'Location:  ${appUser?.location}',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            'Profile: ${appUser?.age}, ${appUser?.gender}',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          const Text(
                            'Bio:',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              '${appUser?.bio}',
                              style: const TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfilePage(
                                    appUser: appUser,
                                    userProvider: userProvider,
                                  ),
                                ),
                              );
                            },
                            child: const Text('Edit Profile'),
                          ),
                          const SizedBox(height: 10.0),
                        ],
                      ),
                    ),
                  );
                }
              },
            );
          },
        ));
  }

  AppBar _appBar() {
    return AppBar(
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'lib/assets/images/logo.png',
              fit: BoxFit.contain,
              height: 32,
            ),
          ),
          const Text(
            'PetYatu',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
          ),
        ],
      ),
    );
  }
}
