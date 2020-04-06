<html>
    <body>
        <?php 
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
            header("Location: https://www.michaelwells.dev");
            echo "Run Function";
        ?>
    </body>
</html>


<!-- For future reference -->

<!-- if($_POST["message"]) {
    mail("your@email.address", "Form to email message", $_POST["message"], "From: an@email.address");
} -->

 <!-- $pass = email($_POST['name'], $_POST['email'], $_POST['phone'], $_POST['description']);

 function email($name,$phone,$email,$message) {
     echo($name);
    echo("Not Working!");
    return true;
 } -->