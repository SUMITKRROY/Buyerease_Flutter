part of 'defect_master_cubit.dart';

@immutable
sealed class DefectMasterState {}

final class DefectMasterInitial extends DefectMasterState {}

final class DefectMasterLoading extends DefectMasterState {}

final class DefectMasterLoaded extends DefectMasterState {
  final dynamic defectData;

  DefectMasterLoaded(this.defectData);
}

final class DefectMasterError extends DefectMasterState {
  final String message;

  DefectMasterError(this.message);
}
