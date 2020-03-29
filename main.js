
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

// var skillsSection = document.getElementById("Skills");
var skillsSection = document.querySelector(".skills")

//! Event listeners

//Listens for user interation with menu button.
sideMenuBtn.addEventListener("click", userClickedMenuBtn);
sideMenuBtn.addEventListener("click", colorSwitcher);

// Listens for interaction on Request Services button.
requestInfoBtn.addEventListener("click", showContactForm);
submitBtn.addEventListener("click", hideContactForm);

// Listens for scrolling.
window.addEventListener("scroll",scroller);

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

function scroller() {

}

