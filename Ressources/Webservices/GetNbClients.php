<?php

$serverName = "decsqldev,1433";
$connectionInfo = array( "Database"=>"BotanicDW_MEC", "UID"=>"login", "PWD"=>"Promethe6337");

$conn = sqlsrv_connect( $serverName, $connectionInfo);
if( $conn === false ) {
     die( print_r( sqlsrv_errors(), true));
}
   
if(isset($_REQUEST['Format']))
   $Format = $_REQUEST['Format'];
else
   $Format = "JSON";

$sql = "EXEC [WebServices].[GetNbClients]";
$stmt = sqlsrv_query( $conn, $sql );
if( $stmt === false) {
    die( print_r( sqlsrv_errors(), true) );
}

if ($Format == "JSON") {

     $ArRows = array();
     while( $row = sqlsrv_fetch_array( $stmt, SQLSRV_FETCH_ASSOC) ) {
           //echo $row['prenom']."<br />";
     	  $ArRows[] = $row;
     	  //echo json_encode($row);
     }
     echo json_encode($ArRows);

}

if ($Format == "Tableau") {

     $strData = "[";
     while( $row = sqlsrv_fetch_array( $stmt, SQLSRV_FETCH_ASSOC) ) {
          $strData = $strData . "[\"CA\", ";
     	$strData = $strData . $row['CA'];
          $strData = $strData . "\",";
     }
     $strData = substr($strData,0,-1) . "]";
     echo $strData;

}

if ($Format == "CSV") {

     $strData = "";
     while( $row = sqlsrv_fetch_array( $stmt, SQLSRV_FETCH_ASSOC) ) {
          $strData = $strData . $row['CA'];
          $strData = $strData . "<P>";
     }
     echo $strData;

}


//var data = [ ["January", 10], ["February", 8], ["March", 4], ["April", 13], ["May", 17], ["June", 9] ];

sqlsrv_free_stmt( $stmt);
?>