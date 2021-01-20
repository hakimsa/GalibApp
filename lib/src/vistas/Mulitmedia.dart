import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Multi_Video extends StatelessWidget {

  static final String routeName="Videos";
Multi_Video({Key key, this.controller_v, this.title, this.subtitle,this.isInitialRoute})
      : super(key: key);

 VideoPlayerController controller_v;
  final String title;
  final String subtitle;
   final bool isInitialRoute;

  Widget _buildInlineVideo() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
      child: Center(
        child: AspectRatio(
          aspectRatio: 3 / 2,
          child: Hero(
            tag: "controller",
            child: VideoPlayerLoading(controller_v),
          ),
        ),
      ),
    );
  }

  Widget _buildFullScreenVideo() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Multimedia"),
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 3 / 2,
          child: Hero(
            tag: controller_v,
            child: VideoPlayPause(controller_v),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget fullScreenRoutePageBuilder(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
    ) {
      return _buildFullScreenVideo();
    }

    void pushFullScreenWidget() {
      final TransitionRoute<void> route = PageRouteBuilder<void>(
      //  settings: RouteSettings(name: "X", isInitialRoute: false),
        pageBuilder: fullScreenRoutePageBuilder,
      );

      route.completed.then((void value) {
        controller_v.setVolume(0.0);
      });

      controller_v.setVolume(1.0);
      Navigator.of(context).push(route);
    }

    return SafeArea(
      top: false,
      bottom: false,
      child: Card(
        child: Column(
          children: <Widget>[

            //ListTile(title: Text(controller_v.dataSource.substring(12,19)), subtitle: Text(AutofillHints.addressState)),
            GestureDetector(

              onTap: pushFullScreenWidget,
              child: _buildInlineVideo(),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoPlayerLoading extends StatefulWidget {
  const VideoPlayerLoading(this.controller_v);

  final VideoPlayerController controller_v;

  @override
  _VideoPlayerLoadingState createState() => _VideoPlayerLoadingState();
}

class _VideoPlayerLoadingState extends State<VideoPlayerLoading> {
  bool _initialized;

  @override
  void initState() {
    super.initState();
    _initialized = widget.controller_v.value.initialized;
    widget.controller_v.addListener(() {
      if (!mounted) {
        return;
      }
      final bool controllerInitialized = widget.controller_v.value.initialized;
      if (_initialized != controllerInitialized) {
        setState(() {
          _initialized = controllerInitialized;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_initialized) {
      return VideoPlayer(widget.controller_v);
    }
    return Stack(
      children: <Widget>[
        VideoPlayer(widget.controller_v),
        const Center(child: CircularProgressIndicator()),
      ],
      fit: StackFit.expand,
    );
  }
}

class VideoPlayPause extends StatefulWidget {
  const VideoPlayPause(this.controller);

  final VideoPlayerController controller;

  @override
  State createState() => _VideoPlayPauseState();
}

class _VideoPlayPauseState extends State<VideoPlayPause> {
  _VideoPlayPauseState() {
    listener = () {
      if (mounted) setState(() {});
    };
  }

  FadeAnimation imageFadeAnimation;
  VoidCallback listener;

  VideoPlayerController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
  }

  @override
  void deactivate() {
    controller.removeListener(listener);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      fit: StackFit.expand,
      children: <Widget>[
        GestureDetector(
          child: VideoPlayerLoading(controller),
          onTap: () {
            if (!controller.value.initialized) {
              return;
            }
            if (controller.value.isPlaying) {
              imageFadeAnimation = const FadeAnimation(
                child: Icon(Icons.pause, size: 100.0),
              );
              controller.pause();
            } else {
              imageFadeAnimation = const FadeAnimation(
                child: Icon(Icons.play_arrow, size: 100.0),
              );
              controller.play();
            }
          },
        ),
        Center(child: imageFadeAnimation),
      ],
    );
  }
}

class FadeAnimation extends StatefulWidget {
  const FadeAnimation({
    this.child,
    this.duration = const Duration(milliseconds: 500),
  });

  final Widget child;
  final Duration duration;

  @override
  _FadeAnimationState createState() => _FadeAnimationState();
}

class _FadeAnimationState extends State<FadeAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    animationController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    animationController.forward(from: 0.0);
  }

  @override
  void deactivate() {
    animationController.stop();
    super.deactivate();
  }

  @override
  void didUpdateWidget(FadeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      animationController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return animationController.isAnimating
        ? Opacity(
            opacity: 1.0 - animationController.value,
            child: widget.child,
          )
        : Container();
  }
}

class ConnectivityOverlay extends StatefulWidget {
  const ConnectivityOverlay({
    this.child,
    this.connectedCompleter,
    this.scaffoldKey,
  });

  final Widget child;
  final Completer<void> connectedCompleter;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  _ConnectivityOverlayState createState() => _ConnectivityOverlayState();
}

class _ConnectivityOverlayState extends State<ConnectivityOverlay> {
  StreamSubscription<ConnectivityResult> connectivitySubscription;
  bool connected = true;

  static const Widget errorSnackBar = SnackBar(
    backgroundColor: Colors.red,
    content: ListTile(
      title: Text('No network'),
      subtitle: Text(
        'To load the videos you must have an active network connection',
      ),
    ),
  );

  Stream<ConnectivityResult> connectivityStream() async* {
    final Connectivity connectivity = Connectivity();
    ConnectivityResult previousResult = await connectivity.checkConnectivity();
    yield previousResult;
    await for (ConnectivityResult result
        in connectivity.onConnectivityChanged) {
      if (result != previousResult) {
        yield result;
        previousResult = result;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    connectivitySubscription = connectivityStream().listen(
      (ConnectivityResult connectivityResult) {
        if (!mounted) {
          return;
        }
        if (connectivityResult == ConnectivityResult.none) {
          widget.scaffoldKey.currentState.showSnackBar(errorSnackBar);
        } else {
          if (!widget.connectedCompleter.isCompleted) {
            widget.connectedCompleter.complete(null);
          }
        }
      },
    );
  }

  @override
  void dispose() {
    connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class Video_show extends StatefulWidget {
  const Video_show({Key key}) : super(key: key);

  @override
  _Video_showState createState() => _Video_showState();
}

final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

Future<bool> isIOSSimulator() async {
  return Platform.isIOS && !(await deviceInfoPlugin.iosInfo).isPhysicalDevice;
}

class _Video_showState extends State<Video_show>
    with SingleTickerProviderStateMixin {
  final VideoPlayerController butterflyController =
      VideoPlayerController.asset('assets/videos/shobe.mp4');
  final VideoPlayerController presentacionVideourl =
  VideoPlayerController.network('http://techslides.com/demos/sample-videos/small.mp4');
  // TODO(sigurdm): This should not be stored here.
  static const String beeUri =
      'assets/videos/moro.mp4';
  final VideoPlayerController beeController =
  VideoPlayerController.asset("assets/videos/moro.mp4");
  final VideoPlayerController presentacionvideo =
  VideoPlayerController.asset("assets/videos/pres.mp4");
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final Completer<void> connectedCompleter = Completer<void>();
  bool isSupported = true;
  bool isDisposed = false;

  @override
  void initState() {
    super.initState();

    Future<void> initController(
        VideoPlayerController controller, String name) async {
      print(
          '> VideoDemo initController "$name" ${isDisposed ? "DISPOSED" : ""}');
      controller.setLooping(true);
      controller.setVolume(0.0);
      controller.play();
      await connectedCompleter.future;
      await controller.initialize();
      if (mounted) {
        print(
            '< VideoDemo initController "$name" done ${isDisposed ? "DISPOSED" : ""}');
        setState(() {});
      }
    }

    initController(butterflyController, 'infogra');
    initController(beeController, 'infogra');
    initController(presentacionvideo, 'presentacion');
    initController(presentacionVideourl, 'presentacion');
    isIOSSimulator().then<void>((bool result) {
      isSupported = !result;
    });
  }

  @override
  void dispose() {
    print('> VideoDemo dispose');
    isDisposed = true;
    butterflyController.dispose();
    beeController.dispose();
    print('< VideoDemo dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Videos'),
      ),
      body: isSupported
          ? ConnectivityOverlay(
              child: Scrollbar(
                child: ListView(
                  children: <Widget>[
                    Multi_Video(
                      title: 'Presentacion',
                      subtitle: 'Pesentacion Marketing digital',
                      controller_v: presentacionvideo,
                    ),
                    Multi_Video(
                      title: 'Butterfly',
                      subtitle: '… flutters by',
                      controller_v: butterflyController,
                    ),
                    Multi_Video(
                      title: 'infogra q',
                      subtitle: '… gently buzzing',
                      controller_v: beeController,
                    ),
                    Multi_Video(
                      title: 'Presentacion',
                      subtitle: 'Pesentacion Marketing digital',
                      controller_v: presentacionVideourl,
                    ),
                  ],
                ),
              ),
              connectedCompleter: connectedCompleter,
              scaffoldKey: scaffoldKey,
            )
          : const Center(
              child: Text(
                'Video playback not supported on the iOS Simulator.',
              ),
            ),
    );
  }
}
