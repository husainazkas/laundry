import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundry/model/order_details_model.dart';

abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryInProgress extends HistoryState {
  HistoryInProgress();
}

class HistorySuccess extends HistoryState {
  final List<OrderDetails> Function(String key) getData;
  HistorySuccess(this.getData);
}

class HistoryFailure extends HistoryState {
  final String error;
  HistoryFailure(this.error);
}

class HistoryEvent {
  final Sort sort;
  HistoryEvent(this.sort);
}

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final CollectionReference _firestore =
      FirebaseFirestore.instance.collection('orders');

  HistoryBloc(HistoryState initialState) : super(initialState);

  @override
  Stream<HistoryState> mapEventToState(HistoryEvent event) async* {
    yield HistoryInProgress();
    List<OrderDetails> otw = [];
    List<OrderDetails> opg = [];
    List<OrderDetails> finish = [];
    List<OrderDetails> canceled = [];

    final snapshot = await _firestore
        .orderBy('start_date', descending: event.sort == Sort.desc)
        .get();

    final data = snapshot.docs;
    if (data.isNotEmpty) {
      for (var item in data) {
        OrderDetails detail = OrderDetails.fromJson(item.data());
        switch (detail.status.toLowerCase().split(' ').join()) {
          case 'sedangdijemput':
          case 'sedangdiantar':
            otw.add(detail);
            break;
          case 'sedangdiproses':
            opg.add(detail);
            break;
          case 'selesai':
            finish.add(detail);
            break;
          case 'batal':
            canceled.add(detail);
            break;
        }
      }
    }

    Map<String, List<OrderDetails>> result = {
      'dalamperjalanan': otw,
      'sedangdiproses': opg,
      'selesai': finish,
      'batal': canceled
    };

    yield HistorySuccess((key) => result[key]);
  }
}
