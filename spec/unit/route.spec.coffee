###
describe "routes", ->
 Given -> module('app')
 Given inject ($route) ->
  @route = $route
 
 Then -> expect(@route).toBeDefined()
 
 describe "login route", ->
  When -> @loginRoute = @route.routes['/login']
  Then -> expect(@loginRoute.controller).toBe('loginController')
  Then -> expect(@loginRoute.templateUrl).toBe('login.html')
 
 describe "home route", ->
  When -> @homeRoute = @route.routes['/home']
  Then -> expect(@homeRoute.controller).toBe('homeController')
  Then -> expect(@homeRoute.templateUrl).toBe('home.html')
  
 describe "default route", ->
  When -> @defaultRoute = @route.routes[null]
  Then -> expect(@defaultRoute.redirectTo).toBe('/home')
 ###