var any = firebase.firestore()

var isFormShowing = false;
var infoBtn = document.getElementById("RequestInfoButton");
var navigationBar = document.getElementById("NavigationBar");

var submitButton = document.getElementById("SubmitButton");
var requestForm = document.getElementById("RequestForm");


//!Form Outlets & Values

var nameField = document.getElementById("NameField");
var phoneField = document.getElementById("PhoneNumberField");
var emailField = document.getElementById("EmailField");
var textField = document.getElementById("DescriptionField");

//%Sections

var transitionArea = document.getElementById("TransitionArea");
var headerArea = document.getElementById("Header");
var headerContent = document.getElementById("HeaderContent");


var skillsSection = document.getElementById("Skills");
var projectSection = document.getElementById("Projects");
var experienceSection = document.getElementById("Experience");
var educationSection = document.getElementById("Education");

var sectionOne = document.getElementById("Section1");
var sectionTwo = document.getElementById("Section2");
var sectionThree = document.getElementById("Section3");
var sectionFour = document.getElementById("Section4");

//* Measurments

var sectionOneArea = sectionOne.getBoundingClientRect();
var sectionTwoArea = sectionTwo.getBoundingClientRect();
var sectionThreeArea = sectionThree.getBoundingClientRect();
var sectionFourArea = sectionFour.getBoundingClientRect();

var windowArea = window.screen.height;
var windowHalfway = (windowArea / 2);

//! Event Listeners
infoBtn.addEventListener("click", infoBtnClicked);
window.addEventListener("scroll", scroller);
submitButton.addEventListener("click", submitButtonTapped);

//% On load
loadSectionHeaderWithFadeIn()

//%End Load

// When user clicks info button method updates background and presents user with form.
function infoBtnClicked() {
    
    if (!isFormShowing) {
        isFormShowing = !isFormShowing;
        growFormContainer()
        headerArea.classList.add("orangeFluid");
        headerArea.classList.remove("fluidArea");
        transitionArea.style.background = "linear-gradient(rgb(250, 187, 69), rgb(255, 255, 255))";
        navigationBar.style.backgroundColor = "rgb(255, 19, 90)";
    } else {
        isFormShowing = !isFormShowing;
        shrinkFormContainer()
        headerArea.classList.add("fluidArea");
        headerArea.classList.remove("orangeFluid");
        transitionArea.style.background = "linear-gradient(rgba(90, 126, 247, 0.911), rgb(255, 255, 255))";
        navigationBar.style.backgroundColor = "rgba(37, 4, 182, 0.911)";
        
    }
}

function growFormContainer(){
        requestForm.classList.add("visible");
        requestForm.classList.remove("hidden");
}

function shrinkFormContainer(){
        requestForm.classList.remove("visible");
        requestForm.classList.add("hidden");
}

// Is called as user scrolls down page.
function scroller() {
    currentScrollPosition = window.scrollY;

    // Skills
    if (sectionOneArea.top - currentScrollPosition <= (windowHalfway)) {
        animateElementin(skillsSection);
    } else {
        removeElementClassIn(skillsSection);
    }
    // Projects
    if ((sectionTwoArea.top - currentScrollPosition) <= (windowHalfway)) {
        animateElementin(projectSection);
    } else {
        removeElementClassIn(projectSection);
    }
    // Experience
    if (sectionThreeArea.top - currentScrollPosition <= (windowHalfway)) {
        animateElementin(experienceSection);
    } else {
        removeElementClassIn(experienceSection);
    }
    // Education
    //% Needs to use the offset of previous item because this will never reach the middle of the screen.
    if (sectionFourArea.top - currentScrollPosition <= (windowHalfway)) {
        animateElementin(educationSection);
    } else {
        removeElementClassIn(educationSection);
    }

}

// Shows element on screen with animations.
function animateElementin(element) {
    element.classList.add("animateSectionHeader");
    element.classList.remove("nonVisable")
}

// Removes element on screen with animation.
function removeElementClassIn(element) {
    element.classList.remove("animateSectionHeader")
    element.classList.add("nonVisable")
}

//Handles data returned from form.
function submitButtonTapped() {

    infoBtnClicked();
    var name = nameField.value;
    var phone = phoneField.value;
    var email = emailField.value;
    var descriptionText = textField.value;

    // Asign values to properties on a new DataObject.
    var data = new DataObject;
    data.name = name;
    data.phone = phone;
    data.email = email;
    data.description = descriptionText;

    any.collection("Messages").doc().set({
        name: data.name,
        phone: data.phone,
        email: data.email,
        message: data.description,
        timestamp : Date.now,
    }).then(function () {
        console.log("Value added to database successfully!");
    })


    clearfields();
    return data;
}

// Class that will hold data returned from form.
class DataObject {
    constructor(name, phone, email, description) {
        this.name = name;
        this.phone = phone;
        this.email = email;
        this.description = description;
    }
}


// Removes values from fields once submitted.
function clearfields() {
    nameField.value = "";
    phoneField.value = "";
    emailField.value = "";
    textField.value = "";
}

//Is called when DOM loads; creates smooth loading animation for content within header section.
function loadSectionHeaderWithFadeIn() {
    headerContent.classList.remove("hidden");
    headerContent.classList.add("visible");
}
