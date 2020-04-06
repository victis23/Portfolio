
// Your web app's Firebase configuration
var firebaseConfig = {
    apiKey: "AIzaSyA8uLjvF05fH-TUjt-QRZ8pkZeFeJWVmno",
    authDomain: "portfolio-5f956.firebaseapp.com",
    databaseURL: "https://portfolio-5f956.firebaseio.com",
    projectId: "portfolio-5f956",
    storageBucket: "portfolio-5f956.appspot.com",
    messagingSenderId: "322089138229",
    appId: "1:322089138229:web:550438e22376920995d97c",
    measurementId: "G-9GSC89H1B3"
};
// Initialize Firebase
firebase.initializeApp(firebaseConfig);
firebase.analytics();

submitButton.addEventListener("click",addToDataBase);

var db = firebase.firestore()

function addToDataBase(){

    console.log("The firebase file is being loaded");

    db.collection("users").add({
        first: "Ada",
        last: "Lovelace",
        born: 1815
    })
        .then(function (docRef) {
            console.log("Document written with ID: ", docRef.id);
        })
        .catch(function (error) {
            console.error("Error adding document: ", error);
        });
}



// var nameField = document.getElementById("NameField");
// var phoneField = document.getElementById("PhoneNumberField");
// var emailField = document.getElementById("EmailField");
// var textField = document.getElementById("DescriptionField");

// var submitButton = document.getElementById("SubmitButton");

