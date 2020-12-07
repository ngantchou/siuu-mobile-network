import 'dart:io';

import 'package:Siuu/services/httpie.dart';
import 'package:Siuu/services/string_template.dart';
import 'package:meta/meta.dart';

class CommunitiesApiService {
  HttpieService _httpService;
  StringTemplateService _stringTemplateService;

  String apiURL;

  static const SEARCH_COMMUNITIES_PATH = 'api/memories/search/';
  static const GET_TRENDING_COMMUNITIES_PATH = 'api/memories/trending/';
  static const GET_SUGGESTED_COMMUNITIES_PATH = 'api/memories/suggested/';
  static const GET_JOINED_COMMUNITIES_PATH = 'api/memories/joined/';
  static const SEARCH_JOINED_COMMUNITIES_PATH = 'api/memories/joined/search/';
  static const CHECK_COMMUNITY_NAME_PATH = 'api/memories/name-check/';
  static const CREATE_COMMUNITY_PATH = 'api/memories/';
  static const DELETE_COMMUNITY_PATH = 'api/memories/{memoryName}/';
  static const UPDATE_COMMUNITY_PATH = 'api/memories/{memoryName}/';
  static const GET_COMMUNITY_PATH = 'api/memories/{memoryName}/';
  static const REPORT_COMMUNITY_PATH = 'api/memories/{memoryName}/report/';
  static const JOIN_COMMUNITY_PATH = 'api/memories/{memoryName}/members/join/';
  static const LEAVE_COMMUNITY_PATH =
      'api/memories/{memoryName}/members/leave/';
  static const INVITE_USER_TO_COMMUNITY_PATH =
      'api/memories/{memoryName}/members/invite/';
  static const UNINVITE_USER_TO_COMMUNITY_PATH =
      'api/memories/{memoryName}/members/uninvite/';
  static const BAN_COMMUNITY_USER_PATH =
      'api/memories/{memoryName}/banned-users/ban/';
  static const UNBAN_COMMUNITY_USER_PATH =
      'api/memories/{memoryName}/banned-users/unban/';
  static const SEARCH_COMMUNITY_BANNED_USERS_PATH =
      'api/memories/{memoryName}/banned-users/search/';
  static const COMMUNITY_AVATAR_PATH = 'api/memories/{memoryName}/avatar/';
  static const COMMUNITY_COVER_PATH = 'api/memories/{memoryName}/cover/';
  static const SEARCH_COMMUNITY_PATH = 'api/memories/{memoryName}/search/';
  static const FAVORITE_COMMUNITY_PATH = 'api/memories/{memoryName}/favorite/';
  static const ENABLE_NEW_POST_NOTIFICATIONS_FOR_COMMUNITY_PATH =
      'api/memories/{memoryName}/notifications/subscribe/new-post/';
  static const GET_FAVORITE_COMMUNITIES_PATH = 'api/memories/favorites/';
  static const SEARCH_FAVORITE_COMMUNITIES_PATH =
      'api/memories/favorites/search/';
  static const GET_ADMINISTRATED_COMMUNITIES_PATH =
      'api/memories/administrated/';
  static const SEARCH_ADMINISTRATED_COMMUNITIES_PATH =
      'api/memories/administrated/search/';
  static const GET_MODERATED_COMMUNITIES_PATH = 'api/memories/moderated/';
  static const SEARCH_MODERATED_COMMUNITIES_PATH =
      'api/memories/moderated/search/';
  static const GET_COMMUNITY_POSTS_PATH = 'api/memories/{memoryName}/posts/';
  static const COUNT_COMMUNITY_POSTS_PATH =
      'api/memories/{memoryName}/posts/count/';
  static const CREATE_COMMUNITY_POST_PATH = 'api/memories/{memoryName}/posts/';
  static const CLOSED_COMMUNITY_POSTS_PATH =
      'api/memories/{memoryName}/posts/closed/';
  static const GET_COMMUNITY_MEMBERS_PATH =
      'api/memories/{memoryName}/members/';
  static const SEARCH_COMMUNITY_MEMBERS_PATH =
      'api/memories/{memoryName}/members/search/';
  static const GET_COMMUNITY_BANNED_USERS_PATH =
      'api/memories/{memoryName}/banned-users/';
  static const GET_COMMUNITY_ADMINISTRATORS_PATH =
      'api/memories/{memoryName}/administrators/';
  static const SEARCH_COMMUNITY_ADMINISTRATORS_PATH =
      'api/memories/{memoryName}/administrators/search/';
  static const ADD_COMMUNITY_ADMINISTRATOR_PATH =
      'api/memories/{memoryName}/administrators/';
  static const REMOVE_COMMUNITY_ADMINISTRATORS_PATH =
      'api/memories/{memoryName}/administrators/{username}/';
  static const GET_COMMUNITY_MODERATORS_PATH =
      'api/memories/{memoryName}/moderators/';
  static const SEARCH_COMMUNITY_MODERATORS_PATH =
      'api/memories/{memoryName}/moderators/search/';
  static const ADD_COMMUNITY_MODERATOR_PATH =
      'api/memories/{memoryName}/moderators/';
  static const REMOVE_COMMUNITY_MODERATORS_PATH =
      'api/memories/{memoryName}/moderators/{username}/';
  static const CREATE_COMMUNITY_POSTS_PATH = 'api/memories/{memoryName}/posts/';
  static const GET_COMMUNITY_MODERATED_OBJECTS_PATH =
      'api/memories/{memoryName}/moderated-objects/';

