<?php

$host = $argv[1];
$db_user = $argv[2];
$db_pass = $argv[3];
$db_name = $argv[4];
$root_user = 'root';
$root_pass = $argv[5];

$sql_query = "CREATE DATABASE  IF NOT EXISTS `$db_name`;
              CREATE USER '$db_user'@'%' IDENTIFIED BY '$db_pass';
              GRANT ALL on '$db_name'.* to '$db_user'@'%' ;
              FLUSH PRIVILEGES;";

$conn = new mysqli($host, $root_user, $root_pass);
$conn->query($sql_query);
$conn->close();

?> 
