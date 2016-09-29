import ace from 'brace';
import 'brace/ext/statusbar';
import 'brace/ext/searchbox';
import 'brace/mode/elm';
import 'brace/theme/cobalt';

function pollElement(id) {
  return new Promise(resolve => {
    const interval = setInterval(() => {
      if (document.getElementById(id)) {
        resolve(document.getElementById(id));
        clearInterval(interval);
      }
    }, 10);
  });
}


function mountEditor(dispatch, id) {
  pollElement(id)
  .then(element => {
    const editor = ace.edit(id);
    editor.getSession().setMode('ace/mode/elm');
    editor.setTheme('ace/theme/cobalt');
    editor.setOptions({
      scrollPastEnd: 1,
    });
  });
}

export default ({ dispatch }) => next => action => {
  next(action);

  switch (action.type) {
    case "MOUNT_EDITOR":
      mountEditor(dispatch, action.payload);
      break;
  }
}
