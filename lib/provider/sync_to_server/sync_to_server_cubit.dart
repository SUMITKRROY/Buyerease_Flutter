import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'sync_to_server_state.dart';

class SyncToServerCubit extends Cubit<SyncToServerState> {
  SyncToServerCubit() : super(SyncToServerInitial());
}
