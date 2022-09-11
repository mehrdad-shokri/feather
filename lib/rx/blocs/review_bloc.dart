import 'package:client/rx/blocs/rx_bloc.dart';
import 'package:client/rx/managers/inapp_review.dart';
import 'package:rxdart/rxdart.dart';

class ReviewBloc extends RxBloc {
  late InAppReviewManager inAppReviewManager;

  ReviewBloc() {
    inAppReviewManager = InAppReviewManager();
  }

  final _addingReviewToStore = BehaviorSubject<bool>();

  Stream<bool> get addingReview => _addingReviewToStore.stream;

  void addReview({Function? onData, Function? onError}) {
    _addingReviewToStore.add(true);
    addFutureSubscription(inAppReviewManager.instance.isAvailable(),
        (bool available) {
      if (available) {
        addFutureSubscription(inAppReviewManager.instance.requestReview(),
            (data) {
          _addingReviewToStore.add(false);
          if (onData != null) onData(data);
        }, (error) {
          _addingReviewToStore.add(false);
          if (onError != null) onError();
        });
      } else {
        _addingReviewToStore.add(false);
        if (onError != null) onError();
      }
    }, (error) {
      _addingReviewToStore.add(false);
      if (onError != null) onError(error);
    });
  }
}
