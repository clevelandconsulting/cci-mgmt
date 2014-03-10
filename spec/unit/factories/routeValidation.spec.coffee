###
describe "routeValidation", ->
 Given -> module('app')
 
 Given angular.mock.inject (restFMAuthorization) ->
  @mockAuth = restFMAuthorization
 
 Given inject ($rootScope, $location, $injector) ->
  @rootScope = $rootScope
  @location = $location
  @subject = $injector.get 'routeValidation', {$rootScope: @rootScope, $location: @location, 'restFMAuthorization': @mockAuth}
  
 Then -> expect(@subject).toBeDefined() 
 
 describe "addNonValidationRoutes()", ->
  Given -> @route = "someroute"
 
  When -> @subject.addNonValidationRoute(@route)
  Then -> expect(@subject.routesRequireNoValidation).toContain(@route)
  
 describe "routeRequiresValidation()", ->
  Given -> 
   @validationRoute = "someroute"
   @nonvalidationRoute = "nonvalidationroute"
   @subject.routesRequireNoValidation.push(@nonvalidationRoute)
   
  describe "with a route that doesn't require validation", ->
   Given -> @route = @nonvalidationRoute
   
   When -> @result = @subject.routeRequiresValidation(@route)
   Then -> expect(@result).toBe(false)
   
  describe "with a route that does require validation", ->
   Given -> @route = @validationRoute
   
   When -> @result = @subject.routeRequiresValidation(@route)
   Then -> expect(@result).toBe(true)
   
 describe "validateRoute()", ->
  Given -> 
   @validationRoute = "/someroute"
   @nonvalidationRoute = "/nonvalidationroute"
   @subject.routesRequireNoValidation.push(@nonvalidationRoute)
   @location.path('/anything')
   
  describe "when going to nonvalidation route", ->
  
   Given -> 
    spyOn(@mockAuth,"checkIfLoggedIn")
   
   When -> 
    @location.path(@nonvalidationRoute)
    @result = @subject.validateRoute('','','')
    
   Then -> expect(@mockAuth.checkIfLoggedIn).not.toHaveBeenCalled()
   Then -> expect(@location.path()).toBe(@nonvalidationRoute)
  
  describe "when going to validation route and not logged in", ->
  
   Given -> 
    spyOn(@mockAuth,"checkIfLoggedIn").andReturn(false)
   
   When -> 
    @location.path(@validationRoute)
    @result = @subject.validateRoute('','','')
    
   Then -> expect(@mockAuth.checkIfLoggedIn).toHaveBeenCalled()
   Then -> expect(@location.path()).toBe('/login') 
   
  describe "when going to validation route and logged in", ->
  
   Given -> 
    spyOn(@mockAuth,"checkIfLoggedIn").andReturn(true)
   
   When -> 
    @location.path(@validationRoute)
    @result = @subject.validateRoute('','','')
    
   Then -> expect(@mockAuth.checkIfLoggedIn).toHaveBeenCalled()
   Then -> expect(@location.path()).toBe(@validationRoute) 
   
 ###  
   