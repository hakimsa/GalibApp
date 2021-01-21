
/*Future<bool> createUserWithEmailAndPassword({
  @required String email,
  @required String password,
  void listener(FirebaseUser user),
}) async {
  final loggedIn = await alreadyLoggedIn();
  if (loggedIn) return loggedIn;

  kFirebaseStorageRef(listener: listener);

  FirebaseUser user;
  try {
    user = await kFirebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((result) {
      _result = result;
      FirebaseUser usr = _result.user;
      return usr;
    });
  } catch (ex) {
    _setError(ex);
    user = null;
    _result = null;
  }
  return user?.uid?.isNotEmpty ?? false;
}

Future<List<String>> fetchSignInMethodsForEmail({
  @required String email,
}) async {
  List<String> providers;

  try {
    providers = await kFirebaseAuth?.fetchSignInMethodsForEmail(email: email);
  } catch (ex) {
    _setError(ex);
    providers = null;
  }
  return providers;
}

Future<bool> sendPasswordResetEmail({
  @required String email,
}) async {
  bool reset;
  try {
    await kFirebaseAuth?.sendPasswordResetEmail(email: email);
    reset = true;
  } catch (ex) {
    _setError(ex);
    reset = false;
  }
  return reset;
}

Future<bool> signInWithEmailAndPassword({
  @required String email,
  @required String password,
  void listener(FirebaseUser user),
}) async {
  final loggedIn = await alreadyLoggedIn();
  if (loggedIn) return loggedIn;

  _initFireBase(listener: listener);

  FirebaseUser user;
  try {
    user = await kFirebaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((result) {
      _result = result;
      FirebaseUser usr = _result?.user;
      return usr;
    }).catchError((ex) {
      _setError(ex);
      _result = null;
      user = null;
    });
  } catch (ex) {
    _setError(ex);
    _result = null;
    user = null;
  }
  return user?.uid?.isNotEmpty ?? false;
}

Future<bool> signInWithCredential({
  @required AuthCredential credential,
  void listener(FirebaseUser user),
}) async {
  final loggedIn = await alreadyLoggedIn();
  if (loggedIn) return loggedIn;

  _initFireBase(listener: listener);

  FirebaseUser user;
  try {
    user =
    await kFirebaseAuth.signInWithCredential(credential).then((result) {
      _result = result;
      FirebaseUser usr = _result?.user;
      return usr;
    }).catchError((ex) {
      _setError(ex);
      _result = null;
      user = null;
    });
  } catch (ex) {
    _setError(ex);
    _result = null;
    user = null;
  }
  return user?.uid?.isNotEmpty ?? false;
}

Future<bool> signInWithCustomToken({
  @required String token,
  void listener(FirebaseUser user),
}) async {
  final loggedIn = await alreadyLoggedIn();
  if (loggedIn) return loggedIn;

  _initFireBase(listener: listener);

  FirebaseUser user;
  try {
    user = await kFirebaseAuth
        .signInWithCustomToken(token: token)
        .then((result) {
      _result = result;
      FirebaseUser usr = _result?.user;
      return usr;
    }).catchError((ex) {
      _setError(ex);
      _result = null;
      user = null;
    });
  } catch (ex) {
    _setError(ex);
    _result = null;
    user = null;
  }
  return user?.uid?.isNotEmpty ?? false;
}

Future<void> setLanguageCode(String language) async {
  try {
    await kFirebaseAuth.setLanguageCode(language).catchError((ex) {
      _setError(ex);
    });
  } catch (ex) {
    _setError(ex);
  }
}

Future<bool> _setUserFromFireBase(FirebaseUser user) async {
  _user = user;

  _idTokenResult = await user?.getIdToken();

  _idToken = _idTokenResult?.token ?? "";

  _accessToken = "";

//    return user?.uid?.isNotEmpty ?? false;
//  }

  _isEmailVerified = user?.isEmailVerified ?? false;

  _isAnonymous = user?.isAnonymous ?? true;

  _uid = user?.uid ?? "";

  _displayName = user?.displayName ?? "";

  _photoUrl = user?.photoUrl ?? "";

  _email = user?.email ?? "";

  _phoneNumber = user?.phoneNumber ?? "";

  return _uid.isNotEmpty;
*/