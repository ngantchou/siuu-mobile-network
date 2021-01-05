import 'package:Siuu/custom/CustomAuthScreens/text/CustomTextinAuthScreens.dart';
import 'package:Siuu/models/user_invite.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/pages/auth/create_account/blocs/create_account.dart';
import 'package:Siuu/res/colors.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/toast.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/services/user_invites_api.dart';
import 'package:Siuu/services/validation.dart';
import 'package:Siuu/widgets/buttons/button.dart';
import 'package:Siuu/widgets/buttons/success_button.dart';
import 'package:Siuu/widgets/buttons/secondary_button.dart';
import 'package:Siuu/pages/auth/create_account/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

class OBAuthNameStepPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OBAuthNameStepPageState();
  }
}

class OBAuthNameStepPageState extends State<OBAuthNameStepPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CreateAccountBloc _createAccountBloc;
  LocalizationService _localizationService;
  ValidationService _validationService;
  ToastService _toastService;
  UserInvitesApiService userInvitesApiService;
  UserService _userService;

  bool _emailCheckInProgress;
  bool _emailTaken;
  bool _usernameCheckInProgress;
  bool _usernameTaken;
  bool passwordIsVisible;
  String token;
  static const passwordMaxLength = ValidationService.PASSWORD_MAX_LENGTH;
  static const passwordMinLength = ValidationService.PASSWORD_MIN_LENGTH;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    _usernameCheckInProgress = false;
    passwordIsVisible = false;
    _emailCheckInProgress = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _localizationService = openbookProvider.localizationService;
    _createAccountBloc = openbookProvider.createAccountBloc;
    _validationService = openbookProvider.validationService;
    _toastService = openbookProvider.toastService;
    _userService = openbookProvider.userService;

    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: height * 0.043),
                        Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Siuu",
                                style: TextStyle(
                                  fontFamily: "Gabriola",
                                  fontSize: 27,
                                  color: Color(0xff4d0cbb),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  "Rejoindre notre communauté",
                                  style: TextStyle(
                                    fontFamily: "Segoe UI",
                                    fontSize: 11,
                                    color: Color(0xff4d0cbb),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: height * 0.117),
                        SizedBox(
                          height: height * 0.117,
                          width: width * 0.243,
                          child: Image.asset(
                            'assets/images/Siu.png',
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        SizedBox(height: height * 0.043),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomTextAuthScreens(
                                'Vous avez déjà un compte ? '),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed('/auth');
                              },
                              child: CustomTextAuthScreens('Se connecter'),
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.029),
                        _buildNameForm(width, height),
                        SizedBox(height: height * 0.029),
                        _buildUsernameForm(width, height),
                        SizedBox(height: height * 0.029),
                        _buildEmailForm(width, height),
                        SizedBox(height: height * 0.029),
                        _buildPasswordForm(width, height),
                        SizedBox(height: height * 0.043),
                        GestureDetector(
                            child: CustomTextAuthScreens(
                                'By registering, you are agreeing\nto our Terms of Service'),
                            onTap: () {
                              Navigator.pushNamed(context, '/auth/legal_step');
                            }),
                      ],
                    )))),
      ),
      backgroundColor: Pigment.fromString('#FFFFFF'),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0.0,
        child: Padding(
          padding: EdgeInsets.only(
              bottom: 20.0 + MediaQuery.of(context).viewInsets.bottom,
              top: 20.0,
              left: 20.0,
              right: 20.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: _buildPreviousButton(context: context),
              ),
              Expanded(child: _buildNextButton()),
              SizedBox(height: height * 0.043),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    String buttonText = _localizationService.trans('auth__create_acc__next');
    return OBSuccessButton(
      minWidth: double.infinity,
      size: OBButtonSize.large,
      child: Text(buttonText, style: TextStyle(fontSize: 18.0)),
      onPressed: onPressedNextStep,
    );
  }

  bool _validateForm() {
    return _formKey.currentState.validate();
  }

  void _setEmailTaken(bool isEmailTaken) {
    setState(() {
      _emailTaken = isEmailTaken;
    });
  }

  void _setUsernameTaken(bool isUsernameTaken) {
    setState(() {
      _usernameTaken = isUsernameTaken;
    });
  }

  void onPressedNextStep() async {
    await _checkEmailAvailable(_emailController.text.trim(), context);
    await _checkUsernameAvailable(_usernameController.text.trim(), context);

    bool isNameValid = _validateForm();
    if (isNameValid) {
      UserInvite createdUserInvite = await _userService.createUserInvite(
          nickname: _usernameController.text.trim());
      setState(() {
        _createAccountBloc.setName(_nameController.text);
        _createAccountBloc.setPassword(_passwordController.text);
        _createAccountBloc.setUsername(_usernameController.text.trim());
        _createAccountBloc.setEmail(_emailController.text.trim());
        _createAccountBloc.setToken(createdUserInvite.token);
        //Navigator.pushNamed(context, '/auth/legal_step');
        // Navigator.pushNamed(context, '/auth/accept_step');
        _createAccountBloc.setLegalAgeConfirmation(true);
        Navigator.pushNamed(context, '/auth/submit_step');
      });
    }
  }

  Future<bool> _checkEmailAvailable(String email, BuildContext context) async {
    _setEmailCheckInProgress(true);
    bool isEmailTaken = false;
    try {
      isEmailTaken = await _validationService.isEmailTaken(email);
      _setEmailTaken(isEmailTaken);
    } catch (error) {
      String errorFeedback =
          _localizationService.trans('auth__create_acc__email_server_error');
      _toastService.error(message: errorFeedback, context: context);
    } finally {
      _setEmailCheckInProgress(false);
    }
    return isEmailTaken;
  }

  Future<bool> _checkUsernameAvailable(
      String username, BuildContext context) async {
    _setUsernameCheckInProgress(true);
    bool isUsernameTaken = false;
    try {
      isUsernameTaken = await _validationService.isUsernameTaken(username);
      _setUsernameTaken(isUsernameTaken);
    } catch (error) {
      String errorFeedback =
          _localizationService.auth__create_acc__username_server_error;
      _toastService.error(message: errorFeedback, context: context);
    } finally {
      _setUsernameCheckInProgress(false);
    }
    return isUsernameTaken;
  }

  Widget _buildPreviousButton({@required BuildContext context}) {
    String buttonText =
        _localizationService.trans('auth__create_acc__previous');

    return OBSecondaryButton(
      isFullWidth: true,
      isLarge: true,
      child: Row(
        children: <Widget>[
          Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          const SizedBox(
            width: 10.0,
          ),
          Text(
            buttonText,
            style: TextStyle(fontSize: 18.0, color: Colors.black),
          )
        ],
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  Widget _buildUsernameForm(double width, double height) {
    String usernameInputPlaceholder =
        _localizationService.auth__create_acc__username_placeholder;
    String errorUsernameTaken =
        _localizationService.auth__create_acc__username_taken_error;

    return Row(children: <Widget>[
      new Expanded(
        child: Container(
          color: Colors.transparent,
          child: TextFormField(
            //hintText: usernameInputPlaceholder,
            validator: (String username) {
              String validateUsernameResult =
                  _validationService.validateUserUsername(username.trim());
              if (validateUsernameResult != null) return validateUsernameResult;
              if (_usernameTaken != null && _usernameTaken) {
                return errorUsernameTaken.replaceFirst('%s', username);
              }
            },
            controller: _usernameController,
            cursorColor: Color(purpleColor),
            obscureText: false,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: "Pseudo",
              hintStyle: TextStyle(
                fontFamily: "SF Pro Display",
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xff4d0cbb),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(48.0)),
                borderSide: BorderSide(
                    width: width * 0.004, color: Color(greyishColor)),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(48.0)),
                borderSide: BorderSide(
                    width: width * 0.004, color: Color(greyishColor)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(48.0)),
                borderSide: BorderSide(
                    width: width * 0.004, color: Color(greyishColor)),
              ),
            ),
          ),
        ),
      ),
    ]);
  }

  Widget _buildEmailForm(double width, double height) {
    String emailInputPlaceholder =
        _localizationService.trans('auth__create_acc__email_placeholder');
    String errorEmailTaken =
        _localizationService.trans('auth__create_acc__email_taken_error');

    return Row(children: <Widget>[
      new Expanded(
        child: Container(
          color: Colors.transparent,
          child: TextFormField(
            validator: (String email) {
              String validateEMail =
                  _validationService.validateUserEmail(email.trim());
              if (validateEMail != null) return validateEMail;
              if (_emailTaken != null && _emailTaken) {
                return errorEmailTaken;
              }
            },
            controller: _emailController,
            cursorColor: Color(purpleColor),
            obscureText: false,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: emailInputPlaceholder,
              hintStyle: TextStyle(
                fontFamily: "SF Pro Display",
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xff4d0cbb),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(48.0)),
                borderSide: BorderSide(
                    width: width * 0.004, color: Color(greyishColor)),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(48.0)),
                borderSide: BorderSide(
                    width: width * 0.004, color: Color(greyishColor)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(48.0)),
                borderSide: BorderSide(
                    width: width * 0.004, color: Color(greyishColor)),
              ),
            ),
          ),
        ),
      ),
    ]);
  }

  Widget _buildNameForm(double width, double height) {
    String nameInputPlaceholder =
        _localizationService.trans('auth__create_acc__name_placeholder');

    return Row(children: <Widget>[
      new Expanded(
        child: Container(
          color: Colors.transparent,
          child: TextFormField(
            validator: (String name) {
              String validateName =
                  _validationService.validateUserProfileName(name);
              if (validateName != null) return validateName;
            },
            controller: _nameController,
            cursorColor: Color(purpleColor),
            obscureText: false,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText: "Name",
              hintStyle: TextStyle(
                fontFamily: "SF Pro Display",
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xff4d0cbb),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(48.0)),
                borderSide: BorderSide(
                    width: width * 0.004, color: Color(greyishColor)),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(48.0)),
                borderSide: BorderSide(
                    width: width * 0.004, color: Color(greyishColor)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(48.0)),
                borderSide: BorderSide(
                    width: width * 0.004, color: Color(greyishColor)),
              ),
            ),
          ),
        ),
      ),
    ]);
  }

  Widget _buildPasswordForm(double width, double height) {
    return Row(children: <Widget>[
      new Expanded(
        child: Container(
          color: Colors.transparent,
          child: TextFormField(
            autocorrect: false,
            obscureText: !passwordIsVisible,
            validator: (String password) {
              String validatePassword =
                  _validationService.validateUserPassword(password);
              if (validatePassword != null) return validatePassword;
            },
            controller: _passwordController,
            cursorColor: Color(purpleColor),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              suffixIcon: GestureDetector(
                child: Icon(passwordIsVisible
                    ? Icons.visibility_off
                    : Icons.visibility),
                onTap: () {
                  _togglePasswordVisibility();
                },
              ),
              hintText: "Password",
              hintStyle: TextStyle(
                fontFamily: "SF Pro Display",
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xff4d0cbb),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(48.0)),
                borderSide: BorderSide(
                    width: width * 0.004, color: Color(greyishColor)),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(48.0)),
                borderSide: BorderSide(
                    width: width * 0.004, color: Color(greyishColor)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(48.0)),
                borderSide: BorderSide(
                    width: width * 0.004, color: Color(greyishColor)),
              ),
            ),
          ),
        ),
      ),
    ]);
  }

  void _setEmailCheckInProgress(bool newEmailCheckInProgress) {
    setState(() {
      _emailCheckInProgress = newEmailCheckInProgress;
    });
  }

  void _setUsernameCheckInProgress(bool newUsernameCheckInProgress) {
    setState(() {
      _usernameCheckInProgress = newUsernameCheckInProgress;
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      passwordIsVisible = !passwordIsVisible;
    });
  }
}
