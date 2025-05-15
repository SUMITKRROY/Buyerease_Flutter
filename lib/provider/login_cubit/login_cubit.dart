import 'package:bloc/bloc.dart';
import 'package:buyerease/provider/master_repo.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';

import '../../database/table/user_master_table.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> login({
    required String user,
    required String password,
    required String deviceId,
    required String deviceIP,
    required String hddSerialNo,
    required String deviceType,
    required String location,
  }) async
  {
    emit(LoginLoading());
    try {
      final response = await MasterRepo().getLogin(
        user: user,
        password: password,
        deviceId: deviceId,
        deviceIP: deviceIP,
        hddSerialNo: hddSerialNo,
        deviceType: deviceType,
        location: location,
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['Message'] == 'Login Successfull.') {
          final user = responseData["Data"][0];

          // Insert to DB
          await UserMasterTable().insert(user);

          emit(LoginSuccess(responseData['Data'][0]));

        } else {
          emit(LoginFailure(responseData['Message'].toString()));
        }
      } else {
        emit(LoginFailure('Server Error: ${response.statusCode}'));
      }
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
