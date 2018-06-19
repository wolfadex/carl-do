'use strict';

import firebase from 'firebase/app';
import 'firebase/auth';
import 'firebase/firestore';
import Elm from './Main.elm';

firebase.initializeApp({
  apiKey: "----", // Fill in locally
  authDomain: "carl-do.firebaseapp.com",
  databaseURL: "https://carl-do.firebaseio.com",
  projectId: "carl-do",
  storageBucket: "carl-do.appspot.com",
  messagingSenderId: "408236124727"
});

const firestore = firebase.firestore();

// firestore.settings({
//   timestampsInSnapshots: true,
// });

const mountNode = document.getElementById('container');
// .embed() can take an optional second argument. This would be an object describing the data we need to start a program, i.e. a userID or some token
const app = Elm.Main.embed(mountNode);

app.ports.toFirebase.subscribe((request) => {
  console.log(`Received firebase request from Elm: ${request}`);
  app.port.fromFirebase.send('Sending from firebase to Elm');
});

// ---- AUTHENTICATION ----
let userId;


firebase.auth().onAuthStateChanged((user) => {
  if (user) {
    userId = user.uid;
    app.ports.firebaseAuthenticationSuccess.send(user);
    getWork();
  }
});


app.ports.firebaseAuthentication.subscribe((authType) => {
  switch (authType) {
    case 'google': {
      const provider = new firebase.auth.GoogleAuthProvider();

      firebase.auth().signInWithPopup(provider).then((result) => {
        const {
          // credential,
          user,
        } = result;
        // const { accessToken } = credential.accessToken;
        app.ports.firebaseAuthenticationSuccess.send(user);
      }).catch(function(error) {
        const {
          // code,
          message,
          // email,
          // credential
        } = error;

        app.ports.firebaseAuthenticationFailure.send(message);
      });
    }
  }
});


app.ports.firebaseUnauthenticate.subscribe(() => {
  firebase.auth().signOut().then(() => {
    app.ports.firebaseUnauthenticateSuccess.send('');
  }).catch((error) => {
    app.ports.firebaseUnauthenticateFailure.send(error);
  });
});


// ---- FIRESTORE ----


app.ports.firebaseFirestoreAdd.subscribe(([collection, data]) => {
  const createTimestamp = firebase.firestore.FieldValue.serverTimestamp();
  // const createTimestamp = firestore.FieldValue.serverTimestamp();

  firestore
    .collection(collection)
    .add({
      ...data,
      status: 'todo',
      createTimestamp,
      updateTimestamp: createTimestamp,
      createdBy: userId,
    })
    .then((docRef) => {
      console.log('carl', docRef);
      app.ports.firebaseFirestoreAddSuccess.send(`${docRef.id}`);
    })
    .catch((error) => {
      console.log('add error', error);
      // app.ports.firebaseFirestoreAddFailure.send(`${error}`); // TODO
    });
});

function getWork() {
  if (!getWork.subscription) {
    getWork.subscription = firestore.collection('work')
      .where(`users.${userId}`, '==', true)
      // .orderBy('createTimestamp')
      .onSnapshot(
        (querySnapshot) => {
          const work = [];

          querySnapshot.forEach((doc) => {
            const data = doc.data();

            work.push({
              ...data,
              uid: doc.id,
              createTimestamp: data.createTimestamp.toISOString(),
              updateTimestamp: data.updateTimestamp.toISOString(),
              users: Object.keys(data.users),
            });
          });
          console.log('work: ', work);
          app.ports.firebaseFirestoreGetWorkSuccess.send(work);
        },
        (error) => {
          console.log('work: Error: ', error);
          app.ports.firebaseFirestoreGetWorkFailure.send(error);
        },
      );
    }
}
