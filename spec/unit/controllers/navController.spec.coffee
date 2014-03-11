describe "navController", ->
 Given -> module('app')
 Given -> angular.mock.inject ($controller, $location, _authorizationService_) ->
  @location = $location
  @mockAuth = _authorizationService_
  @subject = $controller 'navController', {$location: @location}
  
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
   @location.path('/home')
   @mockAuth.apiService.credentials = 'somecredentials'
   spyOn(@mockAuth.apiService,"clearCredentials").andCallFake =>
    @mockAuth.apiService.credentials = ''
   spyOn(@mockAuth.credentialStorageService,"clear")
   spyOn(@mockAuth,"doLogout").andCallThrough() 
  
  When -> @subject.logout()
  
  Then -> expect(@mockAuth.doLogout).toHaveBeenCalled()
  Then -> expect(@mockAuth.apiService.credentials).toBe('')
  Then -> expect(@location.path()).toBe('/login')