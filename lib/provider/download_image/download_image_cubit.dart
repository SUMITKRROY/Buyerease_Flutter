import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'download_image_state.dart';

class DownloadImageCubit extends Cubit<DownloadImageState> {
  DownloadImageCubit() : super(DownloadImageInitial());
}
