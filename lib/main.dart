import 'dart:developer';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final TrackerListController controller;

  @override
  void initState() {
    super.initState();
    controller = TrackerListController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TrackerListComponent(
              steps: const [
                'Texto exemplo 1',
                'Texto exemplo 2',
                'Texto exemplo 3',
                'Texto exemplo 4',
                'Texto exemplo 5',
                'Texto exemplo 6',
                'Texto exemplo 7',
                'Texto exemplo 8',
                'Texto exemplo 9',
                'Texto exemplo 10',
              ],
              controller: controller,
            ),
            const SizedBox(
              height: 24,
            ),
            ElevatedButton(
              onPressed: controller.next,
              child: const Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}

class TrackerListController extends ValueNotifier<int> {
  TrackerListController() : super(0);

  int _stepCount = 0;
  List<AnimationController> _controllers = [];
  List<Animation<double>> _animations = [];

  late final AnimationController _progressController;
  late final Animation<double> _progressAnimation;

  final ValueNotifier<int> currentIndex = ValueNotifier<int>(0);

  void initializeControllers({
    required TickerProvider tickerProvider,
    required int stepCount,
  }) {
    _stepCount = stepCount;

    for (int i = 0; i < stepCount; i++) {
      final controller = AnimationController(
        vsync: tickerProvider,
        duration: const Duration(milliseconds: 600),
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

    _progressController = AnimationController(
      vsync: tickerProvider,
      duration: const Duration(milliseconds: 600),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeInOut,
      ),
    );

    _controllers[0].forward();
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    _progressController.dispose();
    super.dispose();
  }

  void next() {
    if (currentIndex.value < _stepCount - 1) {
      _progressController.forward(from: 0.0).then(
        (_) {
          currentIndex.value++;
          _controllers[currentIndex.value].forward();
        },
      );
    }
  }

  int get stepCount => _stepCount;
  List<Animation<double>> get animations => _animations;
  Animation<double> get progressAnimation => _progressAnimation;
}

class TrackerListComponent extends StatefulWidget {
  const TrackerListComponent({
    super.key,
    required this.steps,
    required this.controller,
  });

  final TrackerListController controller;
  final List<String> steps;

  @override
  State<TrackerListComponent> createState() => _TrackerListComponentState();
}

class _TrackerListComponentState extends State<TrackerListComponent>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.controller.initializeControllers(
      tickerProvider: this,
      stepCount: widget.steps.length,
    );
  }

  @override
  void dispose() {
    widget.controller.dispose();
    widget.controller.currentIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log(widget.controller.currentIndex.toString());
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        ValueListenableBuilder<int>(
          valueListenable: widget.controller.currentIndex,
          builder: (context, currentIndex, child) {
            return ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: widget.controller.animations[index],
                  builder: (context, child) {
                    return Row(
                      children: [
                        SizedBox(
                          width: 24,
                          child: Center(
                            child: SizedBox(
                              width: widget.controller.animations[index].value,
                              height: widget.controller.animations[index].value,
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
                          animation: widget.controller.progressAnimation,
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
              itemCount: widget.controller.stepCount,
            );
          },
        ),
      ],
    );
  }
}
