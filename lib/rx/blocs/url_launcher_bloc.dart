import 'package:client/rx/blocs/rx_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UrlLauncherBloc extends RxBloc {
  final _launchingUrls = BehaviorSubject<List<Map<String, bool>>>();

  Stream<List<Map<String, bool>>> get launchingUrl => _launchingUrls.stream;

  void launchUrl(String url, [Function? onError]) {
    _launchingUrls.add(_launchingUrls.hasValue
        ? [
            ..._launchingUrls.value,
            {url: true}
          ]
        : [
            {url: true}
          ]);
    addFutureSubscription(canLaunchUrlString(url), (bool available) {
      if (available) {
        addFutureSubscription(launchUrlString(url), (bool result) {
          urlLaunched(url);
          if (!result && onError != null) {
            onError();
          }
        }, (e) {
          urlLaunched(url);
          if (onError != null) onError();
        });
      } else {
        urlLaunched(url);
        if (onError != null) onError();
      }
    }, (error) {
      if (onError != null) {
        onError(error);
      }
      urlLaunched(url);
    });
  }

  void urlLaunched(String url) {
    _launchingUrls.add([
      ..._launchingUrls.value.where((element) => element.keys.first != url),
    ]);
  }
}
