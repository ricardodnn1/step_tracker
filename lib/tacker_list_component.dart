import 'package:flutter/material.dart';

class TackerListComponent extends StatefulWidget {
  const TackerListComponent({
    super.key,
    required this.steps,
  });

  final List<String> steps;

  @override
  State<TackerListComponent> createState() => _TackerListComponentState();
}

class _TackerListComponentState extends State<TackerListComponent> {
  double _width = 20;
  double _height = 20;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200)).then(
      (value) => {
        _width = _width + 4,
        _height = _height + 4,
      },
    );

    setState(() {
      Future.delayed(const Duration(milliseconds: 200)).then(
        (value) => {
          _width = _width + 10,
          _height = _height + 10,
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return Row(
          children: [
            SizedBox(
              width: _width,
              height: _height,
              child: AnimatedContainer(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                duration: const Duration(seconds: 2),
                child: const Icon(
                  Icons.check,
                  size: 12,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(widget.steps[index]),
            ),
          ],
        );
      },
      separatorBuilder: (context, index) {
        return Row(
          children: [
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: _width / 2, vertical: 0),
              child: SizedBox(
                width: 2,
                height: 24,
                child: RotatedBox(
                  quarterTurns: 1,
                  child: LinearProgressIndicator(
                    value: 1,
                    backgroundColor: Colors.grey[300],
                    color: Colors.green,
                  ),
                ),
              ),
            ),
          ],
        );
      },
      itemCount: widget.steps.length,
    );
  }
}
