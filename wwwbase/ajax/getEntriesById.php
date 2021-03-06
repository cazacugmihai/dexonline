<?php
require_once("../../phplib/Core.php");

$ids = Request::getJson('q', []);
$data = [];

foreach ($ids as $id) {
  $e = Entry::get_by_id($id);

  if ($e) {
    $data[] = [
      'id' => $id,
      'text' => $e->description,
    ];
  } else {
    $data[] = [
      'id' => 0,
      'text' => '',
    ];
  }
}

header('Content-Type: application/json');
print json_encode($data);
