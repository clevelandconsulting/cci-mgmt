angular.module('app').controller 'loginController', [ 'restFMAuthorization', 'notifications', '$scope', '$location'
 class loginController 
  constructor: (@auth, @notifications, @scope, @location) ->
   @username=''
   @password=''
  
  login: ->
   @loginToastr = @notifications.info 'Logging In...'
   success = (response) => 
    @notifications.clear(@loginToastr)
    @notifications.success 'Welcome ' + @username + '!'
 
    @location.path('/home')
   failure = (response) => 
    @notifications.clear(@loginToastr)
    if @auth.lastError == 500
     @notifications.error "Oops, something went wrong! It's our fault not yours. Shoot us an email if this keeps happening!"
    else
     @notifications.error "That's not a valid username and password."
    
   @auth.doLogin(@username,@password).then success, failure
   
]