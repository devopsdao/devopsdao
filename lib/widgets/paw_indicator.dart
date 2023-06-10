import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rive/rive.dart';

/// [RefreshIndicator] with the space animation.
///
/// Example:
/// ```dart
/// @override
/// Widget build(BuildContext context) {
///   return Scaffold(
///     appBar: AppBar(),
///     body: RefreshConfiguration(
///       // should be greater than the AstroRefreshIndicator height
///       headerTriggerDistance: 155,
///       child: SmartRefresher(
///         header: const AstroRefreshIndicator(),
///         controller: _refreshController,
///         onRefresh: _onRefresh,
///         child: ListView.builder(
///           padding: const EdgeInsets.symmetric(vertical: 5),
///           itemBuilder: (c, i) => const Card(),
///           itemExtent: 200,
///           itemCount: 5,
///         ),
///       ),
///     ),
///   );
/// }
/// ```
class AstroRefreshIndicator extends RefreshIndicator {
  /// Creates a refresh indicator.
  ///
  /// `fit` is a [BoxFit] for the animation
  ///
  /// `backgroundColor` is a color to paint behind the animation.
  ///
  /// `antiAliasing` enables/disables anti-aliasing.
  ///
  /// `height` is a full animation height.
  ///
  /// `completeDuration` is a duration that occurs
  /// when refresh has been completed.
  ///
  /// `refreshStyle` is a [RefreshIndicator] display style.
  const AstroRefreshIndicator({
    this.fit = BoxFit.cover,
    this.backgroundColor = const Color(0xFF43378D),
    this.antiAliasing = true,
    Duration completeDuration = const Duration(milliseconds: 500),
    double height = 150,
    RefreshStyle refreshStyle = RefreshStyle.UnFollow,
    Key? key,
  }) : super(
    key: key,
    height: height,
    completeDuration: completeDuration,
    refreshStyle: refreshStyle,
  );

  /// BoxFit for the animation.
  ///
  /// Defaults to [BoxFit.cover].
  final BoxFit fit;

  /// The color to paint behind the animation.
  ///
  /// Defaults to [Color(0xFF43378D)].
  final Color backgroundColor;

  /// Enables/disables anti-aliasing
  ///
  /// Default to true
  final bool antiAliasing;

  @override
  State<StatefulWidget> createState() {
    return _AstroRefreshIndicatorState();
  }
}

class _AstroRefreshIndicatorState
    extends RefreshIndicatorState<AstroRefreshIndicator> {
  late final Artboard _riveArtboard;
  late final StateMachineController _riveController;
  late final SMIInput<double> _pullAmountInput;
  late final SMIInput<bool> _isLoadingInput;

  bool _assetLoaded = false;
  double _innerHeight = 0;

  @override
  void initState() {
    super.initState();

    _initRive();
  }

  Future<void> _initRive() async {
    const assetPath =
        'packages/astro_refresh_indicator/assets/space_reload.riv';
    final file = await RiveFile.asset(assetPath);

    _riveArtboard = file.mainArtboard;
    _riveController = StateMachineController.fromArtboard(
      _riveArtboard,
      'Reload',
    )!;

    _riveArtboard.addController(_riveController);

    _pullAmountInput = _riveController.findInput<double>('Pull Amount')!;
    _isLoadingInput = _riveController.findInput<bool>('Is Loading')!;

    setState(() => _assetLoaded = true);
  }

  @override
  void onOffsetChange(double offset) {
    if (!_assetLoaded) {
      return;
    }

    _updateInnerHeight(offset);
    _updatePullAmount(offset);
  }

  void _updateInnerHeight(double offset) {
    if (offset > 0.0 && offset < widget.height * 2.0) {
      setState(() => _innerHeight = offset);
    }
  }

  void _updatePullAmount(double offset) {
    if (_isLoadingInput.value) {
      return;
    }

    if (offset < 0.0 || offset > widget.height) {
      return;
    }

    final pullAmount = 100.0 * offset / widget.height;

    _pullAmountInput.value = pullAmount;
  }

  @override
  void onModeChange(RefreshStatus? mode) {
    if (!_assetLoaded) {
      return;
    }

    if (mode == RefreshStatus.canRefresh) {
      _isLoadingInput.value = true;
    }

    if (mode == RefreshStatus.completed || mode == RefreshStatus.idle) {
      _isLoadingInput.value = false;
    }
  }

  @override
  Widget buildContent(BuildContext context, RefreshStatus mode) {
    if (!_assetLoaded) {
      return const SizedBox();
    }

    return Container(
      height: _innerHeight,
      color: widget.backgroundColor,
      child: Rive(
        artboard: _riveArtboard,
        fit: widget.fit,
        antialiasing: widget.antiAliasing,
      ),
    );
  }
}