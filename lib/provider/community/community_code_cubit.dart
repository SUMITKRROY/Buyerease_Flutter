import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import '../master_repo.dart';

part 'community_code_state.dart';

class CommunityCodeCubit extends Cubit<CommunityCodeState> {


  CommunityCodeCubit() : super(CommunityCodeInitial());

  Future<void> getCommunityCode(String code) async {
    try {

      emit(CommunityCodeLoading());
      final response = await MasterRepo().getCommunityCode(code);
      
      if (response.data['ErrorCode'] == 201) {
        // Emit the entire response data
        emit(CommunityCodeLoaded(response.data));
      } else {
        emit(CommunityCodeError('${response.data['Status']}'));
      }
    } catch (e) {
      emit(CommunityCodeError(e.toString()));
    }
  }
}
