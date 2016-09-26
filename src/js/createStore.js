import { createStore, applyMiddleware } from 'redux';
import auth from './auth';
import aceEditor from './aceEditor';
import toElmLand from './toElmLand'

export default function(ports) {
  const store = createStore(
    () => ({}),
    applyMiddleware(auth, aceEditor, toElmLand(ports))
  );

  Object.keys(ports).forEach(key => {
    ports[key].subscribe &&
    ports[key].subscribe(([type, payload]) => store.dispatch({
      type, payload
    }));
  });

  return store;
};
