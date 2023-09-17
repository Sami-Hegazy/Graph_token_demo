import 'package:flutter/material.dart';

class DraggableContainer extends StatefulWidget {
  const DraggableContainer({super.key});

  @override
  State<DraggableContainer> createState() => _DraggableContainerState();
}

class _DraggableContainerState extends State<DraggableContainer> {
  double _xOffset = 0.0;
  double _yOffset = 0.0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _xOffset += details.delta.dx;
          _yOffset += details.delta.dy;
        });
      },
      child: Container(
        width: 200,
        height: 200,
        color: Colors.blue,
        transform: Matrix4.translationValues(_xOffset, _yOffset, 0.0),
        child: Draggable(
          data: 'draggable_container',
          feedback: Container(
            width: 200,
            height: 200,
            color: Colors.green,
            child: const Center(
              child: Text('Dragging'),
            ),
          ),
          childWhenDragging: Container(),
          onDragEnd: (details) {
            setState(() {
              _xOffset = 0.0;
              _yOffset = 0.0;
            });
          },
          child: const Center(
            child: Text('Drag me'),
          ),
        ),
      ),
    );
  }
}
