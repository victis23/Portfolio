const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.notifyNewMessage = functions.database.ref('/Messages/').onCreate((snapshot, context) => {

    const message = snapshot._data();
    const senderName = message['name'];
    const senderMessage = message['message'];

    console.debug('This was the user auth for writer' + context.auth.uid);

    console.log(senderName);
    console.log(senderMessage);

    return admin.firestore().doc().get().then(userDoc => {

        console.debug(userDoc);

        const token = "drLtG9pfFUKhoZ1DrPgdlx:APA91bH_W6kD620W0RByX_6IYYbEDjHC1pXiFzFiDtL0JoPDS82ocswZYd-ZFjiInUZ7qrSbmEkkMXi55z-2oiL05OYXetsjBVtoeP4D1hHNi8HLkODYNPTKRjt8vHrgiY30Gmho9bmc";

        const notificationBody = ("You recieved a new request from https://www.michaelwells.dev");
        
        // const topic = '/topics/sentMessages';

        const message = {
            data: {
                title: senderName + " sent you a messsage.",
                body: notificationBody,
                clickAction: "RemoveBadge"
            }
            // topic: {
            //     topic: topic,
            // }
        }

        return admin.messaging().sendToDevice(token,message);
    })
})