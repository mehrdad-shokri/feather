import 'package:in_app_review/in_app_review.dart';

class InAppReviewManager {
  late InAppReview _inAppReview;

  InAppReview get instance => _inAppReview;

  InAppReviewManager() {
    _inAppReview = InAppReview.instance;
  }
}
