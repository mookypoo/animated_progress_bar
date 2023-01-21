import 'package:flutter/material.dart';
import 'package:progress_bar/progress_bar.dart';
import 'package:provider/provider.dart';

import 'count_provider.dart';

class AnimatedBar extends StatefulWidget {
  const AnimatedBar({Key? key}) : super(key: key);

  @override
  State<AnimatedBar> createState() => _AnimatedBarState();
}

class _AnimatedBarState extends State<AnimatedBar> with TickerProviderStateMixin {
  Animation<double>? _countAnimation;
  Animation<double>? _couponAnimation;
  AnimationController? _countAnimationController;
  AnimationController? _couponAnimationController;

  @override
  void initState() {
    super.initState();
    this._countAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))
      ..addListener(() async {
        if (this._countAnimationController!.isAnimating) {
          context.read<CountProvider>().changeCount(this._countAnimation!.value);
        }
        if (this._countAnimationController!.isCompleted) {
          context.read<CountProvider>().changeCount(this._countAnimation!.value);
          if (context.read<CountProvider>().count2 == 7) {
            await showDialog(
              context: context,
              builder: (BuildContext ctx) {
                return Dialog(
                  child: Container(
                      alignment: Alignment.center,
                      height: 150.0,
                      width: 100.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Congratulations!\nYou have received a coupon!", style: TextStyle(fontSize: 16.0),),
                          TextButton(onPressed: Navigator.of(ctx).pop, child: Text("Close", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),))
                        ],
                      )
                  ),
                );
              },
            );

            this._countAnimation = Tween<double>(begin: 7.0, end: 0.0).animate(this._countAnimationController!);
            this._countAnimationController?.reset();
            context.read<CountProvider>().resetCount();
            this._countAnimationController!.forward();
            this._couponAnimationController!.forward();
          }
        }
      });
    this._couponAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 600))
      ..addListener(() {
        if (this._couponAnimationController!.isAnimating) this.setState(() {});
      });
    final double _count = context.read<CountProvider>().count2;
    this._couponAnimation = Tween<double>(begin: 15.0, end: 26.0).animate(this._couponAnimationController!);
    this._countAnimation = Tween<double>(begin: _count, end: _count+1).animate(this._countAnimationController!);
  }

  @override
  void dispose() {
    this._countAnimationController?.dispose();
    this._couponAnimationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Builder(
              builder: (BuildContext ctx) {
                final int _stampCount = ctx.select<CountProvider, int>((CountProvider p) => p.couponCount);
                if (_stampCount == 0) return const SizedBox();
                return Container(
                  margin: const EdgeInsets.only(left: 30.0),
                  child: Row(
                    children: List.generate(_stampCount, (int i) => SizedBox(
                      width: 30.0,
                      child: Icon(Icons.local_attraction, size: 26.0),),
                    ),
                  ),
                );
              },
            ),
            Builder(
              builder: (BuildContext ctx) {
                final bool _needNewStamp = ctx.select<CountProvider, bool>((CountProvider p) => p.needNewCoupon);
                if (!_needNewStamp) return const SizedBox();
                return Container(
                  width: 30.0,
                  child: Icon(Icons.local_attraction, size: this._couponAnimation?.value ?? 26.0),
                );
              },
            ),
          ],
        ),
        Builder(
          builder: (BuildContext ctx) {
            final double _count = ctx.select<CountProvider, double>((CountProvider p) => p.count2);
            return ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: ProgressBar(count: _count),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () async {
                  final int _count = this._countAnimation!.value.toInt();
                  if (_count == 0) return;
                  this._countAnimation = Tween<double>(begin: _count.toDouble(), end: _count - 1).animate(this._countAnimationController!);
                  this._countAnimationController?.reset();
                  await this._countAnimationController!.forward();
                },
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  final int _count = this._countAnimation!.value.toInt();
                  this._countAnimation = Tween<double>(begin: _count.toDouble(), end: _count + 1).animate(this._countAnimationController!);
                  this._countAnimationController?.reset();
                  await this._countAnimationController!.forward();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

