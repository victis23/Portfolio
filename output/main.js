

var isFormShowing = false;
var infoBtn = document.getElementById("RequestInfoButton");
var navigationBar = document.getElementById("NavigationBar");
var contactFormScreen = document.getElementById("ContactForm");
var contactFormFields = document.getElementById("ContactFormContent");
var submitButton = document.getElementById("SubmitButton");

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

contactFormScreen.style.height = "0%";
contactFormScreen.style.visibility = "hidden";
loadSectionHeaderWithFadeIn()

//%End Load

// When user clicks info button method updates background and presents user with form.
function infoBtnClicked() {

    isFormShowing = !isFormShowing;

    if (isFormShowing) {
        showContactForm();
        headerArea.classList.add("orangeFluid");
        headerArea.classList.remove("fluidArea");
        transitionArea.style.background = "linear-gradient(rgb(250, 187, 69), rgb(255, 255, 255))";
        navigationBar.style.backgroundColor = "rgb(255, 19, 90)";
    } else {
        hideContactForm();
        headerArea.classList.add("fluidArea");
        headerArea.classList.remove("orangeFluid");
        transitionArea.style.background = "linear-gradient(rgba(90, 126, 247, 0.911), rgb(255, 255, 255))";
        navigationBar.style.backgroundColor = "rgba(37, 4, 182, 0.911)";
    }
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

//Displays contact form to user.
function showContactForm() {
    var position = 0;
    var interval = setInterval(move, 5);
    function move() {
        if (position === 75) {
            // formView.style.visibility = "visible";
            clearInterval(interval);
        } else {
            position += 1;
            contactFormScreen.style.height = position + "%";
        }
    }
    contactFormFields.classList.add("visible");
    contactFormFields.classList.remove("hidden");
    contactFormScreen.style.visibility = "visible";
}

//Hides contact from from user.
function hideContactForm() {
    var position = 50;
    var interval = setInterval(move, 5);
    // formView.style.visibility = "hidden";
    function move() {
        if (position === 75) {
            clearInterval(interval);
        } else {
            position -= 1;
            contactFormScreen.style.height = position + "%";
        }

        if (position === 0) {
            contactFormScreen.style.visibility = "hidden";
        }
    }
    contactFormFields.classList.remove("visible");
    contactFormFields.classList.add("hidden");
}

//Handles data returned from form.
function submitButtonTapped() {

    infoBtnClicked();
    var name = nameField.value;
    var phone = phoneField.value;
    var email = emailField.value;
    var descriptionText = textField.value;

    console.dir(phoneField);
    console.dir(emailField);

}

//Is called when DOM loads; creates smooth loading animation for content within header section.
function loadSectionHeaderWithFadeIn() {
    headerContent.style.opacity = "0";
    var currentOpacity = 0;

   var interval = setInterval(function () {

        if (currentOpacity != 100){
            headerContent.style.opacity = currentOpacity + "%";
            currentOpacity += 0.3; // might need to change this to 1 (might be introducing a bug).
        }
    }, 5);

    if (currentOpacity === 100) {
        clearInterval(interval);
    }
}


