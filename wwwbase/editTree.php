<?php
require_once("../phplib/util.php");

util_assertModerator(PRIV_EDIT | PRIV_STRUCT);

$id = Request::get('id');
$saveButton = Request::has('saveButton');
$mergeButton = Request::has('mergeButton');
$clone = Request::has('clone');
$delete = Request::has('delete');

if ($id) {
  $t = Tree::get_by_id($id);
  if (!$t) {
    FlashMessage::add('Arborele nu există.');
    util_redirect(util_getWwwRoot());
  }
} else {
  $t = Model::factory('Tree')->create();
}

if ($mergeButton) {
  $mergeTreeId = Request::get('mergeTreeId');
  $other = Tree::get_by_id($mergeTreeId);

  if (!$other) {
    FlashMessage::add('Arborele selectat nu există.');
    util_redirect("?id={$t->id}");
  }

  $treeMentions = Mention::getTreeMentions($t->id);
  if (count($treeMentions)) {
    FlashMessage::add('Nu puteți unifica acest arbore până nu rezolvați mențiunile despre el.');
    util_redirect("?id={$t->id}");
  }

  $t->mergeInto($other->id);

  FlashMessage::add('Am unificat arborii.', 'success');
  util_redirect("?id={$other->id}");
}

if ($clone) {
  $newt = $t->_clone();
  Log::info("Cloned tree {$t->id} ({$t->description}), new id {$newt->id}");
  FlashMessage::add('Am clonat arborele.', 'success');
  util_redirect("?id={$newt->id}");
}

if ($delete) {
  $te = TreeEntry::get_by_treeId($t->id); // try to redirect to a relevant entry
  $t->delete();
  FlashMessage::add('Am șters arborele.', 'success');

  if ($te) {
    util_redirect("editEntry.php?id={$te->entryId}");
  } else {
    util_redirect(util_getWwwRoot());
  }
}

if ($saveButton) {
  $t->description = Request::get('description');
  $t->status = Request::get('status');
  $entryIds = Request::get('entryIds');
  $jsonMeanings = Request::get('jsonMeanings');
  $meanings = json_decode($jsonMeanings);

  $errors = $t->validate();
  if ($errors) {
    FlashMessage::add('Nu pot salva arborele datorită erorilor de mai jos.');
    SmartyWrap::assign('errors', $errors);
    $t->setMeanings(Meaning::convertTree($meanings));
  } else {
    $t->save();

    TreeEntry::wipeAndRecreate($t->id, $entryIds);

    Meaning::saveTree($meanings, $t);

    FlashMessage::add('Am salvat arborele.', 'success');
    util_redirect("?id={$t->id}");
  }
} else {
  $t->getMeanings(); // ensure they are loaded
  $entryIds = $t->getEntryIds();
  RecentLink::add("Arbore: {$t->description} (ID={$t->id})");
}

// Load the distinct model types for the entries' lexems
if (count($entryIds)) {
  $modelTypes = Model::factory('Lexem')
              ->table_alias('l')
              ->select('l.modelType')
              ->distinct()
              ->join('EntryLexem', ['el.lexemId', '=', 'l.id'], 'el')
              ->where_in('el.entryId', $entryIds)
              ->order_by_asc('modelType')
              ->find_many();
} else {
  $modelTypes = [];
}

$relatedMeanings = Model::factory('Meaning')
                 ->table_alias('m')
                 ->select('m.*')
                 ->select('r.type', 'relationType')
                 ->join('Relation', ['m.id', '=', 'r.meaningId'], 'r')
                 ->where('r.treeId', $t->id)
                 ->find_many();
foreach ($relatedMeanings as $m) {
  $m->getTree(); // preload it
}

// find other trees from this tree's entries
$entryTrees = Model::factory('Tree')
  ->table_alias('t')
  ->select('t.*')
  ->join('TreeEntry', ['t.id', '=', 'te.treeId'], 'te')
  ->join('TreeEntry', ['te.entryId', '=', 'te2.entryId'], 'te2')
  ->where('te2.treeId', $t->id)
  ->where_not_equal('t.id', $t->id)
  ->find_many();

$treeMentions = Mention::getDetailedTreeMentions($t->id);

$numMeanings = Model::factory('Meaning')
  ->where('treeId', $t->id)
  ->count();
$numRelations = Model::factory('Relation')
  ->where('treeId', $t->id)
  ->count();
$canDelete = !$numMeanings && !$numRelations;

SmartyWrap::assign('t', $t);
SmartyWrap::assign('entryIds', $entryIds);
SmartyWrap::assign('modelTypes', $modelTypes);
// TODO: canEdit if STRUCT_STATUS_IN_PROGRESS) || util_isModerator(PRIV_EDIT)
SmartyWrap::assign('canEdit', true);
SmartyWrap::assign('canDelete', $canDelete);
SmartyWrap::assign('relatedMeanings', $relatedMeanings);
SmartyWrap::assign('entryTrees', $entryTrees);
SmartyWrap::assign('treeMentions', $treeMentions);
SmartyWrap::assign('statusNames', Tree::$STATUS_NAMES);
SmartyWrap::addCss('meaningTree', 'textComplete', 'admin');
SmartyWrap::addJs('select2Dev', 'meaningTree', 'textComplete');
SmartyWrap::display('editTree.tpl');

?>
