angular.module('app').factory 'user', [ 'fmRestModel', (fmRestModel) -> class user extends fmRestModel
 constructor: (data,href,recordID) ->
  super(data,href,recordID)
  
  ###
  if @data == undefined || @href == undefined || @recordID == undefined
   throw error
   
  if (!Date.now) 
    Date.now = -> new Date().getTime()
  
  @lastAccessed = Date.now()
  ###
  @lastAccessed = Date.now()
  
  if @data.filemaker_accountname
   @username = @data.filemaker_accountname
  else
   throw Error 'Invalid data for user'
   
]