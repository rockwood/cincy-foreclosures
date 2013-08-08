#= require jquery
#= require underscore
#= require angular

window.CF = angular.module('CF', []);

CF.factory 'properties', ->
  propertiesArray = []

  for property in window.properties
    propertiesArray.push
      id:             property.id
      address:        property.address
      appraisal:      property.appraisal
      attorney:       property.attorney
      attorneyPhone:  property.attorney_phone
      caseNumber:     property.case_number
      city:           property.city
      latitude:       property.latitude
      longitude:      property.longitude
      minimumBid:     property.minimum_bid
      owner:          property.owner
      plaintiff:      property.plaintiff
      state:          property.state
      township:       property.township
      withdrawn:      property.withdrawn
      zip:            property.zip
      sale_date:      new Date(property.sale_date)
      createdAt:      new Date(property.created_at)
      updatedAt:      new Date(property.updated_at)

  propertiesArray

CF.factory 'Map', (properties) ->
  class Map
    constructor: (options={})->
      @properties = properties
      @map = new google.maps.Map options.el,
        center: new google.maps.LatLng(39.1619, -84.4569)
        zoom: 12
        mapTypeId: google.maps.MapTypeId.ROADMAP

    render: ->
      for property in @properties
        property.marker = @renderMarker(property)
        property.infowindow = @renderInfoWindow(property)
        @addMarkerListener(property.marker, property.infowindow)

    renderMarker: (property) ->
      new google.maps.Marker
        map: @map
        position: new google.maps.LatLng(property.latitude, property.longitude);
        title: property.address

    renderInfoWindow: (property) ->
      content = "withdrawn: " + property.withdrawn
      new google.maps.InfoWindow
        content: content

    addMarkerListener: (marker, infowindow) ->
      google.maps.event.addListener marker, 'click', ->
        infowindow.open(@map, marker)

    showAllMarkers: ->
      for property in @properties
        property.marker.setVisible(true)

    hideAllMarkers: ->
      for property in @properties
        property.marker.setVisible(false)

    filterMarkers: (query) ->
      return if query == false
      @hideAllMarkers()
      for property in _(@properties).where(query)
        property.marker.setVisible(true)

CF.controller 'MapController', ($scope, Map) ->
  map = new Map(el: $('#map__canvas').get(0))
  map.render()
  $scope.showWithdrawn = false
  $scope.properties = map.properties

  filter = (query) ->
    return $scope.properties = properties.all if query == false
    $scope.properties = properties.where(query)

  $scope.$watch 'showWithdrawn', ->
    if $scope.showWithdrawn == true
      map.showAllMarkers()
    else
      map.filterMarkers(withdrawn: false)


