angular.module('app').controller 'loginController', [ 'restFMAuthorization', '$scope', 
 class loginController 
  constructor: (@auth, @scope) ->
   @username=''
   @password=''
  
  login: ->
   success = (response) => @flash = 'Welcome ' + @username + '!'
   failure = (response) => 
    if @auth.lastError == 500
     @flash = "Oops, something went wrong! It's our fault not yours. Shoot us an email if this keeps happening!"
    else
     @flash = "That's not a valid username and password."
    
   @auth.doLogin(@username,@password).then success, failure
   
]