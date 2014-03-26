describe "loginController", ->
 Given -> module('app')
 
 Given angular.mock.inject (authorizationService, notifications, userRepository, routeValidation) ->
  @mockRestFMAuthorization = authorizationService
  @mockNotifications = notifications
  @mockRepository = userRepository
  @mockRouteValidation = routeValidation
 
 Given inject ($controller, $rootScope, $q, $location) ->
  @scope = $rootScope.$new()
  @location = $location
  @q = $q
  @subject = $controller 'loginController', {restFMAuthorization: @mockRestFMAuthorization, notifications:@mockNotifications,$location:@location, userRepository:@mockRepository}
  
 Then -> expect(@subject).toBeDefined()
 Then -> expect(@subject.username).toBeDefined()
 Then -> expect(@subject.password).toBeDefined()
 
 describe "login()", ->
  
  Given ->
   @currentLocation = @location.path()
   @username = 'foo'
   @password = 'bar'
   @subject.username = @username
   @subject.password = @password
   @loginToastr = 'foo'
   @loginMessage = "Logging In..."
   #turn off validation for now
   spyOn(@mockRouteValidation, "routeRequiresValidation").andReturn(false)
   spyOn(@mockNotifications, "success")
   spyOn(@mockNotifications, "error")
   spyOn(@mockNotifications, "clear")
   spyOn(@mockNotifications, "info").andReturn(@loginToastr)
   spyOn(@mockRestFMAuthorization, 'doLogin').andCallFake =>
    if @succeedPromise
     @q.when 'foo'
    else
     @q.reject @response

  describe "with a successful promise resolution", ->
   Given ->
    @succeedPromise = true
    @msg = 'Welcome ' + @username + '!'
    @mockRestFMAuthorization.lastError = 0
    @userId = 2
    spyOn(@mockRepository,"saveCurrentUserId")
    spyOn(@mockRepository,'getUserByUsername').andCallFake =>
     if @succeedPromise
      @q.when {username:@username, recordID:@userId}
     else
      @q.reject @response

   When -> 
    @result = @subject.login()
    @scope.$apply()
    
   Then -> expect(@mockNotifications.info).toHaveBeenCalledWith(@loginMessage) 
   Then -> expect(@mockRestFMAuthorization.doLogin).toHaveBeenCalledWith(@username,@password)
   Then -> expect(@mockNotifications.clear).toHaveBeenCalledWith(@loginToastr)
   Then -> expect(@mockNotifications.success).toHaveBeenCalledWith(@msg)
   Then -> expect(@mockRepository.getUserByUsername).toHaveBeenCalledWith(@username)
   Then -> expect(@mockRepository.saveCurrentUserId).toHaveBeenCalledWith(@userId)
   Then -> expect(@location.path()).toEqual('/time')
  
  describe "with a rejection and no error on the authorization", ->
   Given ->
    @succeedPromise = false
    @msg = "That's not a valid username and password."
    @mockRestFMAuthorization.lastError = 0
    spyOn(@mockRepository,"clearCurrentUserId")
    spyOn(@mockRepository,'getUserByUsername')
    
   When -> 
    @result = @subject.login()
    @scope.$apply()
    
   Then -> expect(@mockNotifications.info).toHaveBeenCalledWith(@loginMessage) 
   Then -> expect(@mockRestFMAuthorization.doLogin).toHaveBeenCalledWith(@username,@password)
   Then -> expect(@mockNotifications.clear).toHaveBeenCalledWith(@loginToastr)
   Then -> expect(@mockNotifications.error).toHaveBeenCalledWith(@msg)
   Then -> expect(@mockRepository.getUserByUsername).not.toHaveBeenCalledWith(@username)
   Then -> expect(@mockRepository.clearCurrentUserId).toHaveBeenCalled()
   Then -> expect(@location.path()).toEqual(@currentLocation)
  
  describe "with a rejection and a 500 error on the authorization", ->
   Given ->
    @succeedPromise = false
    @msg = "Oops, something went wrong! It's our fault not yours. Shoot us an email if this keeps happening!"
    @mockRestFMAuthorization.lastError = 500
       
   When -> 
    @result = @subject.login()
    @scope.$apply()
   
   Then -> expect(@mockNotifications.info).toHaveBeenCalledWith(@loginMessage)  
   Then -> expect(@mockRestFMAuthorization.doLogin).toHaveBeenCalledWith(@username,@password)
   Then -> expect(@mockNotifications.clear).toHaveBeenCalledWith(@loginToastr)
   Then -> expect(@mockNotifications.error).toHaveBeenCalledWith(@msg)
   Then -> expect(@location.path()).toEqual(@currentLocation) 