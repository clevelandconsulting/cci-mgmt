angular.module('app').factory 'user', [ 'fmRestModel', (fmRestModel) -> class user extends fmRestModel
 constructor: (data,href,recordID) ->
  super(data,href,recordID)
  @lastAccessed = Date.now()
  
  if @data.filemaker_accountname
   @username = @data.filemaker_accountname
  else
   throw Error 'Invalid data for user'
  
  if @data.filemaker_accountprivilege == '[Full Access]'
   @canSeeOthers = true
  else
   @canSeeOthers = false
]