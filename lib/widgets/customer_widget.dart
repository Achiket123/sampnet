import 'package:flutter/material.dart';
import 'package:hackathon/globals/constants/assets.dart';
import 'package:hackathon/globals/constants/color_pallete.dart';
import 'package:hackathon/globals/constants/styles.dart';

class CustomerWidget extends StatelessWidget {
  const CustomerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final swidth = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(15),
      width: swidth / 4,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color.fromARGB(255, 28, 28, 28)),
      child: Column(
        children: [
          ListTile(
            leading: Image.asset(ImageAssets.profile),
            title: const Text(
              "John Doe",
              style: TextStyle(color: Colors.white),
            ),
            subtitle: const Row(
              children: [
                Icon(
                  Icons.star,
                  color: Colors.yellow,
                ),
                Icon(
                  Icons.star,
                  color: Colors.yellow,
                ),
                Icon(
                  Icons.star,
                  color: Colors.yellow,
                ),
                Icon(
                  Icons.star,
                  color: Colors.yellow,
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(18.0),
            child: Text(
              "Aliqua ut mollit est incididunt aliqua. Amet quis exercitation occaecat est laborum incididunt commodo nulla duis eiusmod proident pariatur. Commodo incididunt aliquip dolore nisi in culpa proident incididunt minim ex officia et deserunt fugiat. Ea eiusmod aliqua ut pariatur enim deserunt culpa id excepteur commodo duis. Occaecat quis duis dolor eu magna dolore ea adipisicing qui.",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
