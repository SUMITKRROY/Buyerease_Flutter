part of 'sync_cubit.dart';

@immutable
sealed class SyncState {}

final class SyncInitial extends SyncState {}

final class SyncLoading extends SyncState {}

final class SyncSuccess extends SyncState {

}

final class SyncFailure extends SyncState {
  final String error;

  SyncFailure(this.error);
}
