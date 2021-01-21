


import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
// Route name of the login screen.
//const kLoginScreenRouteName = 'LoginScreen';
typedef void GoogleListener(GoogleSignInAccount event);
typedef void FireBaseListener(FirebaseUser user);
typedef Future<FirebaseUser> FireBaseUser();

class Auth {
  factory Auth.init({
    List<String> scopes,
    String hostedDomain,
    void listen(GoogleSignInAccount account),
    void listener(FirebaseUser user),
  }) {
    Auth auth;
    if (_this == null) {
      _this = Auth._init(

          scopes: scopes,
          hostedDomain: hostedDomain,
          listen: listen,
          listener: listener);
      auth = _this;
    }

    /// Any subsequent instantiations are ignored.
    return auth;
  }
  static Auth _this;
  static FirebaseAuth _fireBaseAuth;
  static GoogleSignIn _googleSignIn;

  /// Important to call this function when terminating the you app.
  void dispose() async {
    await signOut_();

    _fireBaseAuth = null;
    _googleSignIn = null;
    _fireBaseListeners = null;
    _googleListeners = null;
    await _googleListener?.cancel();
    await _firebaseListener?.cancel();
    _googleListener = null;
    _firebaseListener = null;
  }

  StreamSubscription<FirebaseUser> _firebaseListener;
  StreamSubscription<GoogleSignInAccount> _googleListener;

  Auth._init({

    List<String> scopes,
    String hostedDomain,
    void listen(GoogleSignInAccount account),
    void listener(FirebaseUser user),
  }) {
    _initFireBase(
      listener: listener,
    );

    if (_googleSignIn == null) {
      _googleSignIn = GoogleSignIn(

          scopes: scopes,
          hostedDomain: hostedDomain);
      // Store in an instance variable
      _googleIn = _googleSignIn;

      _initListen(
        listen: listen,
      );
    }
  }
  GoogleSignIn _googleIn;
  GoogleSignIn get googleSignIn => _googleIn;

  _initFireBase({
    void listener(FirebaseUser user),
    Function onError,
    void onDone(),
    bool cancelOnError = false,
  }) {
    // Clear any errors first.

    getEventError();

    if (_fireBaseAuth == null) {
      _fireBaseAuth = FirebaseAuth.instance;
      _firebaseListener = _fireBaseAuth.onAuthStateChanged.listen(
          _listFireBaseListeners,
          onError: _eventError,
          onDone: onDone,
          cancelOnError: cancelOnError);
      // Store in an instance variable
      _fbAuth = _fireBaseAuth;
    }

    if (listener != null) {
      _fireBaseListeners.add(listener);
    }
  }

  FirebaseAuth _fbAuth;
  FirebaseAuth get firebaseAuth => _fbAuth;

  Set<FireBaseListener> _fireBaseListeners = Set();
  bool _firebaseRunning = false;

  void _listFireBaseListeners(FirebaseUser user) async {
    if (_firebaseRunning) return;
    _firebaseRunning = true;
    await _setUserFromFireBase(user);
    for (var listener in _fireBaseListeners) {
      listener(user);
    }
    _firebaseRunning = false;
  }

  void fireBaseListener(FireBaseListener f) => _fireBaseListeners.add(f);

  set listener(FireBaseListener f) => _fireBaseListeners.add(f);

  void removeListener(FireBaseListener f) => _fireBaseListeners.remove(f);

  Set<GoogleListener> _googleListeners = Set();
  bool _googleRunning = false;

  void _initListen({
    void listen(GoogleSignInAccount account),
    Function onError,
    void onDone(),
    bool cancelOnError = false,
  }) async {
    // Clear any errors first.

    getEventError();

    if (listen != null) _googleListeners.add(listen);

    if (_googleListener == null) {
      _googleListener = _googleSignIn?.onCurrentUserChanged?.listen(
          _listGoogleListeners,
          onError: _eventError,
          onDone: onDone,
          cancelOnError: cancelOnError);
    }
  }

  /// async so you'll come back if there's a setState() called in the listener.
  void _listGoogleListeners(GoogleSignInAccount account) async {
    if (_googleRunning) return;
    _googleRunning = true;
    await _setFireBaseUserFromGoogle(account);
    for (var listener in _googleListeners) {
      listener(account);
    }
    _googleRunning = false;
  }

  List<Exception> _eventErrors = List();
  List<Exception> getEventError() {
    var errors = _eventErrors;
    _eventErrors = null;
    return errors;
  }

  bool get eventErrors => _eventErrors.isNotEmpty;

  /// Record errors for the event listeners.
  void _eventError(Object ex) {
    if (ex is! Exception) ex = Exception(ex.toString());
    _eventErrors.add(ex);
  }

  void googleListener(GoogleListener f) => _googleListeners.add(f);

  set listen(GoogleListener f) => _googleListeners.add(f);

  void removeListen(GoogleListener f) => _googleListeners.remove(f);

  Future<bool> alreadyLoggedIn([GoogleSignInAccount googleUser]) async {
    FirebaseUser _user;
    FirebaseUser fireBaseUser;
    if (_fireBaseAuth != null) fireBaseUser = await _fireBaseAuth.currentUser();
    return _user != null &&
        fireBaseUser != null &&
        _user.uid == fireBaseUser.uid &&
        (googleUser == null ||
            googleUser.id == fireBaseUser?.providerData[1]?.uid);
  }

  /// Firebase Login.

  Future<bool> createUserWithEmailAndPassword({
     String email,
     String password,
    void listener(User user),
  }) async {
    final loggedIn = await alreadyLoggedIn();
    if (loggedIn) return loggedIn;

    _initFireBase(listener: listener);

  User user;
    try {
      user = await _fireBaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((result) {

        FirebaseUser usr = user;
        return usr;
      });
    } catch (ex) {

      user = null;

    }
    return user?.uid?.isNotEmpty ?? false;
  }

  Future<List<String>> fetchSignInMethodsForEmail({
    String email,
  }) async {
    List<String> providers;

    try {
      providers = await _fireBaseAuth?.fetchSignInMethodsForEmail(email: email);
    } catch (ex) {

      providers = null;
    }
    return providers;
  }

  Future<bool> sendPasswordResetEmail({
 String email,
  }) async {
    bool reset;
    try {
      await _fireBaseAuth?.sendPasswordResetEmail(email: email);
      reset = true;
    } catch (ex) {

      reset = false;
    }
    return reset;
  }

  signOut_() {

    _fireBaseAuth.signOut();

print(_fireBaseAuth.toString()+"          ...HA SALIDO");
  }

  _setUserFromFireBase(FirebaseUser user) {}

  _setFireBaseUserFromGoogle(GoogleSignInAccount account) {}

}
// For firebase authentication.
final kFirebaseAuth = FirebaseAuth.instance;
// Google sign-in configuration.
final kGoogleSignIn = GoogleSignIn();
// A reference to the firebase realtime database.
final kFirebaseDbRef = FirebaseDatabase.instance.reference();
// A reference for uploading files to firebase storage.
final kFirebaseStorageRef = FirebaseStorage.instance.ref();
final kSignInOption =StreamSubscription;
// Animation duration for sending message.
const kAnimationDuration = 300;


