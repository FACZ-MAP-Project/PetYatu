import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/pet_provider.dart';
import '../../models/pet.dart';

//class named ViewPet with argument called pet
class ViewPet extends StatelessWidget {
  final Pet pet;

  const ViewPet({Key? key, required this.pet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PetProvider _petProvider =
        Provider.of<PetProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(pet.name),
      ),
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _petImageWidget(),
          _petInfoWidget(),
        ],
      ),
    );
  }

  Widget _petImageWidget() {
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(pet.image == ''
              ? 'https://images.gamebanana.com/img/embeddables/Wip_70549_sd_image.jpg?1663639846'
              : pet.image ?? ''),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // widget to display pet info
  Widget _petInfoWidget() {
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
                  Text(pet.age.toString() ?? ''),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
