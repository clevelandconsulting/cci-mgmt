class fmRestList
 constructor: (object, model) ->
  @nav = {}
  @items = []
  if object?
   if object.nav?   
    #assume that we have a full object sent
    @loadNav(object.nav)
   else
    if !object.data?
    #assume we have just a nav object
     @loadNav(object)
   
   if object.data? and object.meta? and model?
     @loadItems(object.data,object.meta,model)
 
 
 loadNav: (nav) ->
  for item in nav
   @nav[item.name] = item.href
 
 loadItems: (data,meta,model) ->
  for item, i in data
   m = new model item, meta[i].href, meta[i].recordID
   @items.push m
 
 getNav: (key) ->
  if @nav?
   @nav[key]
 
 totalByKey: (key) ->
  total = 0
  for item in @items
   if item.data[key]?
    value = parseFloat(item.data[key])
    if !isNaN(value) && isFinite(item.data[key])
     total = total + value
  
  return total
  
 next: ->
  @getNav('next')
   
 previous: ->
  @getNav('prev')
 
 start: ->
  @getNav('start')
 
 end: ->
  @getNav('end')
  
 hasPaging: ->
  @next()? || @previous()?
  
 hasNext: ->
  @next()?
 
 hasPrevious: ->
  @previous()?
 
angular.module('app').factory 'fmRestList', -> fmRestList