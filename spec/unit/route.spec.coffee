describe "routes", ->
 Given -> module('app')
 Given inject ($route) ->
  @route = $route
 
 Then -> expect(@route).toBeDefined()
 
 describe "login route", ->
  When -> @loginRoute = @route.routes['/login']
  Then -> expect(@loginRoute.controller).toBe('loginController')
  Then -> expect(@loginRoute.templateUrl).toBe('login.html')
 
 describe "time route", ->
  When -> @homeRoute = @route.routes['/time']
  Then -> expect(@homeRoute.controller).toBe('timeController')
  Then -> expect(@homeRoute.templateUrl).toBe('time.html')
  
 describe "default route", ->
  When -> @defaultRoute = @route.routes[null]
  Then -> expect(@defaultRoute.redirectTo).toBe('/time')