  void setHttpieService(HttpieService httpService) {
    _httpService = httpService;
  }

  void setStringTemplateService(StringTemplateService stringTemplateService) {
    _stringTemplateService = stringTemplateService;
  }

  void setApiURL(String newApiURL) {
    apiURL = newApiURL;
  }

  Future<HttpieResponse> checkNameIsAvailable({@required String name}) {
    return _httpService.postJSON('$apiURL$CHECK_COMMUNITY_NAME_PATH',
        body: {'name': name}, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getTrendingCommunities(
      {bool authenticatedRequest = true, String category}) {
    Map<String, dynamic> queryParams = {};

    if (category != null) queryParams['category'] = category;

    return _httpService.get('$apiURL$GET_TRENDING_COMMUNITIES_PATH',
        queryParameters: queryParams,
        appendAuthorizationToken: authenticatedRequest);
  }

  Future<HttpieResponse> getSuggestedCommunities(
      {bool authenticatedRequest = true}) {
    return _httpService.get('$apiURL$GET_SUGGESTED_COMMUNITIES_PATH',
        appendAuthorizationToken: authenticatedRequest);
  }

  Future<HttpieStreamedResponse> createPostForMemoryWithId(String memoryName,
      {String text, File image, File video, bool isDraft = false}) {
    Map<String, dynamic> body = {};

    if (image != null) {
      body['image'] = image;
    }

    if (video != null) {
      body['video'] = video;
    }

    if (isDraft != null) {
      body['is_draft'] = isDraft;
    }

    if (text != null && text.length > 0) {
      body['text'] = text;
    }

    String url = _makeCreateMemoryPost(memoryName);

    return _httpService.putMultiform(_makeApiUrl(url),
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getPostsForMemoryWithName(String memoryName,
      {int maxId, int count, bool authenticatedRequest = true}) {
    Map<String, dynamic> queryParams = {};

    if (count != null) queryParams['count'] = count;

    if (maxId != null) queryParams['max_id'] = maxId;

    String url = _makeGetMemoryPostsPath(memoryName);

    return _httpService.get(_makeApiUrl(url),
        queryParameters: queryParams,
        appendAuthorizationToken: authenticatedRequest);
  }

  Future<HttpieResponse> getPostsCountForMemoryWithName(String memoryName,
      {bool authenticatedRequest = true}) {
    String url = _makeGetPostsCountForMemoryWithNamePath(memoryName);

    return _httpService.get(_makeApiUrl(url),
        appendAuthorizationToken: authenticatedRequest);
  }

  Future<HttpieResponse> getClosedPostsForMemoryWithName(String memoryName,
      {int maxId, int count, bool authenticatedRequest = true}) {
    Map<String, dynamic> queryParams = {};

    if (count != null) queryParams['count'] = count;

    if (maxId != null) queryParams['max_id'] = maxId;

    String url = _makeClosedMemoryPostsPath(memoryName);

    return _httpService.get(_makeApiUrl(url),
        queryParameters: queryParams,
        appendAuthorizationToken: authenticatedRequest);
  }

  Future<HttpieResponse> searchCommunitiesWithQuery(
      {bool authenticatedRequest = true,
      @required String query,
      bool excludedFromProfilePosts}) {
    Map<String, dynamic> queryParams = {'query': query};

    if (excludedFromProfilePosts != null)
      queryParams['excluded_from_profile_posts'] = excludedFromProfilePosts;

    return _httpService.get('$apiURL$SEARCH_COMMUNITIES_PATH',
        queryParameters: queryParams,
        appendAuthorizationToken: authenticatedRequest);
  }

  Future<HttpieResponse> getMemoryWithName(String name,
      {bool authenticatedRequest = true}) {
    String url = _makeGetMemoryPath(name);
    return _httpService.get(_makeApiUrl(url),
        appendAuthorizationToken: authenticatedRequest,
        headers: {'Accept': 'application/json; version=1.0'});
  }

  Future<HttpieStreamedResponse> createMemory(
      {@required String name,
      @required String title,
      @required List<String> categories,
      @required String type,
      bool invitesEnabled,
      String color,
      String userAdjective,
      String usersAdjective,
      String description,
      String rules,
      File cover,
      File avatar}) {
    Map<String, dynamic> body = {
      'name': name,
      'title': title,
      'categories': categories,
      'type': type
    };

    if (avatar != null) {
      body['avatar'] = avatar;
    }

    if (cover != null) {
      body['cover'] = cover;
    }

    if (color != null) {
      body['color'] = color;
    }

    if (rules != null) {
      body['rules'] = rules;
    }

    if (description != null) {
      body['description'] = description;
    }

    if (userAdjective != null && userAdjective.isNotEmpty) {
      body['user_adjective'] = userAdjective;
    }

    if (usersAdjective != null && usersAdjective.isNotEmpty) {
      body['users_adjective'] = usersAdjective;
    }

    if (invitesEnabled != null) {
      body['invites_enabled'] = invitesEnabled;
    }

    return _httpService.putMultiform(_makeApiUrl(CREATE_COMMUNITY_PATH),
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieStreamedResponse> updateMemoryWithName(String memoryName,
      {String name,
      String title,
      List<String> categories,
      bool invitesEnabled,
      String type,
      String color,
      String userAdjective,
      String usersAdjective,
      String description,
      String rules}) {
    Map<String, dynamic> body = {};

    if (name != null) {
      body['name'] = name;
    }

    if (title != null) {
      body['title'] = title;
    }

    if (categories != null) {
      body['categories'] = categories;
    }

    if (type != null) {
      body['type'] = type;
    }

    if (invitesEnabled != null) {
      body['invites_enabled'] = invitesEnabled;
    }

    if (color != null) {
      body['color'] = color;
    }

    if (rules != null) {
      body['rules'] = rules;
    }

    if (description != null) {
      body['description'] = description;
    }

    if (userAdjective != null && userAdjective.isNotEmpty) {
      body['user_adjective'] = userAdjective;
    }

    if (usersAdjective != null && usersAdjective.isNotEmpty) {
      body['users_adjective'] = usersAdjective;
    }

    return _httpService.patchMultiform(
        _makeApiUrl(_makeUpdateMemoryPath(memoryName)),
        body: body,
        appendAuthorizationToken: true);
  }

  Future<HttpieStreamedResponse> updateAvatarForMemoryWithName(
      String memoryName,
      {File avatar}) {
    Map<String, dynamic> body = {'avatar': avatar};

    return _httpService.putMultiform(
        _makeApiUrl(_makeMemoryAvatarPath(memoryName)),
        body: body,
        appendAuthorizationToken: true);
  }

  Future<HttpieResponse> deleteAvatarForMemoryWithName(String memoryName) {
    return _httpService.delete(_makeApiUrl(_makeMemoryAvatarPath(memoryName)),
        appendAuthorizationToken: true);
  }

  Future<HttpieStreamedResponse> updateCoverForMemoryWithName(String memoryName,
      {File cover}) {
    Map<String, dynamic> body = {'cover': cover};

    return _httpService.putMultiform(
        _makeApiUrl(_makeMemoryCoverPath(memoryName)),
        body: body,
        appendAuthorizationToken: true);
  }

  Future<HttpieResponse> deleteCoverForMemoryWithName(String memoryName) {
    return _httpService.delete(_makeApiUrl(_makeMemoryCoverPath(memoryName)),
        appendAuthorizationToken: true);
  }

  Future<HttpieResponse> deleteMemoryWithName(String memoryName) {
    String path = _makeDeleteMemoryPath(memoryName);

    return _httpService.delete(_makeApiUrl(path),
        appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getMembersForMemoryWithId(String memoryName,
      {int count, int maxId, List<String> exclude}) {
    Map<String, dynamic> queryParams = {};
    if (count != null) queryParams['count'] = count;

    if (maxId != null) queryParams['max_id'] = maxId;

    if (exclude != null && exclude.isNotEmpty) queryParams['exclude'] = exclude;

    String path = _makeGetMemoryMembersPath(memoryName);

    return _httpService.get(_makeApiUrl(path),
        queryParameters: queryParams, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> searchMembers(
      {@required String memoryName,
      @required String query,
      List<String> exclude}) {
    Map<String, dynamic> queryParams = {'query': query};

    if (exclude != null && exclude.isNotEmpty) queryParams['exclude'] = exclude;

    String path = _makeSearchMemoryMembersPath(memoryName);

    return _httpService.get(_makeApiUrl(path),
        queryParameters: queryParams, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> inviteUserToMemory(
      {@required String memoryName, @required String username}) {
    Map<String, dynamic> body = {'username': username};
    String path = _makeInviteUserToMemoryPath(memoryName);
    return _httpService.post(_makeApiUrl(path),
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> uninviteUserFromMemory(
      {@required String memoryName, @required String username}) {
    Map<String, dynamic> body = {'username': username};
    String path = _makeUninviteUserToMemoryPath(memoryName);
    return _httpService.post(_makeApiUrl(path),
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getJoinedCommunities(
      {bool authenticatedRequest = true,
      int offset,
      bool excludedFromProfilePosts}) {
    Map<String, dynamic> queryParams = {'offset': offset};

    if (excludedFromProfilePosts != null)
      queryParams['excluded_from_profile_posts'] = excludedFromProfilePosts;

    return _httpService.get('$apiURL$GET_JOINED_COMMUNITIES_PATH',
        appendAuthorizationToken: authenticatedRequest,
        queryParameters: queryParams);
  }

  Future<HttpieResponse> searchJoinedCommunities({
    @required String query,
    int count,
  }) {
    Map<String, dynamic> queryParams = {'query': query};

    if (count != null) queryParams['count'] = count;

    return _httpService.get(_makeApiUrl('$SEARCH_JOINED_COMMUNITIES_PATH'),
        queryParameters: queryParams, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> joinMemoryWithId(String memoryName) {
    String path = _makeJoinMemoryPath(memoryName);
    return _httpService.post(_makeApiUrl(path), appendAuthorizationToken: true);
  }

  Future<HttpieResponse> leaveMemoryWithId(String memoryName) {
    String path = _makeLeaveMemoryPath(memoryName);
    return _httpService.post(_makeApiUrl(path), appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getModeratorsForMemoryWithId(String memoryName,
      {int count, int maxId}) {
    Map<String, dynamic> queryParams = {};
    if (count != null) queryParams['count'] = count;

    if (maxId != null) queryParams['max_id'] = maxId;

    String path = _makeGetMemoryModeratorsPath(memoryName);

    return _httpService.get(_makeApiUrl(path),
        queryParameters: queryParams, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> searchModerators({
    @required String memoryName,
    @required String query,
  }) {
    Map<String, dynamic> queryParams = {'query': query};

    String path = _makeSearchMemoryModeratorsPath(memoryName);

    return _httpService.get(_makeApiUrl(path),
        queryParameters: queryParams, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> addMemoryModerator(
      {@required String memoryName, @required String username}) {
    Map<String, dynamic> body = {'username': username};

    String path = _makeAddMemoryModeratorPath(memoryName);
    return _httpService.putJSON(_makeApiUrl(path),
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> removeMemoryModerator(
      {@required String memoryName, @required String username}) {
    String path = _makeRemoveMemoryModeratorPath(memoryName, username);
    return _httpService.delete(_makeApiUrl(path),
        appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getAdministratorsForMemoryWithName(String memoryName,
      {int count, int maxId}) {
    Map<String, dynamic> queryParams = {};
    if (count != null) queryParams['count'] = count;

    if (maxId != null) queryParams['max_id'] = maxId;

    String path = _makeGetMemoryAdministratorsPath(memoryName);

    return _httpService.get(_makeApiUrl(path),
        queryParameters: queryParams, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> searchAdministrators({
    @required String memoryName,
    @required String query,
  }) {
    Map<String, dynamic> queryParams = {'query': query};

    String path = _makeSearchMemoryAdministratorsPath(memoryName);

    return _httpService.get(_makeApiUrl(path),
        queryParameters: queryParams, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> addMemoryAdministrator(
      {@required String memoryName, @required String username}) {
    Map<String, dynamic> body = {'username': username};

    String path = _makeAddMemoryAdministratorPath(memoryName);
    return _httpService.putJSON(_makeApiUrl(path),
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> removeMemoryAdministrator(
      {@required String memoryName, @required String username}) {
    String path = _makeRemoveMemoryAdministratorPath(memoryName, username);
    return _httpService.delete(_makeApiUrl(path),
        appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getBannedUsersForMemoryWithId(String memoryName,
      {int count, int maxId}) {
    Map<String, dynamic> queryParams = {};
    if (count != null) queryParams['count'] = count;

    if (maxId != null) queryParams['max_id'] = maxId;

    String path = _makeGetMemoryBannedUsersPath(memoryName);

    return _httpService.get(_makeApiUrl(path),
        queryParameters: queryParams, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> searchBannedUsers({
    @required String memoryName,
    @required String query,
  }) {
    Map<String, dynamic> queryParams = {'query': query};

    String path = _makeSearchMemoryBannedUsersPath(memoryName);

    return _httpService.get(_makeApiUrl(path),
        queryParameters: queryParams, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> banMemoryUser(
      {@required String memoryName, @required String username}) {
    Map<String, dynamic> body = {'username': username};
    String path = _makeBanMemoryUserPath(memoryName);
    return _httpService.postJSON(_makeApiUrl(path),
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> unbanMemoryUser(
      {@required String memoryName, @required String username}) {
    Map<String, dynamic> body = {'username': username};
    String path = _makeUnbanMemoryUserPath(memoryName);
    return _httpService.post(_makeApiUrl(path),
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getFavoriteCommunities(
      {bool authenticatedRequest = true, int offset}) {
    return _httpService.get('$apiURL$GET_FAVORITE_COMMUNITIES_PATH',
        appendAuthorizationToken: authenticatedRequest,
        queryParameters: {'offset': offset});
  }

  Future<HttpieResponse> searchFavoriteCommunities(
      {@required String query, int count}) {
    Map<String, dynamic> queryParams = {'query': query};

    if (count != null) queryParams['count'] = count;

    return _httpService.get('$apiURL$SEARCH_FAVORITE_COMMUNITIES_PATH',
        queryParameters: queryParams, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> favoriteMemory({@required String memoryName}) {
    String path = _makeFavoriteMemoryPath(memoryName);
    return _httpService.putJSON(_makeApiUrl(path),
        appendAuthorizationToken: true);
  }

  Future<HttpieResponse> unfavoriteMemory({@required String memoryName}) {
    String path = _makeFavoriteMemoryPath(memoryName);
    return _httpService.delete(_makeApiUrl(path),
        appendAuthorizationToken: true);
  }

  Future<HttpieResponse> enableNewPostNotificationsForMemory(
      {@required String memoryName}) {
    String path = _makeEnableNewPostNotificationsForMemoryPath(memoryName);
    return _httpService.putJSON(_makeApiUrl(path),
        appendAuthorizationToken: true);
  }

  Future<HttpieResponse> disableNewPostNotificationsForMemory(
      {@required String memoryName}) {
    String path = _makeEnableNewPostNotificationsForMemoryPath(memoryName);
    return _httpService.delete(_makeApiUrl(path),
        appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getAdministratedCommunities(
      {bool authenticatedRequest = true, int offset}) {
    return _httpService.get('$apiURL$GET_ADMINISTRATED_COMMUNITIES_PATH',
        appendAuthorizationToken: authenticatedRequest,
        queryParameters: {'offset': offset});
  }

  Future<HttpieResponse> searchAdministratedCommunities(
      {@required String query, int count}) {
    Map<String, dynamic> queryParams = {'query': query};

    if (count != null) queryParams['count'] = count;

    return _httpService.get('$apiURL$SEARCH_ADMINISTRATED_COMMUNITIES_PATH',
        queryParameters: queryParams, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> searchModeratedCommunities(
      {@required String query, int count}) {
    Map<String, dynamic> queryParams = {'query': query};

    if (count != null) queryParams['count'] = count;

    return _httpService.get('$apiURL$SEARCH_MODERATED_COMMUNITIES_PATH',
        queryParameters: queryParams, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getModeratedCommunities(
      {bool authenticatedRequest = true, int offset}) {
    return _httpService.get('$apiURL$GET_MODERATED_COMMUNITIES_PATH',
        appendAuthorizationToken: authenticatedRequest,
        queryParameters: {'offset': offset});
  }

  Future<HttpieResponse> reportMemoryWithName(
      {@required String memoryName,
      @required int moderationCategoryId,
      String description}) {
    String path = _makeReportMemoryPath(memoryName);

    Map<String, dynamic> body = {
      'category_id': moderationCategoryId.toString()
    };

    if (description != null && description.isNotEmpty) {
      body['description'] = description;
    }

    return _httpService.post(_makeApiUrl(path),
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> getModeratedObjects({
    @required String memoryName,
    int count,
    int maxId,
    String type,
    bool verified,
    List<String> statuses,
    List<String> types,
  }) {
    Map<String, dynamic> queryParams = {};
    if (count != null) queryParams['count'] = count;

    if (maxId != null) queryParams['max_id'] = maxId;

    if (statuses != null) queryParams['statuses'] = statuses;
    if (types != null) queryParams['types'] = types;

    if (verified != null) queryParams['verified'] = verified;

    String path = _makeGetMemoryModeratedObjectsPath(memoryName);

    return _httpService.get(_makeApiUrl(path),
        queryParameters: queryParams, appendAuthorizationToken: true);
  }

  String _makeGetMemoryModeratedObjectsPath(String memoryName) {
    return _stringTemplateService.parse(
        GET_COMMUNITY_MODERATED_OBJECTS_PATH, {'memoryName': memoryName});
  }

  String _makeCreateMemoryPost(String memoryName) {
    return _stringTemplateService
        .parse(CREATE_COMMUNITY_POST_PATH, {'memoryName': memoryName});
  }

  String _makeReportMemoryPath(String memoryName) {
    return _stringTemplateService
        .parse(REPORT_COMMUNITY_PATH, {'memoryName': memoryName});
  }

  String _makeClosedMemoryPostsPath(String memoryName) {
    return _stringTemplateService
        .parse(CLOSED_COMMUNITY_POSTS_PATH, {'memoryName': memoryName});
  }

  String _makeInviteUserToMemoryPath(String memoryName) {
    return _stringTemplateService
        .parse(INVITE_USER_TO_COMMUNITY_PATH, {'memoryName': memoryName});
  }

  String _makeUninviteUserToMemoryPath(String memoryName) {
    return _stringTemplateService
        .parse(UNINVITE_USER_TO_COMMUNITY_PATH, {'memoryName': memoryName});
  }

  String _makeUnbanMemoryUserPath(String memoryName) {
    return _stringTemplateService
        .parse(UNBAN_COMMUNITY_USER_PATH, {'memoryName': memoryName});
  }

  String _makeBanMemoryUserPath(String memoryName) {
    return _stringTemplateService
        .parse(BAN_COMMUNITY_USER_PATH, {'memoryName': memoryName});
  }

  String _makeSearchMemoryBannedUsersPath(String memoryName) {
    return _stringTemplateService
        .parse(SEARCH_COMMUNITY_BANNED_USERS_PATH, {'memoryName': memoryName});
  }

  String _makeDeleteMemoryPath(String memoryName) {
    return _stringTemplateService
        .parse(DELETE_COMMUNITY_PATH, {'memoryName': memoryName});
  }

  String _makeGetMemoryPath(String memoryName) {
    return _stringTemplateService
        .parse(GET_COMMUNITY_PATH, {'memoryName': memoryName});
  }

  String _makeAddMemoryAdministratorPath(String memoryName) {
    return _stringTemplateService
        .parse(ADD_COMMUNITY_ADMINISTRATOR_PATH, {'memoryName': memoryName});
  }

  String _makeRemoveMemoryAdministratorPath(
      String memoryName, String username) {
    return _stringTemplateService.parse(REMOVE_COMMUNITY_ADMINISTRATORS_PATH,
        {'memoryName': memoryName, 'username': username});
  }

  String _makeAddMemoryModeratorPath(String memoryName) {
    return _stringTemplateService
        .parse(ADD_COMMUNITY_MODERATOR_PATH, {'memoryName': memoryName});
  }

  String _makeRemoveMemoryModeratorPath(String memoryName, String username) {
    return _stringTemplateService.parse(REMOVE_COMMUNITY_MODERATORS_PATH,
        {'memoryName': memoryName, 'username': username});
  }

  String _makeGetMemoryPostsPath(String memoryName) {
    return _stringTemplateService
        .parse(GET_COMMUNITY_POSTS_PATH, {'memoryName': memoryName});
  }

  String _makeGetPostsCountForMemoryWithNamePath(String memoryName) {
    return _stringTemplateService
        .parse(COUNT_COMMUNITY_POSTS_PATH, {'memoryName': memoryName});
  }

  String _makeFavoriteMemoryPath(String memoryName) {
    return _stringTemplateService
        .parse(FAVORITE_COMMUNITY_PATH, {'memoryName': memoryName});
  }

  String _makeEnableNewPostNotificationsForMemoryPath(String memoryName) {
    return _stringTemplateService.parse(
        ENABLE_NEW_POST_NOTIFICATIONS_FOR_COMMUNITY_PATH,
        {'memoryName': memoryName});
  }

  String _makeJoinMemoryPath(String memoryName) {
    return _stringTemplateService
        .parse(JOIN_COMMUNITY_PATH, {'memoryName': memoryName});
  }

  String _makeLeaveMemoryPath(String memoryName) {
    return _stringTemplateService
        .parse(LEAVE_COMMUNITY_PATH, {'memoryName': memoryName});
  }

  String _makeUpdateMemoryPath(String memoryName) {
    return _stringTemplateService
        .parse(UPDATE_COMMUNITY_PATH, {'memoryName': memoryName});
  }

  String _makeMemoryAvatarPath(String memoryName) {
    return _stringTemplateService
        .parse(COMMUNITY_AVATAR_PATH, {'memoryName': memoryName});
  }

  String _makeMemoryCoverPath(String memoryName) {
    return _stringTemplateService
        .parse(COMMUNITY_COVER_PATH, {'memoryName': memoryName});
  }

  String _makeGetMemoryMembersPath(String memoryName) {
    return _stringTemplateService
        .parse(GET_COMMUNITY_MEMBERS_PATH, {'memoryName': memoryName});
  }

  String _makeSearchMemoryMembersPath(String memoryName) {
    return _stringTemplateService
        .parse(SEARCH_COMMUNITY_MEMBERS_PATH, {'memoryName': memoryName});
  }

  String _makeGetMemoryBannedUsersPath(String memoryName) {
    return _stringTemplateService
        .parse(GET_COMMUNITY_BANNED_USERS_PATH, {'memoryName': memoryName});
  }

  String _makeGetMemoryAdministratorsPath(String memoryName) {
    return _stringTemplateService
        .parse(GET_COMMUNITY_ADMINISTRATORS_PATH, {'memoryName': memoryName});
  }

  String _makeSearchMemoryAdministratorsPath(String memoryName) {
    return _stringTemplateService.parse(
        SEARCH_COMMUNITY_ADMINISTRATORS_PATH, {'memoryName': memoryName});
  }

  String _makeGetMemoryModeratorsPath(String memoryName) {
    return _stringTemplateService
        .parse(GET_COMMUNITY_MODERATORS_PATH, {'memoryName': memoryName});
  }

  String _makeSearchMemoryModeratorsPath(String memoryName) {
    return _stringTemplateService
        .parse(SEARCH_COMMUNITY_MODERATORS_PATH, {'memoryName': memoryName});
  }

  String _makeApiUrl(String string) {
    return '$apiURL$string';
  }
}
