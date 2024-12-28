import 'package:flutter/material.dart';

class QuoteBox extends StatelessWidget {
  const QuoteBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      height: 400,
      width: double.infinity,
      decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                  "https://img.freepik.com/premium-photo/banner-woman-sitting-office-with-laptop-computer-yellow-desktop_180633-909.jpg?semt=ais_hybrid"))),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "The beautiful thing about learning is that no one can take it away from you.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            SizedBox(height: 8),
            Text(
              "--- B.B.King",
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ],
        ),
      ),
    ));
  }
}
