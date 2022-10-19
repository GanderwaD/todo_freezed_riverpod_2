// ignore_for_file: invalid_use_of_protected_member, overridden_fields, invalid_use_of_visible_for_testing_member

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import 'enums/load_status.dart';
import 'enums/refresh_status.dart';
import 'indicator/classic_indicator.dart';
import 'internals/indicator_wrap.dart';
import 'internals/refresh_physics.dart';
import 'internals/slivers.dart';

typedef IndicatorBuilder = Widget Function();
typedef PaginatedListBuilder = Widget Function(
    BuildContext context, RefreshPhysics physics);

class PaginatedList extends StatefulWidget {
  final Widget? child;
  final Widget? header;
  final Widget? footer;
  final bool enablePullUp;
  final bool enablePullDown;
  final VoidCallback? onRefresh;
  final VoidCallback? onLoading;
  final PaginatedListController controller;
  final PaginatedListBuilder? builder;
  final Axis? scrollDirection;
  final bool? reverse;
  final ScrollController? scrollController;
  final bool? primary;
  final ScrollPhysics? physics;
  final double? cacheExtent;
  final int? semanticChildCount;
  final DragStartBehavior? dragStartBehavior;

  const PaginatedList(
      {Key? key,
      required this.controller,
      this.child,
      this.header,
      this.footer,
      this.enablePullDown = true,
      this.enablePullUp = false,
      this.onRefresh,
      this.onLoading,
      this.dragStartBehavior,
      this.primary,
      this.cacheExtent,
      this.semanticChildCount,
      this.reverse,
      this.physics,
      this.scrollDirection,
      this.scrollController})
      : builder = null,
        super(key: key);

  const PaginatedList.builder({
    super.key,
    required this.controller,
    required this.builder,
    this.enablePullDown = true,
    this.enablePullUp = false,
    this.onRefresh,
    this.onLoading,
  })  : header = null,
        footer = null,
        child = null,
        scrollController = null,
        scrollDirection = null,
        physics = null,
        reverse = null,
        semanticChildCount = null,
        dragStartBehavior = null,
        cacheExtent = null,
        primary = null;

  static PaginatedList? of(BuildContext? context) {
    return context!.findAncestorWidgetOfExactType<PaginatedList>();
  }

  static PaginatedListState? ofState(BuildContext? context) {
    return context!.findAncestorStateOfType<PaginatedListState>();
  }

  @override
  State<StatefulWidget> createState() {
    return PaginatedListState();
  }
}

class PaginatedListState extends State<PaginatedList> {
  RefreshPhysics? _physics;
  bool _updatePhysics = false;
  double viewportExtent = 0;
  bool _canDrag = true;

  final RefreshIndicator defaultHeader = const ClassicHeader();

  final LoadIndicator defaultFooter = const ClassicFooter();

  List<Widget>? _buildSliversByChild(BuildContext context, Widget? child,
      RefreshConfiguration? configuration) {
    List<Widget>? slivers;
    if (child is ScrollView) {
      if (child is BoxScrollView) {
        //avoid system inject padding when own indicator top or bottom
        Widget sliver = child.buildChildLayout(context);
        if (child.padding != null) {
          slivers = [SliverPadding(sliver: sliver, padding: child.padding!)];
        } else {
          slivers = [sliver];
        }
      } else {
        slivers = List.from(child.buildSlivers(context), growable: true);
      }
    } else if (child is! Scrollable) {
      slivers = [
        SliverRefreshBody(
          child: child ?? Container(),
        )
      ];
    }
    if (widget.enablePullDown ) {
      slivers?.insert(
          0,
          widget.header ??
              (configuration?.headerBuilder != null
                  ? configuration?.headerBuilder!()
                  : null) ??
              defaultHeader);
    }
    //insert header or footer
    if (widget.enablePullUp) {
      slivers?.add(widget.footer ??
          (configuration?.footerBuilder != null
              ? configuration?.footerBuilder!()
              : null) ??
          defaultFooter);
    }

    return slivers;
  }

