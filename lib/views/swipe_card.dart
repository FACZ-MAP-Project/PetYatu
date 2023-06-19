import 'dart:math';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:petyatu/models/pet.dart';
import 'package:petyatu/providers/pet_provider.dart';
import 'package:petyatu/views/profile_cat_page.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class SwipeCard extends StatefulWidget {
  const SwipeCard({
    super.key,
  });

  @override
  SwipeCardState createState() => SwipeCardState();
}

class SwipeCardState extends State<SwipeCard>
    with SingleTickerProviderStateMixin {
  late SwiperController _swiperController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _swiperController = SwiperController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _swiperController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PetProvider _petProvider =
        Provider.of<PetProvider>(context, listen: true);
    return FutureBuilder<List<Pet>>(
      future: _petProvider.getPetsForAdoption(),
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
          final List<Pet> _pets = snapshot.data!;

          if (_pets.isEmpty) {
            return const Center(
              child: Text('No pets found'),
            );
          } else {
            return Swiper(
              controller: _swiperController,
              itemCount: _pets.length,
              itemBuilder: (BuildContext context, int index) {
                return _itemBuilder(_pets[index]);
              },
              loop: true,
              layout: SwiperLayout.TINDER,
              itemWidth: MediaQuery.of(context).size.width,
              itemHeight: MediaQuery.of(context).size.height,
            );
          }
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Stack _itemBuilder(Pet pet) {
    return Stack(
      children: [
        _imageBox(pet),
        _imageDetail(pet),
      ],
    );
  }

  Positioned _imageDetail(Pet pet) {
    return Positioned(
      left: 0,
      bottom: 0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 300.0,
        padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 32.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.6),
              Colors.black.withOpacity(0.8),
            ],
          ),
        ),
        child: _detail(pet),
      ),
    );
  }

  Column _detail(Pet pet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          pet.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 50.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10.0),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed("/adopt-me", arguments: pet.uid);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Colors.lightBlue,
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
              icon: const Icon(
                Icons.pets,
                color: Colors.white,
              ),
              label: const Text(
                "Adopt Me",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  // if (!likedItems[index]) {
                  //   totalLikes[index]++;
                  // } else {
                  //   totalLikes[index]--;
                  // }
                  // likedItems[index] = !likedItems[index];
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  // likedItems[index] ? Colors.pink : Colors.grey,
                  Colors.pink,
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
                // likedItems[index] ? Icons.favorite : Icons.favorite_border,
                Icons.favorite,
                color: Colors.white,
              ),
              label: Text(
                pet.likes.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                //color: star[index] ? Colors.yellow : Colors.grey,
                color: Colors.yellow,
              ),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    //star[index] = !star[index];
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Icon(
                    //star[index] ? Icons.star : Icons.star_border,
                    Icons.star,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 10.0),
        Text(
          pet.bio ?? "",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14.0,
          ),
        ),
      ],
    );
  }

  Container _imageBox(Pet pet) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
        image: DecorationImage(
          image: NetworkImage(pet.image ?? ""),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 10,
            right: 10,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.ios_share_outlined,
                  color: Colors.black,
                  size: 24.0,
                ),
                onPressed: () {
                  // Handle share button click here
                  // _sharePet(pet);
                  _sharePet(pet);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sharePet(Pet pet) async {
    final response = await http.get(Uri.parse(pet.image ?? ""));
    final bytes = response.bodyBytes;

    final tempDir = await getTemporaryDirectory();
    final tempPath = '${tempDir.path}/image.png';

    final file = File(tempPath);
    await file.writeAsBytes(bytes);

    await Share.shareXFiles(
      [XFile(tempPath)],
      text: "I found ${pet.name}!\n"
          "Check out more pets at https://facz-map-project.github.io/PetYatu/",
      subject: "Look at this pet!",
    );

    // Optionally, delete the temporary file after sharing
    await file.delete();

    // Share.share(
    //   "Check out this pet: ${pet.name}! ${pet.image}",
    //   subject: "Look at this pet!",
    // );
  }
}
