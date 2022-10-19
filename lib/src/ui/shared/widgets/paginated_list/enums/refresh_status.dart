/// header state
enum RefreshStatus {
  /// Initial state, when not being overscrolled into, or after the overscroll
  /// is canceled or after done and the sliver retracted away.
  idle,

  /// Dragged far enough that the onRefresh callback will callback
  canRefresh,

  /// the indicator is refreshing,waiting for the finish callback
  refreshing,

  /// the indicator refresh completed
  completed,

  /// the indicator refresh failed
  failed,

  ///  Dragged far enough that the onTwoLevel callback will callback
  canTwoLevel,

  ///  indicator is opening twoLevel
  twoLevelOpening,

  /// indicator is in twoLevel
  twoLeveling,

  ///  indicator is closing twoLevel
  twoLevelClosing
}