  ScrollPhysics _getScrollPhysics(
      RefreshConfiguration? conf, ScrollPhysics physics) {
    final bool isBouncingPhysics = physics is BouncingScrollPhysics ||
        (physics is AlwaysScrollableScrollPhysics &&
            ScrollConfiguration.of(context)
                    .getScrollPhysics(context)
                    .runtimeType ==
                BouncingScrollPhysics);
    return _physics = RefreshPhysics(
            dragSpeedRatio: conf?.dragSpeedRatio ?? 1,
            springDescription: conf?.springDescription ??
                const SpringDescription(
                  mass: 2.2,
                  stiffness: 150,
                  damping: 16,
                ),
            controller: widget.controller,
            enableScrollWhenTwoLevel: conf?.enableScrollWhenTwoLevel ?? true,
            updateFlag: _updatePhysics ? 0 : 1,
            enableScrollWhenRefreshCompleted:
                conf?.enableScrollWhenRefreshCompleted ?? false,
            maxUnderScrollExtent: conf?.maxUnderScrollExtent ??
                (isBouncingPhysics ? double.infinity : 0.0),
            maxOverScrollExtent: conf?.maxOverScrollExtent ??
                (isBouncingPhysics ? double.infinity : 60.0),
            topHitBoundary: conf?.topHitBoundary ??
                (isBouncingPhysics ? double.infinity : 0.0),
            bottomHitBoundary: conf?.bottomHitBoundary ??
                (isBouncingPhysics ? double.infinity : 0.0))
        .applyTo(!_canDrag ? const NeverScrollableScrollPhysics() : physics);
  }

  Widget? _buildBodyBySlivers(
      Widget? childView, List<Widget>? slivers, RefreshConfiguration? conf) {
    Widget? body;
    if (childView is! Scrollable) {
      bool? primary = widget.primary;
      Key? key;
      double? cacheExtent = widget.cacheExtent;

      Axis? scrollDirection = widget.scrollDirection;
      int? semanticChildCount = widget.semanticChildCount;
      bool? reverse = widget.reverse;
      ScrollController? scrollController = widget.scrollController;
      DragStartBehavior? dragStartBehavior = widget.dragStartBehavior;
      ScrollPhysics? physics = widget.physics;
      Key? center;
      double? anchor;
      ScrollViewKeyboardDismissBehavior? keyboardDismissBehavior;
      String? restorationId;
      Clip? clipBehavior;

      if (childView is ScrollView) {
        primary = primary ?? childView.primary;
        cacheExtent = cacheExtent ?? childView.cacheExtent;
        key = key ?? childView.key;
        semanticChildCount = semanticChildCount ?? childView.semanticChildCount;
        reverse = reverse ?? childView.reverse;
        dragStartBehavior = dragStartBehavior ?? childView.dragStartBehavior;
        scrollDirection = scrollDirection ?? childView.scrollDirection;
        physics = physics ?? childView.physics;
        center = center ?? childView.center;
        anchor = anchor ?? childView.anchor;
        keyboardDismissBehavior =
            keyboardDismissBehavior ?? childView.keyboardDismissBehavior;
        restorationId = restorationId ?? childView.restorationId;
        clipBehavior = clipBehavior ?? childView.clipBehavior;
        scrollController = scrollController ?? childView.controller;
      }
      body = CustomScrollView(
        // ignore: DEPRECATED_MEMBER_USE_FROM_SAME_PACKAGE
        controller: scrollController,
        cacheExtent: cacheExtent,
        key: key,
        scrollDirection: scrollDirection ?? Axis.vertical,
        semanticChildCount: semanticChildCount,
        primary: primary,
        clipBehavior: clipBehavior ?? Clip.hardEdge,
        keyboardDismissBehavior:
            keyboardDismissBehavior ?? ScrollViewKeyboardDismissBehavior.manual,
        anchor: anchor ?? 0.0,
        restorationId: restorationId,
        center: center,
        physics: _getScrollPhysics(
            conf, physics ?? const AlwaysScrollableScrollPhysics()),
        slivers: slivers!,
        dragStartBehavior: dragStartBehavior ?? DragStartBehavior.start,
        reverse: reverse ?? false,
      );
    // ignore: unnecessary_type_check
    } else if (childView is Scrollable) {
      body = Scrollable(
        physics: _getScrollPhysics(
            conf, childView.physics ?? const AlwaysScrollableScrollPhysics()),
        controller: childView.controller,
        axisDirection: childView.axisDirection,
        semanticChildCount: childView.semanticChildCount,
        dragStartBehavior: childView.dragStartBehavior,
        viewportBuilder: (context, offset) {
          Viewport viewport =
              childView.viewportBuilder(context, offset) as Viewport;
          if (widget.enablePullDown) {
            viewport.children.insert(
                0,
                widget.header ??
                    (conf?.headerBuilder != null
                        ? conf?.headerBuilder!()
                        : null) ??
                    defaultHeader);
          }
          //insert header or footer
          if (widget.enablePullUp) {
            viewport.children.add(widget.footer ??
                (conf?.footerBuilder != null ? conf?.footerBuilder!() : null) ??
                defaultFooter);
          }
          return viewport;
        },
      );
    }
    return body;
  }

