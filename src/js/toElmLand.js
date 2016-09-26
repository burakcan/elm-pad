export default ports => ({ dispatch }) => next => action => {
  next(action);

  if (!(action.port && ports[action.port] && ports[action.port].send)) {
    return false;
  }

  ports[action.port].send(action.payload);
}
