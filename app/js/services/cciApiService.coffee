angular.module('app').service 'cciApiService', ['$http','apiService', '$q', ($http, api, $q) -> 
 cciApi = new api($http, $q) 
 cciApi.setUrl 'https://fms.clevelandconsulting.com/RESTfm/STEVE/'
 #cciApi.setUrl 'https://10.0.1.185/RESTfm/STEVE/'
 
 cciApi
]