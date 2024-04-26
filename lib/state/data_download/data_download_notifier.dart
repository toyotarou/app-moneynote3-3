import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../enums/data_download_data_type.dart';
import 'data_download_response_state.dart';

final dataDownloadProvider = StateNotifierProvider.autoDispose<DataDownloadNotifier, DataDownloadResponseState>((ref) {
  return DataDownloadNotifier(const DataDownloadResponseState());
});

class DataDownloadNotifier extends StateNotifier<DataDownloadResponseState> {
  DataDownloadNotifier(super.state);

  ///
  Future<void> setStartDate({required String date}) async => state = state.copyWith(startDate: date);

  ///
  Future<void> setEndDate({required String date}) async => state = state.copyWith(endDate: date);

  ///
  Future<void> setDataType({required DateDownloadDataType dataType}) async => state = state.copyWith(dataType: dataType);
}
