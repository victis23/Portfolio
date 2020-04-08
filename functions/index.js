const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions

// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

exports.notifyNewMessage = functions.database.ref('Messages').onCreate((snapshot,context) => {
    
    const message = snapshot._data();
    const senderName = message['name'];
    const senderMessage = message['message'];

    console.log(senderName);
    console.log(senderMessage);

    return admin.firestore().doc().get().then( userDoc => {

        console.debug(userDoc);

        const registrationTokens = userDoc.get('registrationTokens');
        const notificationBody = ("You recieved a new request from https://www.michaelwells.dev");
        
        const payload = {
            notification: {
                title: senderName + " sent you a messsage.",
                body: notificationBody,
                clickAction: "RemoveBadge"
            },
            data : {
                userName : senderName,
                userId : message['senderId']
            }
        }
        return admin.messaging().sendToDevice(registrationTokens,payload)
    })
})