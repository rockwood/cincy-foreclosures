#= require jquery

class window.CincyForclosures
  constructor: (options={})->
    @properties = options.properties
    @map = new google.maps.Map options.el,
      center: new google.maps.LatLng(39.1619, -84.4569)
      zoom: 12
      mapTypeId: google.maps.MapTypeId.ROADMAP

  render: ->
    for property in @properties
      @renderPoint(property)

  renderPoint: (property) ->
    new google.maps.Marker
      map: @map
      position: new google.maps.LatLng(property.latitude, property.longitude);
      title: property.address

$ ->
  cincyForclosures = new CincyForclosures
    properties: window.properties
    el: $("#map").get(0)

  cincyForclosures.render()