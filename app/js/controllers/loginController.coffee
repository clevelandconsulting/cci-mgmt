angular.module('app').controller 'loginController', [ 'authorizationService', 'notifications', '$location', 'userRepository',
 class loginController 
  constructor: (@auth, @notifications, @location, @userRepository) ->
   @username=''
   @password=''
  
  login: ->
   @loginToastr = @notifications.info 'Logging In...'
   success = (response) => 
    #console.log 'login success', response
    @notifications.clear(@loginToastr)
    @notifications.success 'Welcome ' + @username + '!'
    
    repoSuccess = (data) =>
     #console.log 'username retrieved success', data
     @userRepository.saveCurrentUserId(data.recordID)
     @location.path('/time')
    repoFailure = (data) =>
     #console.log 'username retrieved problem', data
     @notifications.error 'Problem getting your username...' + data
    
    @userRepository.getUserByUsername(@username).then repoSuccess, repoFailure  
    
    
   failure = (response) => 
    @notifications.clear(@loginToastr)
    if @auth.lastError == 500
     @notifications.error "Oops, something went wrong! It's our fault not yours. Shoot us an email if this keeps happening!"
    else
     @userRepository.clearCurrentUserId()
     @notifications.error "That's not a valid username and password."
   
   #console.log 'doing login...'
   @auth.doLogin(@username,@password).then success, failure
   
]