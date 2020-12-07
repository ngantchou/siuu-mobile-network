import 'package:Siuu/pages/auth/create_account/blocs/create_account.dart';
import 'package:Siuu/plugins/proxy_settings.dart';
import 'package:Siuu/services/auth_api.dart';
import 'package:Siuu/services/bottom_sheet.dart';
import 'package:Siuu/services/categories_api.dart';
import 'package:Siuu/services/communities_api.dart';
import 'package:Siuu/services/connections_circles_api.dart';
import 'package:Siuu/services/connections_api.dart';
import 'package:Siuu/services/connectivity.dart';
import 'package:Siuu/services/date_picker.dart';
import 'package:Siuu/services/devices_api.dart';
import 'package:Siuu/services/dialog.dart';
import 'package:Siuu/services/documents.dart';
import 'package:Siuu/services/draft.dart';
import 'package:Siuu/services/explore_timeline_preferences.dart';
import 'package:Siuu/services/hashtags_api.dart';
import 'package:Siuu/services/intercom.dart';
import 'package:Siuu/services/moderation_api.dart';
import 'package:Siuu/services/media/media.dart';
import 'package:Siuu/services/notifications_api.dart';
import 'package:Siuu/services/permissions.dart';
import 'package:Siuu/services/push_notifications/push_notifications.dart';
import 'package:Siuu/services/share.dart';
import 'package:Siuu/services/text_autocompletion.dart';
import 'package:Siuu/services/universal_links/universal_links.dart';
import 'package:Siuu/services/emoji_picker.dart';
import 'package:Siuu/services/emojis_api.dart';
import 'package:Siuu/services/environment_loader.dart';
import 'package:Siuu/services/follows_api.dart';
import 'package:Siuu/services/httpie.dart';
import 'package:Siuu/services/follows_lists_api.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/modal_service.dart';
import 'package:Siuu/services/navigation_service.dart';
import 'package:Siuu/services/posts_api.dart';
import 'package:Siuu/services/storage.dart';
import 'package:Siuu/services/string_template.dart';
import 'package:Siuu/services/theme.dart';
import 'package:Siuu/services/theme_value_parser.dart';
import 'package:Siuu/services/toast.dart';
import 'package:Siuu/services/url_launcher.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/services/user_invites_api.dart';
import 'package:Siuu/services/user_preferences.dart';
import 'package:Siuu/services/utils_service.dart';
import 'package:Siuu/services/validation.dart';
import 'package:Siuu/services/waitlist_service.dart';
import 'package:flutter/material.dart';
import 'package:sentry/sentry.dart';

// TODO Waiting for dependency injection support
// https://github.com/flutter/flutter/issues/21980

class OpenbookProvider extends StatefulWidget {
  final Widget child;

  const OpenbookProvider({Key key, @required this.child}) : super(key: key);

  @override
  OpenbookProviderState createState() {
    return OpenbookProviderState();
  }

  static OpenbookProviderState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_OpenbookProvider)
            as _OpenbookProvider)
        .data;
  }
}

class OpenbookProviderState extends State<OpenbookProvider> {
  UserPreferencesService userPreferencesService = UserPreferencesService();
  ExploreTimelinePreferencesService exploreTimelinePreferencesService =
      ExploreTimelinePreferencesService();
  CreateAccountBloc createAccountBloc = CreateAccountBloc();
  ValidationService validationService = ValidationService();
  HttpieService httpService = HttpieService();
  AuthApiService authApiService = AuthApiService();
  PostsApiService postsApiService = PostsApiService();
  StorageService storageService = StorageService();
  UserService userService = UserService();
  ModerationApiService moderationApiService = ModerationApiService();
  ToastService toastService = ToastService();
  StringTemplateService stringTemplateService = StringTemplateService();
  EmojisApiService emojisApiService = EmojisApiService();
  ThemeService themeService = ThemeService();
  MediaService mediaService = MediaService();
  ShareService shareService = ShareService();
  DatePickerService datePickerService = DatePickerService();
  EmojiPickerService emojiPickerService = EmojiPickerService();
  FollowsApiService followsApiService = FollowsApiService();
  PermissionsService permissionService = PermissionsService();
  CommunitiesApiService memoriesApiService = CommunitiesApiService();
  HashtagsApiService hashtagsApiService = HashtagsApiService();
  CategoriesApiService categoriesApiService = CategoriesApiService();
  NotificationsApiService notificationsApiService = NotificationsApiService();
  DevicesApiService devicesApiService = DevicesApiService();
  ConnectionsApiService connectionsApiService = ConnectionsApiService();
  ConnectionsCirclesApiService connectionsCirclesApiService =
      ConnectionsCirclesApiService();
  FollowsListsApiService followsListsApiService = FollowsListsApiService();
  UserInvitesApiService userInvitesApiService = UserInvitesApiService();
  ThemeValueParserService themeValueParserService = ThemeValueParserService();
  ModalService modalService = ModalService();
  NavigationService navigationService = NavigationService();
  WaitlistApiService waitlistApiService = WaitlistApiService();

