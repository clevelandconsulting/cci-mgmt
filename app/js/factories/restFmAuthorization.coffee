angular.module('app').factory 'restFMAuthorization', [ 'authorizationService', (authorizationService) -> 
 authorizationService.apiUrl 'https://fms.clevelandconsulting.com/RESTfm/CCI_Mgmt/'
 authorizationService

]