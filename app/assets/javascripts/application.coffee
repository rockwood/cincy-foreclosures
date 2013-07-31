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
      marker = @renderMarker(property)
      infowindow = @renderInfoWindow(property)
      @addMarkerListener(marker, infowindow)


  renderMarker: (property) ->
    new google.maps.Marker
      map: @map
      position: new google.maps.LatLng(property.latitude, property.longitude);
      title: property.address

  renderInfoWindow: (property) ->
    content = ""
    for key, value of property
      content += "<dl class='info__list'><dt>#{key}: </dt><dd>#{value}</dd></dl>"
    new google.maps.InfoWindow
      content: content

  addMarkerListener: (marker, infowindow) ->
    google.maps.event.addListener marker, 'click', ->
      infowindow.open(@map, marker)

$ ->
  cincyForclosures = new CincyForclosures
    properties: window.properties
    el: $("#map").get(0)

  cincyForclosures.render()