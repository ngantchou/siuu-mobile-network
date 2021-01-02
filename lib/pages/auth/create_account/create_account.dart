import 'package:Siuu/auth/OTPVerificationScreen.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/pages/auth/create_account/blocs/create_account.dart';
import 'package:Siuu/services/auth_api.dart';
import 'package:Siuu/services/httpie.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/toast.dart';
import 'package:Siuu/services/validation.dart';
import 'package:Siuu/widgets/buttons/button.dart';
import 'package:Siuu/widgets/buttons/success_button.dart';
import 'package:Siuu/widgets/buttons/secondary_button.dart';
import 'package:Siuu/pages/auth/create_account/widgets/auth_text_field.dart';
import 'package:Siuu/widgets/country_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:flutter/services.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';

class OBAuthCreateAccountPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OBAuthCreateAccountPageState();
  }
}

class OBAuthCreateAccountPageState extends State<OBAuthCreateAccountPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  CreateAccountBloc _createAccountBloc;
  LocalizationService _localizationService;
  ValidationService _validationService;
  ToastService _toastService;
  AuthApiService _authApiService;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationId;
  String smsOTP;
  TextEditingController _linkController = TextEditingController();
  //final SmsAutoFill _autoFill = SmsAutoFill();
  bool _tokenIsInvalid;
  bool _tokenValidationInProgress;
  User firebaseUser;
  String actualCode;
  CancelableOperation _tokenValidationOperation;

  @override
  void initState() {
    super.initState();
    _tokenIsInvalid = false;
    _tokenValidationInProgress = false;
    _linkController.addListener(_onLinkChanged);
  }

  @override
  void dispose() {
    super.dispose();
    _linkController.removeListener(_onLinkChanged);
    _tokenValidationOperation?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _localizationService = openbookProvider.localizationService;
    _validationService = openbookProvider.validationService;
    _createAccountBloc = openbookProvider.createAccountBloc;
    _toastService = openbookProvider.toastService;
    _authApiService = openbookProvider.authApiService;

    return Scaffold(
      //  key: _scaffoldKey,
      body: Center(
        child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  children: <Widget>[
                    _buildFormField(context),
                    //OTPVerificationScreen(),
                    /*_buildPasteRegisterLink(context: context),
                    const SizedBox(
                      height: 20.0,
                    ),
                    _buildLinkForm(),*/
                    const SizedBox(height: 20.0),
                    // _buildRequestInvite(context: context)
                  ],
                ))),
      ),
      //backgroundColor: Colors.indigoAccent,
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
              Expanded(child: _buildNextButton(context)),
            ],
          ),
        ),
      ),
    );
  }

  bool _validateForm() {
    return _formKey.currentState.validate();
  }

  void onPressedNextStep(BuildContext context) async {
    bool isFormValid = await _validateForm();
    FirebaseFirestore.instance
        .collection('users')
        .where("phone",
            isEqualTo: '$_dialCode${_contactEditingController.text}')
        .get()
        .then((QuerySnapshot documentSnapshot) async {
      if (documentSnapshot.size > 0) {
        print('Document exists on the database');
        isFormValid = false;
      }
    });
    if (isFormValid) {
      setState(() {
        //var token = _getTokenFromLink(_linkController.text.trim());
        _createAccountBloc
            .setPhone('$_dialCode${_contactEditingController.text}');
      });
      print('$_dialCode${_contactEditingController.text}');

      await sendVerificationCode('$_dialCode${_contactEditingController.text}');
      // Navigator.pushNamed(context, '/auth/phone-verification');
    }
  }

  Future<void> sendVerificationCode(String phone) async {
    //print("phone to verify is $phone");
    //showAlertDialog(context);

    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: phone,
          codeAutoRetrievalTimeout: (String verId) {
            verificationId = verId;
          },
          codeSent: (String verificationId, [int forceCodeResend]) async {
            // Update the UI - wait for the user to enter the SMS code
            showAlertDialog(context);

            // Create a PhoneAuthCredential with the code
            PhoneAuthCredential phoneAuthCredential =
                PhoneAuthProvider.credential(
                    verificationId: verificationId, smsCode: smsOTP);

            // Sign the user in (or link) with the credential
            await _auth.signInWithCredential(phoneAuthCredential);
            Navigator.pushReplacementNamed(context, '/auth/name_step');
          },
          timeout: const Duration(seconds: 60),
          verificationCompleted: (AuthCredential phoneAuthCredential) async {
            print("phone to verify is succes");
            // Sign the user in (or link) with the auto-generated credential
            await _auth.signInWithCredential(phoneAuthCredential);
            Navigator.pushReplacementNamed(context, '/auth/name_step');
          },
          verificationFailed: (FirebaseAuthException exception) {
            if (exception.code == 'invalid-phone-number') {
              print('The provided phone number is not valid.');
            }
          });
    } catch (e) {
      //handleError(e as PlatformException);
      print("erreur de génération du code $e");
    }
  }

  //Basic alert dialogue for alert errors and confirmations
  void showAlertDialog(BuildContext context) {
    // set up the AlertDialog
    final AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      contentPadding: EdgeInsets.only(top: 10.0),
      title: const Text('code'),
      content: Container(
        child: PinEntryTextField(
          fields: 6,
          onSubmit: (text) {
            smsOTP = text as String;
          },
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: const Text('Verify'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  String _getTokenFromLink(String link) {
    final uri = Uri.decodeFull(link);
    final params = Uri.parse(uri).queryParametersAll;
    var token = '';
    if (params.containsKey('token')) {
      token = params['token'][0];
    } else {
      token = uri.split('?token=')[1];
    }
    return token;
  }

  final _contactEditingController = TextEditingController();
  var _dialCode = '';

  //Login click with contact number validation
  Future<void> clickOnLogin(BuildContext context) async {
    if (_contactEditingController.text.isEmpty) {
      showErrorDialog(context, 'Contact number can\'t be empty.');
    } else {
      final responseMessage = await Navigator.pushNamed(context, '/otpScreen',
          arguments: '$_dialCode${_contactEditingController.text}');
      if (responseMessage != null) {
        showErrorDialog(context, responseMessage as String);
      }
    }
  }

  //callback function of country picker
  void _callBackFunction(String name, String dialCode, String flag) {
    _dialCode = dialCode;
  }

  //Alert dialogue to show error and response
  void showErrorDialog(BuildContext context, String message) {
    // set up the AlertDialog
    final CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: const Text('Error'),
      content: Text('\n$message'),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('Yes'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget _buildFormField(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Image.asset(
                'assets/images/Siu.png',
                width: screenWidth * 0.7,
                fit: BoxFit.contain,
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              const Text(
                'Login',
                style: TextStyle(fontSize: 28, color: Colors.black),
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              const Text(
                'Enter your mobile number to receive a verification code',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.04,
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: screenWidth > 600 ? screenWidth * 0.2 : 16),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    // ignore: prefer_const_literals_to_create_immutables
                    boxShadow: [
                      const BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 6.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(16.0)),
                child: Column(
                  children: [
                    Form(
                        key: _formKey,
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          height: 45,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromARGB(255, 253, 188, 51),
                            ),
                            borderRadius: BorderRadius.circular(36),
                          ),
                          child: Row(
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              CountryPicker(
                                callBackFunction: _callBackFunction,
                                headerText: 'Select Country',
                                headerBackgroundColor:
                                    Theme.of(context).primaryColor,
                                headerTextColor: Colors.white,
                              ),
                              SizedBox(
                                width: screenWidth * 0.01,
                              ),
                              Expanded(
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    hintText: 'Contact Number',
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 13.5),
                                  ),
                                  validator: (String phone) {
                                    String validatephone = _validationService
                                        .validateUserProfilePhone(phone);
                                    if (validatephone != null)
                                      return validatephone;
                                  },
                                  controller: _contactEditingController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(10)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(
                      height: 8,
                    ),
                    // CustomButton(clickOnLogin),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    String buttonText = _localizationService.trans('auth__create_acc__next');

    return OBSuccessButton(
      minWidth: double.infinity,
      size: OBButtonSize.large,
      isLoading: _tokenValidationInProgress,
      child: Text(buttonText, style: TextStyle(fontSize: 18.0)),
      onPressed: () {
        onPressedNextStep(context);
      },
    );
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

  Widget _buildPasteRegisterLink({@required BuildContext context}) {
    String pasteLinkText =
        _localizationService.trans('auth__create_acc__paste_link');

    return Column(
      children: <Widget>[
        Text(
          '🔗',
          style: TextStyle(fontSize: 45.0, color: Colors.white),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Text(pasteLinkText,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ],
    );
  }

  Widget _buildLinkForm() {
    return Form(
      key: _formKey,
      child: Row(children: <Widget>[
        new Expanded(
          child: Container(
              color: Colors.transparent,
              child: OBAuthTextField(
                autocorrect: false,
                hintText: '',
                validator: (String link) {
                  String validateLink = _validationService
                      .validateUserRegistrationLink(link.trim());
                  if (validateLink != null) {
                    return validateLink;
                  }

                  if (_tokenIsInvalid) {
                    return _localizationService.auth__create_acc__invalid_token;
                  }

                  return null;
                },
                controller: _linkController,
                onFieldSubmitted: (v) => onPressedNextStep(context),
              )),
        ),
      ]),
    );
  }

  Widget _buildRequestInvite({@required BuildContext context}) {
    String requestInviteText =
        _localizationService.trans('auth__create_acc__request_invite');

    return OBSecondaryButton(
      isFullWidth: true,
      isLarge: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            requestInviteText,
            style: TextStyle(fontSize: 18.0, color: Colors.black),
          )
        ],
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/waitlist/subscribe_email_step');
      },
    );
  }

  _validateToken() async {
    _setTokenValidationInProgress(true);
    String token = _getTokenFromLink(_linkController.text.trim());
    debugPrint('Validating token ${token}');

    try {
      final isTokenValid = await _validationService.isInviteTokenValid(token);
      debugPrint('Token was valid:  ${isTokenValid}');
      return isTokenValid;
    } catch (error) {
      _onError(error);
    } finally {
      _setTokenValidationInProgress(false);
    }
  }

  _onLinkChanged() {
    if (_tokenIsInvalid) _setTokenIsInvalid(false);
  }

  _setTokenIsInvalid(bool tokenIsInvalid) {
    setState(() {
      _tokenIsInvalid = tokenIsInvalid;
      _formKey.currentState.validate();
    });
  }

  _setTokenValidationInProgress(bool tokenValidationInProgress) {
    setState(() {
      _tokenValidationInProgress = tokenValidationInProgress;
    });
  }

  void _onError(error) async {
    if (error is HttpieConnectionRefusedError) {
      _toastService.error(
          message: error.toHumanReadableMessage(), context: context);
    } else if (error is HttpieRequestError) {
      String errorMessage = await error.toHumanReadableMessage();
      _toastService.error(message: errorMessage, context: context);
    } else {
      _toastService.error(message: 'Unknown error', context: context);
      throw error;
    }
  }
}
