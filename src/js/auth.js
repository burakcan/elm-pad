import firebase from 'firebase';
import FbAuth, { GithubAuthProvider } from 'firebase/auth';

const lsCacheKey = 'ELM_PAD_GH_CREDENTIAL';

const config = {
  apiKey: "AIzaSyBhnwSOy1YuFCQsmu25WFuXOfF0gmWEu1Q",
  authDomain: "elm-pad.firebaseapp.com",
};

const provider = new GithubAuthProvider();
provider.addScope('gist');

const fbAuth = new FbAuth(
  firebase.initializeApp(config)
);

function toUserType({ user, credential }) {
  return {
    displayName: user.displayName,
    email: user.email,
    photoUrl: user.photoURL,
    uid: user.uid,
    accessToken: credential.accessToken,
    credential: credential,
  };
}

function handleLoginSuccess(dispatch, payload) {
  const userType = toUserType(payload);

  localStorage.setItem(lsCacheKey, JSON.stringify(userType));

  dispatch({
    type: 'LOGIN_SUCCESS',
    port: 'loginSuccess',
    payload: userType,
  });
}

function handleLoginError(dispatch, error, silent = false) {
  dispatch({
    type: 'LOGIN_ERROR',
    port: 'loginError',
    payload: {
      error,
      silent,
    },
  });
}

function login(dispatch) {
  fbAuth
  .signInWithPopup(provider)
  .then(
    result => handleLoginSuccess(dispatch, result),
    error => handleLoginError(dispatch, error, false)
  );
}

function tryAutoLogin(dispatch) {
  const cached = localStorage.getItem(lsCacheKey);

  if (cached && cached !== "undefined") {
    const credential = GithubAuthProvider.credential(
      JSON.parse(cached).credential
    );

    return (
      fbAuth
      .signInWithCredential(credential)
      .then(
        user => handleLoginSuccess(dispatch, { user, credential }),
        error => {
          localStorage.removeItem(lsCacheKey);
          handleLoginError(dispatch, error, true);
        }
      )
    );
  }

  setTimeout(
    () => handleLoginError(dispatch, { code : 'no cache' }, true), 10
  );
}

export default ({ dispatch }) => {
  tryAutoLogin(dispatch);

  return next => action => {
    next(action);

    switch (action.type) {
      case 'LOGIN':
        login(dispatch);
        break;
    }
  }
}
