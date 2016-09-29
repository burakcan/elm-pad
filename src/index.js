import 'normalize.css';
import './style.css';
import './Main/style.css'
import './Editor/style.css';
import './Editor/FileTree/style.css';
import createStore from './js/createStore';
import { Main } from './Main.elm';

const { ports } = Main.embed(
  document.getElementById('root')
  ,
  {}
);

const store = createStore(ports);
