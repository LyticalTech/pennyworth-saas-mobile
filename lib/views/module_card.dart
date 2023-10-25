import 'package:flutter/material.dart';

class ModulesCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final IconData icon;

  ModulesCard({required this.title, required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Card(
          color: Colors.white,
          margin: EdgeInsets.symmetric(vertical: 12.0),
          elevation: 3,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(icon, size: 56, color: Colors.orange,),
                  SizedBox(height: 8,),
                  Text(title)
                ],
              ),
            ),
          ),
        ),
    );
  }
}