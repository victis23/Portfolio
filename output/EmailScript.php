
<?php 

$pass = email($_POST['name'], $_POST['email'], $_POST['phone'], $_POST['description']);

function email($name,$phone,$email,$message) {
    echo($name);
    echo("Not Working!");
    return true;
}



?>