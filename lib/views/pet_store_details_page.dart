import 'package:flutter/material.dart';

class PetStoreDetailsPage extends StatelessWidget {
  const PetStoreDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildInfoBox(
                      'Pet Store 1',
                      Icons.store,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildInfoBox(
                      'Address: 123 Street',
                      Icons.location_on,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              _buildInfoBox(
                'Opening Hours:',
                Icons.schedule,
                children: [
                  _buildOpeningHours('Monday', '9:00 AM - 6:00 PM'),
                  _buildOpeningHours('Tuesday', '9:00 AM - 6:00 PM'),
                  _buildOpeningHours('Wednesday', '9:00 AM - 6:00 PM'),
                  _buildOpeningHours('Thursday', '9:00 AM - 6:00 PM'),
                  _buildOpeningHours('Friday', '9:00 AM - 7:00 PM'),
                  _buildOpeningHours('Saturday', '10:00 AM - 4:00 PM'),
                  _buildOpeningHours('Sunday', 'Closed'),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildButton(
                    'Visit Website',
                    Icons.web,
                    () {
                      // Open website link
                    },
                  ),
                  SizedBox(width: 16),
                  _buildButton(
                    'View Location',
                    Icons.map,
                    () {
                      // Open location map
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildContactButton(
                    'Call Store',
                    Icons.phone,
                    () {
                      // Perform call operation
                    },
                  ),
                  SizedBox(width: 16),
                  _buildContactButton(
                    'WhatsApp',
                    Icons.message,
                    () {
                      // Perform WhatsApp operation
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBox(String title, IconData icon, {List<Widget>? children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Icon(icon, size: 40, color: Colors.blue),
          SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          if (children != null) ...children,
        ],
      ),
    );
  }

  Widget _buildOpeningHours(String day, String hours) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(day),
          Text(hours),
        ],
      ),
    );
  }

  Widget _buildButton(String label, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        primary: Colors.blue,
        onPrimary: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  Widget _buildContactButton(
      String label, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        onPrimary: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: Colors.grey.withOpacity(0.5)),
        ),
      ),
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
          Text(
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
}
