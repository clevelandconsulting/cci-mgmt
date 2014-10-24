angular.module('app').controller 'timeController', [ '$scope', 'userRepository', 'timeRepository', 'timeTypeRepository', 'staffAssignedRepository', 'notifications', 'staffRepository', 
 class timeController
  constructor: (@scope, @userRepository, @timeRepository, @timeTypeRepository, @staffAssignedRepository, @notifications, @staffRepository) ->
   #console.log 'INIT TIME CONTROLLER'
   @gettingTime = false
   @newtime = @initNewTime()
   @getTimeTypes()
   #@timeTypes = ['Development/Design', 'Project Mgmt', 'Client Support']
   @pagesize = 10
   
   if !@staffid?
    @getStaffId()
   
   @scope.pagesize = 25
   
   @scope.$watch('otherStaffId', (newVal, oldVal, scope) =>
    #console.log 'watch triggered', newVal
    if newVal?
     @getTimeForStaff(newVal)
   )
   
   @scope.$watch('pagesize', (newVal, oldVal, scope) =>
    #console.log 'watch triggered', newVal
    if newVal? && scope.otherStaffId
     @getTimeForStaff(scope.otherStaffId)
   )
  
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
    @currentUser = data
   @promise = @userRepository.getCurrentUser()
   
   @promise.then successFn, (response) => @notifications.error(response.status)
    
   @promise
  
  canSeeOthers: -> 
   result = @currentUser.canSeeOthers
   if result and !@staff and !@staffRequested and !@timeTypesProcessing
    @getStaff()
    @staffRequested = true
   
   result
  
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

  getTimeTypes: ->
   successFn = (data) =>
    @timeTypesProcessing = false
    @timeTypes = data
   failureFn = (response) =>
    @timeTypesProcessing = false
    @failureMessage(response,'time types')
    #msg = "There was a problem. " + response
    #@notifications.error msg
    
   @promise = @timeTypeRepository.getAllSorted()
   
   @timeTypesProcessing = true
   
   @promise.then successFn, failureFn
   
   @promise
  
  
  getStaff: ->
   successFn = (data) =>
    @staff = data
   failureFn = (response) =>
    @failureMessage(response,'staff')
    #msg = "There was a problem. " + response
    #@notifications.error msg
    
   @promise = @staffRepository.getAllSorted()
   
   @promise.then successFn, failureFn
   
   @promise

  getJobs: ->
   successFn = (data) =>
    @jobs = data
   failureFn = (response) =>
    @failureMessage(response,'job')
    #msg = "There was a problem. " + response
    #@notifications.error msg
    
   @promise = @staffAssignedRepository.getAllForStaff(@staffid, '', 1000)
   
   @promise.then successFn, failureFn
   
   @promise

  getTime: (path) ->
  
   successFn = (data) =>
    @times = data
   failureFn = (response) =>
    @failureMessage(response,'time')
  
   if (path? and path != '') || @staffid?
    if (path? and path != '')
     path = path.replace '/RESTfm/STEVE/',''
     @promise = @timeRepository.getAll(path)
    else if @staffid?
     @promise = @timeRepository.getAllForStaff(@staffid, @pagesize)
     
    @promise.then successFn, failureFn
    
    @promise
   else
    'blahohioe'
    
    
  getTimeForStaff: (staffid,path) ->
   
   pagesize = 25
   if @scope.pagesize?
    pagesize = @scope.pagesize
   
   successFn = (data) =>
    @staffTimes = data
   failureFn = (response) =>
    @failureMessage(response,'time')
  

   if (path? and path != '')
    path = path.replace '/RESTfm/STEVE/',''
    @promise = @timeRepository.getAll(path)
   else 
    @promise = @timeRepository.getAllForStaff(staffid, pagesize)
     
   @promise.then successFn, failureFn
    
   @promise


  hasJobs: ->
   if !@gettingJobs and !@jobs? and @staffid
    @promise = @getJobs()
    @promise.then (data) =>
     @gettingJobs = false
    @gettingJobs = true
  
   if @jobs?
    true
   else 
    false
   
  hasTime: ->
   if !@gettingTime and !@times? and @staffid
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
     @times.items.unshift response.data
    else
     @times = @timeRepository.newTimes(response.data)
     
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
   
  deleteTime: (time) ->
   successFn = (msg) => 
    @notifications.success(msg)
    for t, i in @times.items
     if t? and t.href? and t.href == time.href
      @times.items.splice(i,1)
   failureFn = (msg) => @notifications.error(msg)
   
   if window.confirm 'Do you really want to delete this time?'
    @timeRepository.delete(time.href).then successFn, failureFn
  
]