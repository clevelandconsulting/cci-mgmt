angular.module('app').service 'routeValidation', [ '$rootScope','$location','restFMAuthorization', class routeValidation
  constructor: (@rootScope,@location,@authorization) ->
   @routesRequireNoValidation = []
   
  addNonValidationRoute: (route) ->
   @routesRequireNoValidation.push(route)

  routeRequiresValidation: (route) ->
   noValidationRoute = _.find @routesRequireNoValidation, (noAuthRoute) -> 
    (route.substr(0, noAuthRoute.length)  == noAuthRoute)
     
   if noValidationRoute? 
    false
   else 
    true 

  validateRoute: (event, next, current) =>
   if (@routeRequiresValidation(@location.url()) && !@authorization.checkIfLoggedIn())
    @location.path('/login');

]