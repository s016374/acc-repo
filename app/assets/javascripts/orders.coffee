# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@selectItem = (element) ->
  # request controller#action
  $.ajax {
    url: '/orders/get_items'
    type: 'get'
    data: "item_keyword=#{element.value}"
    dataType: 'html'
    success: (data, status, xhr) ->
      console.log 'ajax.success'
    error: (data, status, xhr) ->
      console.log 'ajax.error'
  }
  # ajax response
  .done (html) ->
    # review item infomation, display:none -> display html
    $("div#get_item").html(html)
    $("div#get_item").removeClass('hide')
