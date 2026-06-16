import 'package:flutter/material.dart';

class DmsDetailScreen extends StatelessWidget {
  final String eventId;

  const DmsDetailScreen({Key? key, required this.eventId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Hero(
          tag: eventId,
          child: Container(
            width: double.infinity,
            height: 400,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://via.placeholder.com/800x600/1a1a1a/ffffff?text=Registro+Fotográfico+Ampliável',
                ),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
