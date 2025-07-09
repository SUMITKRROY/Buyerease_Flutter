import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../master_repo.dart';

part 'sync_to_server_state.dart';

class SyncToServerCubit extends Cubit<SyncToServerState> {


  SyncToServerCubit() : super(SyncToServerInitial());

  Future<bool> sendInspection(Map<String, dynamic> inspectionData) async {
    emit(SyncToServerLoading());

    try {
      final response = await MasterRepo().sendQualityInspection(
        inspectionData: inspectionData,
      );

      developer.log("responce data >>>${response.data}");

      if (response.statusCode == 200) {
        final data = response.data;

        // Check if message is exactly what you expect
        if (data != null && data['Message'] == 'Temp Data successfully processed.') {
          emit(SyncToServerSuccess(data));
          return true;
        } else {
          emit(SyncToServerFailure("Unexpected message: ${data['Message']}"));
          return false;
        }
      } else {
        emit(SyncToServerFailure("Error: ${response.statusMessage}"));
        return false;
      }
    } catch (e) {
      emit(SyncToServerFailure("Exception: ${e.toString()}"));
      return false;
    }
  }

}
