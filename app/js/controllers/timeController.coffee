angular.module('app').controller 'timeController', [ '$scope', 'userRepository', 'timeRepository', 'notifications', 
 class timeController
  constructor: (@scope, @userRepository, @timeRepository, @notifications) ->
   @gettingTime = false
   if !@staffid?
    @getStaffId()

  getStaffId: -> 
    @promise = @userRepository.getCurrentUser()
    
    @promise.then (data) =>
     @staffid = data.data.__guid
    
    @promise


  getTime: ->
   if @staffid?
    
    successFn = (data) =>
     @times = data
    failureFn = (response) =>
     isError = true
     if response.data? && response.data.info?
      
      if parseInt(response.data.info['X-RESTfm-FM-Status']) == 401
       isError = false
       msg = "No time records were found for this staff member."
      else
       msg = 'Trying to get time records for ' + @staffid + '. Server returned ' + response.data.info['X-RESTfm-FM-Reason']
      
     else if response.status == 500
      msg = 'Server return 500 error trying to get the times for ' + @staffid
     else 
      msg = 'There was a problem. ' + response
     
     if isError
      @notifications.error(msg)
     else
      @notifications.info(msg)
   
    @promise = @timeRepository.getAllForStaff(@staffid)
   
    @promise.then successFn, failureFn
    
    @promise
   
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

]