  bool _ifNeedUpdatePhysics() {
    RefreshConfiguration? conf = RefreshConfiguration.of(context);
    if (conf == null || _physics == null) {
      return false;
    }

    if (conf.topHitBoundary != _physics!.topHitBoundary ||
        _physics!.bottomHitBoundary != conf.bottomHitBoundary ||
        conf.maxOverScrollExtent != _physics!.maxOverScrollExtent ||
        _physics!.maxUnderScrollExtent != conf.maxUnderScrollExtent ||
        _physics!.dragSpeedRatio != conf.dragSpeedRatio ||
        _physics!.enableScrollWhenTwoLevel != conf.enableScrollWhenTwoLevel ||
        _physics!.enableScrollWhenRefreshCompleted !=
            conf.enableScrollWhenRefreshCompleted) {
      return true;
    }
    return false;
  }

  void setCanDrag(bool canDrag) {
    if (_canDrag == canDrag) {
      return;
    }
    setState(() {
      _canDrag = canDrag;
    });
  }

  @override
  void didUpdateWidget(PaginatedList oldWidget) {
    if (widget.controller != oldWidget.controller) {
      widget.controller.headerMode!.value =
          oldWidget.controller.headerMode!.value;
      widget.controller.footerMode!.value =
          oldWidget.controller.footerMode!.value;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_ifNeedUpdatePhysics()) {
      _updatePhysics = !_updatePhysics;
    }
  }

  @override
  void initState() {
    if (widget.controller.initialRefresh) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.controller.requestRefresh();
      });
    }
    widget.controller._bindState(this);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller._detachPosition();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final RefreshConfiguration? configuration =
        RefreshConfiguration.of(context);
    Widget? body;
    if (widget.builder != null) {
      body = widget.builder!(
          context,
          _getScrollPhysics(configuration, const AlwaysScrollableScrollPhysics())
              as RefreshPhysics);
    } else {
      List<Widget>? slivers =
          _buildSliversByChild(context, widget.child, configuration);
      body = _buildBodyBySlivers(widget.child, slivers, configuration);
    }
    if (configuration == null) {
      body = RefreshConfiguration(child: body!);
    }
    return LayoutBuilder(
      builder: (c2, cons) {
        viewportExtent = cons.biggest.height;
        return body!;
      },
    );
  }
}

class PaginatedListController {
  PaginatedListState? _refresherState;

  RefreshNotifier<RefreshStatus>? headerMode;

