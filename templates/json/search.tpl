{assign var="results" value=$results|default:null}
{
    "type": "searchResults",
    "word": {$cuv|@json_encode},
    "definitions": [
        {foreach $results as $row}
        {
            "type": "definition",
            "id": {$row->definition->id|@json_encode},
            "internalRep": {$row->definition->internalRep|escape:html|@json_encode}, 
            "htmlRep": {$row->definition->htmlRep|@json_encode},
            "userNick": {$row->user->nick|@json_encode},
            "sourceName": {$row->source->shortName|@json_encode},
            "createDate": {$row->definition->createDate|@json_encode},
            "modDate": {$row->definition->modDate|@json_encode}
        }{if !$row@last},{/if}
        {/foreach}
    ]
}
