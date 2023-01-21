import 'package:flutter/material.dart';
import 'package:progress_bar/progress_bar.dart';
import 'package:provider/provider.dart';

import 'animated_bar.dart';
import 'count_provider.dart';

void main() => runApp(const ProgressBarApp());

class ProgressBarApp extends StatelessWidget {
  const ProgressBarApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// in an actual app, you'll be using MultiProvider
    return ChangeNotifierProvider<CountProvider>(
      create: (_) => CountProvider(),
      child: const MaterialApp(home: Home()),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// listen: false if you do not want this widget to rebuild when the provider notifies its listeners
    /// since I'm only creating the instance to use its methods, do not need to listen
    final CountProvider _countProvider = Provider.of(context, listen: false);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Builder(
              /// use Builder + select so that only this widget will rebuild when the selected value changes in a provider
              builder: (BuildContext ctx) {
                final int _count = ctx.select<CountProvider, int>((CountProvider p) => p.count1);
                return ProgressBar(count: _count);
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: _countProvider.removeCount1,
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _countProvider.addCount1,
                  ),
                ],
              ),
            ),
            const AnimatedBar(),
          ],
        ),
      ),
    );
  }
}
