angular.module('app').service 'cciApiService', ['$http','apiService', ($http, api) -> 
 cciApi = new api($http) 
 cciApi.setUrl 'https://fms.clevelandconsulting.com/RESTfm/STEVE/'
 #cciApi.setUrl 'https://10.0.1.185/RESTfm/STEVE/'
 
 cciApi
]