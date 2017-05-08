<!DOCTYPE html>
<html>
    <head>
        <title>www.gratuityp.com</title>
        <link rel="stylesheet" href="../css/main.css">
    </head>
    <body>
        <?php
        
        $serverName = "db638520808.db.1and1.com"; //serverName\instanceName
        $connectionInfo = array( "Database"=>"db638520808", "UID"=>"dbo638520808", "PWD"=>"Register2016!");
        $conn = sqlsrv_connect( $serverName, $connectionInfo);

        if( $conn ) {
            //echo "Connection established.<br />";
        }else{
             echo "Connection to database could not be established.<br />";
             die( print_r( sqlsrv_errors(), true));
        }

        $sql = "EXEC sp_gratuityp_registration_GETLIST";
        $params = array("");
        $stmt = sqlsrv_query( $conn, $sql, $params);

        if( $stmt === false ) {
            die( print_r( sqlsrv_errors(), true));
        }

        //echo "<h1>Thanks for registering your interest, we will contact you soon</h1>";

        echo "<table>";
        echo "<tr>";
        echo "<th>ID</th>";
        echo "<th>Email</th>";
        echo "<th>First Name</th>";
        echo "<th>Last Name</th>";
        echo "<th>Country</th>";
        echo "</tr>";

        while( $row = sqlsrv_fetch_array( $stmt, SQLSRV_FETCH_ASSOC))
        {
            $id = $row["ID"];
            $email = $row["emailaddress"];
            $fname = $row["firstname"];
            $lname = $row["lastname"];
            $country = $row["country"];
            
            echo "<tr>";
            echo "<td>$id</td>";
            echo "<td>$email</td>";
            echo "<td>$fname</td>";
            echo "<td>$lname</td>";
            echo "<td>$country</td>";
            echo "</tr>";

        }
        
        echo "</table>";
        
        ?>
    </body>
</html>