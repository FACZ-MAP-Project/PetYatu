import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  @override
  Widget build(BuildContext context) {
    final MomentProvider momentProvider =
        Provider.of<MomentProvider>(context, listen: true);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/add_moment');
        },
        child: Icon(Icons.add),
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

            return ListView.builder(
              itemCount: moments.length,
              itemBuilder: (context, index) {
                return _card(moments[index]);
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  @override
  Widget _card(Moment moment) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final MomentProvider _momentProvider =
        Provider.of<MomentProvider>(context, listen: true);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/');
      },
      child: Card(
        color: Colors.white, // set color here
        child: Column(
          children: [
            ListTile(
              title: Text(
                moment.pet,
              ),
              subtitle: Text(moment.datePosted.toString()),
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
                  onPressed: () {
                    if (moment.likesBy.contains(_auth.currentUser!.uid)) {
                      // remove like
                      _momentProvider.unlikeMoment(moment.uid);
                    } else {
                      // add like
                      _momentProvider.likeMoment(moment.uid);
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      // false ? Colors.pink : Colors.grey,
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
                    if (moment.commentsBy.contains(_auth.currentUser!.uid)) {
                      // remove comment
                      await _momentProvider.uncommentMoment(
                        moment.uid,
                      );
                    } else {
                      // add comment
                      await _momentProvider.commentMoment(
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
  }
}
