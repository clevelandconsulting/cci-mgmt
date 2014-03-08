angular.module('app').config ['$routeProvider', (routeProvider) ->
 routeProvider
 .when('/login', {controller:'loginController', templateUrl:'login.html'})
 .when('/home', {controller:'homeController', templateUrl: 'home.html'})
 .otherwise {redirectTo:'/login'}
]