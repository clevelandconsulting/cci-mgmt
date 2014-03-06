angular.module('app').service 'apiService', ['$http', ($http) ->
 url = "https://fms.clevelandconsulting.com/RESTfm/"
 username = "Developer"
 password = ""
  

 #$http.defaults.headers.common = {"Access-Control-Request-Headers": "accept, origin, authorization"};
 $http.defaults.headers.common['Authorization'] = 'Basic ' + Base64.encode username + ':' + password
  
 $http({method: 'GET', url: url}).
   success (data, status, headers, config) =>
    @result = data
    console.log data
   .error (data, status, headers, config) =>
    console.log data

]