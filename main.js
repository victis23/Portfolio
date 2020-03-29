
// Main javascript file used for altering UI Appearences. 



var requestButton = document.getElementById("MenuButton");
var menu = document.getElementById("ChildScreen");


//Listens for user interation with menu button.
requestButton.addEventListener("click", userClickedMenuBtn);
requestButton.addEventListener("click", colorSwitcher);

var isWhite = true;

function colorSwitcher() {
    
    if (isWhite) {
        requestButton.style.color = "rgba(79, 118, 245, 0.884)";
    } else if (!isWhite){
        requestButton.style.color = "white";
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

function userClickedRequestServicesBtn() {
    /* 
  Sudo code
  — When button is clicked slide in new screen with a purple / pink gradient 
  containing a contact form
  — Change gradient colors for skills to match
  — Prsent user with submit button
  — Return to main screen upon submit button click
  */
}
