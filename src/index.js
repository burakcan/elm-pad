import 'normalize.css';
import './style.css';
import createStore from './js/createStore';
import { Main } from './Main.elm';

const { ports } = Main.embed(
  document.getElementById('root')
  ,
  {}
);

const store = createStore(ports);
