angular.module('app').service 'staffAssignedRepository', [ '$q', 'fmRestModel', 'fmRestRepository','cciApiService', ($q, fmRestModel, fmRestRepository, cciApiService) -> 
 class staffAssignedRepository extends fmRestRepository
  constructor : -> 
   super($q, cciApiService, fmRestModel,'layout/Api-StaffAssigned', 'staff assignment') 
  
 new staffAssignedRepository()

]