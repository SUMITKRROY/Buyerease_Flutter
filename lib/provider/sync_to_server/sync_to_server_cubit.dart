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

  Future<String> sendSingleImageData(Map<String, dynamic> inspectionData) async {
    emit(SyncToServerLoading());

    try {
      final response = await MasterRepo().sendSingleImageData(
        inspectionData: inspectionData,
      );
      developer.log("Response data >>> ${response.data}");

      if (response.statusCode == 200) {
        final data = response.data;

        if (data != null && data.containsKey('Result')) {
          emit(SyncToServerSuccess(data));
          // Return the Result directly
          return data['Result'];
        } else {
          emit(SyncToServerFailure("Unexpected response format"));
          return "";
        }
      } else {
        emit(SyncToServerFailure("Error: ${response.statusMessage}"));
        return '';
      }
    } catch (e) {
      emit(SyncToServerFailure("Exception: ${e.toString()}"));
      return '';
    }
  }


/*  Future<bool> sendSingleImageData(Map<String, dynamic> inspectionData) async {
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
  }*/

}
