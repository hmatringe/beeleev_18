function showNewCommentForm() {
  $(this).parents('.beeleever-post').find('.new_comment').slideDown();
  return false;
}

function ensureCommentBody() {
  var submit = $(this).parents('form').find(":submit");

  if ($(this).val() === '') {
    submit.prop('disabled', true);
  } else {
    submit.prop('disabled', false);
  }
}

function showCommentSavingSpinner() {
  $(this).find('.comment-saving-spinner').css('visibility','visible');
}

function commentSaveSuccess() {
  clearNewCommentForm();
  hideNewCommentForm();
}

function clearNewCommentForm() {
  $("form.new_comment textarea").val('');
  $("form.new_comment :submit").prop('disabled', true);
}

function hideNewCommentForm() {
  $("form.new_comment").slideUp();
  $('.comment-saving-spinner').css('visibility','hidden');
}

$(document).ready(function () {
  $(".start-comment").click(showNewCommentForm);

  $(".new_comment textarea").keyup(ensureCommentBody);
  $("form.new_comment")
    .on("ajax:before", showCommentSavingSpinner)
    .on("ajax:success", commentSaveSuccess)
    .on("ajax:error", postSaveError);
  //
  // $('#show-new-beeleever-post').click(showNewPostFormVisibility);
  // $('#cancel-new-beeleever-post').click(cancelNewPost);
});
