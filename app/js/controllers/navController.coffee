angular.module('app').controller 'navController', ['$location', 'authorizationService', 'userRepository',
 class navController
  constructor: (@$location, @authorizationService, @userRepository) ->
    
  isLoggedIn: ->
   loggedIn = @authorizationService.checkIfLoggedIn()
   if loggedIn and @username == undefined
    @getUsername()
   loggedIn
  
  logout: ->
   @authorizationService.doLogout()
   @userRepository.clearCurrentUserId()
   @username = undefined
   @$location.path('/login')

  getUsername: -> 
   @promise = @userRepository.getCurrentUser()
   
   @promise.then (data) =>
    @username = data.username
   
   @promise
]