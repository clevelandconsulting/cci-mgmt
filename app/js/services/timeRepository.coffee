angular.module('app').service 'timeRepository', [ '$q', 'fmRestModel', 'fmRestList', 'fmRestRepository', 'cciApiService', ($q, fmRestModel, fmRestList, fmRestRepository, cciApiService) -> 
 class timeRepository extends fmRestRepository
  constructor : -> 
   super($q, cciApiService, fmRestModel, fmRestList, 'layout/Api-Time', 'time')
  
  getAllForStaff: (staff_id, pagesize) ->
   super(staff_id,'Api-Time.sort', pagesize)
  
  add:(job_id, staff_id, type, date, hours, note) ->
   time = new @model {date:date,hours:hours,job_id:job_id,staff_id:staff_id,type:type,note:note},'',''
   super(time.data)
   
  update: (time) ->
   data = {job_id: time.data.job_id, staff_id: time.data.staff_id, type: time.data.type, date: time.data.date, hours:time.data.hours, note:time.data.note }
   super(data,time.href)
   
  newList: (times) ->
   return new fmRestList(times,fmRestModel)
 
  
 new timeRepository()

]