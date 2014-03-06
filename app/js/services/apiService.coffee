angular.module('app').service 'apiService', ['$http', '$rootScope', class apiService
 constructor: ($http, $rootScope) -> 
  @url = '' 
  @credentials = ''
  @validated = false
  @http = $http
  #@http({method: 'GET', url: @url + "?RFMkey=cci-developer"})
  
 setUrl: (@url) ->
 
 setCredentials: (@credentials) ->
  
 isValidated: -> @validated 
  
 checkCredentials: (credentials) ->
  @http.defaults.headers.common['Authorization'] = 'Basic ' + credentials
  @http({method: 'GET', url: @url})
   .success( (data,status,headers,config) => 
    @validated = true
    @setCredentials credentials 
   )
   .error (data,status,headers,config) => 
    @validated = false
    @setCredentials '' 
]