import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/moment_provider.dart';
import '../../models/moment.dart';

class AddMoment extends StatefulWidget {
  const AddMoment({Key? key}) : super(key: key);

  @override
  State<AddMoment> createState() => _AddMomentState();
}

class _AddMomentState extends State<AddMoment> {
  final TextEditingController _nameCatController = TextEditingController();
  final TextEditingController _imageCatController = TextEditingController();
  final TextEditingController _descriptionCatController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Moment'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              controller: _nameCatController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextFormField(
              controller: _imageCatController,
              decoration: const InputDecoration(
                labelText: 'Image',
              ),
            ),
            TextFormField(
              controller: _descriptionCatController,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final MomentProvider momentProvider =
                    Provider.of<MomentProvider>(context, listen: false);

                final Moment _moment = Moment(
                  uid: '',
                  owner: '',
                  pet: _nameCatController.text,
                  image: _imageCatController.text,
                  caption: _descriptionCatController.text,
                  datePosted: DateTime.now(),
                  likes: 0,
                  likesBy: [],
                  comments: 0,
                  commentsBy: [],
                );

                try {
                  momentProvider.createMoment(_moment);
                  // show success dialog
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Success'),
                        content: const Text('Moment has been added'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } catch (e) {
                  print(e);
                }
              },
              child: const Text('Add Moment'),
            ),
          ],
        ),
      ),
    );
  }
}
