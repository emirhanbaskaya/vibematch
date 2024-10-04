import 'package:flutter/material.dart';

class NameScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController monthController = TextEditingController();
  final TextEditingController dayController = TextEditingController();
  final TextEditingController yearController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: monthController,
                    decoration: InputDecoration(
                      labelText: 'Month',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: dayController,
                    decoration: InputDecoration(
                      labelText: 'Day',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: yearController,
                    decoration: InputDecoration(
                      labelText: 'Year',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/spotify');
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
