angular.module('app').service 'authorizationService', ['$q', 'credentialStorageService','apiService', class authorizationService
 constructor: (@$q, @credentialStorageService,@apiService) ->
 
 checkIfLoggedIn: -> @apiService.isValidated()
 
 getStoredCredentials: -> @credentialStorageService.get()
 
 allowedAccess: -> 
  #start by creating a deferred promise
  @deferred = @$q.defer()
  
  #check if the user is already logged in (apiService is validated)
  loggedIn = @checkIfLoggedIn()
  
  if !loggedIn
   #if they're not logged in, check to see if they have any stored credentials
   credentials = @getStoredCredentials()
    
   if credentials != ''  
    #if they have stored credentials, check the api service to see if the credentials are valid
    success = (data) => @deferred.resolve true
    failure = (data) => @deferred.reject false
    @apiService.checkCredentials(credentials).then success, failure
    
   else
    #no credentials stored, so they're not allowed
    @deferred.reject false
  else
   #they're logged in already, so they're allowed
   @deferred.resolve true
   
  #return the promise 
  @deferred.promise

]