import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Colors.white,
      shadowColor: Colors.grey,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                    flex: 1,
                    child: CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/images/person.jpg'))),
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 8.0),
                    child: Text(
                      'John Doe Angel',
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: PopupMenuButton(
                      itemBuilder: (context) => [
                            const PopupMenuItem(
                              child: Text("First"),
                              value: 1,
                            ),
                            const PopupMenuItem(
                              child: Text("Second"),
                              value: 2,
                            )
                          ]),
                ),
              ],
            ),
          ),
          const Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
            shadowColor: Colors.grey,
            color: Colors.blue,
            child: Image(image: AssetImage('assets/images/person.jpg')),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Wrap(
                children: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.favorite)),
                  IconButton(onPressed: () {}, icon: Icon(Icons.thumb_down)),
                  IconButton(onPressed: () {}, icon: Icon(Icons.comment)),
                ],
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.bookmark_add),
              ),
            ],
          ),
          Text('')
        ],
      ),
    );
  }
}
