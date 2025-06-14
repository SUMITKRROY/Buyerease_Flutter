import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:buyerease/database/table/defect_master.dart';
import 'package:buyerease/provider/master_repo.dart';
import 'package:meta/meta.dart';

part 'defect_master_state.dart';

class DefectMasterCubit extends Cubit<DefectMasterState> {
  DefectMasterCubit() : super(DefectMasterInitial());

  Future<void> fetchDefectMaster({required String data}) async {
    emit(DefectMasterLoading());

    try {
      final response = await MasterRepo().getDefectMaster( userId: '');
      developer.log(" DefectMasterCubit responce ${response.data['Data'][0]['DefectMaster'].runtimeType}");
      final List<dynamic> defectList = response.data['Data'][0]['DefectMaster'];

      for (var item in defectList) {
        // Ensure all necessary fields exist or provide defaults
        final record = {
          DefectMaster.pRowID: item['pRowID'] ?? '',
          DefectMaster.locID: item['LocID'] ?? '',
          DefectMaster.defectName: item['DefectName'] ?? '',
          DefectMaster.code: item['Code'] ?? '',
          DefectMaster.dclTypeID: item['DCLTypeID'] ?? '',
          DefectMaster.inspectionStage: item['InspectionStage'] ?? '',
          DefectMaster.chkCritical: item['chkCritical'] ?? 0,
          DefectMaster.chkMajor: item['chkMajor'] ?? 0,
          DefectMaster.chkMinor: item['chkMinor'] ?? 0,
          DefectMaster.recEnable: 1,
          DefectMaster.recAdddt: '',         // Set appropriate date if available
          DefectMaster.recDt: '',            // Set appropriate date if available
          DefectMaster.recAddUser: item['recAddUser'] ?? '',
          DefectMaster.recUser: '',          // Fill if available
        };

        await DefectMaster().insert(record);
      }
      emit(DefectMasterLoaded(response.data));
    } catch (e) {
      emit(DefectMasterError(e.toString()));
    }
  }
}
