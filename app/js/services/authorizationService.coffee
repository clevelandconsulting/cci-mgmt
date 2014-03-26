class authorizationService
  constructor: (@$q, @credentialStorageService, @apiService) ->
   @init()
   
  init: -> 
   @lastError = 0
   credentials = @credentialStorageService.get()
   if credentials != ''
    @apiService.setCredentials credentials
  
  apiUrl: (url) ->
   @apiService.setUrl(url) 
   
  checkIfLoggedIn: -> 
   creds = @getStoredCredentials()
   #console.log 'Checking Creds', creds
   if creds != '' 
    true
   else
    false
    
  getStoredCredentials: -> @credentialStorageService.get()
  
  doLogin: (username,password) ->
   #clear any previous error 
   @lastError = 0 
   
   @deferred = @$q.defer()
   
   credentials = @credentialStorageService.form(username,password)
   
   success = (response) =>
    @apiService.setCredentials credentials
    @credentialStorageService.save(credentials)  
    @deferred.resolve true
   failure = (response) =>
    if response.status != 401
     #set an error if we didn't get the expected 401
     @lastError = response.status
 
    if response.status != 500
     @apiService.setCredentials ''
     @credentialStorageService.clear()
    
    @deferred.reject false
    
   @apiService.checkCredentials(credentials).then success, failure
   
   @deferred.promise
  
  doLogout: ->
   if @checkIfLoggedIn()
    @credentialStorageService.clear()
   @apiService.clearCredentials() 
     
angular.module('app').factory 'authorizationService', ['$q', 'credentialStorageService', 'cciApiService', ($q, credentialStorageService, cciApiService) -> new authorizationService($q, credentialStorageService, cciApiService) ]