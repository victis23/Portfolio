

var isFormShowing = false;
var infoBtn = document.getElementById("RequestInfoButton");
var navigationBar = document.getElementById("NavigationBar");

//%Sections

var transitionArea = document.getElementById("TransitionArea");
var headerArea = document.getElementById("Header");

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

//% On load

function infoBtnClicked() {

    isFormShowing = !isFormShowing;

    if (isFormShowing) {
        headerArea.classList.add("orangeFluid");
        headerArea.classList.remove("fluidArea");
        transitionArea.style.background = "linear-gradient(rgb(250, 187, 69), rgb(255, 255, 255))";
        navigationBar.style.backgroundColor = "rgb(255, 19, 90)";
    } else {
        headerArea.classList.add("fluidArea");
        headerArea.classList.remove("orangeFluid");
        transitionArea.style.background = "linear-gradient(rgba(90, 126, 247, 0.911), rgb(255, 255, 255))";
        navigationBar.style.backgroundColor = "rgba(37, 4, 182, 0.911)";
    }
}

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



/*

//Executed when user taps Request Services button.
function userClickedMenuBtn() {
    if (menu.style.width === "300px") {
        hideMenu();
    } else {
        showMenu();
    }
}

//Displays contact form to user.
function showContactForm() {
    var position = 0;
    var interval = setInterval(move, 5);
    console.dir(skillsSection.classList);
    function move() {
        if (position === 100) {
            formView.style.visibility = "visible";
            clearInterval(interval);
        } else {
            position += 1;
            contactFormScreen.style.height = position + "%";
        }
    }
    //% Changes color gradient of Skills section to orange.
    skillsSection.classList.remove("blueGradient");
    skillsSection.classList.add("orangeGradient");
}

//Hides contact from from user.
function hideContactForm() {
    var position = 100;
    var interval = setInterval(move, 5);
    formView.style.visibility = "hidden";
    function move() {
        if (position === 0) {
            clearInterval(interval);
        } else {
            position -= 1;
            contactFormScreen.style.height = position + "%";
        }
    }
    //% Changes color gradient of Skills section to blue.
    skillsSection.classList.remove("orangeGradient");
    skillsSection.classList.add("blueGradient");
}

*/