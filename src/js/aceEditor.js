import ace from 'brace';
import 'brace/ext/statusbar';
import 'brace/ext/searchbox';
import 'brace/mode/elm';
import 'brace/mode/json';
import 'brace/mode/html';
import 'brace/mode/javascript';
import 'brace/mode/css';
import 'brace/theme/cobalt';

const editors = {};

window.asd = ace;

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
  editors[id] = editors[id] || {
    editor: ace.edit(),
    sessions: {},
  };

  const editor = editors[id].editor;

  pollElement(id)
  .then(element => {
    element.appendChild(editor.container);
    editor.setTheme('ace/theme/cobalt');
    editor.setOptions({
      scrollPastEnd: 1,
    });
  });
}

function openFile(dispatch, [id, file]) {
  const session = ace.createEditSession(file.content);
  editors[id].sessions[file.url] = session;
}

function activateFile(dispatch, [id, file]) {
  editors[id].editor.setSession(
    editors[id].sessions[file.url]
  );

  const fileExtension = file.name.split('.').pop();
  editors[id].sessions[file.url].setMode(`ace/mode/${fileExtension}`);
}

export default ({ dispatch }) => next => action => {
  next(action);

  console.log(action);

  switch (action.type) {
    case "MOUNT_EDITOR":
      mountEditor(dispatch, action.payload);
      break;

    case "OPEN_FILE":
      openFile(dispatch, action.payload);
      break;

    case "ACTIVATE_FILE":
      activateFile(dispatch, action.payload);
  }
}
