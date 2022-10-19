enum LoadStyle {
  /// indicator always own layoutExtent whatever the state
  showAlways,

  /// indicator always own 0.0 layoutExtent whatever the state
  hideAlways,

  /// indicator always own layoutExtent when loading state, the other state is 0.0 layoutExtent
  showWhenLoading
}