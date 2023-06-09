// import 'dart:html';

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

class AddPet extends StatefulWidget {
  const AddPet({Key? key}) : super(key: key);

  @override
  _AddPetState createState() => _AddPetState();
}

class _AddPetState extends State<AddPet> {
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
              // Permissions are denied, next time you could try
              // requesting permissions again (this is also where
              // Android's shouldShowRequestPermissionRationale
              // returned true. According to Android guidelines
              // your App should show an explanatory UI now.
              return Future.error('Location permissions are denied');
            }
          }
        }
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
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

  Future<void> _putAdoption() async {
    final PetProvider _petProvider =
        Provider.of<PetProvider>(context, listen: false);

    final HistoryProvider _historyProvider =
        Provider.of<HistoryProvider>(context, listen: false);

    String location;

    if (_locationController.text != _currentAddress) {
      //Get Location
      List<Location> locations =
          await locationFromAddress(_locationController.text);
      location = '${locations[0].latitude}, ${locations[0].longitude}';
    } else {
      location =
          '${_currentPosition?.latitude}, ${_currentPosition?.longitude}';
    }

    final Pet _pet = Pet(
      uid: '',
      name: _nameController.text,
      type: _typeController.text,
      image: '',
      age: int.parse(_ageController.text),
      gallery: [],
      owner: '',
      contact: _contactController.text,
      location: location,
      datePosted: DateTime.now(),
      bio: _descriptionController.text,
      isOpenForAdoption: _isOpenForAdoption,
      likes: 0,
      likedBy: [],
    );

    try {
      _petProvider.createPet(_pet);
      _historyProvider.historyAddPet(_pet);
      // show success dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('Pet has been added'),
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
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
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
                      'Add Pet',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Please fill the form below to put your pet for adoption',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _form(),
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
          validator: (value) {
            if (value == null || value.isEmpty || int.parse(value) <= 0) {
              return 'Please enter age';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        // Text(
        //   _currentPosition != null
        //       ? 'Current Location: ${_currentPosition?.latitude}, ${_currentPosition?.longitude}'
        //       : 'Fetching location...',
        // ),
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
        TextFormField(
          controller: _contactController,
          decoration: const InputDecoration(
            labelText: 'Contact',
            border: OutlineInputBorder(),
          ),
        ),
        // toggle switch
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Open for Adoption'),
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
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _putAdoption,
          child: const Text('Add Pet'),
        ),
      ],
    );
  }
}
