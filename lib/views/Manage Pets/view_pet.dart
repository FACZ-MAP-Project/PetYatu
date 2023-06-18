import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../providers/pet_provider.dart';
import '../../models/pet.dart';
import 'package:cached_network_image/cached_network_image.dart';

//class named ViewPet with argument called pet
class ViewPet extends StatelessWidget {
  const ViewPet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PetProvider petProvider =
        Provider.of<PetProvider>(context, listen: true);

    final String petUuid = ModalRoute.of(context)!.settings.arguments as String;
    final Future<Pet> petFuture = petProvider.getPetByUuid(petUuid);

    return FutureBuilder<Pet>(
      future: petFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Something went wrong: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text('No pet found.'),
            );
          }

          final Pet pet = snapshot.data!;

          return Scaffold(
            appBar: AppBar(
              title: Text(pet.name),
            ),
            body: _body(context, pet),
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _body(BuildContext context, Pet pet) {
    final PetProvider petProvider =
        Provider.of<PetProvider>(context, listen: true);
    final ImagePicker picker = ImagePicker();

    // ignore: no_leading_underscores_for_local_identifiers
    Future<void> _getImage(ImageSource source) async {
      final XFile? pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        await petProvider.uploadImage(imageFile, pet.uid, pet.image);
      }
    }

    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _petImageWidget(pet),
          //add button to add image from gallery
          ElevatedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Change Image'),
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
            child: const Text('Change Image'),
          ),
          _petInfoWidget(context, pet),
        ],
      ),
    );
  }

  Widget _petImageWidget(Pet pet) {
    String imageUrl = pet.image == ''
        ? 'https://images.gamebanana.com/img/embeddables/Wip_70549_sd_image.jpg?1663639846'
        : pet.image ?? '';

    return SizedBox(
      width: 300,
      height: 300,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: CachedNetworkImage(
            key: UniqueKey(),
            imageUrl: imageUrl,
            width: 300, // Set the width of the image
            height: 300, // Set the height of the image
            fit: BoxFit
                .cover, // Adjust the image to fit within the specified size
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
    );
  }

  // widget to display pet info
  Widget _petInfoWidget(BuildContext context, Pet pet) {
    final PetProvider petProvider =
        Provider.of<PetProvider>(context, listen: true);
    return SizedBox(
      width: 300,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Pet Info',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Name:'),
                  Text(pet.name),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Type:'),
                  Text(pet.type ?? ''),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Age:'),
                  Text(pet.age.toString()),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Bio:"),
                  Text(pet.bio ?? ''),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Open For Adoption:"),
                  Text(pet.isOpenForAdoption == true ? 'Yes' : 'No'),
                ],
              ),
              const SizedBox(height: 12),
              //Button to edit and delete pet
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed('/edit-pet', arguments: pet.uid);
                    },
                    child: const Text('Edit'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      petProvider.deletePet(pet.uid);
                      Navigator.of(context)
                          .popUntil(ModalRoute.withName('/manage-pets'));
                    },
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
