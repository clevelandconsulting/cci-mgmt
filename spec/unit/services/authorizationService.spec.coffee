describe "authorizatonService", ->
 Given -> module ('app')
 
 Given angular.mock.inject ($injector, $q, $rootScope, $http, _credentialStorageService_, _cciApiService_) ->
  @mockCredentialStorageService = _credentialStorageService_   
  @mockApiService = _cciApiService_
  @q = $q
  @rootScope = $rootScope
  @injector = $injector
  @mock2 = $injector.get 'credentialStorageService'
  @services = { $q: @q, credentialStorageService: @mockCredentialStorageService, $http: $http, apiService: @mockApiService }
  @subject = @injector.get 'authorizationService', @services
  @subject.lastError = 500
  
 describe "init() when no stored credentials", ->
  Given -> 
   @creds = ''
   spyOn(@mockCredentialStorageService, "get").andReturn @creds
   spyOn(@mockApiService,"setCredentials").andCallFake =>
    @mockApiService.credentials = @creds
  
  When -> @subject.init()
   
  Then -> expect(@subject).toBeDefined()
  Then -> expect(@subject.credentialStorageService).toBe(@mockCredentialStorageService)
  Then -> expect(@subject.apiService).toBe(@mockApiService)
  Then -> expect(@mockCredentialStorageService.get).toHaveBeenCalled()
  Then -> expect(@mockApiService.setCredentials).not.toHaveBeenCalledWith(@creds)
  Then -> expect(@subject.getStoredCredentials()).toEqual(@creds)
  Then -> expect(@mockApiService.credentials).toBe(@creds)
 
 describe "constructor when there is a stored credential", ->
  Given -> 
   @creds = 'foo'
   spyOn(@mockCredentialStorageService, "get").andReturn @creds
   spyOn(@mockApiService,"setCredentials").andCallFake =>
    @mockApiService.credentials = @creds
    
  When -> @subject.init()
   
  Then -> expect(@subject).toBeDefined()
  Then -> expect(@subject.credentialStorageService).toBe(@mockCredentialStorageService)
  Then -> expect(@subject.apiService).toBe(@mockApiService)
  Then -> expect(@mockCredentialStorageService.get).toHaveBeenCalled()
  Then -> expect(@mockApiService.setCredentials).toHaveBeenCalledWith(@creds)
  Then -> expect(@mockApiService.credentials).toEqual @creds

 describe "apiUrl()", ->
  Given ->
   spyOn(@mockApiService,"setUrl")
   @url = 'some/url'
   @mockApiService.url = @url
   
  When -> @subject.apiUrl(@url)
  Then -> expect(@mockApiService.setUrl).toHaveBeenCalledWith(@url)
  Then -> expect(@subject.apiService.url).toBe(@url)
 
 describe "checkIfLoggedIn() when credentials present", ->
  Given ->
   @credentials = 'something'
   spyOn(@mockCredentialStorageService, 'get').andReturn(@credentials)
   
  When -> @result = @subject.checkIfLoggedIn()
  
  Then -> expect(@mockCredentialStorageService.get).toHaveBeenCalled()
  Then -> expect(@result).toBe(true)
  
 describe "checkIfLoggedIn() when credentials not present", ->
  Given ->
   @credentials = ''
   spyOn(@mockCredentialStorageService, 'get').andReturn(@credentials)
   
  When -> @result = @subject.checkIfLoggedIn()
  
  Then -> expect(@mockCredentialStorageService.get).toHaveBeenCalled()
  Then -> expect(@result).toBe(false)
  
 describe "getStoredCredentials() when credentials exist", ->
  Given ->
   @credentials = 'foobar'
   spyOn(@mockCredentialStorageService,"get").andReturn(@credentials)
   
  When -> @result = @subject.getStoredCredentials()
  
  Then -> expect(@mockCredentialStorageService.get).toHaveBeenCalled()
  Then -> expect(@result).toBe(@credentials)
  
 describe "getStoredCredentials() when credentials don't exist", ->
  Given ->
   @credentials = ''
   spyOn(@mockCredentialStorageService,"get").andReturn(@credentials)
   
  When -> @result = @subject.getStoredCredentials()
  
  Then -> expect(@mockCredentialStorageService.get).toHaveBeenCalled()
  Then -> expect(@result).toBe(@credentials)
 
 describe "doLogin()", ->
  Given ->
   @successFn = (data) => 
    @success = true
   @failureFn = (data) =>
    @failure = true
   
   @username = 'foo'
   @password = 'bar'
   @credentials = Base64.encode(@username + ':' + @password)
   spyOn(@mockCredentialStorageService,'form').andReturn(@credentials) 
   spyOn(@mockCredentialStorageService,'save')
   spyOn(@mockCredentialStorageService,'clear')
   spyOn(@mockApiService, 'checkCredentials').andCallFake =>
    if @succeedPromise
     @q.when @response
    else
     @q.reject @response
     
  describe "when the credentials are valid and service responds correctly", ->
   Given -> @succeedPromise = true
     
   When ->
    @status = 200
    @response = {status:@status,data:''}
    @promise = @subject.doLogin(@username,@password)
    @promise.then @successFn, @failureFn
    @rootScope.$apply()
   
   Then -> expect(@mockCredentialStorageService.form).toHaveBeenCalledWith(@username,@password) 
   Then -> expect(@mockApiService.checkCredentials).toHaveBeenCalledWith(@credentials)
   Then -> expect(@mockCredentialStorageService.save).toHaveBeenCalledWith(@credentials)
   Then -> expect(@success).toBe(true)
   Then -> expect(@subject.lastError).toBe(0)
 
  describe "when the credentials are invalid and service responds 401", ->
   Given -> @succeedPromise = false
     
   When ->
    @status = 401
    @response = {status:@status,data:''}
    @promise = @subject.doLogin(@username,@password)
    @promise.then @successFn, @failureFn
    @rootScope.$apply()
   
   Then -> expect(@mockCredentialStorageService.form).toHaveBeenCalledWith(@username,@password) 
   Then -> expect(@mockApiService.checkCredentials).toHaveBeenCalledWith(@credentials)
   Then -> expect(@mockCredentialStorageService.save).not.toHaveBeenCalledWith(@credentials)
   Then -> expect(@mockCredentialStorageService.clear).toHaveBeenCalled()
   Then -> expect(@failure).toBe(true)
   Then -> expect(@subject.lastError).toBe(0)
   
  describe "when the responds with anything other than valid or 401", ->
   Given -> @succeedPromise = false
     
   When ->
    @status = 500
    @response = {status:@status,data:''}
    @promise = @subject.doLogin(@username,@password)
    @promise.then @successFn, @failureFn
    @rootScope.$apply()
   
   Then -> expect(@mockCredentialStorageService.form).toHaveBeenCalledWith(@username,@password) 
   Then -> expect(@mockApiService.checkCredentials).toHaveBeenCalledWith(@credentials)
   Then -> expect(@mockCredentialStorageService.save).not.toHaveBeenCalledWith(@credentials)
   Then -> expect(@mockCredentialStorageService.clear).not.toHaveBeenCalled()
   Then -> expect(@failure).toBe(true)
   Then -> expect(@subject.lastError).toBe(@status)
 
 describe 'doLogout() when there are credentials', ->
  
  Given ->
   @credentials = 'something'
   spyOn(@mockCredentialStorageService, 'get').andReturn(@credentials)
   spyOn(@mockCredentialStorageService, "clear")
   spyOn(@mockApiService,"clearCredentials").andCallFake =>
    @mockApiService.credentials = ''
   
  When -> @subject.doLogout()
  
  Then -> expect(@mockCredentialStorageService.get).toHaveBeenCalled()
  Then -> expect(@mockApiService.clearCredentials).toHaveBeenCalled()
  Then -> expect(@mockApiService.credentials).toBe('')
  Then -> expect(@mockCredentialStorageService.clear).toHaveBeenCalled()
 
 describe 'doLogout() when there no credentials', ->
  
  Given ->
   @credentials = ''
   spyOn(@mockCredentialStorageService, 'get').andReturn(@credentials)
   spyOn(@mockCredentialStorageService, "clear")
   spyOn(@mockApiService,"clearCredentials").andCallFake =>
    @mockApiService.credentials = ''
   
  When -> @subject.doLogout()
  
  Then -> expect(@mockCredentialStorageService.get).toHaveBeenCalled()
  Then -> expect(@mockApiService.clearCredentials).toHaveBeenCalled()
  Then -> expect(@mockApiService.credentials).toBe('')
  Then -> expect(@mockCredentialStorageService.clear).not.toHaveBeenCalled()
   