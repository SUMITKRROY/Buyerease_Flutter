part of 'community_code_cubit.dart';

@immutable
sealed class CommunityCodeState {}

final class CommunityCodeInitial extends CommunityCodeState {}

final class CommunityCodeLoading extends CommunityCodeState {}

final class CommunityCodeLoaded extends CommunityCodeState {
  final dynamic responseData;
  CommunityCodeLoaded(this.responseData);
}

final class CommunityCodeError extends CommunityCodeState {
  final String message;
  CommunityCodeError(this.message);
}
