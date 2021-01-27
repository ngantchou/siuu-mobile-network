import 'package:Siuu/widgets/icon.dart';
import 'package:Siuu/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/widgets/theming/primary_color_container.dart';
import 'package:Siuu/widgets/theming/secondary_text.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBUsefulLinksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var urlLauncherService = openbookProvider.urlLauncherService;
    var _localizationService = openbookProvider.localizationService;

    return CupertinoPageScaffold(
      navigationBar: OBThemedNavigationBar(
        title: _localizationService.drawer__useful_links_title,
      ),
      child: OBPrimaryColorContainer(
        child: Column(
          children: <Widget>[
            SizedBox(height: 50),
            Expanded(
                child: ListView(
              physics: const ClampingScrollPhysics(),
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(
                  leading: const OBIcon(OBIcons.guide),
                  title: OBText(
                      _localizationService.drawer__useful_links_guidelines),
                  subtitle: OBSecondaryText(_localizationService
                      .drawer__useful_links_guidelines_desc),
                  onTap: () {
                    OpenbookProviderState openbookProvider =
                        OpenbookProvider.of(context);
                    openbookProvider.navigationService
                        .navigateToMemoryGuidelinesPage(context: context);
                  },
                ),
                ListTile(
                  leading: const OBIcon(OBIcons.lock),
                  title: OBText(
                      _localizationService.drawer__useful_links_privacy_policy),
                  subtitle: OBSecondaryText(_localizationService
                      .drawer__useful_links_privacy_policy_desc),
                  onTap: () {
                    OpenbookProviderState openbookProvider =
                        OpenbookProvider.of(context);
                    openbookProvider.navigationService
                        .navigateToPrivacyPolicyPage(context: context);
                  },
                ),
                ListTile(
                  leading: const OBIcon(OBIcons.crewModerators),
                  title: OBText(
                      _localizationService.drawer__useful_links_terms_of_use),
                  subtitle: OBSecondaryText(_localizationService
                      .drawer__useful_links_terms_of_use_desc),
                  onTap: () {
                    OpenbookProviderState openbookProvider =
                        OpenbookProvider.of(context);
                    openbookProvider.navigationService
                        .navigateToTermsOfUsePage(context: context);
                  },
                ),
                /*ListTile(
                  leading: const OBIcon(OBIcons.dashboard),
                  title: OBText(_localizationService
                      .drawer__useful_links_guidelines_github),
                  subtitle: OBSecondaryText(_localizationService
                      .drawer__useful_links_guidelines_github_desc),
                  onTap: () {
                    urlLauncherService.launchUrl(
                        'https://github.com/orgs/SiuuOrg/projects/3');
                  },
                ),*/
                /*ListTile(
                  leading: const OBIcon(OBIcons.roadmap),
                  title: OBText(_localizationService
                      .drawer__useful_links_guidelines_roadmap),
                  subtitle: OBSecondaryText(_localizationService
                      .drawer__useful_links_guidelines_roadmap_desc),
                  onTap: () {
                    urlLauncherService.launchUrl('https://siuu.io/roadmap');
                  },
                ),*/
                /* ListTile(
                  leading: const OBIcon(OBIcons.featureRequest),
                  title: OBText(_localizationService
                      .drawer__useful_links_guidelines_feature_requests),
                  subtitle: OBSecondaryText(_localizationService
                      .drawer__useful_links_guidelines_feature_requests_desc),
                  onTap: () {
                    urlLauncherService
                        .launchUrl('https://siuu.fun/feature-requests');
                  },
                ),*/
                /* ListTile(
                  leading: const OBIcon(OBIcons.bug),
                  title: OBText(_localizationService
                      .drawer__useful_links_guidelines_bug_tracker),
                  subtitle: OBSecondaryText(_localizationService
                      .drawer__useful_links_guidelines_bug_tracker_desc),
                  onTap: () {
                    urlLauncherService.launchUrl('https://siuu.fun/bugs');
                  },
                ),*/
                ListTile(
                  leading: const OBIcon(OBIcons.guide),
                  title: OBText(_localizationService
                      .drawer__useful_links_guidelines_handbook),
                  subtitle: OBSecondaryText(_localizationService
                      .drawer__useful_links_guidelines_handbook_desc),
                  onTap: () {
                    urlLauncherService.launchUrl(
                        'https://siuu.fun/livre-blanc-white-paper-siuucoin/');
                  },
                ),
                /*ListTile(
                  leading: const OBIcon(OBIcons.slackChannel),
                  title: OBText(
                      _localizationService.drawer__useful_links_slack_channel),
                  subtitle: OBSecondaryText(_localizationService
                      .drawer__useful_links_slack_channel_desc),
                  onTap: () {
                    urlLauncherService.launchUrl(
                        'https://join.slack.com/t/Siuu/shared_invite/zt-5fzmpygy-V5nbMzmNJnEg5Hiwx4LO~w');
                  },
                ),*/
                ListTile(
                  leading: const OBIcon(OBIcons.support),
                  title:
                      OBText(_localizationService.drawer__useful_links_support),
                  subtitle: OBSecondaryText(
                      _localizationService.drawer__useful_links_support_desc),
                  onTap: () {
                    urlLauncherService
                        .launchUrl('https://siuu.fun/faq-foire-aux-questions/');
                  },
                )
              ],
            )),
          ],
        ),
      ),
    );
  }
}
