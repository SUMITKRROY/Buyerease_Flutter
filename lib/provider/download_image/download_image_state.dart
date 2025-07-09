part of 'download_image_cubit.dart';

@immutable
sealed class DownloadImageState {}

final class DownloadImageInitial extends DownloadImageState {}

final class DownloadImageLoading extends DownloadImageState {
  final int count;
  DownloadImageLoading({required this.count});
}
final class DownloadImageCount extends DownloadImageState {
  final int count;
  DownloadImageCount({required this.count});
}

final class DownloadImageSuccess extends DownloadImageState {}

final class DownloadImageFailure extends DownloadImageState {
  final String error;

  DownloadImageFailure(this.error);
}
