enum LoadStatus {
  /// Initial state, which can be triggered loading more by gesture pull up
  idle,

  canLoading,

  /// indicator is loading more data
  loading,

  /// indicator is no more data to loading,this state doesn't allow to load more whatever
  noMore,

  /// indicator load failed,Initial state, which can be click retry,If you need to pull up trigger load more,you should set enableLoadingWhenFailed = true in RefreshConfiguration
  failed
}