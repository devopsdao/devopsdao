import 'dart:math' as math;
import 'package:flutter/material.dart';

class HorizontalListView extends StatefulWidget {
  HorizontalListView({
    required this.itemWidths,
    required this.crossAxisSpacing,
    this.controller,
    this.alignment = CrossAxisAlignment.center,
    required this.children,
    super.key,
  })  : itemCount = children!.length,
        itemBuilder = null;



  const HorizontalListView.builder({
    required this.itemWidths, // Список ширин элементов
    this.crossAxisSpacing = 0,
    this.controller,
    this.alignment = CrossAxisAlignment.center,
    required this.itemCount,
    required this.itemBuilder,
    super.key,
  }) : children = null;

  final List<double> itemWidths;

  // /// [crossAxisCount] specifies the number of items to display per row.
  // final int crossAxisCount;

  /// [crossAxisSpacing] sets the spacing between items in the same row.
  final double crossAxisSpacing;

  /// [alignment] defines the alignment of items within the rows (default is center).
  final CrossAxisAlignment? alignment;

  /// [controller] is an optional scroll controller to control the scroll behavior.
  final HorizontalListViewController? controller;

  /// [itemCount] is the total number of items in the list.
  final int itemCount;

  /// [children] is a list of child widgets.
  final List<Widget>? children;

  /// [itemBuilder] is a callback function to build each item widget.
  final Widget Function(BuildContext context, int index)? itemBuilder;

  @override
  State<HorizontalListView> createState() => _HorizontalListViewState();
}

class _HorizontalListViewState extends State<HorizontalListView> {
  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  Key _key = UniqueKey();

  int _computeActualChildCount(int itemCount) {
    return math.max(0, itemCount * 2 - 1);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      key: _key,
      builder: (context, constraints) {
        double snapSize = constraints.maxWidth + widget.crossAxisSpacing;

        // SnapScrollSize scrollPhysics = SnapScrollSize(snapSize: snapSize);
        SnapScrollPhysics snapScrollPhysics = SnapScrollPhysics(itemWidths: widget.itemWidths, crossAxisSpacing: widget.crossAxisSpacing);

        if (!_key.toString().contains(snapSize.toString())) {
          Future.delayed(Duration.zero, () {
            setState(() {
              rebuildAllChildren(context);
              _key = new Key('snap-$snapSize');
            });
          });
        }

        if (widget.controller != null) {
          widget.controller!.snapSize = snapSize;
        }

        // double itemWidth = (constraints.maxWidth -
        //     ((widget.crossAxisCount - 1) * widget.crossAxisSpacing)) /
        //     widget.crossAxisCount;

        return SingleChildScrollView(
          controller: widget.controller,
          physics: snapScrollPhysics,
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: widget.alignment ?? CrossAxisAlignment.center,
            children: List.generate(
              widget.itemCount,
                  (index) {
                return Padding(
                  padding: EdgeInsets.only(right: widget.crossAxisSpacing),
                  child: SizedBox(
                    width: widget.itemWidths[index],
                    child: widget.children != null
                        ? widget.children![index]
                        : widget.itemBuilder!.call(context, index),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class HorizontalListViewController extends ScrollController {
  HorizontalListViewController() : super();

  /// Animates the scroll view to a specific page with [duration] and [curve].
  ///
  /// [page] is the target page number.
  Future<void> animateToPage(int page,
      {required Duration duration, required Curve curve}) {
    double offset = _snapSize * page;

    if (page <= 0) {
      page = 0;
      offset = position.minScrollExtent;
    }
    if (page >= pageLenght) {
      page = pageLenght;
      offset = position.maxScrollExtent;
    }

    return super.animateTo(offset, duration: duration, curve: curve);
  }

  /// Gets the current visible page.
  int get currentPage {
    String roundedPage = (position.pixels / _snapSize).toStringAsFixed(1);
    int parsedNumber = double.parse(roundedPage).ceil();
    return parsedNumber;
  }

  /// Gets the total number of pages in the list.
  int get pageLenght => (position.maxScrollExtent / _snapSize).ceil();

  double _snapSize = 0;

  /// Sets the snap size for scrolling.
  set snapSize(double value) => _snapSize = value;
}


class SnapScrollPhysics extends ScrollPhysics {
  const SnapScrollPhysics({
    super.parent,
    required this.itemWidths,
    required this.crossAxisSpacing,
  });

  final List<double> itemWidths;
  final double crossAxisSpacing;

  @override
  SnapScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return SnapScrollPhysics(
      parent: buildParent(ancestor),
      itemWidths: itemWidths,
      crossAxisSpacing: crossAxisSpacing,
    );
  }

  double _getNearestItemEdge(ScrollMetrics position) {
    double pixels = position.pixels;
    double totalWidth = 0.0;

    for (int i = 0; i < itemWidths.length; i++) {
      double itemWidth = itemWidths[i];
      double itemMidpoint = totalWidth + itemWidth / 2;
      double itemEndPosition = totalWidth + itemWidth;

      if (pixels < itemMidpoint) {
        return totalWidth;
      } else if (pixels >= itemMidpoint && pixels < itemEndPosition) {
        return itemEndPosition;
      }

      totalWidth = itemEndPosition + crossAxisSpacing;
    }

    return totalWidth;
  }

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    final double targetPixels = _getNearestItemEdge(position);
    if (targetPixels != position.pixels) {
      return ScrollSpringSimulation(
        spring,
        position.pixels,
        targetPixels,
        velocity,
      );
    }
    return super.createBallisticSimulation(position, velocity);
  }

  @override
  bool get allowImplicitScrolling => false;
}

//
// class SnapScrollSize extends ScrollPhysics {
//   const SnapScrollSize({super.parent, required this.snapSize});
//
//   final double snapSize;
//
//   @override
//   SnapScrollSize applyTo(ScrollPhysics? ancestor) {
//     return SnapScrollSize(parent: buildParent(ancestor), snapSize: snapSize);
//   }
//
//   double _getPage(ScrollMetrics position) {
//     return position.pixels / snapSize;
//   }
//
//   double _getPixels(ScrollMetrics position, double page) {
//     return page * snapSize;
//   }
//
//   double _getTargetPixels(
//       ScrollMetrics position, Tolerance tolerance, double velocity) {
//     double page = _getPage(position);
//     if (velocity < -tolerance.velocity) {
//       page -= 0.5;
//     } else if (velocity > tolerance.velocity) {
//       page += 0.5;
//     }
//     return _getPixels(position, page.roundToDouble());
//   }
//
//
//   @override
//   Simulation? createBallisticSimulation(
//       ScrollMetrics position, double velocity) {
//     // If we're out of range and not headed back in range, defer to the parent
//     // ballistics, which should put us back in range at a page boundary.
//     if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
//         (velocity >= 0.0 && position.pixels >= position.maxScrollExtent)) {
//       return super.createBallisticSimulation(position, velocity);
//     }
//     // ignore: deprecated_member_use
//     final Tolerance tolerance = this.tolerance;
//     final double target = _getTargetPixels(position, tolerance, velocity);
//     if (target != position.pixels) {
//       return ScrollSpringSimulation(spring, position.pixels, target, velocity,
//           tolerance: tolerance);
//     }
//     return null;
//   }
//
//   @override
//   bool get allowImplicitScrolling => false;
// }
