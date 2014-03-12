class user
 constructor: (@data,@href,@recordID) ->
  if (!Date.now) 
    Date.now = -> new Date().getTime()
  
  @lastAccessed = Date.now()
 
angular.module('app').factory 'user', -> user