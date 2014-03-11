angular.module('app').controller 'navController', ['$location', 'authorizationService', 
 class navController
  constructor: (@$location, @authorizationService) ->
  
  isLoggedIn: ->
   @authorizationService.checkIfLoggedIn()
  
  logout: ->
   @authorizationService.doLogout()
   @$location.path('/login')

]