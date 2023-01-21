import 'package:flutter/foundation.dart';

class CountProvider extends ChangeNotifier {
  /// for static progress bar
  int _count1 = 0;
  int get count1 => this._count1;
  set count1(int i) => throw "error";

  /// for animated progress bar
  double _count2 = 6.0;
  double get count2 => this._count2;
  set count2(double i) => throw "error";

  int _couponCount = 2;
  int get couponCount => this._couponCount;
  set couponCount(int i) => throw "error";

  bool _needNewCoupon = false;
  bool get needNewCoupon => this._needNewCoupon;
  set needNewCoupon(bool b) => throw "error";

  void addCount1(){
    if (this._count1 == 7) return;
    this._count1++;
    this.notifyListeners();
  }

  void removeCount1(){
    if (this._count1 == 0) return;
    this._count1--;
    this.notifyListeners();
  }

  void changeCount(double count){
    if (count == 0 && this._needNewCoupon) {
      this._couponCount ++;
      this._needNewCoupon = false;
      this.notifyListeners();
    }
    this._count2 = count;
    this.notifyListeners();
  }

  void resetCount(){
    this._needNewCoupon = true;
    this.notifyListeners();
  }
}