  RefreshNotifier<LoadStatus>? footerMode;

  ScrollPosition? position;

  RefreshStatus? get headerStatus => headerMode?.value;

  LoadStatus? get footerStatus => footerMode?.value;

  bool get isRefresh => headerMode?.value == RefreshStatus.refreshing;

  bool get isTwoLevel =>
      headerMode?.value == RefreshStatus.twoLeveling ||
      headerMode?.value == RefreshStatus.twoLevelOpening ||
      headerMode?.value == RefreshStatus.twoLevelClosing;

  bool get isLoading => footerMode?.value == LoadStatus.loading;

  final bool initialRefresh;

  PaginatedListController(
      {this.initialRefresh = false,
      RefreshStatus? initialRefreshStatus,
      LoadStatus? initialLoadStatus}) {
    headerMode = RefreshNotifier(initialRefreshStatus ?? RefreshStatus.idle);
    footerMode = RefreshNotifier(initialLoadStatus ?? LoadStatus.idle);
  }

  void _bindState(PaginatedListState state) {
    assert(_refresherState == null,
        "Don't use one refreshController to multiple SmartRefresher,It will cause some unexpected bugs mostly in TabBarView");
    _refresherState = state;
  }

  void onPositionUpdated(ScrollPosition newPosition) {
    position?.isScrollingNotifier.removeListener(_listenScrollEnd);
    position = newPosition;
    position!.isScrollingNotifier.addListener(_listenScrollEnd);
  }

  void _detachPosition() {
    _refresherState = null;
    position?.isScrollingNotifier.removeListener(_listenScrollEnd);
  }

  StatefulElement? _findIndicator(BuildContext context, Type elementType) {
    StatefulElement? result;
    context.visitChildElements((Element e) {
      if (elementType == RefreshIndicator) {
        if (e.widget is RefreshIndicator) {
          result = e as StatefulElement?;
        }
      } else {
        if (e.widget is LoadIndicator) {
          result = e as StatefulElement?;
        }
      }

      result ??= _findIndicator(e, elementType);
    });
    return result;
  }

  void _listenScrollEnd() {
    if (position != null && position!.outOfRange) {
      position?.activity?.applyNewDimensions();
    }
  }

  Future<void>? requestRefresh(
      {bool needMove = true,
      bool needCallback = true,
      Duration duration = const Duration(milliseconds: 500),
      Curve curve = Curves.linear}) {
    assert(position != null,
        'Try not to call requestRefresh() before build,please call after the ui was rendered');
    if (isRefresh) return Future.value();
    StatefulElement? indicatorElement =
        _findIndicator(position!.context.storageContext, RefreshIndicator);

    if (indicatorElement == null || _refresherState == null) return null;
    (indicatorElement.state as RefreshIndicatorState).floating = true;

    if (needMove && _refresherState!.mounted) {
      _refresherState!.setCanDrag(false);
    }
    if (needMove) {
      return Future.delayed(const Duration(milliseconds: 50)).then((_) async {
        await position
            ?.animateTo(position!.minScrollExtent - 0.0001,
                duration: duration, curve: curve)
            .then((_) {
          if (_refresherState != null && _refresherState!.mounted) {
            _refresherState!.setCanDrag(true);
            if (needCallback) {
              headerMode!.value = RefreshStatus.refreshing;
            } else {
              headerMode!.setValueWithNoNotify(RefreshStatus.refreshing);
              if (indicatorElement.state.mounted) {
                (indicatorElement.state as RefreshIndicatorState)
                    .setState(() {});
              }
            }
          }
        });
      });
    } else {
      Future.value().then((_) {
        headerMode!.value = RefreshStatus.refreshing;
      });
    }
    return null;
  }

