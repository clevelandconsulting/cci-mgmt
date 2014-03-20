angular.module('app').service 'timeRepository', [ '$q', 'fmRestModel', 'fmRestRepository','cciApiService', ($q, fmRestModel, fmRestRepository, cciApiService) -> 
 class timeRepository extends fmRestRepository
  constructor : -> 
   super($q, cciApiService, fmRestModel,'layout/Api-Time', 'time')
  
  add:(job_id, staff_id, type, date, hours, note) ->
   time = new @model {date:date,hours:hours,job_id:job_id,staff_id:staff_id,type:type,note:note},'',''
   super(time.data)
   
  update: (time) ->
   data = {job_id: time.data.job_id, staff_id: time.data.staff_id, type: time.data.type, date: time.data.date, hours:time.data.hours, note:time.data.note }
   super(data,time.href)
 
  
 new timeRepository()

]