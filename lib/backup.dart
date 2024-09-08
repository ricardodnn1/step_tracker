import 'package:flutter/material.dart';

class TrackerListComponent extends StatefulWidget {
  const TrackerListComponent({
    super.key,
    required this.steps,
  });

  final List<String> steps;

  @override
  State<TrackerListComponent> createState() => _TrackerListComponentState();
}

class _TrackerListComponentState extends State<TrackerListComponent>
    with TickerProviderStateMixin {
  final List<AnimationController> _controllers = [];
  final List<Animation<double>> _animations = [];
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);

  late final AnimationController _progressController;
  late final Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < widget.steps.length; i++) {
      final controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      );

      final animation = Tween<double>(begin: 20, end: 24).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeInOut,
        ),
      );

      _controllers.add(controller);
      _animations.add(animation);
    }

    _controllers[0].forward();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeInOut,
      ),
    );

    _progressController.repeat(reverse: true);
  }

  void stopProgressAnimation() {
    if (_progressAnimation.value > 0.99) {
      _progressController.stop();
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    _progressController.dispose();
    _currentIndex.dispose();
    super.dispose();
  }

  void next() {
    if (_currentIndex.value < widget.steps.length - 1) {
      _progressController.forward(from: 0.0).then(
        (_) {
          _currentIndex.value++;
          _controllers[_currentIndex.value].forward();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ValueListenableBuilder<int>(
            valueListenable: _currentIndex,
            builder: (context, currentIndex, child) {
              return ListView.separated(
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: _animations[index],
                    builder: (context, child) {
                      return Row(
                        children: [
                          SizedBox(
                            width: 24,
                            child: Center(
                              child: SizedBox(
                                width: _animations[index].value,
                                height: _animations[index].value,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: index <= currentIndex
                                        ? Colors.green
                                        : Colors.grey,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: index <= currentIndex
                                      ? const Icon(
                                          Icons.check,
                                          size: 12,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
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
                  );
                },
                separatorBuilder: (context, index) {
                  return Row(
                    children: [
                      SizedBox(
                        width: 24,
                        child: Center(
                          child: AnimatedBuilder(
                            animation: _progressAnimation,
                            builder: (context, child) {
                              return SizedBox(
                                width: 2,
                                height: 24,
                                child: RotatedBox(
                                  quarterTurns: 1,
                                  child: LinearProgressIndicator(
                                    value: index < currentIndex ? 1.0 : 0.0,
                                    backgroundColor: Colors.grey[300],
                                    color: Colors.green,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
                itemCount: widget.steps.length,
              );
            },
          ),
        ),
        ElevatedButton(
          onPressed: next,
          child: const Text("Next"),
        ),
      ],
    );
  }
}
