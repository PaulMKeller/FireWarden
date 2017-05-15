<?php
/* Set Connection Credentials */
$serverName="db680844177.db.1and1.com";
$uid = "dbo680844177";
$pwd = "FireWarden1";
$connectionInfo = array( "UID"=>$uid,
                         "PWD"=>$pwd,
                         "Database"=>"db680844177",
                         "CharacterSet"=>"UTF-8");
 
/* Connect using SQL Server Authentication. */
$conn = sqlsrv_connect( $serverName, $connectionInfo);
 
if( $conn === false ) {
     echo "Unable to connect.</br>";
     die( print_r( sqlsrv_errors(), true));
}
 
/* TSQL Query */
$tsql = "EXEC sp_Login_Get @LoginName=?";
/*$getLogin = $_POST['LoginName'];*/
$getLogin = 'Paul';
$params = array($getLogin);
$stmt = sqlsrv_query( $conn, $tsql, $params);
 
if( $stmt === false ) {
     echo "Error in executing query.</br>";
     die( print_r( sqlsrv_errors(), true));
}

/* Process results */
$json = array();

do {
     while ($row = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC)) {
     $json[] = $row;
     }
} while ( sqlsrv_next_result($stmt) );

/* Run the tabular results through json_encode() */
/* And ensure numbers don't get cast to trings */
//echo json_encode($json,<code>JSON_NUMERIC_CHECK</code>);
echo json_encode($json);

/* Free statement and connection resources. */
sqlsrv_free_stmt( $stmt);
sqlsrv_close( $conn);
 
?>