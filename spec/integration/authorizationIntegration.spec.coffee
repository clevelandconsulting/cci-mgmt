describe "authorization integration", ->
###
 Given -> module ('app')
 Given inject ($injector, $http, $httpBackend, $rootScope) ->
  @restFmAuthorization = $injector.get 'restFMAuthorization' 
  @httpBackend = $httpBackend
  @rootScope = $rootScope
  
   
 Then -> expect(@restFmAuthorization).toBeDefined()
 
 Given ->
  @username = 'foo'
  @password = 'bar'
  @credentials = Base64.encode(@username+':'+@password)
  @successFn = (data) => @success = true
  @failureFn = (data) => @failure = true
  @httpBackend.whenGET('https://fms.clevelandconsulting.com/RESTfm/CCI_Mgmt/').respond (method, url, data, headers) =>
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
   @restFmAuthorization.credentialStorageService.save('')
   
  When ->
   @promise = @restFmAuthorization.doLogin(@loginUser,@loginPass)
   @promise.then @successFn, @failureFn
   @httpBackend.flush()
   @rootScope.$apply()
   
  Then -> expect(@success).toBe(true)
  Then -> expect(@restFmAuthorization.lastError).toBe(0)
  Then -> expect(@restFmAuthorization.credentialStorageService.get()).toEqual(@credentials)
  
 describe "doLogin() with valid server error should fail and have last error", ->  
  
  Given ->
   @loginUser = @username
   @loginPass = @password 
   @previousCredentials = 'foo'
   @serverError = true
   #@restFmAuthorization.apiService.validated = true
   @restFmAuthorization.credentialStorageService.save(@previousCredentials)
   
  When ->   
   @promise = @restFmAuthorization.doLogin(@loginUser,@loginPass)
   @promise.then @successFn, @failureFn
   @httpBackend.flush()
   @rootScope.$apply()
   
  Then -> expect(@failure).toBe(true)
  Then -> expect(@restFmAuthorization.lastError).toBe(500)
  Then -> expect(@restFmAuthorization.credentialStorageService.get()).toEqual(@previousCredentials)


 describe "doLogin() with invalid username & password should fail", ->  
  
  Given ->
   @loginUser = 'notfoo'
   @loginPass = 'notbar' 
   @serverError = false
    
  When ->
   @promise = @restFmAuthorization.doLogin(@loginUser,@loginPass)
   @promise.then @successFn, @failureFn
   @httpBackend.flush()
   @rootScope.$apply()
   
  Then -> expect(@failure).toBe(true)
  Then -> expect(@restFmAuthorization.lastError).toBe(0)
  Then -> expect(@restFmAuthorization.credentialStorageService.get()).toEqual('')
###