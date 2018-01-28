<?php 

// Create a new data base named with the worker ID 
// $username="root";
// $password="";
// $hostname="localhost";

$username="squarega_aia";
$password="haruvi21";
$hostname="localhost";
$db="squarega_mixIm"; 

//$username="id175400_aiaharuvi";
//$password="aia1712";
//$hostname="localhost";
$con = mysqli_connect($hostname,$username,$password) or die('Could not connect: ' . mysqli_error($con));
//  $sql1 = "CREATE DATABASE whatsintheimage_results";
// mysqli_query($con, $sql1); 
// $db = "whatsintheimage_results"; 
// Create a personal details table 
// mysqli_select_db($con,"square_game_results");
mysqli_select_db($con,$db) or die('Could not select db');

/*$sql2 = "CREATE TABLE Personal (
worker_id VARCHAR(30) NOT NULL, 
gender VARCHAR(10) NOT NULL,
condition INT(6),
reg_date TIMESTAMP 
)";*/

$sql2 = "CREATE TABLE personal (
ip_address VARCHAR(50) NOT NULL, 	
code VARCHAR(10) NOT NULL,
worker_id VARCHAR(50),
cond INT(3) NOT NULL,
gender VARCHAR(10) NOT NULL,
birth_year INT(6) NOT NULL,
beg_date VARCHAR(30),
end_date VARCHAR(30),
cmmnts VARCHAR(400) NOT NULL,
got_code VARCHAR(6) NOT NULL
)";


$retval = mysqli_query($con, $sql2);
   if(! $retval ) {
      die('Could not create table: ' . mysqli_error($con));
   }

//$query = "INSERT INTO personal VALUES('$work_id','$gender','$condition',CURRENT_TIMESTAMP)";
//mysqli_query($con, $query);

// Create also training table and testing table : 
$ans_table = "CREATE TABLE subject_answers (
code VARCHAR(30) NOT NULL, 
cond INT(3) NOT NULL,
trial INT(3) NOT NULL,
image_index INT(3) NOT NULL,
sub_ans VARCHAR(100) NOT NULL,
ITI DOUBLE PRECISION(8,4) NOT NULL
)";
mysqli_query($con, $ans_table); 


mysqli_close($con);

?> 