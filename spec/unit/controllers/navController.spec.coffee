describe "navController", ->
 Given -> module('app')
 Given -> angular.mock.inject ($controller, $location, $rootScope, $q, _authorizationService_, _userRepository_) ->
  @location = $location
  @rootScope = $rootScope
  @q = $q
  @mockAuth = _authorizationService_
  @mockRepo = _userRepository_
  @subject = $controller 'navController', {$location: @location, authorizationService: @mockAuth, userRepository:@mockRepo }
  
 Then -> expect(@subject).toBeDefined()
 
 describe "isLoggedIn() when logged in", ->
  Given ->
   @location.path('/home')
   spyOn(@mockAuth,"checkIfLoggedIn").andReturn(true)
 
  When -> @result = @subject.isLoggedIn()
  
  Then -> expect(@mockAuth.checkIfLoggedIn).toHaveBeenCalled()
  Then -> expect(@result).toBe(true)
  
 describe "isLoggedIn() when not logged in", ->
  Given ->
   @location.path('/login')
   spyOn(@mockAuth,"checkIfLoggedIn").andReturn(false)
 
  When -> @result = @subject.isLoggedIn()
  
  Then -> expect(@mockAuth.checkIfLoggedIn).toHaveBeenCalled()
  Then -> expect(@result).toBe(false)
  
 
 describe "logout()", ->
  Given ->
   @subject.username = 'anytest'
   @location.path('/home')
   @mockAuth.apiService.credentials = 'somecredentials'
   spyOn(@mockAuth.apiService,"clearCredentials").andCallFake =>
    @mockAuth.apiService.credentials = ''
   spyOn(@mockAuth.credentialStorageService,"clear")
   spyOn(@mockAuth,"doLogout").andCallThrough() 
   spyOn(@mockRepo,"clearCurrentUserId")
   
  When -> @subject.logout()
  
  Then -> expect(@mockAuth.doLogout).toHaveBeenCalled()
  Then -> expect(@mockAuth.apiService.credentials).toBe('')
  Then -> expect(@mockRepo.clearCurrentUserId).toHaveBeenCalled()
  Then -> expect(@location.path()).toBe('/login')
  Then -> expect(@subject.username).not.toBeDefined()
  
 describe "getUsername() when user exists", ->
  Given ->
   @username = 'somename'
   @user = {username:@username, recordID:2, href:'', data:{}} 
   spyOn(@mockRepo,"getCurrentUser").andCallFake =>
    @q.when @user
   
  When -> 
   @promise = @subject.getUsername()
   @promise.then (data) => @result = data
   @rootScope.$apply()
   
  Then -> expect(@mockRepo.getCurrentUser).toHaveBeenCalled()
  Then -> expect(@result).toEqual @user
  Then -> expect(@subject.username).toEqual @username
   