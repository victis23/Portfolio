



/*
// Main javascript file used for altering UI Appearences. 


//! Variables

// State variable that is set depending on what color the menu button is.
var isWhite = true;

// Current position of screen.
var currentScrollPosition = 0;

//%  Element Variables

// Hamburger Button in top left corner of screen.
var sideMenuBtn = document.getElementById("MenuButton");

// Left slideout menu.
var menu = document.getElementById("ChildScreen");

//Screen containing form for requesting more information. | Actuall form.
var contactFormScreen = document.getElementById("RequestServiceForm");
var formView = document.getElementById("ContactForm");

//Button used to request contact form | Button used to submit info from form (also dismisses form).
var requestInfoBtn = document.getElementById("RequestServicesBtn");
var submitBtn = document.getElementById("SubmitButton");

var skillsSection = document.querySelector(".skills");
var skillLists = document.querySelector(".skillList");

// project section values.
var projectSectionContent = document.querySelector("#projectContent");

//* Section Header Properties

var skillHeaderTxt = document.querySelector(".skillHeader");
var projectHeaderTxt = document.querySelector(".projectHeader");
var experienceHeaderTxt = document.querySelector(".experienceHeader");
var experienceData = document.querySelector(".experienceData");
var educationHeaderTxt = document.querySelector(".educationHeader");

//* Coordinates
var skillTitleTxtOffset = skillHeaderTxt.getBoundingClientRect();
var projectTitleTxtOffset = projectHeaderTxt.getBoundingClientRect();
var experienceTitleTxtOffset = experienceHeaderTxt.getBoundingClientRect();
var educationTitleTxtOffset = educationHeaderTxt.getBoundingClientRect();

//! Event listeners

//Listens for user interation with menu button.
sideMenuBtn.addEventListener("click", userClickedMenuBtn);
sideMenuBtn.addEventListener("click", colorSwitcher);

// Listens for interaction on Request Services button.
requestInfoBtn.addEventListener("click", showContactForm);
submitBtn.addEventListener("click", hideContactForm);

// Listens for scrolling.
window.addEventListener("scroll", scroller);

//! Methods

//Controls color state of menu button.
function colorSwitcher() {

    if (isWhite) {
        sideMenuBtn.style.color = "rgba(79, 118, 245, 0.884)";
    } else if (!isWhite) {
        sideMenuBtn.style.color = "white";
    }
    isWhite = !isWhite;
}

//Executed when user taps Request Services button.
function userClickedMenuBtn() {
    if (menu.style.width === "300px") {
        hideMenu();
    } else {
        showMenu();
    }
}

// Reveals side menu to user.
function showMenu() {
    var shift = 0;
    var id = setInterval(frame, 5);

    function frame() {
        if (shift === 300) {
            clearInterval(id);
        } else {
            shift += 5;
            menu.style.width = shift + "px";
        }
    }
}

// Hides side menu from user.
function hideMenu() {
    var shift = 300;
    var id = setInterval(frame, 5);

    function frame() {
        if (shift === 0) {
            clearInterval(id);
        } else {
            shift -= 5;
            menu.style.width = shift + "px";
        }
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

// When user scrolls element becomes visible when it reaches the middle of screen.
function scroller() {
    currentScrollPosition = window.scrollY;
    
    if (currentScrollPosition >= (skillTitleTxtOffset.top / 2)) {
        animateElementin(skillHeaderTxt);
        showSkillLists();
    } else {
        removeElementClassIn(skillHeaderTxt);
        hideSkillList();
    }

    if (currentScrollPosition >= (projectTitleTxtOffset.top / 1.5)) {
        animateElementin(projectHeaderTxt);
        projectSectionContent.classList.add("animateSectionHeader");
    } else {
        removeElementClassIn(projectHeaderTxt);
        projectSectionContent.classList.remove("animateSectionHeader");
    }

    if (currentScrollPosition >= (experienceTitleTxtOffset.top / 1.5)) {
        animateElementin(experienceHeaderTxt);
        experienceData.classList.remove("checker");
        experienceData.classList.add("appear");
    } else {
        removeElementClassIn(experienceHeaderTxt);
        experienceData.classList.add("checker");
        experienceData.classList.remove("appear");
    }

    //% Needs to use the offset of previous item because this will never reach the middle of the screen.
    if (currentScrollPosition >= (experienceTitleTxtOffset.top / 1.5)) {
        animateElementin(educationHeaderTxt);
    } else {
        removeElementClassIn(educationHeaderTxt);
    }

}

function showSkillLists(){
    skillLists.classList.add("appear");
}
function hideSkillList(){
    skillLists.classList.remove("appear");
}

// Shows element on screen with animations.
function animateElementin(element) {
    element.classList.add("animateSectionHeader");
}

// Removes element on screen with animation.
function removeElementClassIn(element) {
    element.classList.remove("animateSectionHeader");
}

/*