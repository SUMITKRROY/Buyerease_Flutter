import 'package:flutter/material.dart';

class DigitalUploaded extends StatefulWidget {
  const DigitalUploaded({super.key});

  @override
  State<DigitalUploaded> createState() => _DigitalUploadedState();
}

class _DigitalUploadedState extends State<DigitalUploaded> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: Colors.black),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Add Images',
                  style: TextStyle(fontSize: 15),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.camera_alt))
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: Colors.black),
              color: Colors.white,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 30,child: Text('Title', style: TextStyle(fontSize: 12))),
                SizedBox(width: 65,child: Text('Description', style: TextStyle(fontSize: 12))),
                SizedBox(width: 70,child: Text('Attachments', style: TextStyle(fontSize: 12))),
                SizedBox(width: 35,child: Text('Delete', style: TextStyle(fontSize: 12)))
              ],
            ),
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: Colors.black),
              color: Colors.white,
            ),
            // width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.4,
            child: ListView.builder(
                itemCount: 2,
                itemBuilder: (e, index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 65,child: Text('Alignment')),
                      const SizedBox(width: 70,child: Text('Alignment')),
                      SizedBox(width: 50,child: Image.asset('assets/images/icon0.png',width: 30, height: 30)),
                      const SizedBox(width: 30,child: Icon(Icons.delete))
                    ],
                  );
                }),
          )
        ],
      ),
    );
  }
}
