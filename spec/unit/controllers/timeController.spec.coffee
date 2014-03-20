describe "timeController", ->
 Given -> module('app')
 
 Given inject ($controller, $rootScope, $q, _userRepository_, _timeRepository_, _staffAssignedRepository_, _fmRestModel_, _notifications_) ->
  @scope = $rootScope.$new()
  @controller = $controller
  @mockRepo = _userRepository_
  @mockTimeRepo = _timeRepository_
  @mockStaffAssigned = _staffAssignedRepository_
  @mockModel = _fmRestModel_
  @mockNotifications = _notifications_
  @q = $q
  @subject = @controller 'timeController', {$scope:@scope, userRepository:@mockRepo, timeRepository:@mockTimeRepo, staffAssignedRepository: @mockStaffAssigned, notifications:@mockNotifications}
  
  @apiResponse = {"data":[{"__guid":"5A5751B4-6F4A-4C7B-BE0E-36493E7CE2D1","job_id":"3B052C63-BE27-433A-94FC-3B82B23ADF44","staff_id":"DC5FB862-E6F0-45FD-AA86-BC9A41003873","billed_flag":"0","type":"Client Support","date":"03\/10\/2014","hours":"500","note":"Client Hand-holding.","__created_ts":"03\/10\/2014 11:35:29","__created_an":"Developer","__modified_ts":"03\/10\/2014 11:35:42","__modified_an":"Developer"}],"meta":[{"recordID":"3","href":"\/RESTfm\/STEVE\/layout\/Time\/3.json"}],"metaField":[{"name":"__guid","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"job_id","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"staff_id","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"billed_flag","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"type","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"date","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"date"},{"name":"hours","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"number"},{"name":"note","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"__created_ts","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"timestamp"},{"name":"__created_an","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"__modified_ts","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"timestamp"},{"name":"__modified_an","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"}],"info":{"X-RESTfm-Version":"2.0.2\/r291","X-RESTfm-Protocol":"4","X-RESTfm-Status":200,"X-RESTfm-Reason":"OK","X-RESTfm-Method":"GET"}}
  
  @apiStaffAssignedResponse = {"data":[{"__guid":"1E99EC79-BB81-4EBB-B033-41C70C48A5DE","job_id":"3B052C63-BE27-433A-94FC-3B82B23ADF44","staff_id":"16CDF29F-B1B5-4015-8D38-E25D2BF32A65","role":"Developer","__created_ts":"03\/10\/2014 11:33:22","__created_an":"Developer","__modified_ts":"03\/10\/2014 11:34:02","__modified_an":"Developer","job_name_c":"CCI Management System","staff_name_c":"Kevin Vile"}],"meta":[{"recordID":"2","href":"\/RESTfm\/STEVE\/layout\/Api-StaffAssigned\/2.json"}],"metaField":[{"name":"__guid","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"job_id","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"staff_id","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"role","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"__created_ts","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"timestamp"},{"name":"__created_an","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"__modified_ts","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"timestamp"},{"name":"__modified_an","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"job_name_c","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"staff_name_c","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"}],"info":{"X-RESTfm-Version":"2.0.2\/r291","X-RESTfm-Protocol":"4","X-RESTfm-Status":200,"X-RESTfm-Reason":"OK","X-RESTfm-Method":"GET"}}
  
  @expectedTime = new @mockModel @apiResponse.data[0], @apiResponse.meta[0].href, @apiResponse.meta[0].recordID
  @expectedTimes = [@expectedTime]
  @expectedStaffAssigned = new @mockModel @apiStaffAssignedResponse.data[0], @apiStaffAssignedResponse.meta[0].href, @apiStaffAssignedResponse.meta[0].recordID
  @expectedStaffAssignments = [@expectedStaffAssigned]
  @failureMessage = 'This is the message'
  spyOn(@mockTimeRepo,"getAllForStaff").andCallFake (staff_id) =>
   if @promiseSucceeds
    @q.when @expectedTimes
   else
    @q.reject @failureMessage
    
  spyOn(@mockStaffAssigned,"getAllForStaff").andCallFake (staff_id) =>
   if @promiseSucceeds
    @q.when @expectedStaffAssignments
   else
    @q.reject @failureMessage

 Then -> expect(@subject).toBeDefined()
 Then -> expect(@subject.timeRepository).toBe(@mockTimeRepo)
 
 describe "getStaffId() when user exists", ->
  Given ->
   @staffid = 'someid'
   @user = {username:'somename', recordID:2, href:'', data:{__guid:@staffid}} 
   spyOn(@mockRepo,"getCurrentUser").andCallFake =>
    @q.when @user
    
  When -> 
   @promiseSucceeds = true
   @promise = @subject.getStaffId()
   @promise.then (data) => @result = data
   @scope.$apply()
   
  Then -> expect(@mockRepo.getCurrentUser).toHaveBeenCalled()
  Then -> expect(@result).toEqual @user
  Then -> expect(@subject.staffid).toEqual @staffid




 describe 'getJobs() when staffid exists and promise succeeds', ->
  Given ->
   @staffid = 'someid'
   
  When ->
   @promiseSucceeds = true
   @subject.staffid = @staffid
   @promise = @subject.getJobs()
   @promise.then (data) => @result = data
   @scope.$apply()
   
  Then -> expect(@mockStaffAssigned.getAllForStaff).toHaveBeenCalledWith(@staffid)
  Then -> expect(@subject.jobs).toEqual(@expectedStaffAssignments)
  Then -> expect(@result).toEqual(@expectedStaffAssignments)
 
 describe "getJobs() when staffid exists and promise fails", ->
  Given ->
   @staffid = 'someid'
   spyOn(@mockNotifications,"error")
   
  When -> 
   @promiseSucceeds = false
   @subject.staffid = @staffid
   @promise = @subject.getJobs()
   @promise.then (data) => @result = data
   @scope.$apply()
  
  Then -> expect(@mockStaffAssigned.getAllForStaff).toHaveBeenCalledWith(@staffid)
  Then -> expect(@mockNotifications.error).toHaveBeenCalledWith('There was a problem. ' + @failureMessage)
  Then -> expect(@result).not.toEqual(@expectedStaffAssignments)

 describe "hasJobs() when staffid exists, jobs does not, and not already getting jobs", ->
  
  Given ->
   @staffid = 'someid'
  
  When ->
   @promiseSucceeds = true
   @subject.staffid = @staffid 
   @subject.jobs = undefined
   @subject.gettingJobs = false
   @result = @subject.hasJobs()
  
  Then -> expect(@mockStaffAssigned.getAllForStaff).toHaveBeenCalledWith(@staffid)
  Then -> expect(@subject.gettingJobs).toBe(true)
  Then -> expect(@result).toBe(false)
  
 describe "hasJobs() when staffid exists, jobs does not exist, promise returns after getting jobs with some jobs", ->
  
  Given ->
   @staffid = 'someid'
  
  When ->
   @promiseSucceeds = true
   @subject.staffid = @staffid 
   @subject.jobs = undefined
   @subject.gettingJobs = false
   @result = @subject.hasJobs()
   @scope.$apply()
  
  Then -> expect(@mockStaffAssigned.getAllForStaff).toHaveBeenCalledWith(@staffid)
  Then -> expect(@subject.gettingJobs).toBe(false)
  Then -> expect(@result).toBe(false)
  
 describe "hasJobs() when staffid exists, jobs does not, and already getting jobs", ->
  
  Given ->
   @staffid = 'someid'
  
  When ->
   @promiseSucceeds = true
   @subject.staffid = @staffid 
   @subject.jobs = undefined
   @subject.gettingJobs = true
   @result = @subject.hasJobs()
  
  Then -> expect(@mockStaffAssigned.getAllForStaff).not.toHaveBeenCalledWith(@staffid)
  Then -> expect(@subject.gettingJobs).toBe(true)
  Then -> expect(@result).toBe(false)
  
 describe "hasJobs() when staffid exists, jobs does exists", ->
  
  Given ->
   @staffid = 'someid'
  
  When ->
   @promiseSucceeds = true
   @subject.staffid = @staffid 
   @subject.jobs = @expectedTimes
   @subject.gettingJobs = false
   @result = @subject.hasJobs()
  
  Then -> expect(@mockStaffAssigned.getAllForStaff).not.toHaveBeenCalledWith(@staffid)
  Then -> expect(@subject.gettingJobs).toBe(false)
  Then -> expect(@result).toBe(true)




 describe "getTime() when staffid exists and promise succeeds", ->
  Given ->
   @staffid = 'someid'
   
  When -> 
   @promiseSucceeds = true
   @subject.staffid = @staffid
   @promise = @subject.getTime()
   @promise.then (data) => @result = data
   @scope.$apply()
  
  Then -> expect(@mockTimeRepo.getAllForStaff).toHaveBeenCalledWith(@staffid)
  Then -> expect(@subject.times).toEqual(@expectedTimes)
  Then -> expect(@result).toEqual(@expectedTimes)
  
 describe "getTime() when staffid exists and promise fails", ->
  Given ->
   @staffid = 'someid'
   spyOn(@mockNotifications,"error")
   
  When -> 
   @promiseSucceeds = false
   @subject.staffid = @staffid
   @promise = @subject.getTime()
   @promise.then (data) => @result = data
   @scope.$apply()
  
  Then -> expect(@mockTimeRepo.getAllForStaff).toHaveBeenCalledWith(@staffid)
  Then -> expect(@mockNotifications.error).toHaveBeenCalledWith('There was a problem. ' + @failureMessage)
  Then -> expect(@result).not.toEqual(@expectedTimes)
  
  
 describe "hasTime() when staffid exists, times does not, and not already getting time", ->
  
  Given ->
   @staffid = 'someid'
  
  When ->
   @promiseSucceeds = true
   @subject.staffid = @staffid 
   @subject.times = undefined
   @subject.gettingTime = false
   @result = @subject.hasTime()
  
  Then -> expect(@mockTimeRepo.getAllForStaff).toHaveBeenCalledWith(@staffid)
  Then -> expect(@subject.gettingTime).toBe(true)
  Then -> expect(@result).toBe(false)
  
 describe "hasTime() when staffid exists, times does not exist, promise returns after getting time with some times", ->
  
  Given ->
   @staffid = 'someid'
  
  When ->
   @promiseSucceeds = true
   @subject.staffid = @staffid 
   @subject.times = undefined
   @subject.gettingTime = false
   @result = @subject.hasTime()
   @scope.$apply()
  
  Then -> expect(@mockTimeRepo.getAllForStaff).toHaveBeenCalledWith(@staffid)
  Then -> expect(@subject.gettingTime).toBe(false)
  Then -> expect(@result).toBe(false)
  
 describe "hasTime() when staffid exists, times does not, and already getting time", ->
  
  Given ->
   @staffid = 'someid'
  
  When ->
   @promiseSucceeds = true
   @subject.staffid = @staffid 
   @subject.times = undefined
   @subject.gettingTime = true
   @result = @subject.hasTime()
  
  Then -> expect(@mockTimeRepo.getAllForStaff).not.toHaveBeenCalledWith(@staffid)
  Then -> expect(@subject.gettingTime).toBe(true)
  Then -> expect(@result).toBe(false)
  
 describe "hasTime() when staffid exists, times does exists", ->
  
  Given ->
   @staffid = 'someid'
  
  When ->
   @promiseSucceeds = true
   @subject.staffid = @staffid 
   @subject.times = @expectedTimes
   @subject.gettingTime = false
   @result = @subject.hasTime()
  
  Then -> expect(@mockTimeRepo.getAllForStaff).not.toHaveBeenCalledWith(@staffid)
  Then -> expect(@subject.gettingTime).toBe(false)
  Then -> expect(@result).toBe(true)
  
 describe "updateTime()", ->
 
  Given ->
   @successResponse = "some success response"
   @failureResponse = "some failure response"
   spyOn(@mockTimeRepo, "update").andCallFake =>
    if @succeedPromise
     @q.when @successResponse
    else
     @q.reject @failureResponse

   spyOn(@mockNotifications, "success")
   spyOn(@mockNotifications, "error")
   
  describe "when the time repo update is successful", ->
  
   When ->
    @succeedPromise = true
    @subject.updateTime(@expectedTime)
    @scope.$apply()
    
   Then -> expect(@mockTimeRepo.update).toHaveBeenCalledWith(@expectedTime)
   Then -> expect(@mockNotifications.success).toHaveBeenCalledWith(@successResponse)
   
  describe "when the time repo update is not successful", ->
  
   When ->
    @succeedPromise = false
    @subject.updateTime(@expectedTime)
    @scope.$apply()
    
   Then -> expect(@mockTimeRepo.update).toHaveBeenCalledWith(@expectedTime)
   Then -> expect(@mockNotifications.error).toHaveBeenCalledWith(@failureResponse)
  