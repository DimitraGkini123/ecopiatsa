import 'package:ecopiatsa/main.dart';
import 'package:ecopiatsa/pages/DiscoverDr.dart';
import 'package:ecopiatsa/pages/driver.dart';
import 'package:ecopiatsa/pages/profileinfodr.dart';
import 'package:flutter/material.dart';

import 'help.dart';
//import 'profileInfo.dart';

class settingsdriver extends StatelessWidget {
  const settingsdriver({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings", style: TextStyle(fontSize: 22)),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => DiscoverDr(),
              ),
            );
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.lightGreen.shade900,
          ),
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            Image.asset(
              'assets/profilepic.png',
              width: 78,
              height: 78,
            ),
            SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    _buildListTile(
                      icon: Icons.info_outline,
                      title: 'Profile info',
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => ProfileInfoScreenDr(userId: Driver.loggedInUserId ?? 0 ),
                          ),
                        );
                        // Handle navigation to the profile info page
                      },
                      showArrow: true,
                    ),
                    _buildListTile(
                      icon: Icons.help_outline,
                      title: 'Help',
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => help()),
                        );
                        // Handle navigation to the help page
                      },
                      showArrow: true,
                    ),
                    _buildListTile(
                      icon: Icons.logout,
                      title: 'Log out',
                      onPressed: () {
                        Driver.clearLoggedInUserId();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => MyApp(),
                          ),
                        );
                      },
                      showArrow: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onPressed,
    bool showArrow = false,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.lightGreen.shade900,
          size: 26.0,
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 22, fontFamily: 'TiroDevanagari'),
        ),
        trailing: showArrow
            ? Icon(
                Icons.arrow_forward_ios,
                color: Colors.lightGreen.shade900,
                size: 18.0,
              )
            : null,
      ),
    );
  }
}
