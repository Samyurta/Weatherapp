import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/helpscreen.dart';

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        children: [
          Image.network(
            'https://www.vhv.rs/dpng/d/427-4270068_gold-retro-decorative-frame-png-free-download-transparent.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'We Show Weather For You',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/homepage');
                  },style: ElevatedButton.styleFrom(
              primary: Colors.pinkAccent, // Set the background color here
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Customize the button shape
      ), // Set the background color here
  ),
              child: Text('Skip'),
              
              
            ),
                  
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}
