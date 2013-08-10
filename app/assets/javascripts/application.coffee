#= require jquery
#= require underscore
#= require angular

window.CF = angular.module('CF', []);

CF.factory 'Property', ->
  class Property
    constructor: (options={})->
      angular.extend this,
        id:             options.id
        address:        options.address
        appraisal:      options.appraisal
        attorney:       options.attorney
        attorneyPhone:  options.attorney_phone
        caseNumber:     options.case_number
        city:           options.city
        latitude:       options.latitude
        longitude:      options.longitude
        minimumBid:     options.minimum_bid
        owner:          options.owner
        plaintiff:      options.plaintiff
        state:          options.state
        township:       options.township
        active:         !options.withdrawn
        zip:            options.zip
        saleDate:       new Date(options.sale_date)
        createdAt:      new Date(options.created_at)
        updatedAt:      new Date(options.updated_at)

CF.factory 'PropertyMarker', ->
  class PropertyMarker
    constructor: (map, property)->
      @map = map
      @property = property
      @marker = @buildMarker()
      @infowindow = @buildInfoWindow()
      @addMarkerListener()

    buildMarker: ->
      new google.maps.Marker
        map: @map
        position: new google.maps.LatLng(@property.latitude, @property.longitude);
        title: @property.address

    buildInfoWindow: ->
      content = @property.address
      new google.maps.InfoWindow
        content: content

    addMarkerListener: ->
      google.maps.event.addListener @marker, 'click', =>
        @infowindow.open(@map, @marker)

    show: ->
      @marker.setVisible(true)

    hide: ->
      @marker.setVisible(false)

CF.factory 'MarkerFilter', ->
  class MarkerFilter
    constructor: (options)->
      @markers = options.markers

    execute: (filters) ->
      for marker in @markers
        marker.hide()
        if filters.showActive && marker.property.active == true
          marker.show()
        if filters.showInactive && marker.property.active == false
          marker.show()

CF.controller 'MapController', ($scope, Property, PropertyMarker, MarkerFilter) ->
  map = new google.maps.Map $('#map__canvas').get(0),
    center: new google.maps.LatLng(39.1619, -84.4569)
    zoom: 12
    mapTypeId: google.maps.MapTypeId.ROADMAP

  propertyMarkers = []

  filters =
    showActive: true
    showInactive: true
    saleDate: null

  for obj in window.propertiesJson
    propertyMarkers.push new PropertyMarker(map, new Property(obj))

  markerFilter = new MarkerFilter(markers: propertyMarkers)

  filter = ->
    markerFilter.execute filters

  $scope.filters = filters

  $scope.$watch 'filters', filter, true


