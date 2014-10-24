angular.module('app').service 'staffRepository', [ '$q', 'fmRestModel', 'fmRestList', 'fmRestRepository', 'cciApiService', ($q, fmRestModel, fmRestList, fmRestRepository, cciApiService) -> 
 class staffRepository extends fmRestRepository
  constructor : -> 
   super($q, cciApiService, fmRestModel, fmRestList, 'layout/Api-Staff', 'staff') 
  
  getAllSorted: ->
   @getAllWithScript('','')
   
 new staffRepository()

]