  LocalizationService localizationService;
  UniversalLinksService universalLinksService = UniversalLinksService();
  BottomSheetService bottomSheetService = BottomSheetService();
  PushNotificationsService pushNotificationsService =
      PushNotificationsService();
  UrlLauncherService urlLauncherService = UrlLauncherService();
  IntercomService intercomService = IntercomService();
  DialogService dialogService = DialogService();
  UtilsService utilsService = UtilsService();
  DocumentsService documentsService = DocumentsService();
  TextAutocompletionService textAccountAutocompletionService =
      TextAutocompletionService();
  ConnectivityService connectivityService = ConnectivityService();
  DraftService draftService = DraftService();

  SentryClient sentryClient;

  @override
  void initState() {
    super.initState();
    initAsyncState();
    imageCache.maximumSize = 200 << 20; // 200MB
    userPreferencesService.setStorageService(storageService);
    userPreferencesService.setConnectivityService(connectivityService);
    exploreTimelinePreferencesService.setStorageService(storageService);
    connectionsCirclesApiService.setHttpService(httpService);
    httpService.setUtilsService(utilsService);
    connectionsCirclesApiService
        .setStringTemplateService(stringTemplateService);
    memoriesApiService.setHttpieService(httpService);
    memoriesApiService.setStringTemplateService(stringTemplateService);
    followsListsApiService.setHttpService(httpService);
    followsListsApiService.setStringTemplateService(stringTemplateService);
    userInvitesApiService.setHttpService(httpService);
    userInvitesApiService.setStringTemplateService(stringTemplateService);
    connectionsApiService.setHttpService(httpService);
    authApiService.setHttpService(httpService);
    authApiService.setStringTemplateService(stringTemplateService);
    followsApiService.setHttpService(httpService);
    createAccountBloc.setAuthApiService(authApiService);
    createAccountBloc.setUserService(userService);
    userService.setAuthApiService(authApiService);
    userService.setHashtagsApiService(hashtagsApiService);
    userService.setPushNotificationsService(pushNotificationsService);
    userService.setIntercomService(intercomService);
    userService.setPostsApiService(postsApiService);
    userService.setEmojisApiService(emojisApiService);
    userService.setHttpieService(httpService);
    userService.setStorageService(storageService);
    userService.setUserInvitesApiService(userInvitesApiService);
    userService.setFollowsApiService(followsApiService);
    userService.setFollowsListsApiService(followsListsApiService);
    userService.setConnectionsApiService(connectionsApiService);
    userService.setConnectionsCirclesApiService(connectionsCirclesApiService);
    userService.setCommunitiesApiService(memoriesApiService);
    userService.setCategoriesApiService(categoriesApiService);
    userService.setNotificationsApiService(notificationsApiService);
    userService.setDevicesApiService(devicesApiService);
    userService.setCreateAccountBlocService(createAccountBloc);
    userService.setWaitlistApiService(waitlistApiService);
    userService.setDraftService(draftService);
    waitlistApiService.setHttpService(httpService);
    userService.setModerationApiService(moderationApiService);
    emojisApiService.setHttpService(httpService);
    categoriesApiService.setHttpService(httpService);
    postsApiService.setHttpieService(httpService);
    postsApiService.setStringTemplateService(stringTemplateService);
    notificationsApiService.setHttpService(httpService);
    notificationsApiService.setStringTemplateService(stringTemplateService);
    devicesApiService.setHttpService(httpService);
    devicesApiService.setStringTemplateService(stringTemplateService);
    validationService.setAuthApiService(authApiService);
    validationService.setUtilsService(utilsService);
    validationService.setFollowsListsApiService(followsListsApiService);
    validationService.setCommunitiesApiService(memoriesApiService);
    validationService
        .setConnectionsCirclesApiService(connectionsCirclesApiService);
    themeService.setStorageService(storageService);
    themeService.setUtilsService(utilsService);
    pushNotificationsService.setUserService(userService);
    pushNotificationsService.setStorageService(storageService);
    intercomService.setUserService(userService);
    dialogService.setThemeService(themeService);
    dialogService.setThemeValueParserService(themeValueParserService);
    mediaService.setValidationService(validationService);
    mediaService.setBottomSheetService(bottomSheetService);
    mediaService.setPermissionsService(permissionService);
    mediaService.setUtilsService(utilsService);
    documentsService.setHttpService(httpService);
    moderationApiService.setStringTemplateService(stringTemplateService);
    moderationApiService.setHttpieService(httpService);
    shareService.setMediaService(mediaService);
    shareService.setToastService(toastService);
    shareService.setValidationService(validationService);
    permissionService.setToastService(toastService);
    hashtagsApiService.setHttpieService(httpService);
    hashtagsApiService.setStringTemplateService(stringTemplateService);
    textAccountAutocompletionService.setValidationService(validationService);
  }

