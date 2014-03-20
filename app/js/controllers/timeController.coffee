angular.module('app').controller 'timeController', [ '$scope', 'userRepository', 'timeRepository', 'staffAssignedRepository', 'notifications', 
 class timeController
  constructor: (@scope, @userRepository, @timeRepository, @staffAssignedRepository, @notifications) ->
   @gettingTime = false
   if !@staffid?
    @getStaffId()

  getStaffId: -> 
    @promise = @userRepository.getCurrentUser()
    
    @promise.then (data) =>
     @staffid = data.data.__guid
    
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
    
  updateTime: (time) ->
   successFn = (msg) => @notifications.success(msg)
   failureFn = (msg) => @notifications.error(msg)
   @timeRepository.update(time).then successFn, failureFn

]