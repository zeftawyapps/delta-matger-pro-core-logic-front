import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matger_core_logic/utls/bloc/remote_base_model.dart';

import 'base_state.dart';

class DataSourceBloc<T> extends Cubit<DataSourceBaseState<T>> {
  DataSourceBloc([T? data])
    : super(
        data != null
            ? DataSourceBaseState.success(data)
            : const DataSourceBaseState.init(),
      );
  T? _data;

  void init() {
    _data = null;
    emit(const DataSourceBaseState.init());
  }

  T? get data => _data;

  set data(T? value) {
    _data = value;
  }

  void loadingState() {
    emit(const DataSourceBaseState.loading());
  }

  void successState([T? data]) {
    if (_data != data) {
      _data = data;
    }
    emit(DataSourceBaseState.success(data));
  }

  void failedState(ErrorStateModel error, VoidCallback callback) {
    emit(DataSourceBaseState.failure(error, callback));
  }
}
