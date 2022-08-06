import 'package:rxdart/rxdart.dart';

abstract class RxBloc {
  final CompositeSubscription compositeSubscription = CompositeSubscription();

  void dispose() {
    compositeSubscription.dispose();
  }

  void addFutureSubscription(
      Future<dynamic> future, Function onData, void Function(Error e) onError) {
    compositeSubscription
        .add(Stream.fromFuture(future).listen((event) {
          onData(event!);
        }))
        .onError(onError);
  }
}
