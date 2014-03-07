angular.module('app').service 'authorizationService', ['$q', 'credentialStorageService','apiService', class authorizationService
 constructor: (@$q, @credentialStorageService,@apiService) ->
  @lastError = 0
 
 apiUrl: (url) ->
  @apiService.setUrl(url) 
  
 checkIfLoggedIn: -> @apiService.isValidated()
 
 getStoredCredentials: -> @credentialStorageService.get()
 
 allowedAccess: ->
  #clear any previous error 
  @lastError = 0
 
  #start by creating a deferred promise
  @deferred = @$q.defer()
  
  #check if the user is already logged in (apiService is validated)
  loggedIn = @checkIfLoggedIn()
  
  if !loggedIn
   #if they're not logged in, check to see if they have any stored credentials
   credentials = @getStoredCredentials()
   if credentials != ''  
    #if they have stored credentials, check the api service to see if the credentials are valid
    success = (response) => 
     @deferred.resolve true
    failure = (response) => 
     if response.status != 401
      #set an error if we didn't get the expected 401
      @lastError = response.status
     @deferred.reject false
          
    @apiService.checkCredentials(credentials).then success, failure
    
   else
    #no credentials stored, so they're not allowed
    @deferred.reject false
  else
   #they're logged in already, so they're allowed
   @deferred.resolve true
   
  #return the promise 
  @deferred.promise

 doLogin: (username,password) ->
  #clear any previous error 
  @lastError = 0 
 
  @deferred = @$q.defer()
  
  credentials = @credentialStorageService.form(username,password)
  
  success = (response) =>
   @credentialStorageService.save(credentials)  
   @deferred.resolve true
  failure = (response) =>
   if response.status != 401
    #set an error if we didn't get the expected 401
    @lastError = response.status
   if response.status != 500
    @credentialStorageService.clear()
   
   @deferred.reject false
   
  @apiService.checkCredentials(credentials).then success, failure
  
  @deferred.promise

]