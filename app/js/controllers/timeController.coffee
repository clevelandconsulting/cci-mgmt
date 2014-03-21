angular.module('app').controller 'timeController', [ '$scope', 'userRepository', 'timeRepository', 'staffAssignedRepository', 'notifications', 
 class timeController
  constructor: (@scope, @userRepository, @timeRepository, @staffAssignedRepository, @notifications) ->
   @gettingTime = false
   @newtime = @initNewTime()
   
   if !@staffid?
    @getStaffId()
  
  initNewTime: ()->
   today = new Date()
   dd = today.getDate()
   mm = today.getMonth()+1
   yyyy = today.getFullYear()
 
   if dd<10 
    dd='0'+dd 
   
   if mm<10
    mm='0'+mm 
    
   { date: mm+'/'+dd+'/'+yyyy}
  
  getStaffId: -> 
   successFn = (data) =>
    @staffid = data.data.__guid
   @promise = @userRepository.getCurrentUser()
   
   @promise.then successFn, (response) => @notifications.error(response.status)
    
   
   @promise
    
  failureMessage: (response, modelName) ->
   isError = true
   if response.data? && response.data.info?
    
    if parseInt(response.data.info['X-RESTfm-FM-Status']) == 401
     isError = false
     msg = "No " + modelName + " records were found for this staff member."
    else
     msg = 'Trying to get ' + modelName + ' records for ' + @staffid + '. Server returned ' + response.data.info['X-RESTfm-FM-Reason']
    
   else if response.status == 500
    msg = 'Server return 500 error trying to get the ' + modelName + ' records for ' + @staffid
   else 
    msg = 'There was a problem. ' + response
   
   if isError
    @notifications.error(msg)
   else
    @notifications.info(msg)

  getJobs: ->
   successFn = (data) =>
    @jobs = data
   failureFn = (response) =>
    @failureMessage(response,'job')
    #msg = "There was a problem. " + response
    #@notifications.error msg
    
   @promise = @staffAssignedRepository.getAllForStaff(@staffid)
   
   @promise.then successFn, failureFn
   
   @promise

  getTime: ->
   if @staffid?

    successFn = (data) =>
     @times = data
    failureFn = (response) =>
     @failureMessage(response,'time')
   
    @promise = @timeRepository.getAllForStaff(@staffid)
   
    @promise.then successFn, failureFn
    
    @promise
   
  hasJobs: ->
   if !@gettingJobs and !@jobs?
    @promise = @getJobs()
    @promise.then (data) =>
     @gettingJobs = false
    @gettingJobs = true
  
   if @jobs?
    true
   else 
    false
   
  hasTime: ->
   if !@gettingTime and !@times?
    @promise = @getTime()
    @promise.then (data) =>
     @gettingTime = false
    @gettingTime = true
  
   if @times?
    true
   else 
    false
  
  editTime: (time) ->
   time.editing = true
  
  updateTime: (time) ->
   time.editing = false
   successFn = (msg) => @notifications.success(msg)
   failureFn = (msg) => @notifications.error(msg)
   @timeRepository.update(time).then successFn, failureFn
   
  addTime: (time) ->
   
   successFn = (response) => 
    @notifications.success(response.msg)
    if @times?
     @times.unshift response.data
    else
     @times = [response.data]
     
    @newtime = @initNewTime()
   failureFn = (msg) => @notifications.error(msg)
  
   if time.job_id? and time.job_id != ''
    if time.hours? and time.hours != ''
     @timeRepository.add(time.job_id, @staffid, time.type, time.date, time.hours, time.note).then successFn, failureFn
    else
     failureFn('Hours must be entered')
   else
    failureFn('A job must be entered')
   
   return
  
]