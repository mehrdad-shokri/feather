import 'package:rxdart/rxdart.dart';

abstract class RxBloc {
  final CompositeSubscription _compositeSubscription = CompositeSubscription();

  void dispose() {
    _compositeSubscription.dispose();
  }

  void addFutureSubscription<T>(Future<T> future,
      [Function(T)? onData, void Function(Error e)? onError]) {
    _compositeSubscription
        .add(Stream.fromFuture(future).listen((event) {
      if (onData != null) onData(event!);
    }))
        .onError((e, callstack) {
      if (onError != null) onError(e);
    });
  }
}
