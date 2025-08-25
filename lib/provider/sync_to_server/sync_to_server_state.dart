part of 'sync_to_server_cubit.dart';

@immutable
sealed class SyncToServerState {}

final class SyncToServerInitial extends SyncToServerState {}

final class SyncToServerLoading extends SyncToServerState {}

final class SyncToServerSuccess extends SyncToServerState {
  final dynamic responseData;

  SyncToServerSuccess(this.responseData);
}final class SyncToSingleImageSuccess extends SyncToServerState {
  final String pRowId;

  SyncToSingleImageSuccess(this.pRowId);
}

final class SyncToServerFailure extends SyncToServerState {
  final String error;

  SyncToServerFailure(this.error);
}
