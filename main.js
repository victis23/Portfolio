
// Main javascript file used for altering UI Appearences. 



var sideMenuBtn = document.getElementById("MenuButton");
var menu = document.getElementById("ChildScreen");

var contactFormScreen = document.getElementById("RequestServiceForm");
var formView = document.getElementById("ContactForm");

var requestInfoBtn = document.getElementById("RequestServicesBtn");
var submitBtn = document.getElementById("SubmitButton");

// var skillsSection = document.getElementById("Skills");
var skillsSection = document.querySelector(".skills")

//Listens for user interation with menu button.
sideMenuBtn.addEventListener("click", userClickedMenuBtn);
sideMenuBtn.addEventListener("click", colorSwitcher);

// Listens for interaction on Request Services button.
requestInfoBtn.addEventListener("click", showContactForm);
submitBtn.addEventListener("click", hideContactForm);

var isWhite = true;

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
    skillsSection.classList.remove("blueGradient");
    skillsSection.classList.add("orangeGradient");
}

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
    skillsSection.classList.remove("orangeGradient");
    skillsSection.classList.add("blueGradient");
}


