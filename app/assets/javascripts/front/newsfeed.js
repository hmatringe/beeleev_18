var _throttleTimer = null;
var _throttleDelay = 100;
var nextPage = 2;

function postSaveSuccess(e, data, status, xhr) {
  clearNewPostForm();
  hideNewPostFormVisibility();
}

function postSaveError(e, xhr, status, error) {
  $("#new_beeleever_post").append("<p>ERROR</p>");
}

function clearNewPostForm() {
  $("#new_beeleever_post textarea").val('');
  ensurePostBody();
  $("[name*='illustration']").remove();
  $("#new_beeleever_post .preview img").attr('src', '');
  $('.preview').slideUp();
}

function showNewPostFormVisibility() {
  $("#new_beeleever_post").slideDown();
  $('#show-new-beeleever-post').addClass('disabled');
}

function hideNewPostFormVisibility() {
  $("#new_beeleever_post").slideUp();
  $('#show-new-beeleever-post').removeClass('disabled');
  $('#beeleever-post-saving-spinner').css('visibility','hidden');
  $('#cancel-new-beeleever-post').show();
}

function cancelNewPost() {
  postSaveSuccess();
  return false;
}

function showBeeleeverPostSavingSpinner() {
  $('#beeleever-post-saving-spinner').css('visibility', 'visible');
  $('#cancel-new-beeleever-post').hide();
}

function fileuploadstart() {
  $('.preview').slideDown();
  $('.preview .progress').show();
  $("#new_beeleever_post :submit").prop('disabled', true);
}

function fileuploadprogress(e, data) {
  $('.preview .progress-bar').css(
    'width',
    Math.round((data.loaded * 100.0) / data.total) + '%'
  );
}

function cloudinarydone(e, data) {
  var imageUrl = $.cloudinary.url(
    data.result.public_id,
    {
      format: data.result.format,
      version: data.result.version,
      crop: 'scale',
      height: 80
    }
  );

  $('.preview .progress-bar').css('width', '0%');
  $('.preview .progress').hide();
  $('.preview img').attr('src', imageUrl);
  ensurePostBody();

  return true;
}

// see http://stackoverflow.com/questions/3898130/check-if-a-user-has-scrolled-to-the-bottom
function getDocHeight() {
  var D = document;

  return Math.max(
    D.body.scrollHeight, D.documentElement.scrollHeight,
    D.body.offsetHeight, D.documentElement.offsetHeight,
    D.body.clientHeight, D.documentElement.clientHeight
  );
}

function ScrollHandler(e) {
  //throttle event:
  clearTimeout(_throttleTimer);
  _throttleTimer = setTimeout(function () {

    //do work
    if ($(window).scrollTop() + $(window).height() > getDocHeight() - 100) {
      $('#beeleever-post-pagination-spinner').css('visibility','visible');
      getNextPage();
    }

  }, _throttleDelay);
}

function getNextPage() {
  $.get(
    'http://beeleev.lvh.me:5000/beeleever_posts',
    {page: nextPage},
    function () {
      nextPage += 1;
      $('#beeleever-post-pagination-spinner').css('visibility','hidden');
    }
  );
}

function ensurePostBody() {
  var submit = $("#new_beeleever_post :submit");

  if ($('#beeleever_post_body').val() === '') {
    submit.prop('disabled', true);
  } else {
    submit.prop('disabled', false);
  }
}

$(document).ready(function () {
  $("#beeleever_post_body").keyup(ensurePostBody);

  $("#new_beeleever_post")
    .on("ajax:before", showBeeleeverPostSavingSpinner)
    .on("ajax:success", postSaveSuccess)
    .on("ajax:error", postSaveError);

  $('#show-new-beeleever-post').click(showNewPostFormVisibility);
  $('#cancel-new-beeleever-post').click(cancelNewPost);

  $('.cloudinary-fileupload').bind('fileuploadstart', fileuploadstart);
  $('.cloudinary-fileupload').bind('fileuploadprogress', fileuploadprogress);
  $('.cloudinary-fileupload').bind('cloudinarydone', cloudinarydone);

  if (window.location.pathname === '/newsfeed') {
    $(window)
      .off('scroll', ScrollHandler)
      .on('scroll', ScrollHandler);
  }
});
