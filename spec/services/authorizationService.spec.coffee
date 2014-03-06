describe "authorizatonService", ->
 Given -> module ('app')
 
 Given angular.mock.inject (credentialStorageService, apiService) ->
  @mockCredentialStorageService = credentialStorageService
  @mockApiService = apiService
  
 Given inject ($injector, $q, $rootScope) ->
  @q = $q
  @rootScope = $rootScope
  @subject = $injector.get 'authorizationService', { $q: @q, credentialStorageService: @mockCredentialStorageService, apiService: @mockApiService }
  
 Then -> expect(@subject).toBeDefined()
 Then -> expect(@subject.credentialStorageService).toBe(@mockCredentialStorageService)
 Then -> expect(@subject.apiService).toBe(@mockApiService)
 
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
     @q.when @validated
    else
     @q.reject false
  
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
  
  describe "when api service not validated but has stored valid credentials", ->
   Given -> 
    @isValidated = false
    spyOn(@mockCredentialStorageService,"get").andReturn(@credentials)
    
   When ->
    @succeedPromise = true
    @promise = @subject.allowedAccess()
    @promise.then @successFn, @failureFn
    @rootScope.$apply()
    
    
   Then -> expect(@mockApiService.isValidated).toHaveBeenCalled()
   Then -> expect(@mockCredentialStorageService.get).toHaveBeenCalled()
   Then -> expect(@mockApiService.checkCredentials).toHaveBeenCalledWith(@credentials)
   Then -> expect(@success).toBe(true)
   
  describe "when api service not validated and has stored invalid credentials", ->
   Given -> 
    @isValidated = false
    spyOn(@mockCredentialStorageService,"get").andReturn(@credentials)
    
   When ->
    @succeedPromise = false
    @promise = @subject.allowedAccess()
    @promise.then @successFn, @failureFn
    @rootScope.$apply()
    
    
   Then -> expect(@mockApiService.isValidated).toHaveBeenCalled()
   Then -> expect(@mockCredentialStorageService.get).toHaveBeenCalled()
   Then -> expect(@mockApiService.checkCredentials).toHaveBeenCalledWith(@credentials)
   Then -> expect(@failure).toBe(true) 
   
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

   