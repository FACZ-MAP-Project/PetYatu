import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:petyatu/models/history.dart';
import 'package:petyatu/providers/history_provider.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    final HistoryProvider _historyProvider =
        Provider.of<HistoryProvider>(context, listen: true);

    return Scaffold(
      appBar: _appBar(),
      body: _body(context),
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
            child: Image.asset(
              'lib/assets/images/logo.png',
              fit: BoxFit.contain,
              height: 32,
            ),
          ),
          const Text(
            'PetYatu',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    final HistoryProvider _historyProvider =
        Provider.of<HistoryProvider>(context, listen: true);

    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _allHistoryWidget(),
        ],
      ),
    );
  }

  Widget _allHistoryWidget() {
    final HistoryProvider _historyProvider =
        Provider.of<HistoryProvider>(context, listen: true);

    return FutureBuilder<List<History>>(
      future: _historyProvider.viewMyHistory(),
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

        return Expanded(
          child: ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              // Sort the data by dateCreated in descending order (newest to oldest)
              snapshot.data!
                  .sort((a, b) => b.dateCreated.compareTo(a.dateCreated));
              String imageUrl = snapshot.data![index].image == ''
                  ? 'https://images.gamebanana.com/img/embeddables/Wip_70549_sd_image.jpg?1663639846'
                  : snapshot.data![index].image ?? '';
              // Get the dateCreated and current time as DateTime objects
              DateTime dateCreated = snapshot.data![index].dateCreated;
              DateTime currentTime = DateTime.now();

              // Calculate the time difference in days and weeks
              int daysDifference = currentTime.difference(dateCreated).inDays;
              int weeksDifference = daysDifference ~/ 7;

              String timeAgo;
              if (weeksDifference > 0) {
                timeAgo =
                    "$weeksDifference ${weeksDifference == 1 ? 'week' : 'weeks'} ago";
              } else if (daysDifference > 0) {
                timeAgo =
                    "$daysDifference ${daysDifference == 1 ? 'day' : 'days'} ago";
              } else if (currentTime.difference(dateCreated).inHours > 0) {
                int hoursDifference =
                    currentTime.difference(dateCreated).inHours;
                timeAgo =
                    "$hoursDifference ${hoursDifference == 1 ? 'hour' : 'hours'} ago";
              } else {
                int minutesDifference =
                    currentTime.difference(dateCreated).inMinutes;
                timeAgo =
                    "$minutesDifference ${minutesDifference == 1 ? 'minute' : 'minutes'} ago";
              }
              return ListTile(
                leading: CachedNetworkImage(
                  imageUrl: imageUrl,
                  imageBuilder: (context, imageProvider) => Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                title: Text(snapshot.data![index].sentence),
                subtitle: Text(timeAgo),
                onTap: () {
                  if (snapshot.data![index].type == 'MY_PET') {
                    Navigator.pushNamed(context, '/view-pet',
                        arguments: snapshot.data![index].pet);
                  }
                },
              );
            },
          ),
        );
      },
    );
  }
}
