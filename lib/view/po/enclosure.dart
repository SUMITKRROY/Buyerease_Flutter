import 'package:flutter/material.dart';

class Enclosure extends StatefulWidget {
  const Enclosure({super.key});

  @override
  State<Enclosure> createState() => _EnclosureState();
}

class _EnclosureState extends State<Enclosure> {
  bool showData = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('General', style: TextStyle(fontSize: 18)),
                IconButton(
                    icon: Icon(
                        showData == true
                            ? Icons.keyboard_arrow_up_outlined
                            : Icons.keyboard_arrow_down,
                        size: 30),
                    onPressed: () {
                      setState(() {
                        if (showData == true) {
                          showData = false;
                        } else {
                          showData = true;
                        }
                      });
                    })
              ],
            ),
            showData == true
                ? Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Upload file Name',
                            style: TextStyle(fontSize: 15)),
                        IconButton(
                          icon: Icon(Icons.upload),
                          onPressed: () {},
                        )
                      ],
                    ),
                  )
                : Container(),
            ElevatedButton(onPressed: () {}, child: const Text('SAVE'))
          ],
        ),
      ),
    );
  }
}
