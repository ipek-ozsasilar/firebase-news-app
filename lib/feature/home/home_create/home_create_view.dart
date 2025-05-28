import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

class HomeCreateView extends StatefulWidget {
  const HomeCreateView({super.key});

  @override
  State<HomeCreateView> createState() => _HomeCreateViewState();
}

class _HomeCreateViewState extends State<HomeCreateView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
      title: Text('add new item'),
      ),
      body:Padding(
        padding: context.padding.low,
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hint: Text('category'),
              ),
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hint: Text('title'),
              ),
             ),
            SizedBox(
              height: context.sized.dynamicHeight(0.2),
              child: Icon(Icons.add_a_photo_outlined),
              ),
          ],
        ),
      ),
    );
  }
}