import 'package:flutter/material.dart';
import 'package:monotone_flutter/components/my_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text('P L A Y L I S T'),
      ),
      drawer: MyDrawer(),
      body: const Center(
        child: Text('Hello World'),
      ),
    );
  }
}
