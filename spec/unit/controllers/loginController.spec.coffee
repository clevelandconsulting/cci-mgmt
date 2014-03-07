describe "loginController", ->
 Given -> module('app')
 
 Given angular.mock.inject (restFMAuthorization) ->
  @mockRestFMAuthorization = restFMAuthorization
 
 Given inject ($controller, $rootScope, $q, $location) ->
  @scope = $rootScope.$new()
  @location = $location
  @q = $q
  @subject = $controller 'loginController', {restFMAuthorization: @mockRestFMAuthorization, $scope:@scope}
  
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
   spyOn(@mockRestFMAuthorization, 'doLogin').andCallFake =>
    if @succeedPromise
     @q.when 'foo'
    else
     @q.reject @response

  describe "with a successful promise resolution", ->
   Given ->
    @succeedPromise = true
    @mockRestFMAuthorization.lastError = 0
   
   When -> 
    @result = @subject.login()
    @scope.$apply()
    
   Then -> expect(@mockRestFMAuthorization.doLogin).toHaveBeenCalledWith(@username,@password)
   Then -> expect(@subject.flash).toEqual('Welcome ' + @username + '!')
  
  describe "with a rejection and no error on the authorization", ->
   Given ->
    @succeedPromise = false
    @mockRestFMAuthorization.lastError = 0
       
   When -> 
    @result = @subject.login()
    @scope.$apply()
    
   Then -> expect(@mockRestFMAuthorization.doLogin).toHaveBeenCalledWith(@username,@password)
   Then -> expect(@subject.flash).toEqual("That's not a valid username and password.")
  
  describe "with a rejection and a 500 error on the authorization", ->
   Given ->
    @succeedPromise = false
    @mockRestFMAuthorization.lastError = 500
       
   When -> 
    @result = @subject.login()
    @scope.$apply()
    
   Then -> expect(@mockRestFMAuthorization.doLogin).toHaveBeenCalledWith(@username,@password)
   Then -> expect(@subject.flash).toEqual("Oops, something went wrong! It's our fault not yours. Shoot us an email if this keeps happening!")
  