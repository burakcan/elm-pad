import ace from 'brace';
import './aceExtensions';

const editors = {};

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
    window.asd = editor;
    editor.getSession().setMode(`ace/mode/elm`)
    element.appendChild(editor.container);
    editor.setTheme('ace/theme/tomorrow');
    editor.setOptions({
      scrollPastEnd: 1,
    });
  });
}

function openFile(dispatch, [editorId, file]) {
  const session = ace.createEditSession(file.content);
  editors[editorId].sessions[file.url] = session;

  activateFile(dispatch, [editorId, file]);
}

function activateFile(dispatch, [editorId, file]) {
  editors[editorId].editor.setSession(
    editors[editorId].sessions[file.url]
  );

  const fileExtension = file.name.split('.').pop();
  editors[editorId].sessions[file.url].setMode(`ace/mode/${fileExtension}`);
}


function closeFile(dispatch, [editorId, file]) {
  const editor = editors[editorId].editor;
  const session = editors[editorId].sessions[file.url];
  delete editors[editorId].sessions[file.url];

  if (!Object.keys(editors[editorId].sessions).length) {
    editor.setSession(ace.createEditSession(""));
  }
}


export default ({ dispatch }) => next => action => {
  next(action);

  switch (action.type) {
    case "MOUNT_EDITOR":
      mountEditor(dispatch, action.payload);
      break;

    case "OPEN_FILE":
      openFile(dispatch, action.payload);
      break;

    case "ACTIVATE_FILE":
      activateFile(dispatch, action.payload);
      break;

    case "CLOSE_FILE":
      closeFile(dispatch, action.payload);
      break;
  }
}
