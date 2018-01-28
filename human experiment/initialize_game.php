<?php 
// session_start(); 

// Create a new data base named with the worker ID 
// $username="root";
// $password="";
// $hostname="localhost";
// $database ="square_game_results";
$username="squarega_aia";
$password="haruvi21";
$hostname="localhost";
$db = "squarega_mondrian"; 

// $db = "square_game_results"; 
$con = mysqli_connect($hostname,$username,$password) or die('Could not connect');

mysqli_select_db($con,$db) or die('Could not select db');

// $work_id = $_POST["ID"];
$ip = $_SERVER["REMOTE_ADDR"];
 $gender =  $_POST["gender"]; 
$BY =$_POST["birthYear"];
// $condition = $_POST["condition"]; 
// $lang = $_POST["lang"]; 
$id = $_POST["ID"]; 
$beg_date = $_POST["begDate"]; 
$cond = $_POST["condition"]; 
// $land_date = $_POST["landDate"]; 
// $version = $_POST["version"]; 
// Generate the code for Mturk: 
$code_length = 10;
// $got_code = "false"; 
// $disqual = "false"; 
$code = random_str($code_length); 
if($id=='lab')
{
	$id = $code ; 
}


$vars = array(); 
$vars['id'] = $id; 
$vars['code'] = $code; 
echo json_encode($vars);
 

$query = "INSERT INTO personal(ip_address,code,worker_id,cond,gender,birth_year,beg_date) VALUES('$ip','$code','$id','$cond','$gender','$BY','$beg_date')";

mysqli_query($con, $query); 


function random_str($length, $keyspace = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')
{
    $str = '';
    $max = mb_strlen($keyspace, '8bit') - 1;
    for ($i = 0; $i < $length; ++$i) {
        $str .= $keyspace[mt_rand(0, $max)];
    }
    return $str;
}

?> 