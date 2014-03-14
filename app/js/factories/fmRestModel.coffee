class fmRestModel
 constructor: (@data,@href,@recordID) ->
  
  error = Error 'Invalid data for record'
  
  if @data == undefined || @href == undefined || @recordID == undefined
   throw error
   
  if (!Date.now) 
    Date.now = -> new Date().getTime()
  
   
angular.module('app').factory 'fmRestModel', -> fmRestModel