import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:fluttertoast/fluttertoast.dart';

const _userPoolId = "us-east-1_VpvKQXRiL";
const _clientId = "4ljsccr0qt5asjmc8ufla661il";

// const _region = 'us-east-1';

final userPool =
    CognitoUserPool(_userPoolId, _clientId, storage: CognitoMemoryStorage());

signUpWithCognito({String email, String password}) async {
  final userAttributes = [
    AttributeArg(name: 'email', value: email),
  ];

  try {
    final data =
        await userPool.signUp(email, password, userAttributes: userAttributes);
    print('successfull: ${data.toString()}');
    Fluttertoast.showToast(msg: 'Succesfully registered');

    return true;
  } on CognitoClientException catch (e) {
    Fluttertoast.showToast(msg: e.message, gravity: ToastGravity.CENTER);
    print('catched error : ${e.toString()}');
    return false;
  }
}

confirmUserCognito({String email, String code}) async {
  final cognitoUser = CognitoUser(email, userPool);

  try {
    await cognitoUser.confirmRegistration(code);

    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

reSendConfirmationCode(String email) async {
  final cognitoUser = CognitoUser(email, userPool);
  var status;
  try {
    status = await cognitoUser.resendConfirmationCode();
    Fluttertoast.showToast(msg: 'Code is resent to $email');
  } on CognitoClientException catch (e) {
    print(e);
  }
  print('status:$status');
}

startSession(
    {String email,
    String password,
    Function(String, CognitoUserSession) callback}) async {
  final cognitoUser =
      CognitoUser(email, userPool, storage: CognitoMemoryStorage());
  final authDetails = AuthenticationDetails(
    username: email,
    password: password,
  );

  CognitoUserSession session;
  try {
    session = await cognitoUser.authenticateUser(authDetails);

    // print(session.getIdToken().getJwtToken());

    // print(session.getAccessToken().getJwtToken());

    print(cognitoUser.username);

    callback(cognitoUser.username, session);
  } on CognitoClientException catch (e) {
    Fluttertoast.showToast(msg: e.message, gravity: ToastGravity.CENTER);

    print('error');
    print(e);

    return e.code;
  }
}

getUserAttributes() async {
  final session = await startSession(
    email: 'first@sign.com',
    password: 'noneMatters',
  );

  final cognitoUser =
      CognitoUser('first@sign.com', userPool, signInUserSession: session);
  List<CognitoUserAttribute> attributes;
  try {
    attributes = await cognitoUser.getUserAttributes();

    attributes.forEach((attribute) {
      print(' ${attribute.getName()}:  ${attribute.getValue()}');
    });

    return attributes;
  } catch (e) {
    print(e);
  }
}

updateUserAttributes() async {
  final session = await startSession(
    email: 'first@sign.com',
    password: 'noneMatters',
  );

  final cognitoUser =
      CognitoUser('first@sign.com', userPool, signInUserSession: session);

  List<CognitoUserAttribute> attributes = [];
  attributes.add(CognitoUserAttribute(name: 'nickname', value: "my nick !"));

  try {
    final result = await cognitoUser.updateAttributes(attributes);
    print(result);
  } catch (e) {
    print(e);
  }
}

forgotPassword() async {
  final cognitoUser = CognitoUser('first@sign.com', userPool);
  var data;
  try {
    data = await cognitoUser.forgotPassword();
  } catch (e) {
    print(e);
  }

  print('code sent to :');
  print(data);
}

confirmPassword(String code, CognitoUser user, String newPassword) async {
  bool result = false;
  try {
    result = await user.confirmPassword(code, newPassword);
  } catch (e) {
    print(e);
  }
  return result;
}
