<?php
    
// Gestion des erreurs
ini_set('display_errors', 1);
// Enregistrer les erreurs dans un fichier de log
ini_set('log_errors', 1);
// Nom du fichier qui enregistre les logs (attention aux droits à l'écriture)
ini_set('error_log', dirname(__file__) . '/log_error_php.txt');
// Afficher les erreurs et les avertissements
error_reporting('e_all');

$serverName = "decsqldev,1433";
$connectionInfo = array( "Database"=>"BotanicDW_MEC", "UID"=>"login", "PWD"=>"Promethe6337");

$conn = sqlsrv_connect( $serverName, $connectionInfo);
if( $conn === false ) {
     die(print_r(sqlsrv_errors(), true));
}

if(isset($_REQUEST['DateInt']))
   $Date = $_REQUEST['DateInt'];
else
   $Date = "0";
   
if(isset($_REQUEST['Format']))
   $Format = $_REQUEST['Format'];
else
   $Format = "JSON";

$sql = "select StrDate, StrMagasin, CA
from [WebServices].[GetCA](".$Date.")";
$stmt = sqlsrv_query( $conn, $sql );
if( $stmt === false) {
    die(print_r(sqlsrv_errors(), true) );
}

if ($Format == "JSON") {

     $ArRows = array();
     while($row = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC) ) {
          //echo $row['StrMagasin']."<br />";
     	  $ArRows[] = $row;
     	  //echo json_encode($row);
     }
     echo json_encode($ArRows);

}

if ($Format == "Tableau") {

     $strData = "[";
     while( $row = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC) ) {
          $strData = $strData . "[\"";
     	  $strData = $strData . $row['StrDate'];
          $strData = $strData . "\", \"";
     	  $strData = $strData . $row['StrMagasin'];
          $strData = $strData . "\",";
          $strData = $strData . $row['CA'];
          $strData = $strData . "],";
     }
     $strData = substr($strData,0,-1) . "]";
     echo $strData;

}

if ($Format == "CSV") {

     $strData = "";
     while( $row = sqlsrv_fetch_array( $stmt, SQLSRV_FETCH_ASSOC) ) {
     	  $strData = $strData . $row['StrDate'];
          $strData = $strData . ";";
          $strData = $strData . $row['StrMagasin'];
          $strData = $strData . ";";
          $strData = $strData . $row['CA'];
          $strData = $strData . "<P>";
     }
     echo $strData;

}


//var data = [ ["January", 10], ["February", 8], ["March", 4], ["April", 13], ["May", 17], ["June", 9] ];

sqlsrv_free_stmt( $stmt);
?>