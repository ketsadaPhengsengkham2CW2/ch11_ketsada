import 'package:flutter/material.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

Offset startLastOffset = Offset.zero;
Offset lastOffset = Offset.zero;
Offset _currentOffset = Offset.zero;
double lastScale = 1.0;
double _currentScale = 1.0;

class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[900],
        title: Center(
          child: Text(
            'Gestures & Scale',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: MyWidget(),
    ); // Include _buildBody in the widget tree.
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }
}

Widget _buildBody(BuildContext context) {
  var _onScaleStart;
  var _onScaleUpdate;
  var _onDoubleTap;
  var _onLongPress;
  return GestureDetector(
    child: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        _transformScaleAndTranslate(),
        //_transformMatrix4(),
        _positionedStatusBar(context),
      ],
    ),
    onScaleStart: _onScaleStart,
    onScaleUpdate: _onScaleUpdate,
    onDoubleTap: _onDoubleTap,
    onLongPress: _onLongPress,
  );
}

Transform _transformScaleAndTranslate() {
  return Transform.scale(
    scale: _currentScale,
    child: Transform.translate(
      offset: _currentOffset,
      child: const Image(
        image: AssetImage('assets/img/elephant1.jpg'),
      ),
    ),
  );
}

Transform _transformMatrix4() {
  return Transform(
    transform: Matrix4.identity()
      ..scale(_currentScale, _currentScale)
      ..translate(_currentOffset.dx, _currentOffset.dy),
    alignment: FractionalOffset.center,
    child: Image(
      image: AssetImage('assets/img/elephant1.jpg'),
    ),
  );
}

Positioned _positionedStatusBar(BuildContext context) {
  return Positioned(
    top: 0.0,
    width: MediaQuery.of(context).size.width,
    child: Container(
      color: Colors.white54,
      height: 50.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(
            'Scale: ${_currentScale.toStringAsFixed(4)}',
          ),
          Text(
            'Current: $_currentOffset',
          ),
        ],
      ),
    ),
  );
}

Positioned _positionedInkWellAndInkResponse(BuildContext context) {
  return Positioned(
    top: 50.0,
    width: MediaQuery.of(context).size.width,
    child: Container(
      color: Colors.white54,
      height: 56.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          InkWell(
            child: Container(
              height: 48.0,
              width: 128.0,
              color: Colors.black12,
              child: Icon(
                Icons.touch_app,
                size: 32.0,
              ),
            ),
            splashColor: Colors.lightGreenAccent,
            highlightColor: Colors.lightBlueAccent,
            onTap: _setScaleSmall,
            onDoubleTap: _setScaleBig,
            onLongPress: _onLongPress,
          ),
          InkResponse(
            child: Container(
              height: 48.0,
              width: 128.0,
              color: Colors.black12,
              child: Icon(
                Icons.touch_app,
                size: 32.0,
              ),
            ),
            splashColor: Colors.lightGreenAccent,
            highlightColor: Colors.lightBlueAccent,
            onTap: _setScaleSmall,
            onDoubleTap: _setScaleBig,
            onLongPress: _onLongPress,
          ),
        ],
      ),
    ),
  );
}

void _setScaleSmall() {
  setState(() {
    _currentScale = 0.5;
  });
}

void setState(Null Function() param0) {
}

void _setScaleBig() {
  setState(() {
    _currentScale = 16.0;
  });
}

void _onScaleStart(ScaleStartDetails details) {
  print('ScaleStartDetails: $details');
  startLastOffset = details.focalPoint;
  lastOffset = _currentOffset;
  lastScale = _currentScale;
}

void _onScaleUpdate(ScaleUpdateDetails details) {
  print('ScaleUpdateDetails: $details - Scale: ${details.scale}');
  if (details.scale != 1.0) {
    // Scaling
    double currentScale = lastScale * details.scale;
    if (currentScale < 0.5) {
      currentScale = 0.5;
    }
    setState(() {
      _currentScale = currentScale;
    });
    print('_scale: $_currentScale - _lastScale: $lastScale');
  } else if (details.scale == 1.0) {
    // We are not scaling but dragging around screen
    // Calculate offset depending on current Image scaling.
    Offset offsetAdjustedForScale =
        (startLastOffset - lastOffset) / lastScale;
    Offset currentOffset =
        details.focalPoint - (offsetAdjustedForScale * _currentScale);
    setState(() {
      _currentOffset = currentOffset;
    });
    print(
        'offsetAdjustedForScale: $offsetAdjustedForScale - _currentOffset: $_currentOffset');
  }
}

void _onDoubleTap() {
  print('onDoubleTap');
  // Calculate current scale and populate the _lastScale with currentScale
  // if currentScale is greater than 16 times the original image, reset scale to default, 1.0
  double currentScale = lastScale * 2.0;
  if (currentScale > 16.0) {
    currentScale = 1.0;
    _resetToDefaultValues();
  }
  lastScale = currentScale;
  setState(() {
    _currentScale = currentScale;
  });
}

void _onLongPress() {
  print('onLongPress');
  setState(() {
    _resetToDefaultValues();
  });
}

void _resetToDefaultValues() {
  startLastOffset = Offset.zero;
  lastOffset = Offset.zero;
  _currentOffset = Offset.zero;
  lastScale = 1.0;
  _currentScale = 1.0;
}
