import 'package:flutter/material.dart';
import 'package:petyatu/providers/history_provider.dart';
import 'package:provider/provider.dart';
import '../../providers/pet_provider.dart';
import '../../models/pet.dart';
import 'view_pet.dart';

class ManagePets extends StatefulWidget {
  const ManagePets({Key? key}) : super(key: key);

  @override
  _ManagePetsState createState() => _ManagePetsState();
}

class _ManagePetsState extends State<ManagePets> {
  @override
  Widget build(BuildContext context) {
    final PetProvider _petProvider =
        Provider.of<PetProvider>(context, listen: true);

    return Scaffold(
        appBar: AppBar(
          title: const Text('My Pets'),
        ),
        body: _body(context));
  }

  Widget _body(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _addPetButton(context),
          _allPetsWidget(),
        ],
      ),
    );
  }

  Widget _addPetButton(context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pushNamed('/add-pet');
      },
      child: const Text('Add Pet'),
    );
  }

  Widget _allPetsWidget() {
    final PetProvider _petProvider =
        Provider.of<PetProvider>(context, listen: true);

    final HistoryProvider _historyProvider =
        Provider.of<HistoryProvider>(context, listen: true);

    return FutureBuilder<List<Pet>>(
      future: _petProvider.viewMyPets(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Something went wrong: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          final List<Pet> _pets = snapshot.data!;

          if (_pets.isEmpty) {
            return const Center(
              child: Text('You have no pets'),
            );
          } else {
            return SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: _pets.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_pets[index].name),
                    // subtitle that is not a text but a clickable widget
                    subtitle: InkWell(
                      onTap: () {
                        // ViewPet
                        Navigator.of(context).pushNamed('/view-pet',
                            arguments: _pets[index].uid);
                      },
                      child: const Text(
                        'View Details',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        // delete pet
                        _petProvider.deletePet(_pets[index].uid);
                        _historyProvider.historyDeletePet(_pets[index]);
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  );
                },
              ),
            );
          }
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
