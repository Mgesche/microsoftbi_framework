<?php

$serverName = "decsqldev,1433";
$connectionInfo = array( "Database"=>"BotanicDW_MEC", "UID"=>"login", "PWD"=>"Promethe6337");

$conn = sqlsrv_connect( $serverName, $connectionInfo);
if( $conn === false ) {
     die( print_r( sqlsrv_errors(), true));
}

$Date = $_GET["DateInt"];

$sql = "select Date_Int, CA
from [WebServices].[GetCA](".DateInt.")";
$stmt = sqlsrv_query( $conn, $sql );
if( $stmt === false) {
    die( print_r( sqlsrv_errors(), true) );
}

$ArRows = array();
while( $row = sqlsrv_fetch_array( $stmt, SQLSRV_FETCH_ASSOC) ) {
      //echo $row['prenom']."<br />";
	  $ArRows[] = $row;
	  //echo json_encode($row);
}
echo json_encode($ArRows);

sqlsrv_free_stmt( $stmt);
?>