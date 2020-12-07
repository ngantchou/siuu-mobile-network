import 'package:Siuu/services/httpie.dart';

class DocumentsService {
  HttpieService _httpService;

  static const guidelinesUrl =
      'https://about.siuu.io/docs/COMMUNITY_GUIDELINES.md';
  static const privacyPolicyUrl =
      'https://about.siuu.io/docs/PRIVACY_POLICY.md';
  static const termsOfUsePolicyUrl =
      'https://about.siuu.io/docs/TERMS_OF_USE.md';

  // Cache
  String _memoryGuidelines = '';
  String _termsOfUse = '';
  String _privacyPolicy = '';

  void preload() {
    getMemoryGuidelines();
    getPrivacyPolicy();
    getTermsOfUse();
  }

  void setHttpService(HttpieService httpService) {
    _httpService = httpService;
  }

  Future<String> getMemoryGuidelines() async {
    if (_memoryGuidelines.isNotEmpty) return _memoryGuidelines;
    HttpieResponse response = await _httpService.get(guidelinesUrl);
    _memoryGuidelines = response.body;
    return _memoryGuidelines;
  }

  Future<String> getPrivacyPolicy() async {
    if (_privacyPolicy.isNotEmpty) return _privacyPolicy;

    HttpieResponse response = await _httpService.get(privacyPolicyUrl);
    _privacyPolicy = response.body;
    return _privacyPolicy;
  }

  Future<String> getTermsOfUse() async {
    if (_termsOfUse.isNotEmpty) return _termsOfUse;

    HttpieResponse response = await _httpService.get(termsOfUsePolicyUrl);
    _termsOfUse = response.body;
    return _termsOfUse;
  }
}
