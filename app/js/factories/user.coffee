class user
 constructor: (@data,@href,@recordID) ->
  
  error = Error 'Invalid data for user'
  
  if @data == undefined || @href == undefined || @recordID == undefined
   throw error
   
  if (!Date.now) 
    Date.now = -> new Date().getTime()
  
  @lastAccessed = Date.now()
  
  
  if @data.filemaker_accountname
   @username = @data.filemaker_accountname
  else
   throw error
   
angular.module('app').factory 'user', -> user