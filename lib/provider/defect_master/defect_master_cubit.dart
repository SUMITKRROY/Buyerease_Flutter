import 'package:bloc/bloc.dart';
import 'package:buyerease/provider/master_repo.dart';
import 'package:meta/meta.dart';

part 'defect_master_state.dart';

class DefectMasterCubit extends Cubit<DefectMasterState> {


  DefectMasterCubit() : super(DefectMasterInitial());

  Future<void> fetchDefectMaster(Map<String, dynamic> data) async {
    emit(DefectMasterLoading());

    try {
      final response = await MasterRepo().getDefectMaster( user: '');
      emit(DefectMasterLoaded(response.data));
    } catch (e) {
      emit(DefectMasterError(e.toString()));
    }
  }
}
