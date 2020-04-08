const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.sendPushNotification = functions.firestore.document("Messages/{document=**}")
.onCreate((snapshot, context) => {

    console.debug(snapshot);
    console.debug(context);

    const topic = "/topics/sentMessages";

    const payload = {
        notification : {
            message : 'You recieved a new message!',
        }
    }
  
    return  admin.messaging().sendToTopic(topic,payload);
})