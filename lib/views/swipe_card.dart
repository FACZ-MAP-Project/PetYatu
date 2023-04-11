import 'dart:math';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

class SwipeCard extends StatefulWidget {
  final List<String> photoUrls;
  final List<String> names;
  final List<String> descriptions;

  const SwipeCard(
      {super.key,
      required this.photoUrls,
      required this.names,
      required this.descriptions});

  @override
  _SwipeCardState createState() => _SwipeCardState();
}

class _SwipeCardState extends State<SwipeCard>
    with SingleTickerProviderStateMixin {
  late SwiperController _swiperController;
  late AnimationController _animationController;

  List<bool> likedItems = List.generate(17, (index) => false);
  List<int> totalLikes = List.generate(17, (index) => Random().nextInt(50) + 1);

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
    return Swiper(
      controller: _swiperController,
      itemCount: widget.photoUrls.length,
      itemBuilder: (BuildContext context, int index) {
        return _itemBuilder(index);
      },
      loop: true,
      layout: SwiperLayout.TINDER,
      itemWidth: MediaQuery.of(context).size.width,
      itemHeight: MediaQuery.of(context).size.height,
    );
  }

  Stack _itemBuilder(int index) {
    return Stack(
      children: [
        _imageBox(index),
        _imageDetail(index),
      ],
    );
  }

  Positioned _imageDetail(int index) {
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
        child: _detail(index),
      ),
    );
  }

  Column _detail(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.names[index],
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
                setState(() {
                  if (!likedItems[index]) {
                    totalLikes[index]++;
                  } else {
                    totalLikes[index]--;
                  }
                  likedItems[index] = !likedItems[index];
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  likedItems[index] ? Colors.pink : Colors.grey,
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
                likedItems[index] ? Icons.favorite : Icons.favorite_border,
                color: Colors.white,
              ),
              label: Text(
                'Like (${totalLikes[index]})',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            ElevatedButton.icon(
              onPressed: () {},
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
          ],
        ),
        const SizedBox(height: 10.0),
        Text(
          widget.descriptions[index],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14.0,
          ),
        ),
      ],
    );
  }

  Container _imageBox(int index) {
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
          image: NetworkImage(widget.photoUrls[index]),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
