describe "timeController", ->
 Given -> module('app')
 
 Given inject ($controller, $rootScope, $q, _userRepository_, _timeRepository_, _staffAssignedRepository_, _timeTypeRepository_, _fmRestModel_, _fmRestList_, _notifications_) ->
  @scope = $rootScope.$new()
  @controller = $controller
  @mockRepo = _userRepository_
  @mockTimeRepo = _timeRepository_
  @mockTimeTypes = _timeTypeRepository_
  @mockStaffAssigned = _staffAssignedRepository_
  @mockModel = _fmRestModel_
  @mockList = _fmRestList_
  @mockNotifications = _notifications_
  @q = $q
  today = new Date()
  dd = today.getDate()
  mm = today.getMonth()+1
  yyyy = today.getFullYear()

  if dd<10 
   dd='0'+dd 
  
  if mm<10
   mm='0'+mm 
  
  @today = mm+'/'+dd+'/'+yyyy
  
  @apiResponse = {"data":[{"__guid":"5A5751B4-6F4A-4C7B-BE0E-36493E7CE2D1","job_id":"3B052C63-BE27-433A-94FC-3B82B23ADF44","staff_id":"DC5FB862-E6F0-45FD-AA86-BC9A41003873","billed_flag":"0","type":"Client Support","date":"03\/10\/2014","hours":"500","note":"Client Hand-holding.","__created_ts":"03\/10\/2014 11:35:29","__created_an":"Developer","__modified_ts":"03\/10\/2014 11:35:42","__modified_an":"Developer"}],"meta":[{"recordID":"3","href":"\/RESTfm\/STEVE\/layout\/Time\/3.json"}],"metaField":[{"name":"__guid","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"job_id","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"staff_id","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"billed_flag","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"type","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"date","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"date"},{"name":"hours","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"number"},{"name":"note","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"__created_ts","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"timestamp"},{"name":"__created_an","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"__modified_ts","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"timestamp"},{"name":"__modified_an","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"}],"info":{"X-RESTfm-Version":"2.0.2\/r291","X-RESTfm-Protocol":"4","X-RESTfm-Status":200,"X-RESTfm-Reason":"OK","X-RESTfm-Method":"GET"}}
  
  @apiStaffAssignedResponse = {"data":[{"__guid":"1E99EC79-BB81-4EBB-B033-41C70C48A5DE","job_id":"3B052C63-BE27-433A-94FC-3B82B23ADF44","staff_id":"16CDF29F-B1B5-4015-8D38-E25D2BF32A65","role":"Developer","__created_ts":"03\/10\/2014 11:33:22","__created_an":"Developer","__modified_ts":"03\/10\/2014 11:34:02","__modified_an":"Developer","job_name_c":"CCI Management System","staff_name_c":"Kevin Vile"}],"meta":[{"recordID":"2","href":"\/RESTfm\/STEVE\/layout\/Api-StaffAssigned\/2.json"}],"metaField":[{"name":"__guid","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"job_id","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"staff_id","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"role","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"__created_ts","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"timestamp"},{"name":"__created_an","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"__modified_ts","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"timestamp"},{"name":"__modified_an","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"job_name_c","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"staff_name_c","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"}],"info":{"X-RESTfm-Version":"2.0.2\/r291","X-RESTfm-Protocol":"4","X-RESTfm-Status":200,"X-RESTfm-Reason":"OK","X-RESTfm-Method":"GET"}}
  @apiTimeTypeResponseData = {"data":[{"__guid":"1D284AD7-6F93-4AFB-91A6-AB62EA616170","name":"Development"},{"__guid":"CF672231-0932-4474-B224-68319379655C","name":"Design"}],"meta":[{"recordID":"1","href":"\/RESTfm\/STEVE\/layout\/Api-TimeType\/1.json"},{"recordID":"2","href":"\/RESTfm\/STEVE\/layout\/Api-TimeType\/2.json"}],"metaField":[{"name":"__guid","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"name","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"}],"info":{"tableRecordCount":"2","foundSetCount":"2","fetchCount":"2","skip":0,"X-RESTfm-Version":"2.0.2\/r291","X-RESTfm-Protocol":"4","X-RESTfm-Status":200,"X-RESTfm-Reason":"OK","X-RESTfm-Method":"GET"}}
  
  @expectedTimeType1 = new @mockModel @apiTimeTypeResponseData.data[0], @apiTimeTypeResponseData.meta[0].href, @apiTimeTypeResponseData.meta[0].recordID
  @expectedTimeType2 = new @mockModel @apiTimeTypeResponseData.data[1], @apiTimeTypeResponseData.meta[1].href, @apiTimeTypeResponseData.meta[1].recordID
  @expectedTimeTypesList = new @mockList()
  @expectedTimeTypesList.items = [@expectedTimeType1, @expectedTimeType2]

  @expectedTime = new @mockModel @apiResponse.data[0], @apiResponse.meta[0].href, @apiResponse.meta[0].recordID
  @expectedTimes = new @mockList
  @expectedTimes.items = [@expectedTime]
  @expectedStaffAssigned = new @mockModel @apiStaffAssignedResponse.data[0], @apiStaffAssignedResponse.meta[0].href, @apiStaffAssignedResponse.meta[0].recordID
  @expectedStaffAssignments = [@expectedStaffAssigned]
  @failureMessage = 'This is the message'
  spyOn(@mockTimeRepo,"getAllForStaff").andCallFake (staff_id,pagesize) =>
   if @promiseSucceeds
    @q.when @expectedTimes
   else
    @q.reject @failureMessage
  spyOn(@mockTimeRepo,"getAll").andCallFake (path) =>
   if @promiseSucceeds
    @q.when @expectedTimes
   else
    @q.reject @failureMessage
  spyOn(@mockTimeTypes,"getAllSorted").andCallFake () =>
   if @promiseSucceeds
    @q.when @expectedTimeTypesList
   else
    @q.reject @failureMessage
    
  spyOn(@mockStaffAssigned,"getAllForStaff").andCallFake (staff_id,pagesize) =>
   if @promiseSucceeds
    @q.when @expectedStaffAssignments
   else
    @q.reject @failureMessage
  
  @subject = @controller 'timeController', {$scope:@scope, userRepository:@mockRepo, timeRepository:@mockTimeRepo, typeTypeRepository:@mockTimeTypes, staffAssignedRepository: @mockStaffAssigned, notifications:@mockNotifications}


 Then -> expect(@subject).toBeDefined()
 Then -> expect(@subject.timeRepository).toBe(@mockTimeRepo)
 Then -> expect(@subject.gettingTime).toBe(false)
 Then -> expect(@subject.newtime.date).toBe(@today)
 
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


 describe 'getTimeTypes() when promise succeeds', ->
  Given ->
   @promiseSucceeds = true
   
  When ->
   @promise = @subject.getTimeTypes()
   @promise.then (data) => @result = data
   @scope.$apply()
   
  Then -> expect(@mockTimeTypes.getAllSorted).toHaveBeenCalled()
  Then -> expect(@subject.timeTypes).toEqual(@expectedTimeTypesList)
  Then -> expect(@result).toEqual(@expectedTimeTypesList)

 describe "getTimeTypes() when promise fails", ->
  Given ->
   @promiseSucceeds = false
   spyOn(@mockNotifications,"error")
   
  When -> 
   @promise = @subject.getTimeTypes()
   @promise.then (data) => @result = data
   @scope.$apply()
  
  Then -> expect(@mockTimeTypes.getAllSorted).toHaveBeenCalled()
  Then -> expect(@mockNotifications.error).toHaveBeenCalledWith('There was a problem. ' + @failureMessage)
  Then -> expect(@result).not.toEqual(@expectedTimeTypesList)

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
  
 describe "hasJobs() when staffid does not exist, jobs does not exist", ->
  
  Given ->
   @staffid = undefined
  
  When ->
   @promiseSucceeds = true
   @subject.staffid = @staffid 
   @subject.jobs = undefined
   @subject.gettingJobs = false
   @result = @subject.hasJobs()
  
  Then -> expect(@mockStaffAssigned.getAllForStaff).not.toHaveBeenCalledWith(@staffid)
  Then -> expect(@subject.gettingJobs).toBe(false)
  Then -> expect(@result).toBe(false)




 describe "getTime() when staffid & pagesize exists and promise succeeds", ->
  Given ->
   @staffid = 'someid'
   @pagesize = 'pagesize'
   
  When -> 
   @promiseSucceeds = true
   @subject.staffid = @staffid
   @subject.pagesize = @pagesize
   @promise = @subject.getTime()
   @promise.then (data) => @result = data
   @scope.$apply()
  
  Then -> expect(@mockTimeRepo.getAllForStaff).toHaveBeenCalledWith(@staffid, @pagesize)
  Then -> expect(@subject.times).toEqual(@expectedTimes)
  Then -> expect(@result).toEqual(@expectedTimes)
  
 describe "getTime() when staffid & pagesize exists and promise fails", ->
  Given ->
   @staffid = 'someid'
   @pagesize = 'pagesize'
   spyOn(@mockNotifications,"error")
   
  When -> 
   @promiseSucceeds = false
   @subject.staffid = @staffid
   @subject.pagesize = @pagesize
   @promise = @subject.getTime()
   @promise.then (data) => @result = data
   @scope.$apply()
  
  Then -> expect(@mockTimeRepo.getAllForStaff).toHaveBeenCalledWith(@staffid, @pagesize)
  Then -> expect(@mockNotifications.error).toHaveBeenCalledWith('There was a problem. ' + @failureMessage)
  Then -> expect(@result).not.toEqual(@expectedTimes)
  
  
 describe "getTime() when path is sent and promise succeeds", ->
  Given ->
   @path = 'somepath'
   
  When -> 
   @promiseSucceeds = true
   @subject.staffid = @staffid
   @subject.pagesize = @pagesize
   @promise = @subject.getTime(@path)
   @promise.then (data) => @result = data
   @scope.$apply()
  
  Then -> expect(@mockTimeRepo.getAll).toHaveBeenCalledWith(@path)
  Then -> expect(@subject.times).toEqual(@expectedTimes)
  Then -> expect(@result).toEqual(@expectedTimes)

  
 describe "hasTime() when staffid & pagesize exists, times does not, and not already getting time", ->
  
  Given ->
   @staffid = 'someid'
   @pagesize = 'pagesize'
  
  When ->
   @promiseSucceeds = true
   @subject.staffid = @staffid 
   @subject.pagesize = @pagesize
   @subject.times = undefined
   @subject.gettingTime = false
   @result = @subject.hasTime()
  
  Then -> expect(@mockTimeRepo.getAllForStaff).toHaveBeenCalledWith(@staffid, @pagesize)
  Then -> expect(@subject.gettingTime).toBe(true)
  Then -> expect(@result).toBe(false)
  
 describe "hasTime() when staffid exists, times does not exist, promise returns after getting time with some times", ->
  
  Given ->
   @staffid = 'someid'
   @pagesize = 'pagesize'
  
  When ->
   @promiseSucceeds = true
   @subject.staffid = @staffid 
   @subject.times = undefined
   @subject.pagesize = @pagesize
   @subject.gettingTime = false
   @result = @subject.hasTime()
   @scope.$apply()
  
  Then -> expect(@mockTimeRepo.getAllForStaff).toHaveBeenCalledWith(@staffid, @pagesize)
  Then -> expect(@subject.gettingTime).toBe(false)
  Then -> expect(@result).toBe(false)
  
 describe "hasTime() when staffid exists, times does not, and already getting time", ->
  
  Given ->
   @staffid = 'someid'
   @pagesize = 'pagesize'
  
  When ->
   @promiseSucceeds = true
   @subject.staffid = @staffid
   @subject.pagesize = @pagesize 
   @subject.times = undefined
   @subject.gettingTime = true
   @result = @subject.hasTime()
  
  Then -> expect(@mockTimeRepo.getAllForStaff).not.toHaveBeenCalledWith(@staffid, @pagesize)
  Then -> expect(@subject.gettingTime).toBe(true)
  Then -> expect(@result).toBe(false)
  
 describe "hasTime() when staffid exists, times does exists", ->
  
  Given ->
   @staffid = 'someid'
   @pagesize = 'pagesize'
  
  When ->
   @promiseSucceeds = true
   @subject.staffid = @staffid
   @subject.pagesize = @pagesize
   @subject.times = @expectedTimes
   @subject.gettingTime = false
   @result = @subject.hasTime()
  
  Then -> expect(@mockTimeRepo.getAllForStaff).not.toHaveBeenCalledWith(@staffid, @pagesize)
  Then -> expect(@subject.gettingTime).toBe(false)
  Then -> expect(@result).toBe(true)
  
 describe "hasTime() when staffid does not exist, times does not exists", ->
  
  Given ->
   @staffid = undefined
   @pagesize = 'pagesize'
  
  When ->
   @promiseSucceeds = true
   @subject.staffid = @staffid
   @subject.pagesize = @pagesize
   @subject.times = undefined
   @subject.gettingTime = false
   @result = @subject.hasTime()
  
  Then -> expect(@mockTimeRepo.getAllForStaff).not.toHaveBeenCalledWith(@staffid, @pagesize)
  Then -> expect(@subject.gettingTime).toBe(false)
  Then -> expect(@result).toBe(false)

 
 describe "editTime() for the first time", ->
  Given -> @expectedTime.editing = undefined
  When ->  @subject.editTime(@expectedTime)
  Then -> expect(@expectedTime.editing).toBe(true)
 
 describe "editTime() when it's false", ->
  Given -> @expectedTime.editing = false
  When ->  @subject.editTime(@expectedTime)
  Then -> expect(@expectedTime.editing).toBe(true)

 describe "editTime() when it's true", ->
  Given -> @expectedTime.editing = true
  When ->  @subject.editTime(@expectedTime)
  Then -> expect(@expectedTime.editing).toBe(true)

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
   Then -> expect(@expectedTime.editing).toBe(false)
   
  describe "when the time repo update is not successful", ->
  
   When ->
    @succeedPromise = false
    @subject.updateTime(@expectedTime)
    @scope.$apply()
    
   Then -> expect(@mockTimeRepo.update).toHaveBeenCalledWith(@expectedTime)
   Then -> expect(@mockNotifications.error).toHaveBeenCalledWith(@failureResponse)
   Then -> expect(@expectedTime.editing).toBe(false)



 describe "deleteTime()", ->
 
  Given ->
   @subject.times = new @mockList()
   @successResponse = "some success response"
   @failureResponse = "some failure response"
   spyOn(@mockTimeRepo, "delete").andCallFake =>
    if @succeedPromise
     @q.when @successResponse
    else
     @q.reject @failureResponse

   spyOn(@mockNotifications, "success")
   spyOn(@mockNotifications, "error")
   
  describe "when the user does not confirm", ->
  
   Given -> spyOn(window,'confirm').andReturn(false)
  
   When ->
    @subject.times.items = [@expectedTime]
    @subject.deleteTime(@expectedTime)
    @scope.$apply()
    
   Then -> expect(window.confirm).toHaveBeenCalled()
   Then -> expect(@mockTimeRepo.delete).not.toHaveBeenCalledWith(@expectedTime.href)
   Then -> expect(@subject.times.items).toContain(@expectedTime)
   
  describe "when the user confirms", ->
   
   Given -> spyOn(window,'confirm').andReturn(true)
   
   describe "and time repo delete is successful", ->
  
    When ->
     @subject.times.items = [@expectedTime]
     
     @succeedPromise = true
     @subject.deleteTime(@expectedTime)
     @scope.$apply()
     
    Then -> expect(window.confirm).toHaveBeenCalled()
    Then -> expect(@mockTimeRepo.delete).toHaveBeenCalledWith(@expectedTime.href)
    Then -> expect(@mockNotifications.success).toHaveBeenCalledWith(@successResponse)
    Then -> expect(@subject.times.items).not.toContain(@expectedTime)
    
   describe "and time repo update is not successful", ->
   
    When ->
     @subject.times.items = [@expectedTime]
     @succeedPromise = false
     @subject.deleteTime(@expectedTime)
     @scope.$apply()
    
    Then -> expect(window.confirm).toHaveBeenCalled()
    Then -> expect(@mockTimeRepo.delete).toHaveBeenCalledWith(@expectedTime.href)
    Then -> expect(@mockNotifications.error).toHaveBeenCalledWith(@failureResponse)
    Then -> expect(@subject.times.items).toContain(@expectedTime)



 describe "addTime()", ->
 
  Given ->
   @subject.times = new @mockList()
   @job_id='someid'
   @subject.staffid = 'someid'
   @type='sometype'
   @date='somedate'
   @hours='somehours'
   @note='somenote'
   @successResponse = "some success response"
   @failureResponse = "some failure response"
   spyOn(@mockNotifications, "success")
   spyOn(@mockNotifications, "error")
   spyOn(@mockTimeRepo, "add").andCallFake =>
    if @succeedPromise
     @q.when {msg:@successResponse, data: @newtimemodel}
    else
     @q.reject @failureResponse
   
  describe "when all data is present", ->
   Given ->
    @subject.newtime = {job_id:@job_id,type:@type,date:@date,hours:@hours,note:@note}
    @newtimemodel = new @mockModel @subject.newtime, '', ''
    
   describe "when the time repo add is successful", ->
    When ->
     @succeedPromise = true
     @subject.addTime(@subject.newtime)
     @scope.$apply()
     
    Then -> expect(@mockTimeRepo.add).toHaveBeenCalledWith(@job_id, @subject.staffid, @type, @date, @hours, @note)
    Then -> expect(@mockNotifications.success).toHaveBeenCalledWith(@successResponse)
    Then -> expect(@subject.times.items).toContain(@newtimemodel)
    Then -> expect(@subject.newtime).toEqual({date:@today})
    
   describe "when the time repo add is not successful", ->
   
    When ->
     @succeedPromise = false
     @subject.addTime(@subject.newtime)
     @scope.$apply()
     
    Then -> expect(@mockTimeRepo.add).toHaveBeenCalledWith(@job_id, @subject.staffid, @type, @date, @hours, @note)
    Then -> expect(@mockNotifications.error).toHaveBeenCalledWith(@failureResponse)
    Then -> expect(@subject.times.items).not.toContain(@newtimemodel)
    
  describe "when all job id is missing", ->
   Given ->
    @newtime = {job_id:'',type:@type,date:@date,hours:@hours,note:@note}
    @newtimemodel = new @mockModel @newtime, '', ''
    
   When ->
    @subject.addTime(@newtime)
    
   Then -> expect(@mockTimeRepo.add).not.toHaveBeenCalledWith('', @subject.staffid, @type, @date, @hours, @note)
   Then -> expect(@mockNotifications.error).toHaveBeenCalledWith('A job must be entered')
   Then -> expect(@subject.times.items).not.toContain(@newtimemodel)
  
  describe "when all hours is missing", ->
   Given ->
    @newtime = {job_id:@job_id,type:@type,date:@date,hours:'',note:@note}
    @newtimemodel = new @mockModel @newtime, '', ''
    
   When ->
    @subject.addTime(@newtime)
    
   Then -> expect(@mockTimeRepo.add).not.toHaveBeenCalledWith(@job_id, @subject.staffid, @type, @date, '', @note)
   Then -> expect(@mockNotifications.error).toHaveBeenCalledWith('Hours must be entered')
   Then -> expect(@subject.times.items).not.toContain(@newtimemodel)
    