import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../providers/moment_provider.dart';
import '../../models/moment.dart';

class CatMoment extends StatefulWidget {
  const CatMoment({
    super.key,
  });

  @override
  State<CatMoment> createState() => _CatMomentState();
}

class _CatMomentState extends State<CatMoment> {
  ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MomentProvider momentProvider =
        Provider.of<MomentProvider>(context, listen: true);

    late File _image;

    // ignore: no_leading_underscores_for_local_identifiers
    Future<void> _getImage(ImageSource source) async {
      final ImagePicker picker = ImagePicker();

      final XFile? image = await picker.pickImage(source: source);

      if (image != null) {
        setState(() {
          _image = File(image.path);
        });
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushNamed('/add_moment', arguments: _image);
      }
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Select Image'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        GestureDetector(
                          child: const Text('Gallery'),
                          onTap: () {
                            Navigator.of(context).pop();
                            _getImage(ImageSource.gallery);
                          },
                        ),
                        const Padding(padding: EdgeInsets.all(8.0)),
                        GestureDetector(
                          child: const Text('Camera'),
                          onTap: () {
                            Navigator.of(context).pop();
                            _getImage(ImageSource.camera);
                          },
                        )
                      ],
                    ),
                  ),
                );
              });
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: momentProvider.viewAllMoments(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            final List<Moment> moments = snapshot.data as List<Moment>;

            return NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollUpdateNotification) {
                    // if(_scrollController.position.maxScrollExtent == _scrollController.offset){
                    //   momentProvider.viewAllMoments();
                    // }
                  }

                  return false;
                },
                child: ListView.builder(
                  itemCount: moments.length,
                  itemBuilder: (context, index) {
                    return _card(moments[index], key: Key(moments[index].uid));
                  },
                ));
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  @override
  Widget _card(Moment moment, {Key? key}) {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    return Consumer<MomentProvider>(
      builder: (context, momentProvider, _) {
        return GestureDetector(
          // onTap: () {
          //   Navigator.of(context).pushNamed('/');
          // },
          child: Card(
            key: key,
            color: Colors.white, // set color here
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    moment.pet,
                  ),
                  subtitle: Text(moment.datePosted.toString()),
                  trailing: _buildKebabMenu(moment, _auth, momentProvider),
                ),
                SizedBox(
                  // set fixed height for image container
                  width: double.infinity, // set width to fill available space
                  child: Image.network(
                    moment.image,
                    fit: BoxFit.cover,
                  ),
                ),
                Row(
                  children: [
                    const SizedBox(width: 10.0),
                    ElevatedButton.icon(
                      onPressed: () async {
                        if (moment.likesBy.contains(_auth.currentUser!.uid)) {
                          // remove like
                          await momentProvider.unlikeMoment(moment.uid);
                        } else {
                          // add like
                          await momentProvider.likeMoment(moment.uid);
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          moment.likesBy.contains(_auth.currentUser!.uid)
                              ? Colors.pink
                              : Colors.grey,
                        ),
                        overlayColor: MaterialStateProperty.all(
                          Colors.white.withOpacity(0.3),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      icon: Icon(
                        moment.likesBy.contains(_auth.currentUser!.uid)
                            ? Icons.favorite
                            : Icons.favorite,
                        color: Colors.white,
                      ),
                      label: Text(
                        moment.likes.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    //comment logo
                    const SizedBox(width: 10.0),
                    ElevatedButton.icon(
                      onPressed: () async {
                        if (moment.commentsBy
                            .contains(_auth.currentUser!.uid)) {
                          // remove comment
                          await momentProvider.uncommentMoment(
                            moment.uid,
                          );
                        } else {
                          // add comment
                          await momentProvider.commentMoment(
                            moment.uid,
                          );
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          moment.commentsBy.contains(_auth.currentUser!.uid)
                              ? Colors.pink
                              : Colors.grey,
                        ),
                        overlayColor: MaterialStateProperty.all(
                          Colors.white.withOpacity(0.3),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      icon: Icon(
                        moment.commentsBy.contains(_auth.currentUser!.uid)
                            ? Icons.comment
                            : Icons.comment,
                        color: Colors.white,
                      ),
                      label: Text(
                        moment.comments.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
                ListTile(
                  subtitle: Text(
                    moment.caption,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildKebabMenu(
      Moment moment, FirebaseAuth auth, MomentProvider momentProvider) {
    return PopupMenuButton<String>(
      itemBuilder: (context) => [
        if (auth.currentUser != null && moment.owner == auth.currentUser!.uid)
          const PopupMenuItem<String>(
            value: 'edit',
            child: Text('Edit Description'),
          ),
        const PopupMenuItem<String>(
          value: 'share',
          child: Text('Share'),
        ),
        if (auth.currentUser != null && moment.owner == auth.currentUser!.uid)
          const PopupMenuItem<String>(
            value: 'delete',
            child: Text('Delete'),
          ),
      ],
      onSelected: (value) {
        if (value == 'edit') {
          _editDescription(momentProvider, moment);
        } else if (value == 'delete') {
          _confirmDelete(momentProvider, moment.uid, moment.image);
        } else if (value == 'share') {
          _shareMoment(moment);
        }
      },
    );
  }

  void _confirmDelete(
      MomentProvider momentProvider, String momentUid, String link) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this moment?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                momentProvider.deleteMoment(momentUid, link);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _editDescription(MomentProvider momentProvider, Moment moment) {
    // Show a dialog for editing the description
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newDescription = moment.caption;
        return AlertDialog(
          title: const Text('Edit Description'),
          content: TextField(
            onChanged: (value) {
              newDescription = value;
            },
            decoration: const InputDecoration(
              hintText: 'Enter new description',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                momentProvider.editDescription(moment.uid, newDescription);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _shareMoment(Moment moment) async {
    // Share.shareFiles([moment.image], text: moment.caption);
    final response = await http.get(Uri.parse(moment.image));
    final bytes = response.bodyBytes;

    final tempDir = await getTemporaryDirectory();
    final tempPath = '${tempDir.path}/${moment.pet}.png';

    final file = File(tempPath);
    await file.writeAsBytes(bytes);

    //share image and caption to other apps
    //the caption is description of the moment and the pet name and tell to download the app

    await Share.shareXFiles(
      [XFile(tempPath)],
      text: "${moment.pet}:\n"
          "${moment.caption}\n\n"
          "Download PetYatu app to see more pets!",
      subject: "PetYatu",
    );
  }
}
