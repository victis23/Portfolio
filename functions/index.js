const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.sendPushNotifications = functions.database.ref('/Messages/{message}').onCreate((snapshot,context) => {

    console.log(snapshot);
    console.log(context);

    var topic = "/topics/sentMessages";

    var payload = {
        data: {
            message : 'You recieved a new message!'
        }
    }
  
    return  admin.messaging().sendToTopic(topic,payload).then((response) => {
        
        return response;
    })
})