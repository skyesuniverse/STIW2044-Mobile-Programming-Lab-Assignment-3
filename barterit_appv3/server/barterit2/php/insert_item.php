<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$userid = $_POST['userid'];
$item_name = $_POST['itemname'];
$item_desc = addslashes($_POST['itemdesc']);
$item_price = $_POST['itemprice'];
$item_qty = $_POST['itemqty'];
$item_category = $_POST['category'];
$latitude = $_POST['latitude'];
$longitude = $_POST['longitude'];
$state = $_POST['state'];
$locality = $_POST['locality'];
$image1 = $_POST['image1'];
$image2 = $_POST['image2'];
$image3 = $_POST['image3'];

$sqlinsert = "INSERT INTO `tbl_items`(`user_id`,`item_name`, `item_desc`, `item_category`, `item_price`, `item_qty`, `item_lat`, `item_long`, `item_state`, `item_locality`) VALUES ('$userid','$item_name','$item_desc','$item_category','$item_price','$item_qty','$latitude','$longitude','$state','$locality')";

if ($conn->query($sqlinsert) === TRUE) {
	$item_id = mysqli_insert_id($conn);
    $response = array('status' => 'success', 'data' => null);

    if (!empty($image1)) {
        $decoded_string = base64_decode($image1);
        $path = '../assets/items/' . $item_id . '_1.png';
        file_put_contents($path, $decoded_string);
    }

    if (!empty($image2)) {
        $decoded_string = base64_decode($image2);
        $path = '../assets/items/' . $item_id . '_2.png';
        file_put_contents($path, $decoded_string);
    }

    if (!empty($image3)) {
        $decoded_string = base64_decode($image3);
        $path = '../assets/items/' . $item_id . '_3.png';
        file_put_contents($path, $decoded_string);
    }

    sendJsonResponse($response);
}else{
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>