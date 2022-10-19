// ignore: library_prefixes
// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, avoid_renaming_method_parameters

// ignore: library_prefixes
import 'dart:math' as Math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../enums/load_status.dart';
import '../enums/refresh_status.dart';
import '../enums/refresh_style.dart';
import '../paginated_list.dart';
class SliverRefresh extends SingleChildRenderObjectWidget {
  const SliverRefresh({
    Key? key,
    this.paintOffsetY,
    this.refreshIndicatorLayoutExtent = 0.0,
    this.floating = false,
    Widget? child,
    this.refreshStyle,
  })  : assert(refreshIndicatorLayoutExtent >= 0.0),
        super(key: key, child: child);
  final double refreshIndicatorLayoutExtent;
  final bool floating;
  final RefreshStyle? refreshStyle;
  final double? paintOffsetY;
  @override
  RenderSliverRefresh createRenderObject(BuildContext context) {
    return RenderSliverRefresh(
      refreshIndicatorExtent: refreshIndicatorLayoutExtent,
      hasLayoutExtent: floating,
      paintOffsetY: paintOffsetY,
      refreshStyle: refreshStyle,
    );
  }
  @override
  void updateRenderObject(
      BuildContext context, covariant RenderSliverRefresh renderObject) {
    final RefreshStatus mode =
        PaginatedList.of(context)!.controller.headerMode!.value;
    renderObject
      ..refreshIndicatorLayoutExtent = refreshIndicatorLayoutExtent
      ..hasLayoutExtent = floating
      ..context = context
      ..refreshStyle = refreshStyle
      ..updateFlag = mode == RefreshStatus.twoLevelOpening ||
          mode == RefreshStatus.twoLeveling ||
          mode == RefreshStatus.idle
      ..paintOffsetY = paintOffsetY;
  }
}
class RenderSliverRefresh extends RenderSliverSingleBoxAdapter {
  RenderSliverRefresh(
      {required double refreshIndicatorExtent,
      required bool hasLayoutExtent,
      RenderBox? child,
      this.paintOffsetY,
      this.refreshStyle})
      : assert(refreshIndicatorExtent >= 0.0),
        _refreshIndicatorExtent = refreshIndicatorExtent,
        _hasLayoutExtent = hasLayoutExtent {
    this.child = child;
  }
  RefreshStyle? refreshStyle;
  late BuildContext context;
  double get refreshIndicatorLayoutExtent => _refreshIndicatorExtent;
  double _refreshIndicatorExtent;
  double? paintOffsetY;
  bool _updateFlag = false;
  set refreshIndicatorLayoutExtent(double value) {
    assert(value >= 0.0);
    if (value == _refreshIndicatorExtent) return;
    _refreshIndicatorExtent = value;
    markNeedsLayout();
  }
  bool get hasLayoutExtent => _hasLayoutExtent;
  bool _hasLayoutExtent;
  set hasLayoutExtent(bool value) {
    if (value == _hasLayoutExtent) return;
    if (!value) {
      _updateFlag = true;
    }
    _hasLayoutExtent = value;
    markNeedsLayout();
  }
  double layoutExtentOffsetCompensation = 0.0;
  @override
  double get centerOffsetAdjustment {
    if (refreshStyle == RefreshStyle.front) {
      final RenderViewportBase renderViewport =
          parent as RenderViewportBase<ContainerParentDataMixin<RenderSliver>>;
      return Math.max(0.0, -renderViewport.offset.pixels);
    }
    return 0.0;
  }
  @override
  void layout(Constraints constraints, {bool parentUsesSize = false}) {
    if (refreshStyle == RefreshStyle.front) {
      final RenderViewportBase renderViewport =
          parent as RenderViewportBase<ContainerParentDataMixin<RenderSliver>>;
      super.layout(
          (constraints as SliverConstraints)
              .copyWith(overlap: Math.min(0.0, renderViewport.offset.pixels)),
          parentUsesSize: true);
    } else {
      super.layout(constraints, parentUsesSize: parentUsesSize);
    }
  }
  set updateFlag(u) {
    _updateFlag = u;
    markNeedsLayout();
  }
  @override
  void debugAssertDoesMeetConstraints() {
    assert(geometry!.debugAssertIsValid(informationCollector: () sync* {
      yield describeForError(
          'The RenderSliver that returned the offending geometry was');
    }));
    assert(() {
      if (geometry!.paintExtent > constraints.remainingPaintExtent) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary(
              'SliverGeometry has a paintOffset that exceeds the remainingPaintExtent from the constraints.'),
          describeForError(
              'The render object whose geometry violates the constraints is the following'),
          ErrorDescription(
            'The paintExtent must cause the child sliver to paint within the viewport, and so '
            'cannot exceed the remainingPaintExtent.',
          ),
        ]);
      }
      return true;
    }());
  }
  @override
  void performLayout() {
    if (_updateFlag) {
      Scrollable.of(context)!.position.activity!.applyNewDimensions();
      _updateFlag = false;
    }
    final double layoutExtent =
        (_hasLayoutExtent ? 1.0 : 0.0) * _refreshIndicatorExtent;
    if (refreshStyle != RefreshStyle.front) {
      if (layoutExtent != layoutExtentOffsetCompensation) {
        geometry = SliverGeometry(
          scrollOffsetCorrection: layoutExtent - layoutExtentOffsetCompensation,
        );
        layoutExtentOffsetCompensation = layoutExtent;
        return;
      }
    }
    bool active = constraints.overlap < 0.0 || layoutExtent > 0.0;
    final double overScrolledExtent =
        -(parent as RenderViewportBase).offset.pixels;
    if (refreshStyle == RefreshStyle.behind) {
      child!.layout(
        constraints.asBoxConstraints(
            maxExtent: Math.max(0, overScrolledExtent + layoutExtent)),
        parentUsesSize: true,
      );
    } else {
      child!.layout(
        constraints.asBoxConstraints(),
        parentUsesSize: true,
      );
    }
    final double boxExtent = (constraints.axisDirection == AxisDirection.up ||
            constraints.axisDirection == AxisDirection.down)
        ? child!.size.height
        : child!.size.width;
    if (active) {
      final double needPaintExtent = Math.min(
          Math.max(
            Math.max(
                    (constraints.axisDirection == AxisDirection.up ||
                            constraints.axisDirection == AxisDirection.down)
                        ? child!.size.height
                        : child!.size.width,
                    layoutExtent) -
                constraints.scrollOffset,
            0.0,
          ),
          constraints.remainingPaintExtent);
      switch (refreshStyle) {
        case RefreshStyle.follow:
          geometry = SliverGeometry(
            scrollExtent: layoutExtent,
            paintOrigin: -boxExtent - constraints.scrollOffset + layoutExtent,
            paintExtent: needPaintExtent,
            hitTestExtent: needPaintExtent,
            hasVisualOverflow: overScrolledExtent < boxExtent,
            maxPaintExtent: needPaintExtent,
            layoutExtent: Math.min(needPaintExtent,
                Math.max(layoutExtent - constraints.scrollOffset, 0.0)),
          );
          break;
        case RefreshStyle.behind:
          geometry = SliverGeometry(
            scrollExtent: layoutExtent,
            paintOrigin: -overScrolledExtent - constraints.scrollOffset,
            paintExtent: needPaintExtent,
            maxPaintExtent: needPaintExtent,
            layoutExtent:
                Math.max(layoutExtent - constraints.scrollOffset, 0.0),
          );
          break;
        case RefreshStyle.unFollow:
          geometry = SliverGeometry(
            scrollExtent: layoutExtent,
            paintOrigin: Math.min(
                -overScrolledExtent - constraints.scrollOffset,
                -boxExtent - constraints.scrollOffset + layoutExtent),
            paintExtent: needPaintExtent,
            hasVisualOverflow: overScrolledExtent < boxExtent,
            maxPaintExtent: needPaintExtent,
            layoutExtent: Math.min(needPaintExtent,
                Math.max(layoutExtent - constraints.scrollOffset, 0.0)),
          );
          break;
        case RefreshStyle.front:
          geometry = SliverGeometry(
            paintOrigin: constraints.axisDirection == AxisDirection.up ||
                    constraints.crossAxisDirection == AxisDirection.left
                ? boxExtent
                : 0.0,
            visible: true,
            hasVisualOverflow: true,
          );
          break;
        case null:
          break;
      }
      setChildParentData(child!, constraints, geometry!);
    } else {
      geometry = SliverGeometry.zero;
    }
  }
  @override
  void paint(PaintingContext paintContext, Offset offset) {
    paintContext.paintChild(
        child!, Offset(offset.dx, offset.dy + paintOffsetY!));
  }
  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) {}
}
class SliverLoading extends SingleChildRenderObjectWidget {
  final bool? hideWhenNotFull;
  final bool? floating;
  final LoadStatus? mode;
  final double? layoutExtent;
  final bool? shouldFollowContent;
  const SliverLoading({
    Key? key,
    this.mode,
    this.floating,
    this.shouldFollowContent,
    this.layoutExtent,
    this.hideWhenNotFull,
    Widget? child,
  }) : super(key: key, child: child);
  @override
  RenderSliverLoading createRenderObject(BuildContext context) {
    return RenderSliverLoading(
        hideWhenNotFull: hideWhenNotFull,
        mode: mode,
        hasLayoutExtent: floating,
        shouldFollowContent: shouldFollowContent,
        layoutExtent: layoutExtent);
  }
  @override
  void updateRenderObject(
      BuildContext context, covariant RenderSliverLoading renderObject) {
    renderObject
      ..mode = mode
      ..hasLayoutExtent = floating!
      ..layoutExtent = layoutExtent
      ..shouldFollowContent = shouldFollowContent
      ..hideWhenNotFull = hideWhenNotFull;
  }
}
class RenderSliverLoading extends RenderSliverSingleBoxAdapter {
  RenderSliverLoading({
    RenderBox? child,
    this.mode,
    double? layoutExtent,
    bool? hasLayoutExtent,
    this.shouldFollowContent,
    this.hideWhenNotFull,
  }) {
    _hasLayoutExtent = hasLayoutExtent;
    this.layoutExtent = layoutExtent;
    this.child = child;
  }
  bool? shouldFollowContent;
  bool? hideWhenNotFull;
  LoadStatus? mode;
  double? _layoutExtent;
  set layoutExtent(extent) {
    if (extent == _layoutExtent) return;
    _layoutExtent = extent;
    markNeedsLayout();
  }
  get layoutExtent => _layoutExtent;
  bool get hasLayoutExtent => _hasLayoutExtent!;
  bool? _hasLayoutExtent;
  set hasLayoutExtent(bool value) {
    if (value == _hasLayoutExtent) return;
    _hasLayoutExtent = value;
    markNeedsLayout();
  }
  bool _computeIfFull(SliverConstraints cons) {
    final RenderViewport viewport = parent as RenderViewport;
    RenderSliver? sliverP = viewport.firstChild;
    double totalScrollExtent = cons.precedingScrollExtent;
    while (sliverP != this) {
      if (sliverP is RenderSliverRefresh) {
        totalScrollExtent -= sliverP.geometry!.scrollExtent;
        break;
      }
      sliverP = viewport.childAfter(sliverP!);
    }
    return totalScrollExtent > cons.viewportMainAxisExtent;
  }
  double? computePaintOrigin(double? layoutExtent, bool reverse, bool follow) {
    if (follow) {
      if (reverse) {
        return layoutExtent;
      }
      return 0.0;
    } else {
      if (reverse) {
        return Math.max(
                constraints.viewportMainAxisExtent -
                    constraints.precedingScrollExtent,
                0.0) +
            layoutExtent!;
      } else {
        return Math.max(
            constraints.viewportMainAxisExtent -
                constraints.precedingScrollExtent,
            0.0);
      }
    }
  }
  @override
  void debugAssertDoesMeetConstraints() {
    assert(geometry!.debugAssertIsValid(informationCollector: () sync* {
      yield describeForError(
          'The RenderSliver that returned the offending geometry was');
    }));
    assert(() {
      if (geometry!.paintExtent > constraints.remainingPaintExtent) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary(
              'SliverGeometry has a paintOffset that exceeds the remainingPaintExtent from the constraints.'),
          describeForError(
              'The render object whose geometry violates the constraints is the following'),
          ErrorDescription(
            'The paintExtent must cause the child sliver to paint within the viewport, and so '
            'cannot exceed the remainingPaintExtent.',
          ),
        ]);
      }
      return true;
    }());
  }
  @override
  void performLayout() {
    assert(constraints.growthDirection == GrowthDirection.forward);
    if (child == null) {
      geometry = SliverGeometry.zero;
      return;
    }
    bool active;
    if (hideWhenNotFull! && mode != LoadStatus.noMore) {
      active = _computeIfFull(constraints);
    } else {
      active = true;
    }
    if (active) {
      child!.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    } else {
      child!.layout(
          constraints.asBoxConstraints(maxExtent: 0.0, minExtent: 0.0),
          parentUsesSize: true);
    }
    double childExtent = constraints.axis == Axis.vertical
        ? child!.size.height
        : child!.size.width;
    final double paintedChildSize =
        calculatePaintOffset(constraints, from: 0.0, to: childExtent);
    final double cacheExtent =
        calculateCacheOffset(constraints, from: 0.0, to: childExtent);
    assert(paintedChildSize.isFinite);
    assert(paintedChildSize >= 0.0);
    if (active) {
      geometry = SliverGeometry(
        scrollExtent: !_hasLayoutExtent! || !_computeIfFull(constraints)
            ? 0
            : layoutExtent,
        paintExtent: paintedChildSize,
        paintOrigin: computePaintOrigin(
            !_hasLayoutExtent! || !_computeIfFull(constraints)
                ? layoutExtent
                : 0.0,
            constraints.axisDirection == AxisDirection.up ||
                constraints.axisDirection == AxisDirection.left,
            _computeIfFull(constraints) || shouldFollowContent!)!,
        cacheExtent: cacheExtent,
        maxPaintExtent: childExtent,
        hitTestExtent: paintedChildSize,
        visible: true,
        hasVisualOverflow: true,
      );
      setChildParentData(child!, constraints, geometry!);
    } else {
      geometry = SliverGeometry.zero;
    }
  }
}
class SliverRefreshBody extends SingleChildRenderObjectWidget {
  const SliverRefreshBody({
    Key? key,
    Widget? child,
  }) : super(key: key, child: child);
  @override
  RenderSliverRefreshBody createRenderObject(BuildContext context) =>
      RenderSliverRefreshBody();
}
class RenderSliverRefreshBody extends RenderSliverSingleBoxAdapter {
  RenderSliverRefreshBody({
    RenderBox? child,
  }) : super(child: child);
  @override
  void performLayout() {
    if (child == null) {
      geometry = SliverGeometry.zero;
      return;
    }
    child!.layout(constraints.asBoxConstraints(maxExtent: 1111111),
        parentUsesSize: true);
    double? childExtent;
    switch (constraints.axis) {
      case Axis.horizontal:
        childExtent = child!.size.width;
        break;
      case Axis.vertical:
        childExtent = child!.size.height;
        break;
    }
    if (childExtent == 1111111) {
      child!.layout(
          constraints.asBoxConstraints(
              maxExtent: constraints.viewportMainAxisExtent),
          parentUsesSize: true);
    }
    switch (constraints.axis) {
      case Axis.horizontal:
        childExtent = child!.size.width;
        break;
      case Axis.vertical:
        childExtent = child!.size.height;
        break;
    }
    final double paintedChildSize =
        calculatePaintOffset(constraints, from: 0.0, to: childExtent);
    final double cacheExtent =
        calculateCacheOffset(constraints, from: 0.0, to: childExtent);
    assert(paintedChildSize.isFinite);
    assert(paintedChildSize >= 0.0);
    geometry = SliverGeometry(
      scrollExtent: childExtent,
      paintExtent: paintedChildSize,
      cacheExtent: cacheExtent,
      maxPaintExtent: childExtent,
      hitTestExtent: paintedChildSize,
      hasVisualOverflow: childExtent > constraints.remainingPaintExtent ||
          constraints.scrollOffset > 0.0,
    );
    setChildParentData(child!, constraints, geometry!);
  }
}
