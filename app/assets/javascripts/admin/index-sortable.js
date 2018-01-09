$(document).ready(function() {

  // Generic code to handle sorting in all index tables of ActiveAdmin
  $("td .handle")
    .parents("tbody")
    .sortable({
      handle: ".handle",
      axis: 'y',
      update: function(event, ui) {

        var indexTableName = $(this).parent().attr('id');
        var resourcesName  = indexTableName.replace('index_table_', '');

        // a real singularize method would have been better
        var resourceName   = resourcesName.slice(0, -1);
        var url            = '/admin/' + resourcesName + '/sort';

        var ids = $(this).find('tr').map(function(i, e) {
          return $(e).attr('id').replace(resourceName + "_", '');
        });

        $.post(url, {ids: ids.get()});
      }
    });

});
