$(document).on('turbolinks:load', function() {
  $('.datepicker').pickadate({
    selectMonths: true,
    selectYears: 5,
    today: 'Today',
    clear: 'Clear',
    close: 'Ok',
    closeOnSelect: true,
    format: 'dd/mm/yyyy'
  });
});
