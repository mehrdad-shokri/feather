import 'package:client/components/atoms/bottom_sheet_scroll_indicator.dart';
import 'package:client/rx/blocs/review_bloc.dart';
import 'package:client/rx/blocs/url_launcher_bloc.dart';
import 'package:client/rx/services/service_provider.dart';
import 'package:client/utils/colors.dart';
import 'package:client/utils/constants.dart';
import 'package:client/utils/feather_icons.dart';
import 'package:client/utils/hex_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AboutDetailDialog extends StatefulWidget {
  final AppLocalizations t;

  const AboutDetailDialog({Key? key, required this.t}) : super(key: key);

  @override
  State<AboutDetailDialog> createState() => _AboutDetailDialogState();
}

class _AboutDetailDialogState extends State<AboutDetailDialog> {
  late ReviewBloc reviewBloc;
  late UrlLauncherBloc urlLauncherBloc;

  @override
  void initState() {
    super.initState();
    reviewBloc = ReviewBloc();
    urlLauncherBloc = UrlLauncherBloc();
  }

  @override
  void dispose() {
    super.dispose();
    reviewBloc.dispose();
    urlLauncherBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8, bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const BottomSheetScrollIndicator(),
            Text(
              widget.t.about,
              style: TextStyle(
                  color: textColor(context),
                  fontSize: Constants.H6_FONT_SIZE,
                  fontWeight: Constants.MEDIUM_FONT_WEIGHT),
            ),
            const SizedBox(
              height: 8,
            ),
            Divider(
              color: dividerColor(context),
            ),
            Padding(
              padding: Constants.PAGE_PADDING,
              child: Text(
                widget.t.featherAbout,
                style: TextStyle(
                    height: 1.6,
                    color: textColor(context),
                    fontSize: Constants.S1_FONT_SIZE,
                    fontWeight: Constants.REGULAR_FONT_WEIGHT),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: Constants.PAGE_PADDING,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: PlatformElevatedButton(
                      color: Constants.PRIMARY_COLOR_DARK,
                      cupertino: (context, _) => CupertinoElevatedButtonData(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          color: Constants.PRIMARY_COLOR_DARK,
                          borderRadius: BorderRadius.circular(24)),
                      child: StreamBuilder(
                        stream: reviewBloc.addingReview,
                        builder: (context, snapshot) {
                          bool? updating = snapshot.data as bool?;
                          if (updating != null && updating) {
                            return PlatformCircularProgressIndicator();
                          }
                          return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Feather.star,
                                  color: Colors.yellow.shade700,
                                  size: 24,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  widget.t.rateApp,
                                  style: const TextStyle(
                                    fontSize: Constants.S2_FONT_SIZE,
                                    color: Colors.white,
                                    fontWeight: Constants.MEDIUM_FONT_WEIGHT,
                                  ),
                                )
                              ]);
                        },
                      ),
                      onPressed: () {
                        reviewBloc.addReview(
                            onError: (e) => Fluttertoast.showToast(
                                msg:
                                    e?.toString() ?? widget.t.errorAddingReview,
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: Constants.TOAST_DEFAULT_LOCATION,
                                timeInSecForIosWeb: 5,
                                backgroundColor: Constants.ERROR_COLOR,
                                textColor: Colors.white,
                                fontSize: 16.0));
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: PlatformTextButton(
                      child: StreamBuilder(
                        stream: urlLauncherBloc.launchingUrl,
                        builder: (context, snapshot) {
                          List<Map<String, bool>>? launching =
                              snapshot.data as List<Map<String, bool>>?;
                          if (launching != null &&
                              launching
                                  .where((element) =>
                                      element.keys.first ==
                                      Constants.GITHUB_REPO_URL)
                                  .isNotEmpty) {
                            return PlatformCircularProgressIndicator();
                          }
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Feather.mark_github,
                                color: dividerColor(context),
                                size: 24,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                widget.t.viewRepository,
                                style: TextStyle(
                                    fontSize: Constants.S2_FONT_SIZE,
                                    color: textColor(context),
                                    fontWeight: Constants.MEDIUM_FONT_WEIGHT),
                              ),
                            ],
                          );
                        },
                      ),
                      onPressed: () {
                        urlLauncherBloc.launchUrl(
                            Constants.GITHUB_REPO_URL,
                            (e) => Fluttertoast.showToast(
                                msg:
                                    e?.toString() ?? widget.t.errorAddingReview,
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: Constants.TOAST_DEFAULT_LOCATION,
                                timeInSecForIosWeb: 5,
                                backgroundColor: Constants.ERROR_COLOR,
                                textColor: Colors.white,
                                fontSize: 16.0));
                      },
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: Constants.PAGE_PADDING,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: PlatformTextButton(
                      child: StreamBuilder(
                        stream: urlLauncherBloc.launchingUrl,
                        builder: (context, snapshot) {
                          List<Map<String, bool>>? launching =
                              snapshot.data as List<Map<String, bool>>?;
                          if (launching != null &&
                              launching
                                  .where((element) =>
                                      element.keys.first ==
                                      Constants.FEATHER_PRIVACY_URL)
                                  .isNotEmpty) {
                            return PlatformCircularProgressIndicator();
                          }
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.privacy_tip,
                                color: HexColor.fromHex('#999999'),
                                size: 24,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                widget.t.privacyPolicy,
                                style: TextStyle(
                                    fontSize: Constants.S2_FONT_SIZE,
                                    color: textColor(context),
                                    fontWeight: Constants.MEDIUM_FONT_WEIGHT),
                              ),
                            ],
                          );
                        },
                      ),
                      onPressed: () {
                        urlLauncherBloc.launchUrl(
                            Constants.FEATHER_PRIVACY_URL,
                            (e) => Fluttertoast.showToast(
                                msg:
                                    e?.toString() ?? widget.t.errorAddingReview,
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: Constants.TOAST_DEFAULT_LOCATION,
                                timeInSecForIosWeb: 5,
                                backgroundColor: Constants.ERROR_COLOR,
                                textColor: Colors.white,
                                fontSize: 16.0));
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: PlatformTextButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isMaterial(context)
                                ? Icons.feed_outlined
                                : CupertinoIcons.doc_text_fill,
                            color: HexColor.fromHex('#999999'),
                            size: 24,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            widget.t.licences,
                            style: TextStyle(
                                fontSize: Constants.S2_FONT_SIZE,
                                color: textColor(context),
                                fontWeight: Constants.MEDIUM_FONT_WEIGHT),
                          ),
                        ],
                      ),
                      onPressed: () {
                        showLicensePage(
                            context: context,
                            applicationName: ServiceProvider.getInstance()
                                .appInfoService
                                .packageInfo
                                .appName,
                            applicationIcon: Image.asset(
                              'assets/images/logo.png',
                              width: 120,
                            ),
                            applicationVersion: ServiceProvider.getInstance()
                                .appInfoService
                                .packageInfo
                                .version);
                      },
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 32,
            )
          ],
        ),
      ),
    );
  }
}