  void initAsyncState() async {
    Environment environment =
        await EnvironmentLoader(environmentPath: ".env.json").load();
    httpService.setMagicHeader(
        environment.magicHeaderName, environment.magicHeaderValue);
    httpService
        .setProxy(await ProxySettings.findProxy(Uri.parse(environment.apiUrl)));
    authApiService.setApiURL(environment.apiUrl);
    postsApiService.setApiURL(environment.apiUrl);
    emojisApiService.setApiURL(environment.apiUrl);
    userInvitesApiService.setApiURL(environment.apiUrl);
    followsApiService.setApiURL(environment.apiUrl);
    moderationApiService.setApiURL(environment.apiUrl);
    connectionsApiService.setApiURL(environment.apiUrl);
    connectionsCirclesApiService.setApiURL(environment.apiUrl);
    followsListsApiService.setApiURL(environment.apiUrl);
    memoriesApiService.setApiURL(environment.apiUrl);
    hashtagsApiService.setApiURL(environment.apiUrl);
    categoriesApiService.setApiURL(environment.apiUrl);
    notificationsApiService.setApiURL(environment.apiUrl);
    devicesApiService.setApiURL(environment.apiUrl);
    waitlistApiService
        .setOpenbookSocialApiURL(environment.openbookSocialApiUrl);
    intercomService.bootstrap(
        iosApiKey: environment.intercomIosKey,
        androidApiKey: environment.intercomAndroidKey,
        appId: environment.intercomAppId);
    sentryClient = SentryClient(dsn: environment.sentryDsn);
    utilsService.setTrustedProxyUrl(environment.linkPreviewsTrustedProxyUrl);

    await connectivityService.bootstrap();
    documentsService.preload();
    userPreferencesService.bootstrap();
  }

  @override
  Widget build(BuildContext context) {
    return new _OpenbookProvider(
      data: this,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    super.dispose();
    universalLinksService.dispose();
    pushNotificationsService.dispose();
    connectivityService.dispose();
    userPreferencesService.dispose();
  }

  setLocalizationService(LocalizationService newLocalizationService) {
    localizationService = newLocalizationService;
    createAccountBloc.setLocalizationService(localizationService);
    httpService.setLocalizationService(localizationService);
    userService.setLocalizationsService(localizationService);
    modalService.setLocalizationService(localizationService);
    userPreferencesService.setLocalizationService(localizationService);
    shareService.setLocalizationService(localizationService);
    mediaService.setLocalizationService(localizationService);
    permissionService.setLocalizationService(localizationService);
  }

  setValidationService(ValidationService newValidationService) {
    validationService = newValidationService;
  }
}

class _OpenbookProvider extends InheritedWidget {
  final OpenbookProviderState data;

  _OpenbookProvider({Key key, this.data, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_OpenbookProvider old) {
    return true;
  }
}
