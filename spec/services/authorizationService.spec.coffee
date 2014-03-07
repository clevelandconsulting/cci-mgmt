describe "authorizatonService", ->
 Given -> module ('app')
 
 Given angular.mock.inject (credentialStorageService, apiService) ->
  @mockCredentialStorageService = credentialStorageService
  @mockApiService = apiService
  
 Given inject ($injector, $q, $rootScope) ->
  @q = $q
  @rootScope = $rootScope
  @subject = $injector.get 'authorizationService', { $q: @q, credentialStorageService: @mockCredentialStorageService, apiService: @mockApiService }
  #simulate a previous error
  @subject.lastError = 500
  
 Then -> expect(@subject).toBeDefined()
 Then -> expect(@subject.credentialStorageService).toBe(@mockCredentialStorageService)
 Then -> expect(@subject.apiService).toBe(@mockApiService)
 
 describe "apiUrl()", ->
  Given ->
   spyOn(@mockApiService,"setUrl")
   @url = 'some/url'
   @mockApiService.url = @url
   
  When -> @subject.apiUrl(@url)
  Then -> expect(@mockApiService.setUrl).toHaveBeenCalledWith(@url)
  Then -> expect(@subject.apiService.url).toBe(@url)
 
 describe "checkIfLoggedIn() when api service validated", ->
  Given ->
   @loggedIn = true;
   spyOn(@mockApiService, 'isValidated').andReturn(@loggedIn)
   
  When -> @result = @subject.checkIfLoggedIn()
  
  Then -> expect(@mockApiService.isValidated).toHaveBeenCalled()
  Then -> expect(@result).toBe(@loggedIn)
  
 describe "checkIfLoggedIn() when api service not validated", ->
  Given ->
   @loggedIn = false;
   spyOn(@mockApiService, 'isValidated').andReturn(@loggedIn)
   
  When -> @result = @subject.checkIfLoggedIn()
  
  Then -> expect(@mockApiService.isValidated).toHaveBeenCalled()
  Then -> expect(@result).toBe(@loggedIn)
  
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


  
 describe "allowedAccess()", ->
  Given -> 
   @credentials = 'foobar'
   
   @successFn = (data) => @success = true
   @failureFn = (data) => @failure = true
   
   spyOn(@mockApiService, 'isValidated').andReturn(@isValidated)
   spyOn(@mockApiService, 'checkCredentials').andCallFake =>
    if @succeedPromise
     @q.when 'foo'
    else
     @q.reject @response
  
  describe "when api service is validated", ->
   Given ->
    @isValidated = true
    spyOn(@mockCredentialStorageService,"get").andReturn(@credentials)
     
   When ->
    @succeedPromise = true
    @promise = @subject.allowedAccess()
    @promise.then @successFn, @failureFn
    @rootScope.$apply()
  
   Then -> expect(@mockApiService.isValidated).toHaveBeenCalled()
   Then -> expect(@success).toBe(true)
   Then -> expect(@subject.lastError).toBe(0)
  
  describe "when api service not validated but has stored valid credentials", ->
   Given -> 
    @isValidated = false
    spyOn(@mockCredentialStorageService,"get").andReturn(@credentials)
    
   When ->
    @status = 200
    @response = {status:@status,data:''}
    @succeedPromise = true
    @promise = @subject.allowedAccess()
    @promise.then @successFn, @failureFn
    @rootScope.$apply()
    
    
   Then -> expect(@mockApiService.isValidated).toHaveBeenCalled()
   Then -> expect(@mockCredentialStorageService.get).toHaveBeenCalled()
   Then -> expect(@mockApiService.checkCredentials).toHaveBeenCalledWith(@credentials)
   Then -> expect(@success).toBe(true)
   Then -> expect(@subject.lastError).toBe(0)
   
  describe "when api service not validated and has stored invalid credentials", ->
   Given -> 
    @isValidated = false
    spyOn(@mockCredentialStorageService,"get").andReturn(@credentials)
    
   When ->
    @succeedPromise = false
    @status = 401
    @response = {status:@status,data:''}
    @promise = @subject.allowedAccess()
    @promise.then @successFn, @failureFn
    @rootScope.$apply()
    
    
   Then -> expect(@mockApiService.isValidated).toHaveBeenCalled()
   Then -> expect(@mockCredentialStorageService.get).toHaveBeenCalled()
   Then -> expect(@mockApiService.checkCredentials).toHaveBeenCalledWith(@credentials)
   Then -> expect(@failure).toBe(true) 
   Then -> expect(@subject.lastError).toBe(0)
   
  describe "when api service not validated and has stored invalid credentials and other than 401", ->
   Given -> 
    @isValidated = false
    spyOn(@mockCredentialStorageService,"get").andReturn(@credentials)
    
   When ->
    @succeedPromise = false
    @status = 500
    @response = {status:@status,data:''}
    @promise = @subject.allowedAccess()
    @promise.then @successFn, @failureFn
    @rootScope.$apply()
    
    
   Then -> expect(@mockApiService.isValidated).toHaveBeenCalled()
   Then -> expect(@mockCredentialStorageService.get).toHaveBeenCalled()
   Then -> expect(@mockApiService.checkCredentials).toHaveBeenCalledWith(@credentials)
   Then -> expect(@failure).toBe(true) 
   Then -> expect(@subject.lastError).toBe(@status)
   
  describe "when api service not validated and has no stored credentials", ->
   Given -> 
    @credentials = ''
    @isValidated = false
    spyOn(@mockCredentialStorageService,"get").andReturn(@credentials)
    
   When ->
    @promise = @subject.allowedAccess()
    @promise.then @successFn, @failureFn
    @rootScope.$apply()
    
    
   Then -> expect(@mockApiService.isValidated).toHaveBeenCalled()
   Then -> expect(@mockCredentialStorageService.get).toHaveBeenCalled()
   Then -> expect(@mockApiService.checkCredentials).not.toHaveBeenCalled()
   Then -> expect(@failure).toBe(true) 
   Then -> expect(@subject.lastError).toBe(0)
   
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
   Then -> expect(@failure).toBe(true)
   Then -> expect(@subject.lastError).toBe(@status)
    
    