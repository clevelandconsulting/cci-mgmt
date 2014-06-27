angular.module('app').service 'timeTypeRepository', [ '$q', 'fmRestModel', 'fmRestList', 'fmRestRepository', 'cciApiService', ($q, fmRestModel, fmRestList, fmRestRepository, cciApiService) -> 
 class timeTypeRepository extends fmRestRepository
  constructor : -> 
   super($q, cciApiService, fmRestModel, fmRestList, 'layout/Api-TimeType', 'timeType') 
  
  getAllSorted: ->
   @getAllWithScript('','Api-TimeType.sort')
   
 new timeTypeRepository()

]