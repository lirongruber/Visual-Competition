<?php

//print("<p>PHP script begin</p>");
$username="squarega_aia";
$password="haruvi21";
$hostname="localhost";
$db = "squarega_mixIm"; 

// $db = "square_game_results"; 
$con = mysqli_connect($hostname,$username,$password) or die('Could not connect');
mysqli_select_db($con,$db) or die('Could not select db');


$code = $_GET["code"]; 
$sub_ans = $_GET["subAnswer"]; 
$trial_idx = $_GET["trial_idx"]; 
$iti = $_GET["ITI"];
$im_idx = $_GET["im_idx"]; 
$cond = $_GET["condition"]; 

$query = "INSERT INTO subject_answers VALUES('$code','$cond','$trial_idx','$im_idx','$sub_ans','$iti')";

mysqli_query($con,$query) or die(mysqli_error($con));
mysqli_close($con);


?>