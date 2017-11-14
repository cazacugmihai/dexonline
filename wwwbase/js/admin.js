$(function() {
  /* Page modal code (loading and displaying original (scanned) images of dictionary pages) */
  var urlPattern;
  var sourceId;
  var volume;
  var page;
  
  function init() {
    // move the modal outside of any tabs
    $('#pageModal').appendTo('body');

    $('#pageModal').on('shown.bs.modal', modalShown);
    $('#pageModal').on('hidden.bs.modal', modalHidden);
    $('.prevPage').click(prevPageClick);
    $('.nextPage').click(nextPageClick);
  }

  function modalShown(event) {
    $(document).bind('keydown', 'left', prevPageClick);
    $(document).bind('keydown', 'right', nextPageClick);

    var link = $(event.relatedTarget); // link that triggered the modal
    sourceId = link.attr('data-sourceId');
    var word = link.attr('data-word');

    // resolve the sourceId + word to a volume + page
    $.get(wwwRoot + 'ajax/getPage.php', { sourceId: sourceId, word: word, })
      .done(function(data) {
        urlPattern = data.urlPattern;
        volume = data.volume;
        page = data.page;
        loadPage();
      })
      .fail(function(e) {
        $('#pageImage').hide();
        $('#pageModal .alert').text(e.responseText).show();
      });
  }

  function modalHidden() {
    $(document).unbind('keydown', prevPageClick);
    $(document).unbind('keydown', nextPageClick);
  }

  function prevPageClick() {
    page--;
    loadPage();
  }

  function nextPageClick() {
    page++;
    loadPage();
  }

  function loadPage() {
    $('#pageModal .alert').hide();
    $('#pageModalSpinner').show();

    var url = sprintf(urlPattern, sourceId, volume, page);

    $('#pageImage').one('load', function() {
      $('#pageModalSpinner').hide();
    }).one('error', function() {
      $('#pageModal .alert').text('Pagina cerută nu există.').show();
      $('#pageModalSpinner').hide();
    }).attr('src', url);
  }

  init();
});