  Future<void> requestTwoLevel(
      {Duration duration = const Duration(milliseconds: 300),
      Curve curve = Curves.linear}) {
    assert(position != null,
        'Try not to call requestRefresh() before build,please call after the ui was rendered');
    headerMode!.value = RefreshStatus.twoLevelOpening;
    return Future.delayed(const Duration(milliseconds: 50)).then((_) async {
      await position?.animateTo(position!.minScrollExtent,
          duration: duration, curve: curve);
    });
  }

  Future<void>? requestLoading(
      {bool needMove = true,
      bool needCallback = true,
      Duration duration = const Duration(milliseconds: 300),
      Curve curve = Curves.linear}) {
    assert(position != null,
        'Try not to call requestLoading() before build,please call after the ui was rendered');
    if (isLoading) return Future.value();
    StatefulElement? indicatorElement =
        _findIndicator(position!.context.storageContext, LoadIndicator);

    if (indicatorElement == null || _refresherState == null) return null;
    (indicatorElement.state as LoadIndicatorState).floating = true;
    if (needMove && _refresherState!.mounted) {
      _refresherState!.setCanDrag(false);
    }
    if (needMove) {
      return Future.delayed(const Duration(milliseconds: 50)).then((_) async {
        await position
            ?.animateTo(position!.maxScrollExtent,
                duration: duration, curve: curve)
            .then((_) {
          if (_refresherState != null && _refresherState!.mounted) {
            _refresherState!.setCanDrag(true);
            if (needCallback) {
              footerMode!.value = LoadStatus.loading;
            } else {
              footerMode!.setValueWithNoNotify(LoadStatus.loading);
              if (indicatorElement.state.mounted) {
                (indicatorElement.state as LoadIndicatorState).setState(() {});
              }
            }
          }
        });
      });
    } else {
      return Future.value().then((_) {
        footerMode!.value = LoadStatus.loading;
      });
    }
  }

  void refreshCompleted({bool resetFooterState = false}) {
    headerMode?.value = RefreshStatus.completed;
    if (resetFooterState) {
      resetNoData();
    }
  }

  Future<void>? twoLevelComplete(
      {Duration duration = const Duration(milliseconds: 500),
      Curve curve = Curves.linear}) {
    headerMode?.value = RefreshStatus.twoLevelClosing;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      position!
          .animateTo(0.0, duration: duration, curve: curve)
          .whenComplete(() {
        headerMode!.value = RefreshStatus.idle;
      });
    });
    return null;
  }

  void refreshFailed() {
    headerMode?.value = RefreshStatus.failed;
  }

  void refreshToIdle() {
    headerMode?.value = RefreshStatus.idle;
  }

  void loadComplete() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      footerMode?.value = LoadStatus.idle;
    });
  }

  void loadFailed() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      footerMode?.value = LoadStatus.failed;
    });
  }

  void loadNoData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      footerMode?.value = LoadStatus.noMore;
    });
  }

  void resetNoData() {
    if (footerMode?.value == LoadStatus.noMore) {
      footerMode!.value = LoadStatus.idle;
    }
  }

  void dispose() {
    headerMode!.dispose();
    footerMode!.dispose();
    headerMode = null;
    footerMode = null;
  }
}

class RefreshConfiguration extends InheritedWidget {
  // ignore: annotate_overrides
  final Widget child;
  final IndicatorBuilder? headerBuilder;
  final IndicatorBuilder? footerBuilder;
  final SpringDescription springDescription;
  final bool skipCanRefresh;
  final bool hideFooterWhenNotFull;
  final bool enableScrollWhenTwoLevel;
  final bool enableScrollWhenRefreshCompleted;
  final bool enableBallisticRefresh;
  final bool enableBallisticLoad;
  final bool enableLoadingWhenFailed;
  final bool enableLoadingWhenNoData;
  final double headerTriggerDistance;
  final double twiceTriggerDistance;
  final double closeTwoLevelDistance;
  final double footerTriggerDistance;
  final double dragSpeedRatio;
  final double? maxOverScrollExtent;
  final double? maxUnderScrollExtent;
  final double? topHitBoundary;
  final double? bottomHitBoundary;
  final bool enableRefreshVibrate;
  final bool enableLoadMoreVibrate;

