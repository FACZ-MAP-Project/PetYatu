import 'package:flutter/material.dart';
import 'package:petyatu/models/pet.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/pet_provider.dart';

class Profile extends StatelessWidget {
  const Profile({
    Key? key,
  }) : super(key: key);

  Future<void> _launchURL(url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

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
          if (!snapshot.hasData || snapshot.data?.uid == '') {
            return const Center(
              child: Text('No pet found.'),
            );
          }

          final Pet pet = snapshot.data!;

          return Scaffold(
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Colors.black),
              title: const Text(
                "Adopt Me",
                style: TextStyle(color: Colors.black),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image(
                    image: NetworkImage(pet.image ?? ''),
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pet.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Age: ${pet.age}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Type: ${pet.type}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Location: ${pet.location}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Bio: ${pet.bio}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _launchURL('sms:${pet.contact}');
                              },
                              child: const Text('Message'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _launchURL(
                                    'whatsapp://send?phone=${pet.contact}');
                              },
                              child: const Text('WhatsApp'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _launchURL('tel:${pet.contact}');
                              },
                              child: const Text('Call'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
