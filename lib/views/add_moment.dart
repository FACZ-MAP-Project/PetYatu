import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:petyatu/models/pet.dart';
import 'package:petyatu/providers/pet_provider.dart';
import 'package:provider/provider.dart';
import '../../providers/moment_provider.dart';
import '../../models/moment.dart';

class AddMoment extends StatefulWidget {
  const AddMoment({Key? key}) : super(key: key);

  @override
  State<AddMoment> createState() => _AddMomentState();
}

class _AddMomentState extends State<AddMoment> {
  final TextEditingController _descriptionCatController =
      TextEditingController();
  String? _selectedPetName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Moment'),
      ),
      body: FutureBuilder<File?>(
        future: _getSelectedImage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while retrieving the selected image
            return const Center(child: CircularProgressIndicator());
          }

          final File? selectedImage = snapshot.data;

          return SingleChildScrollView(
            child: Column(
              children: [
                if (selectedImage != null) Image.file(selectedImage),
                FutureBuilder<List<String>>(
                  future: _getPetNames(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    final List<String> petNames = snapshot.data ?? [];

                    return DropdownButtonFormField<String>(
                      value: _selectedPetName,
                      onChanged: (value) {
                        setState(() {
                          _selectedPetName = value;
                        });
                      },
                      items: petNames.map((String petName) {
                        return DropdownMenuItem<String>(
                          value: petName,
                          child: Text(petName),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        labelText: 'Name',
                      ),
                    );
                  },
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
                      pet: _selectedPetName!,
                      image: '',
                      caption: _descriptionCatController.text,
                      datePosted: DateTime.now(),
                      likes: 0,
                      likesBy: [],
                      comments: 0,
                      commentsBy: [],
                    );

                    try {
                      momentProvider.createMoment(_moment, selectedImage!);
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
                      if (kDebugMode) {
                        print(e);
                      }
                    }
                  },
                  child: const Text('Add Moment'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<File?> _getSelectedImage() async {
    final selectedImage = (ModalRoute.of(context)?.settings.arguments as File?);

    return selectedImage;
  }

  Future<List<String>> _getPetNames() async {
    final List<Pet> ownedPets =
        await Provider.of<PetProvider>(context).viewMyPets();
    return ownedPets.map((pet) => pet.name).toList();
  }
}
