'use strict';

import firebase from 'firebase/app';
import 'firebase/auth';
import Elm from './Main.elm';

const config = {
  apiKey: "AIzaSyB4WYbwvIWE3XSN24-cXrTUzOpbJMwdQp8",
  authDomain: "carl-do.firebaseapp.com",
  databaseURL: "https://carl-do.firebaseio.com",
  projectId: "carl-do",
  storageBucket: "carl-do.appspot.com",
  messagingSenderId: "408236124727"
};
firebase.initializeApp(config);

const mountNode = document.getElementById('container');
// .embed() can take an optional second argument. This would be an object describing the data we need to start a program, i.e. a userID or some token
const app = Elm.Main.embed(mountNode);

app.ports.toFirebase.subscribe((request) => {
  console.log(`Received firebase request from Elm: ${request}`);
  app.port.fromFirebase.send('Sending from firebase to Elm');
});
