//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// © Cosmos Software | Ali Yigit Bireroglu                                                                                                           /
// All material used in the making of this code, project, program, application, software et cetera (the "Intellectual Property")                     /
// belongs completely and solely to Ali Yigit Bireroglu. This includes but is not limited to the source code, the multimedia and                     /
// other asset files. If you were granted this Intellectual Property for personal use, you are obligated to include this copyright                   /
// text at all times.                                                                                                                                /
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//@formatter:off

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'gesture_detector.dart' as MyGestureDetector;
import 'Export.dart';

///The widget that is responsible of detecting Peek & Pop related gestures until the gesture recognition is rerouted to the instantiated
///[PeekAndPopChild]. It is automatically created by the [PeekAndPopController]. It uses [MyGestureDetector.GestureDetector] for reasons
///explained at [PeekAndPopController.startPressure] and [PeekAndPopController.peakPressure]
class PeekAndPopDetector extends StatelessWidget {
  final PeekAndPopControllerState _peekAndPopController;

  final Widget child;

  const PeekAndPopDetector(
    this._peekAndPopController,
    this.child,
  );

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      child: _peekAndPopController.uiChildUseCache ? child : null,
      builder: (BuildContext context, int pressRerouted, Widget cachedChild) {
        return IgnorePointer(
          ignoring: pressRerouted != 0,
          child: MyGestureDetector.GestureDetector(
            startPressure: _peekAndPopController.startPressure,
            peakPressure: _peekAndPopController.peakPressure,
            onTap: () {
              HapticFeedback.mediumImpact();
              _peekAndPopController.peekAndPopComplete();
            },
            onForcePressStart: (ForcePressDetails forcePressDetails) {
              _peekAndPopController.pushPeekAndPop(forcePressDetails);
            },
            onForcePressUpdate: (ForcePressDetails forcePressDetails) {
              _peekAndPopController.updatePeekAndPop(forcePressDetails);
            },
            onForcePressEnd: (ForcePressDetails forcePressDetails) {
              _peekAndPopController.cancelPeekAndPop();
            },
            onForcePressPeak: (ForcePressDetails forcePressDetails) {
              _peekAndPopController.finishPeekAndPop();
            },
            child: _peekAndPopController.uiChildUseCache ? cachedChild : child,
          ),
        );
      },
      valueListenable: _peekAndPopController.pressReroutedNotifier,
    );
  }
}
