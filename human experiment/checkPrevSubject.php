<?php 
// session_start(); 

$username="squarega_aia";
$password="haruvi21";
$hostname="localhost";
$db="squarega_mixIm"; 
// $db = "square_game_results"; 
$con = mysqli_connect($hostname,$username,$password) or die('Could not connect');
mysqli_select_db($con,$db) or die('Could not select db');

// $work_id = $_POST["ID"];
 
$id = $_POST["ID"]; 

// $created_date = date("Y-m-d H:i:s");
// Check if the subject already played: 
$query_code =  "SELECT code FROM personal WHERE worker_id = '$id'"; 
$res = mysqli_query($con, $query_code) or die( "Unable to select code"); 
$code_prev = mysqli_fetch_assoc($res);
// Create a personal details table 

$vars = array(); 
$vars['prev_player'] = $code_prev['code']; 
echo json_encode($vars);
 
?> 