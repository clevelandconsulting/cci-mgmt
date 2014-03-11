describe "authorization integration", ->
 Given -> module('app')
 
 Given angular.mock.inject ($injector, $q, $httpBackend, $rootScope, credentialStorageService, cciApiService) ->
  @mockCreds = credentialStorageService
  @mockCCI = cciApiService
  @authorization = $injector.get 'authorizationService', {$q:$q, credentialStorageService:@mockCreds, cciApiService:@mockCCI} 
  @httpBackend = $httpBackend
  @rootScope = $rootScope
  
   
 Then -> expect(@authorization).toBeDefined()
 
 Given ->
  @username = 'foo'
  @password = 'bar'
  @credentials = Base64.encode(@username+':'+@password)
  @successFn = (data) => @success = true
  @failureFn = (data) => @failure = true
  @httpBackend.whenGET('https://fms.clevelandconsulting.com/RESTfm/STEVE/').respond (method, url, data, headers) =>
   if @serverError
    [500,{},{}]
   else
    if headers.Authorization == 'Basic ' + @credentials
     [200,{},{}]
    else
     [401,{},{}] 
    
 describe "doLogin() with valid username & password should succeed", ->  
  
  Given ->
   @loginUser = @username
   @loginPass = @password 
   @serverError = false
   @authorization.credentialStorageService.save('')
   
  When ->
   @promise = @authorization.doLogin(@loginUser,@loginPass)
   @promise.then @successFn, @failureFn
   @httpBackend.flush()
   @rootScope.$apply()
   
  Then -> expect(@success).toBe(true)
  Then -> expect(@authorization.lastError).toBe(0)
  Then -> expect(@authorization.credentialStorageService.get()).toEqual(@credentials)
  
 describe "doLogin() with valid server error should fail and have last error", ->  
  
  Given ->
   @loginUser = @username
   @loginPass = @password 
   @previousCredentials = 'foo'
   @serverError = true
   @authorization.credentialStorageService.save(@previousCredentials)
   
  When ->   
   @promise = @authorization.doLogin(@loginUser,@loginPass)
   @promise.then @successFn, @failureFn
   @httpBackend.flush()
   @rootScope.$apply()
   
  Then -> expect(@failure).toBe(true)
  Then -> expect(@authorization.lastError).toBe(500)
  Then -> expect(@authorization.credentialStorageService.get()).toEqual(@previousCredentials)


 describe "doLogin() with invalid username & password should fail", ->  
  
  Given ->
   @loginUser = 'notfoo'
   @loginPass = 'notbar' 
   @serverError = false
    
  When ->
   @promise = @authorization.doLogin(@loginUser,@loginPass)
   @promise.then @successFn, @failureFn
   @httpBackend.flush()
   @rootScope.$apply()
   
  Then -> expect(@failure).toBe(true)
  Then -> expect(@authorization.lastError).toBe(0)
  Then -> expect(@authorization.credentialStorageService.get()).toEqual('')