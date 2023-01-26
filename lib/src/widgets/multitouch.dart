import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class OnlyOnePointerRecognizer extends OneSequenceGestureRecognizer {
  int _point = 0;

  @override
  void addPointer(PointerDownEvent event) {
    startTrackingPointer(event.pointer);

    if (_point == 0) {
      resolve(GestureDisposition.rejected);
      _point = event.pointer;
    } else {
      resolve(GestureDisposition.accepted);
    }
  }

  @override
  String get debugDescription => 'only one pointer recognizer';

  @override
  void didStopTrackingLastPointer(int pointer) {}

  @override
  void handleEvent(PointerEvent event) {
    if (!event.down && event.pointer == _point) {
      _point = 0;
    }
  }
}

class OnlyOnePointerRecognizerWidget extends StatelessWidget {
  final Widget? child;

  const OnlyOnePointerRecognizerWidget({Key? key, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(gestures: <Type, GestureRecognizerFactory>{
      OnlyOnePointerRecognizer:
          GestureRecognizerFactoryWithHandlers<OnlyOnePointerRecognizer>(
              () => OnlyOnePointerRecognizer(),
              (OnlyOnePointerRecognizer instance) {})
    }, child: child);
  }
}