  const RefreshConfiguration(
      {Key? key,
      required this.child,
      this.headerBuilder,
      this.footerBuilder,
      this.dragSpeedRatio = 1.0,
      this.enableScrollWhenTwoLevel = true,
      this.enableLoadingWhenNoData = false,
      this.enableBallisticRefresh = false,
      this.springDescription = const SpringDescription(
        mass: 2.2,
        stiffness: 150,
        damping: 16,
      ),
      this.enableScrollWhenRefreshCompleted = false,
      this.enableLoadingWhenFailed = true,
      this.twiceTriggerDistance = 150.0,
      this.closeTwoLevelDistance = 80.0,
      this.skipCanRefresh = false,
      this.maxOverScrollExtent,
      this.enableBallisticLoad = true,
      this.maxUnderScrollExtent,
      this.headerTriggerDistance = 80.0,
      this.footerTriggerDistance = 15.0,
      this.hideFooterWhenNotFull = false,
      this.enableRefreshVibrate = false,
      this.enableLoadMoreVibrate = false,
      this.topHitBoundary,
      this.bottomHitBoundary})
      : assert(headerTriggerDistance > 0),
        assert(twiceTriggerDistance > 0),
        assert(closeTwoLevelDistance > 0),
        assert(dragSpeedRatio > 0),
        super(key: key, child: child);

  RefreshConfiguration.copyAncestor({
    Key? key,
    required BuildContext context,
    required this.child,
    IndicatorBuilder? headerBuilder,
    IndicatorBuilder? footerBuilder,
    double? dragSpeedRatio,
    bool? enableScrollWhenTwoLevel,
    bool? enableBallisticRefresh,
    bool? enableBallisticLoad,
    bool? enableLoadingWhenNoData,
    SpringDescription? springDescription,
    bool? enableScrollWhenRefreshCompleted,
    bool? enableLoadingWhenFailed,
    double? twiceTriggerDistance,
    double? closeTwoLevelDistance,
    bool? skipCanRefresh,
    double? maxOverScrollExtent,
    double? maxUnderScrollExtent,
    double? topHitBoundary,
    double? bottomHitBoundary,
    double? headerTriggerDistance,
    double? footerTriggerDistance,
    bool? enableRefreshVibrate,
    bool? enableLoadMoreVibrate,
    bool? hideFooterWhenNotFull,
  })  : assert(RefreshConfiguration.of(context) != null,
            "search RefreshConfiguration ancestor return null,please  Make sure that RefreshConfiguration is the ancestor of that element"),
        headerBuilder =
            headerBuilder ?? RefreshConfiguration.of(context)!.headerBuilder,
        footerBuilder =
            footerBuilder ?? RefreshConfiguration.of(context)!.footerBuilder,
        dragSpeedRatio =
            dragSpeedRatio ?? RefreshConfiguration.of(context)!.dragSpeedRatio,
        twiceTriggerDistance = twiceTriggerDistance ??
            RefreshConfiguration.of(context)!.twiceTriggerDistance,
        headerTriggerDistance = headerTriggerDistance ??
            RefreshConfiguration.of(context)!.headerTriggerDistance,
        footerTriggerDistance = footerTriggerDistance ??
            RefreshConfiguration.of(context)!.footerTriggerDistance,
        springDescription = springDescription ??
            RefreshConfiguration.of(context)!.springDescription,
        hideFooterWhenNotFull = hideFooterWhenNotFull ??
            RefreshConfiguration.of(context)!.hideFooterWhenNotFull,
        maxOverScrollExtent = maxOverScrollExtent ??
            RefreshConfiguration.of(context)!.maxOverScrollExtent,
        maxUnderScrollExtent = maxUnderScrollExtent ??
            RefreshConfiguration.of(context)!.maxUnderScrollExtent,
        topHitBoundary =
            topHitBoundary ?? RefreshConfiguration.of(context)!.topHitBoundary,
        bottomHitBoundary = bottomHitBoundary ??
            RefreshConfiguration.of(context)!.bottomHitBoundary,
        skipCanRefresh =
            skipCanRefresh ?? RefreshConfiguration.of(context)!.skipCanRefresh,
        enableScrollWhenRefreshCompleted = enableScrollWhenRefreshCompleted ??
            RefreshConfiguration.of(context)!.enableScrollWhenRefreshCompleted,
        enableScrollWhenTwoLevel = enableScrollWhenTwoLevel ??
            RefreshConfiguration.of(context)!.enableScrollWhenTwoLevel,
        enableBallisticRefresh = enableBallisticRefresh ??
            RefreshConfiguration.of(context)!.enableBallisticRefresh,
        enableBallisticLoad = enableBallisticLoad ??
            RefreshConfiguration.of(context)!.enableBallisticLoad,
        enableLoadingWhenNoData = enableLoadingWhenNoData ??
            RefreshConfiguration.of(context)!.enableLoadingWhenNoData,
        enableLoadingWhenFailed = enableLoadingWhenFailed ??
            RefreshConfiguration.of(context)!.enableLoadingWhenFailed,
        closeTwoLevelDistance = closeTwoLevelDistance ??
            RefreshConfiguration.of(context)!.closeTwoLevelDistance,
        enableRefreshVibrate = enableRefreshVibrate ??
            RefreshConfiguration.of(context)!.enableRefreshVibrate,
        enableLoadMoreVibrate = enableLoadMoreVibrate ??
            RefreshConfiguration.of(context)!.enableLoadMoreVibrate,
        super(key: key, child: child);

