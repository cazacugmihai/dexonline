{extends "layout-admin.tpl"}

{block "title"}Pagina moderatorului{/block}

{block "content"}
  <h3>Pagina moderatorului</h3>

  {include "bits/phpConstants.tpl"}

  {if User::can(User::PRIV_EDIT)}
    <div class="panel panel-default">
      <div class="panel-heading">
        Rapoarte

        <form class="pull-right">

          <small class="text-muted">
            calculate acum {($timeAgo/60)|string_format:"%d"} minute, {$timeAgo%60} secunde
          </small>

          <button type="submit" name="recountButton" class="btn btn-info btn-xs">
            <i class="glyphicon glyphicon-repeat"></i>
            recalculează acum
          </button>

        </form>

      </div>

      <table class="table table-condensed table-hover">
        {foreach $reports as $r}
          {if $r.count && User::can($r.privilege)}
            <tr>
              <td>{$r.text}</td>
              <td><a href="{$wwwRoot}{$r.url}">{$r.count}</a></td>
            </tr>
          {/if}
        {/foreach}
      </table>
    </div>
  {/if}

  {if User::can(User::PRIV_EDIT)}
    <div class="panel panel-default quickNav">
      <div class="panel-heading">
        Navigare rapidă
      </div>

      <div class="panel-body">
        <div class="col-lg-4 col-md-6 col-sm-6">
          <form action="definitionEdit.php">
            <select id="definitionId" name="definitionId"></select>
          </form>
        </div>

        <div class="col-lg-4 col-md-6 col-sm-6">
          <form action="{$wwwRoot}editEntry.php">
            <select id="entryId" name="id"></select>
          </form>
        </div>

        <div class="col-lg-4 col-md-6 col-sm-6">
          <form action="lexemeEdit.php">
            <select id="lexemeId" name="lexemeId"></select>
          </form>
        </div>

        <div class="col-lg-4 col-md-6 col-sm-6">
          <form action="{$wwwRoot}editTree.php">
            <select id="treeId" name="id"></select>
          </form>
        </div>

        <div class="col-lg-4 col-md-6 col-sm-6">
          <form action="{$wwwRoot}eticheta.php">
            <select id="labelId" name="id"></select>
          </form>
        </div>
      </div>
    </div>
  {/if}

  {if User::can(User::PRIV_EDIT)}
    <div class="panel panel-default">
      <div class="panel-heading">
        Căutare avansată
      </div>

      <div class="panel-body">
        <form class="form-horizontal" action="advancedSearch.php" method="post">

          <div class="row">

            <div class="col-lg-4 col-md-6 col-sm-6">

              <fieldset>
                <legend>proprietăți intrări</legend>

                <div class="form-group">
                  <label class="col-xs-4 control-label">descriere</label>
                  <div class="col-xs-8">
                    <input class="form-control"
                           type="text"
                           name="description"
                           placeholder="acceptă expresii regulate">
                  </div>
                </div>

                <div class="form-group">
                  <label class="col-xs-4 control-label">structurare</label>
                  <div class="col-xs-8">
                    <select name="structStatus" class="form-control">
                      <option value="">oricare</option>
                      {foreach Entry::$STRUCT_STATUS_NAMES as $i => $s}
                        <option value="{$i}">{$s}</option>
                      {/foreach}
                    </select>
                  </div>
                </div>

                <div class="form-group">
                  <label class="col-xs-4 control-label">structurist</label>
                  <div class="col-xs-8">
                    <select name="structuristId" class="form-control">
                      <option value="{Entry::STRUCTURIST_ID_ANY}">oricare</option>
                      <option value="{Entry::STRUCTURIST_ID_NONE}">niciunul</option>
                      {foreach $structurists as $s}
                        <option value="{$s->id}">
                          {$s->nick} ({$s->name})
                        </option>
                      {/foreach}
                    </select>
                  </div>
                </div>

                <div class="form-group">
                  <label class="col-xs-4 control-label">etichete</label>
                  <div class="col-xs-8">
                    <select name="entryTagIds[]" class="form-control select2Tags" multiple>
                    </select>
                  </div>
                </div>

              </fieldset>
            </div>

            <div class="col-lg-4 col-md-6 col-sm-6">

              <fieldset>
                <legend>proprietăți lexeme</legend>

                <div class="form-group">
                  <label class="col-xs-4 control-label">formă lexem</label>
                  <div class="col-xs-8">
                    <input class="form-control"
                           type="text"
                           name="formNoAccent"
                           placeholder="acceptă expresii regulate">
                  </div>
                </div>

                <div class="form-group">
                  <label class="col-xs-4 control-label">în LOC</label>
                  <div class="col-xs-8">
                    <select class="form-control" name="isLoc">
                      <option value="">indiferent</option>
                      <option value="1">da</option>
                      <option value="0">nu</option>
                    </select>
                  </div>
                </div>

                <div class="form-group">
                  <label class="col-xs-4 control-label">paradigmă</label>
                  <div class="col-xs-8">
                    <select class="form-control" name="paradigm">
                      <option value="">indiferent</option>
                      <option value="1">da</option>
                      <option value="0">nu</option>
                    </select>
                  </div>
                </div>

                <div class="form-group">
                  <label class="col-xs-4 control-label">etichete</label>
                  <div class="col-xs-8">
                    <select name="lexemeTagIds[]" class="form-control select2Tags" multiple>
                    </select>
                  </div>
                </div>

              </fieldset>
            </div>

            <div class="col-lg-4 col-md-6 col-sm-6">

              <fieldset>
                <legend>proprietăți definiții</legend>

                <div class="form-group">
                  <label class="col-xs-4 control-label">lexicon</label>
                  <div class="col-xs-8">
                    <input class="form-control"
                           type="text"
                           name="lexicon"
                           placeholder="acceptă expresii regulate">
                  </div>
                </div>

                <div class="form-group">
                  <label class="col-xs-4 control-label">starea</label>
                  <div class="col-xs-8">
                    {include "bits/statusDropDown.tpl"
                      name="status"
                      anyOption=true}
                  </div>
                </div>

                <div class="form-group">
                  <label class="col-xs-4 control-label">sursa</label>
                  <div class="col-xs-8">
                    {include "bits/sourceDropDown.tpl" name="sourceId"}
                  </div>
                </div>

                <div class="form-group">
                  <label class="col-xs-4 control-label">structurată</label>
                  <div class="col-xs-8">
                    <select class="form-control" name="structured">
                      <option value="">indiferent</option>
                      <option value="1">da</option>
                      <option value="0">nu</option>
                    </select>
                  </div>
                </div>

                <div class="form-group">
                  <label class="col-xs-4 control-label">trimise de</label>
                  <div class="col-xs-8">
                    <select name="userId" class="form-control select2Users"></select>
                  </div>
                </div>

                <div class="form-group">
                  <label class="col-xs-4 control-label">între</label>

                  <div class="col-xs-8 form-inline">
                    <input type="text" name="startDate" class="form-control calendar">
                    <label class="control-label">și</label>
                    <input type="text" name="endDate" class="form-control calendar pull-right">
                  </div>
                </div>

              </fieldset>
            </div>
          </div>

          <div class="row">
            <div class="form-group">
              <label class="col-xs-4 control-label">afișează</label>
              <div class="col-xs-8">
                <div class="btn-group" data-toggle="buttons">
                  <label class="btn btn-default active">
                    <input type="radio" name="view" value="Entry" checked> intrări
                  </label>
                  <label class="btn btn-default">
                    <input type="radio" name="view" value="Lexeme"> lexeme
                  </label>
                  <label class="btn btn-default">
                    <input type="radio" name="view" value="Definition"> definiții
                  </label>
                </div>

                <button type="submit" class="btn btn-primary" name="submitButton">
                  <i class="glyphicon glyphicon-search"></i>
                  caută
                </button>
              </div>
            </div>
          </div>

        </form>
      </div>
    </div>
  {/if}

  {if User::can(User::PRIV_EDIT)}
    <div class="panel panel-default">
      <div class="panel-heading">
        Modele de flexiune
      </div>

      <div class="panel-body">

        <form class="form-inline" action="dispatchModelAction.php">
          <div class="form-group">
            <span data-model-dropdown>
              <input type="hidden" name="locVersion" value="6.0" data-loc-version>
              <select class="form-control" name="modelType" data-model-type data-canonical="1">
              </select>
              <select class="form-control" name="modelNumber" data-model-number>
              </select>
            </span>

            <div class="btn-group">
              <button type="submit" class="btn btn-default" name="showLexemes">
                arată toate lexemele
              </button>
              <button type="submit" class="btn btn-default" name="editModel">
                <i class="glyphicon glyphicon-pencil"></i>
                editează
              </button>
              <button type="submit" class="btn btn-default" name="cloneModel">
                <i class="glyphicon glyphicon-duplicate"></i>
                clonează
              </button>
              <button type="submit" class="btn btn-danger" name="deleteModel">
                <i class="glyphicon glyphicon-trash"></i>
                șterge
              </button>
            </div>
          </div>
        </form>

        <div class="voffset2"></div>

        <p>
          <a href="../admin/mergeLexemes.php">unificare plural-singular</a>

          <span class="text-muted">
            pentru familiile de plante și animale și pentru alte lexeme care apar
            cu restricția „P” într-o sursă, dar fără restricții în altă sursă.
          </span>
        </p>

        <p>
          <a href="../admin/bulkLabelSelectSuffix.php">etichetare în masă a lexemelor</a>

          <span class="text-muted">
            pe baza sufixului
          </span>
        </p>
      </div>
    </div>
  {/if}

  {if User::can(User::PRIV_ADMIN)}
    <div class="panel panel-default">
      <div class="panel-heading">
        Înlocuiește în definiții
      </div>

      <div class="panel-body">
        <form class="form-horizontal" action="bulkReplace.php">

          <div class="row">

            <div class="col-md-6">

              <div class="form-group">
                <label class="control-label col-xs-3">înlocuiește</label>
                <div class="col-xs-9">
                  <input class="form-control" type="text" name="search">
                </div>
              </div>

              <div class="form-group">
                <label class="control-label col-xs-3">cu</label>
                <div class="col-xs-9">
                  <input class="form-control" type="text" name="replace">
                </div>
              </div>

            </div>

            <div class="col-md-6">

              <div class="form-group">
                <label class="control-label col-xs-3">sursa</label>
                <div class="col-xs-9">
                  {include "bits/sourceDropDown.tpl" name="sourceId"}
                </div>
              </div>

              <div class="form-group">
                <label class="control-label col-xs-3">rezultate</label>
                <div class="col-xs-9" id="maxaffected">
                  <div class="input-group spinner">
                    <input type="numeric"
                           name="maxaffected"
                           class="form-control"
                           value="1000"
                           min="100"
                           max="1000"
                           step="100"
                           tabindex="-1">
                    <div class="input-group-btn-vertical">
                      <button class="btn btn-default" type="button" tabindex="-1"">
                        <i class="glyphicon glyphicon-chevron-up"></i>
                      </button>
                      <button class="btn btn-default" type="button" tabindex="-1">
                        <i class="glyphicon glyphicon-chevron-down"></i>
                      </button>
                    </div>
                  </div>
                  <p class="help-block">Min 100 - Max 1000.</p>
                </div>
              </div>
            </div>
          </div>

          <div class="form-group">
            <div class="col-xs-5 col-xs-offset-1">
              <button type="submit" class="btn btn-primary" name="previewButton">
                previzualizează
              </button>
            </div>
          </div>
        </form>

        <p class="text-muted">
          Folosiți cu precauție această unealtă. Ea înlocuiește primul text cu al
          doilea în toate definițiile, făcând diferența între litere mari și mici
          (case-sensitive) și fără expresii regulate (textul este căutat ca
          atare). Vor fi modificate maximum 1.000 de definiții. Veți putea vedea
          lista de modificări propuse și să o acceptați.
        </p>
      </div>
    </div>

    <div class="panel panel-default">
      <div class="panel-heading">
        Legături
      </div>

      <table class="table table-condensed">
        <tr>
          <td><a href="{$wwwRoot}moderatori">moderatori</a></td>
          <td><a href="{$wwwRoot}surse">surse</a></td>
        </tr>
        <tr>
          <td><a href="{$wwwRoot}etichete">etichete</a></td>
          <td><a href="{$wwwRoot}tipuri-modele">tipuri de model</a></td>
        </tr>
        <tr>
          <td><a href="{$wwwRoot}flexiuni">flexiuni</a></td>
          <td><a href="{$wwwRoot}admin/ocrInput.php">adaugă definiții OCR</a></td>
        </tr>
        <tr>
          <td><a href="{$wwwRoot}admin/contribTotals">contorizare contribuții</a></td>
          <td></td>
        </tr>
      </table>
    </div>
  {/if}

  {if User::can(User::PRIV_EDIT + User::PRIV_DONATION)}
    <div class="panel panel-default">
      <div class="panel-heading">
        Unelte diverse
      </div>

      <div class="panel-body">
        <ul>
          {if User::can(User::PRIV_EDIT)}
            <li>
              <a href="../admin/deTool.php">reasociere D. Enciclopedic</a>
              <span class="text-muted">
                o interfață mai rapidă pentru asocierea de lexeme și modificarea modelelor
                acestora
              </span>
            </li>

            <li>
              <a href="../admin/placeAccents.php">plasarea asistată a accentelor</a>
              <span class="text-muted">
                pentru lexeme alese la întâmplare
              </span>
            </li>

            <li>
              <a href="{$wwwRoot}acuratete">verificarea acurateței editorilor</a>
            </li>
          {/if}

          {if User::can(User::PRIV_DONATION)}
            <li>
              <a href="{$wwwRoot}proceseaza-donatii">procesează donații</a>
            </li>
          {/if}
        </ul>
      </div>
    </div>
  {/if}

  {if User::can(User::PRIV_STRUCT)}
    <div class="panel panel-default">
      <div class="panel-heading">
        Structurare
      </div>

      <div class="panel-body">
        <ul>
          <li>
            <a href="structChooseEntry.php">Intrări ușor de structurat</a>
            <span class="text-muted">
              100 de cuvinte din DEX cu definiții cât mai scurte
            </span>
          </li>
        </ul>
      </div>
    </div>
  {/if}

  {if User::can(User::PRIV_VISUAL)}
    <div class="panel panel-default">
      <div class="panel-heading">
        Dicționarul vizual
      </div>

      <div class="panel-body">
        <a href="{$wwwRoot}admin/visual.php">dicționarul vizual</a>
      </div>
    </div>
  {/if}

  {if User::can(User::PRIV_WOTD)}
    <div class="panel panel-default">
      <div class="panel-heading">
        Cuvântul + imaginea zilei
      </div>

      <div class="panel-body">
        <ul>
          <li><a href="wotdTable.php">cuvântul zilei</a></li>
          <li><a href="wotdImages.php">imaginea zilei</a></li>
          <li><a href="../autori-imagini.php">autori</a></li>
          <li><a href="../alocare-autori.php">alocarea autorilor</a></li>
        </ul>
      </div>
    </div>
  {/if}
{/block}
