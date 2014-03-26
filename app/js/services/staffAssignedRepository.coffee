angular.module('app').service 'staffAssignedRepository', [ '$q', 'fmRestModel', 'fmRestList', 'fmRestRepository','cciApiService', ($q, fmRestModel, fmRestList, fmRestRepository, cciApiService) -> 
 class staffAssignedRepository extends fmRestRepository
  constructor : -> 
   super($q, cciApiService, fmRestModel, fmRestList, 'layout/Api-StaffAssigned', 'staff assignment') 
  
 new staffAssignedRepository()

]