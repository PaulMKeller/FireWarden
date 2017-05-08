<?php
header("Content-Type: application/json; charset=UTF-8");
$obj = json_decode($_GET["x"], false);

/* Set Connection Credentials */
$serverName="db680844177.db.1and1.com";
$uid = "dbo680844177";
$pwd = "FireWarden1";
$connectionInfo = array( "UID"=>$uid,
                         "PWD"=>$pwd,
                         "Database"=>"db680844177",
                         "CharacterSet"=>"UTF-8");

$conn = new mysqli($serverName, $uid, $pwd, "db680844177");
$result = $conn->query("SELECT name FROM ".$obj->table." LIMIT ".$obj->limit);
$outp = array();
$outp = $result->fetch_all(MYSQLI_ASSOC);

echo json_encode($outp);
?>