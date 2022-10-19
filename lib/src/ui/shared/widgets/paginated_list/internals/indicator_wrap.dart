// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../enums/load_status.dart';
import '../enums/load_style.dart';
import '../enums/refresh_status.dart';
import '../enums/refresh_style.dart';
import '../paginated_list.dart';
import 'slivers.dart';
typedef VoidFutureCallBack = Future<void> Function();
typedef OffsetCallBack = void Function(double offset);
typedef ModeChangeCallBack<T> = void Function(T? mode);
abstract class RefreshIndicator extends StatefulWidget {
  
  final RefreshStyle? refreshStyle;
  
  final double height;
  
  final double offset;
  
  final Duration completeDuration;
  const RefreshIndicator(
      {Key? key,
      this.height = 60.0,
      this.offset = 0.0,
      this.completeDuration = const Duration(milliseconds: 500),
      this.refreshStyle = RefreshStyle.follow})
      : super(key: key);
}
abstract class LoadIndicator extends StatefulWidget {
  final LoadStyle loadStyle;
  final double height;  
  final VoidCallback? onClick;

  const LoadIndicator(
      {Key? key,
      this.onClick,
      this.loadStyle = LoadStyle.showAlways,
      this.height = 60.0})
      : super(key: key);
}

abstract class RefreshIndicatorState<T extends RefreshIndicator>
    extends State<T>
    with IndicatorStateMixin<T, RefreshStatus>, RefreshProcessor {
  bool _inVisual() {
    return _position!.pixels < 0.0;
  }
  @override
  double _calculateScrollOffset() {
    return (floating
            ? (mode == RefreshStatus.twoLeveling ||
                    mode == RefreshStatus.twoLevelOpening ||
                    mode == RefreshStatus.twoLevelClosing
                ? refresherState!.viewportExtent
                : widget.height)
            : 0.0) -
        (_position?.pixels as num);
  }
  @override
  void _handleOffsetChange() {
    super._handleOffsetChange();
    final double overScrollPast = _calculateScrollOffset();
    onOffsetChange(overScrollPast);
  }
  
  @override
  void _dispatchModeByOffset(double offset) {
    if (mode == RefreshStatus.twoLeveling) {
      if (_position!.pixels > configuration!.closeTwoLevelDistance &&
          activity is BallisticScrollActivity) {
        refresher!.controller.twoLevelComplete();
        return;
      }
    }
    if (RefreshStatus.twoLevelOpening == mode ||
        mode == RefreshStatus.twoLevelClosing) {
      return;
    }
    if (floating) return;
    
    if (offset == 0.0) {
      mode = RefreshStatus.idle;
    }
    
    if (_position!.extentBefore == 0.0 &&
        widget.refreshStyle == RefreshStyle.front) {
      _position!.context.setIgnorePointer(false);
    }
    
    
    
    if ((configuration!.enableBallisticRefresh && activity!.velocity < 0.0) ||
        activity is DragScrollActivity ||
        activity is DrivenScrollActivity) {
      if (refresher!.enablePullDown &&
          offset >= configuration!.headerTriggerDistance) {
        if (!configuration!.skipCanRefresh) {
          mode = RefreshStatus.canRefresh;
        } else {
          floating = true;
          update();
          readyToRefresh().then((_) {
            if (!mounted) return;
            mode = RefreshStatus.refreshing;
          });
        }
      } else if (refresher!.enablePullDown) {
        mode = RefreshStatus.idle;
      }
   
    }
    
    else if (activity is BallisticScrollActivity) {
      if (RefreshStatus.canRefresh == mode) {
        
        floating = true;
        update();
        readyToRefresh().then((_) {
          if (!mounted) return;
          mode = RefreshStatus.refreshing;
        });
      }
      if (mode == RefreshStatus.canTwoLevel) {
        
        floating = true;
        update();
        if (!mounted) return;
        mode = RefreshStatus.twoLevelOpening;
      }
    }
  }
  @override
  void _handleModeChange() {
    if (!mounted) {
      return;
    }
    update();
    if (mode == RefreshStatus.idle || mode == RefreshStatus.canRefresh) {
      floating = false;
      resetValue();
      if (mode == RefreshStatus.idle) refresherState!.setCanDrag(true);
    }
    if (mode == RefreshStatus.completed || mode == RefreshStatus.failed) {
      endRefresh().then((_) {
        if (!mounted) return;
        floating = false;
        if (mode == RefreshStatus.completed || mode == RefreshStatus.failed) {
          refresherState!
              .setCanDrag(configuration!.enableScrollWhenRefreshCompleted);
        }
        update();
       
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) {
            return;
          }
          if (widget.refreshStyle == RefreshStyle.front) {
            if (_inVisual()) {
              _position!.jumpTo(0.0);
            }
            mode = RefreshStatus.idle;
          } else {
            if (!_inVisual()) {
              mode = RefreshStatus.idle;
            } else {
              activity!.delegate.goBallistic(0.0);
            }
          }
        });
      });
    } else if (mode == RefreshStatus.refreshing) {
      if (!floating) {
        floating = true;
        readyToRefresh();
      }
      if (configuration!.enableRefreshVibrate) {
        HapticFeedback.vibrate();
      }
      if (refresher!.onRefresh != null) refresher!.onRefresh!();
    } else if (mode == RefreshStatus.twoLevelOpening) {
      floating = true;
      refresherState!.setCanDrag(false);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        activity!.resetActivity();
        _position!
            .animateTo(0.0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.linear)
            .whenComplete(() {
          mode = RefreshStatus.twoLeveling;
        });
      
      });
    } else if (mode == RefreshStatus.twoLevelClosing) {
      floating = false;
      refresherState!.setCanDrag(false);
      update();
      
    } else if (mode == RefreshStatus.twoLeveling) {
      refresherState!.setCanDrag(configuration!.enableScrollWhenTwoLevel);
    }
    onModeChange(mode);
  }
  
  @override
  Future<void> readyToRefresh() {
    return Future.value();
  }
  
  @override
  Future<void> endRefresh() {
    return Future.delayed(widget.completeDuration);
  }
  bool needReverseAll() {
    return true;
  }
  @override
  void resetValue() {}
  @override
  Widget build(BuildContext context) {
    return SliverRefresh(
        paintOffsetY: widget.offset,
        floating: floating,
        refreshIndicatorLayoutExtent: mode == RefreshStatus.twoLeveling ||
                mode == RefreshStatus.twoLevelOpening ||
                mode == RefreshStatus.twoLevelClosing
            ? refresherState!.viewportExtent
            : widget.height,
        refreshStyle: widget.refreshStyle,
        child: RotatedBox(
          quarterTurns: needReverseAll() &&
                  Scrollable.of(context)!.axisDirection == AxisDirection.up
              ? 10
              : 0,
          child: buildContent(context, mode),
        ));
  }
}
abstract class LoadIndicatorState<T extends LoadIndicator> extends State<T>
    with IndicatorStateMixin<T, LoadStatus>, LoadingProcessor {
  
  bool _isHide = false;
  bool _enableLoading = false;
  LoadStatus? _lastMode = LoadStatus.idle;
  @override
  double _calculateScrollOffset() {
    final double overScrollPastEnd =
        math.max(_position!.pixels - _position!.maxScrollExtent, 0.0);
    return overScrollPastEnd;
  }
  void enterLoading() {
    setState(() {
      floating = true;
    });
    _enableLoading = false;
    readyToLoad().then((_) {
      if (!mounted) {
        return;
      }
      mode = LoadStatus.loading;
    });
  }
  @override
  Future endLoading() {
    
    return Future.delayed(const Duration(milliseconds: 0));
  }
  void finishLoading() {
    if (!floating) {
      return;
    }
    endLoading().then((_) {
      if (!mounted) {
        return;
      }
      
      if (mounted) Scrollable.of(context)!.position.correctBy(0.00001);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _position?.outOfRange == true) {
          activity!.delegate.goBallistic(0);
        }
      });
      setState(() {
        floating = false;
      });
    });
  }
  bool _checkIfCanLoading() {
    if (_position!.maxScrollExtent - _position!.pixels <=
            configuration!.footerTriggerDistance &&
        _position!.extentBefore > 2.0 &&
        _enableLoading) {
      if (!configuration!.enableLoadingWhenFailed &&
          mode == LoadStatus.failed) {
        return false;
      }
      if (!configuration!.enableLoadingWhenNoData &&
          mode == LoadStatus.noMore) {
        return false;
      }
      if (mode != LoadStatus.canLoading &&
          _position!.userScrollDirection == ScrollDirection.forward) {
        return false;
      }
      return true;
    }
    return false;
  }
  @override
  void _handleModeChange() {
    if (!mounted || _isHide) {
      return;
    }
    update();
    if (mode == LoadStatus.idle ||
        mode == LoadStatus.failed ||
        mode == LoadStatus.noMore) {
      
      
      if (_position!.activity!.velocity < 0 &&
          _lastMode == LoadStatus.loading &&
          !_position!.outOfRange &&
          _position is ScrollActivityDelegate) {
        _position!.beginActivity(
            IdleScrollActivity(_position as ScrollActivityDelegate));
      }
      finishLoading();
    }
    if (mode == LoadStatus.loading) {
      if (!floating) {
        enterLoading();
      }
      if (configuration!.enableLoadMoreVibrate) {
        HapticFeedback.vibrate();
      }
      if (refresher!.onLoading != null) {
        refresher!.onLoading!();
      }
      if (widget.loadStyle == LoadStyle.showWhenLoading) {
        floating = true;
      }
    } else {
      if (activity is! DragScrollActivity) _enableLoading = false;
    }
    _lastMode = mode;
    onModeChange(mode);
  }
  @override
  void _dispatchModeByOffset(double offset) {
    if (!mounted || _isHide || LoadStatus.loading == mode || floating) {
      return;
    }
    if (activity is DragScrollActivity) {
      if (_checkIfCanLoading()) {
        mode = LoadStatus.canLoading;
      } else {
        mode = _lastMode;
      }
    }
    if (activity is BallisticScrollActivity) {
      if (configuration!.enableBallisticLoad) {
        if (_checkIfCanLoading()) enterLoading();
      } else if (mode == LoadStatus.canLoading) {
        enterLoading();
      }
    }
  }
  @override
  void _handleOffsetChange() {
    if (_isHide) {
      return;
    }
    super._handleOffsetChange();
    final double overScrollPast = _calculateScrollOffset();
    onOffsetChange(overScrollPast);
  }
  void _listenScrollEnd() {
    if (!_position!.isScrollingNotifier.value) {
      
      if (_isHide || mode == LoadStatus.loading || mode == LoadStatus.noMore) {
        return;
      }
      if (_checkIfCanLoading()) {
        if (activity is IdleScrollActivity) {
          if ((configuration!.enableBallisticLoad) ||
              ((!configuration!.enableBallisticLoad) &&
                  mode == LoadStatus.canLoading)) enterLoading();
        }
      }
    } else {
      if (activity is DragScrollActivity || activity is DrivenScrollActivity) {
        _enableLoading = true;
      }
    }
  }
  @override
  void _onPositionUpdated(ScrollPosition newPosition) {
    _position?.isScrollingNotifier.removeListener(_listenScrollEnd);
    newPosition.isScrollingNotifier.addListener(_listenScrollEnd);
    super._onPositionUpdated(newPosition);
  }
  @override
  void didChangeDependencies() {
    
    super.didChangeDependencies();
    _lastMode = mode;
  }
  @override
  void dispose() {
    
    _position?.isScrollingNotifier.removeListener(_listenScrollEnd);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    
    return SliverLoading(
        hideWhenNotFull: configuration!.hideFooterWhenNotFull,
        floating: widget.loadStyle == LoadStyle.showAlways
            ? true
            : widget.loadStyle == LoadStyle.hideAlways
                ? false
                : floating,
        shouldFollowContent: mode == LoadStatus.noMore,
        layoutExtent: widget.height,
        mode: mode,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints cons) {
            _isHide = cons.biggest.height == 0.0;
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (widget.onClick != null) {
                  widget.onClick!();
                }
              },
              child: buildContent(context, mode),
            );
          },
        ));
  }
}
mixin IndicatorStateMixin<T extends StatefulWidget, V> on State<T> {
  PaginatedList? refresher;
  RefreshConfiguration? configuration;
  PaginatedListState? refresherState;
  bool _floating = false;
  set floating(floating) => _floating = floating;
  get floating => _floating;
  set mode(mode) => _mode?.value = mode;
  get mode => _mode?.value;
  RefreshNotifier<V?>? _mode;
  ScrollActivity? get activity => _position!.activity;
  
  
  ScrollPosition? _position;
  
  void update() {
    if (mounted) setState(() {});
  }
  void _handleOffsetChange() {
    if (!mounted) {
      return;
    }
    final double overScrollPast = _calculateScrollOffset();
    if (overScrollPast < 0.0) {
      return;
    }
    _dispatchModeByOffset(overScrollPast);
  }
  void disposeListener() {
    _mode?.removeListener(_handleModeChange);
    _position?.removeListener(_handleOffsetChange);
    _position = null;
    _mode = null;
  }
  void _updateListener() {
    configuration = RefreshConfiguration.of(context);
    refresher = PaginatedList.of(context);
    refresherState = PaginatedList.ofState(context);
    RefreshNotifier<V>? newMode = V == RefreshStatus
        ? refresher!.controller.headerMode as RefreshNotifier<V>?
        : refresher!.controller.footerMode as RefreshNotifier<V>?;
    final ScrollPosition newPosition = Scrollable.of(context)!.position;
    if (newMode != _mode) {
      _mode?.removeListener(_handleModeChange);
      _mode = newMode;
      _mode?.addListener(_handleModeChange);
    }
    if (newPosition != _position) {
      _position?.removeListener(_handleOffsetChange);
      _onPositionUpdated(newPosition);
      _position = newPosition;
      _position?.addListener(_handleOffsetChange);
    }
  }
  @override
  void initState() {
    
    if (V == RefreshStatus) {
      PaginatedList.of(context)?.controller.headerMode?.value =
          RefreshStatus.idle;
    }
    super.initState();
  }
  @override
  void dispose() {
    
    
    disposeListener();
    super.dispose();
  }
  @override
  void didChangeDependencies() {
    
    _updateListener();
    super.didChangeDependencies();
  }
  @override
  void didUpdateWidget(T oldWidget) {
    
    
    
    _updateListener();
    super.didUpdateWidget(oldWidget);
  }
  void _onPositionUpdated(ScrollPosition newPosition) {
    refresher!.controller.onPositionUpdated(newPosition);
  }
  void _handleModeChange();
  double _calculateScrollOffset();
  void _dispatchModeByOffset(double offset);
  Widget buildContent(BuildContext context, V mode);
}
abstract class RefreshProcessor {
  
  void onOffsetChange(double offset) {}
  
  void onModeChange(RefreshStatus? mode) {}
  
  Future readyToRefresh() {
    return Future.value();
  }
  
  Future endRefresh() {
    return Future.value();
  }
  
  void resetValue() {}
}
abstract class LoadingProcessor {
  void onOffsetChange(double offset) {}
  void onModeChange(LoadStatus? mode) {}
  
  Future readyToLoad() {
    return Future.value();
  }
  
  Future endLoading() {
    return Future.value();
  }
  
  void resetValue() {}
}