  static RefreshConfiguration? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<RefreshConfiguration>();
  }

  @override
  bool updateShouldNotify(RefreshConfiguration oldWidget) {
    return skipCanRefresh != oldWidget.skipCanRefresh ||
        hideFooterWhenNotFull != oldWidget.hideFooterWhenNotFull ||
        dragSpeedRatio != oldWidget.dragSpeedRatio ||
        enableScrollWhenRefreshCompleted !=
            oldWidget.enableScrollWhenRefreshCompleted ||
        enableBallisticRefresh != oldWidget.enableBallisticRefresh ||
        enableScrollWhenTwoLevel != oldWidget.enableScrollWhenTwoLevel ||
        closeTwoLevelDistance != oldWidget.closeTwoLevelDistance ||
        footerTriggerDistance != oldWidget.footerTriggerDistance ||
        headerTriggerDistance != oldWidget.headerTriggerDistance ||
        twiceTriggerDistance != oldWidget.twiceTriggerDistance ||
        maxUnderScrollExtent != oldWidget.maxUnderScrollExtent ||
        oldWidget.maxOverScrollExtent != maxOverScrollExtent ||
        enableBallisticRefresh != oldWidget.enableBallisticRefresh ||
        enableLoadingWhenFailed != oldWidget.enableLoadingWhenFailed ||
        topHitBoundary != oldWidget.topHitBoundary ||
        enableRefreshVibrate != oldWidget.enableRefreshVibrate ||
        enableLoadMoreVibrate != oldWidget.enableLoadMoreVibrate ||
        bottomHitBoundary != oldWidget.bottomHitBoundary;
  }
}

class RefreshNotifier<T> extends ChangeNotifier implements ValueListenable<T> {
  RefreshNotifier(this._value);
  T _value;

  @override
  T get value => _value;

  set value(T newValue) {
    if (_value == newValue) return;
    _value = newValue;
    notifyListeners();
  }

  void setValueWithNoNotify(T newValue) {
    if (_value == newValue) return;
    _value = newValue;
  }

  @override
  String toString() => '${describeIdentity(this)}($value)';
}
