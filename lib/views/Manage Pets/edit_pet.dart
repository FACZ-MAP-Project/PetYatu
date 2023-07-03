import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../providers/history_provider.dart';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../../providers/pet_provider.dart';
import '../../models/pet.dart';
import '../../models/history.dart';

class EditPet extends StatefulWidget {
  final Pet pet;

  const EditPet({Key? key, required this.pet}) : super(key: key);

  @override
  _EditPetState createState() => _EditPetState();
}

class _EditPetState extends State<EditPet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  // toggle switch control in form
  bool _isOpenForAdoption = false;

  Position? _currentPosition;
  String? _currentAddress;

  Future<void> _getCurrentLocation() async {
    LocationPermission permission;
    bool serviceEnabled;
    try {
      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Check if location permission is granted
        PermissionStatus permissionStatus =
            await Permission.locationWhenInUse.status;
        if (!permissionStatus.isGranted) {
          if (await Permission.location.isPermanentlyDenied) {
            openAppSettings();
          } else {
            // If permission is not granted, request the permission
            Map<Permission, PermissionStatus> status =
                await [Permission.location].request();

            if (status[Permission.location] == PermissionStatus.denied) {
              return Future.error('Location permissions are denied');
            }
          }
        }
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      setState(() {
        _currentPosition = position;
        _locationController.text =
            '${placemarks[0].locality}, ${placemarks[0].administrativeArea}';
        _currentAddress =
            '${placemarks[0].locality}, ${placemarks[0].administrativeArea}';
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _updatePet() async {
    final PetProvider _petProvider =
        Provider.of<PetProvider>(context, listen: false);

    final HistoryProvider _historyProvider =
        Provider.of<HistoryProvider>(context, listen: false);

    String location;

    if (_locationController.text != _currentAddress) {
      List<Location> locations =
          await locationFromAddress(_locationController.text);
      location = '${locations[0].latitude}, ${locations[0].longitude}';
    } else {
      location =
          '${_currentPosition?.latitude}, ${_currentPosition?.longitude}';
    }

    final Pet updatedPet = Pet(
      uid: widget.pet.uid,
      name: _nameController.text,
      type: _typeController.text,
      image: widget.pet.image,
      gallery: widget.pet.gallery,
      owner: widget.pet.owner,
      datePosted: widget.pet.datePosted,
      likes: widget.pet.likes,
      likedBy: widget.pet.likedBy,
      age: int.tryParse(_ageController.text) ?? 0,
      bio: _descriptionController.text,
      contact: _contactController.text,
      location: location,
      isOpenForAdoption: _isOpenForAdoption,
    );

    await _petProvider.updatePet(updatedPet);

    await _historyProvider.historyUpdatePet(updatedPet);

    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Pet detail has been updated'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.pet.name;
    _typeController.text = widget.pet.type!;
    _ageController.text = widget.pet.age.toString();
    _descriptionController.text = widget.pet.bio!;
    _contactController.text = widget.pet.contact!;
    _locationController.text = widget.pet.location!;
    _isOpenForAdoption = widget.pet.isOpenForAdoption!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('lib/assets/images/logo.png',
                fit: BoxFit.contain, height: 32),
          ),
          const Text('PetYatu',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 32,
              )),
        ],
      ),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[200],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Edit Pet',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Please update the information of your pet',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _form(),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _updatePet,
                      child: const Text('Update Pet'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _form() {
    return Column(
      children: [
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _typeController,
          decoration: const InputDecoration(
            labelText: 'Type',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _ageController,
          decoration: const InputDecoration(
            labelText: 'Age',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _descriptionController,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _contactController,
          decoration: const InputDecoration(
            labelText: 'Contact',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _locationController,
          decoration: InputDecoration(
            labelText: 'Location',
            border: OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(Icons.location_searching_outlined),
              onPressed: () {
                _getCurrentLocation();
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Text(
              'Open for Adoption',
              style: TextStyle(fontSize: 16),
            ),
            const Spacer(),
            Switch(
              value: _isOpenForAdoption,
              onChanged: (value) {
                setState(() {
                  _isOpenForAdoption = value;
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}
