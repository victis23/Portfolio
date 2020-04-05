
<?php 

function SendEmail(){

if (!isset($_POST["submit"])){
    echo "Form is invalid";
}

$name = $_POST["name"];
$phone = $_POST["phone"];
$email = $_POST["email"];
$description = $_POST["requestDescription"];

$email_from = "wow@duhmarket.com";
$email_subject = "Request from form";
$email_message = "The following email was automatically generated with the following message: \n
$name /n
$phone /n
$email /n
$description .
";
$to = "wow@duhmarket.com";
$headers = "From: $email_from \r\n";

// Send Email: 
mail($to,$email_subject,$email_message,$headers);

echo "Run Function";

}



?>

<!-- if($_POST["message"]) {
    mail("your@email.address", "Form to email message", $_POST["message"], "From: an@email.address");
} -->