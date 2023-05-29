import 'package:flutter/material.dart';
import '../providers/user_provider.dart';
import '../models/app_user.dart';

class EditProfilePage extends StatefulWidget {
  final AppUser? appUser;
  final UserProvider userProvider;

  const EditProfilePage({
    Key? key,
    required this.appUser,
    required this.userProvider,
  }) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Set the initial values based on the provided appUser data
    nameController.text = widget.appUser?.name ?? '';
    emailController.text = widget.appUser?.email ?? '';
    locationController.text = widget.appUser?.location ?? '';
    ageController.text = widget.appUser?.age.toString() ?? '';
    genderController.text = widget.appUser?.gender ?? '';
    bioController.text = widget.appUser?.bio ?? '';
  }

  void saveUpdatedUserProfile() async {
    String newName = nameController.text;
    String newEmail = emailController.text;
    String newLocation = locationController.text;
    String newBio = bioController.text;
    int newAge = int.tryParse(ageController.text) ?? 0;
    String newGender = genderController.text;

    // Create a new updated user object
    AppUser updatedUser = AppUser(
      uid: widget.appUser?.uid ?? '',
      name: newName,
      email: newEmail,
      password: widget.appUser?.password ?? '',
      token: widget.appUser?.token ?? '',
      dateJoined: widget.appUser?.dateJoined ?? DateTime.now(),
      age: newAge,
      gender: newGender,
      location: newLocation,
      bio: newBio,
      isAdoptee: widget.appUser?.isAdoptee ?? false,
    );

    // Call the update user method of your user provider to save the updated user profile
    try {
      await widget.userProvider.updateUser(updatedUser);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully.'),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update profile.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(
                labelText: 'Age',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: genderController,
              decoration: const InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: bioController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Bio',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                saveUpdatedUserProfile();
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
