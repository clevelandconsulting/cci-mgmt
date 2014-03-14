angular.module('app').config ['$routeProvider', (routeProvider) ->
 routeProvider
 .when('/login', {controller:'loginController', templateUrl:'login.html'})
 .when('/time', {controller:'timeController', templateUrl: 'time.html'})
 .when('/test', {controller: 'testController', template: '<p>{{ result }}</p>'})
 .otherwise {redirectTo:'/time'}
]

angular.module('app').run ($rootScope,$location,routeValidation) ->
 routeValidation.addNonValidationRoute '/login'
 
 $rootScope.$on '$routeChangeStart', routeValidation.validateRoute