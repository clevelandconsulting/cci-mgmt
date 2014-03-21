describe "timeRepository", ->
 Given -> module('app')
 
 Given angular.mock.inject ($injector,  $rootScope, $q, _fmRestRepository_, _cciApiService_, _fmRestModel_) -> 
  @mockRepo = _fmRestRepository_
  @mockModel = _fmRestModel_
  @mockApi = _cciApiService_
  @q = $q
  @rootScope = $rootScope
  @subject = $injector.get 'timeRepository', {$q:@q,fmRestModel: @mockModel, fmRestRepository:@mockRepo, cciApiService:@mockApi}
  @apiResponse = {'data': {"data":[{"__guid":"D35E2D2B-949E-4110-B11D-6AB193EF32C0","job_id":"5304D753-BDEF-403A-A347-74CCCFA2F71D","staff_id":"DC5FB862-E6F0-45FD-AA86-BC9A41003873","billed_flag":"0","type":"Development\/Design","date":"03\/10\/2014","hours":"34","note":"Great note!","__created_ts":"03\/10\/2014 08:05:32","__created_an":"Developer","__modified_ts":"03\/10\/2014 08:05:39","__modified_an":"Developer","Job.Time::name":"Test Project"}],"meta":[{"recordID":"2","href":"\/RESTfm\/STEVE\/layout\/Api-Time\/2.json"}],"metaField":[{"name":"__guid","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"job_id","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"staff_id","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"billed_flag","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"type","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"date","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"date"},{"name":"hours","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"number"},{"name":"note","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"__created_ts","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"timestamp"},{"name":"__created_an","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"__modified_ts","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"timestamp"},{"name":"__modified_an","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"Job.Time::name","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"}],"info":{"X-RESTfm-Version":"2.0.2\/r291","X-RESTfm-Protocol":"4","X-RESTfm-Status":200,"X-RESTfm-Reason":"OK","X-RESTfm-Method":"GET"}}, 'status': 200}
  @expectedTime = new @mockModel @apiResponse.data.data[0], @apiResponse.data.meta[0].href, @apiResponse.data.meta[0].recordID
  @expectedTimeId = @expectedTime.recordID
  @staff_id = @expectedTime.data.staff_id  #'DC5FB862-E6F0-45FD-AA86-BC9A41003873'
  @apiResponseFunction = (path) =>
   if @succeedPromise
    @q.when @apiResponse
   else
    @q.reject @apiResponse
  @emptyFunction = ->
  @modelName = 'time'
  @path = 'layout/Api-Time'
  spyOn(@mockApi,"get").andCallFake @apiResponseFunction
  
 Then -> expect(@subject).toBeDefined()
 Then -> expect(@subject.path).toEqual(@path)
 Then -> expect(@subject.modelName).toEqual(@modelName)

 describe "getAllForStaff()", ->
  When ->
   @succeedPromise = true 
   @promise = @subject.getAllForStaff(@staff_id)
   @promise.then (data) => @result = data
   @rootScope.$apply()
   
  Then -> expect(@mockApi.get).toHaveBeenCalledWith('layout/Api-Time.json?RFMsF1=staff_id&RFMsV1=' + @staff_id + '&RFMscript=Api-Time.sort')
  Then -> expect(@result).toEqual([@expectedTime])
  
 describe "add()", ->
  Given ->
   
   @dataExpected = [{"__guid":"D35E2D2B-949E-4110-B11D-6AB193EF32C0","job_id":"5304D753-BDEF-403A-A347-74CCCFA2F71D","staff_id":"DC5FB862-E6F0-45FD-AA86-BC9A41003873","billed_flag":"0","type":"Development\/Design","date":"03\/10\/2014","hours":"34","note":"Great note!","__created_ts":"03\/10\/2014 08:05:32","__created_an":"Developer","__modified_ts":"03\/10\/2014 08:05:39","__modified_an":"Developer","Job.Time::name":"Test Project"}]
   @metaExpected = [{"recordID":"2","href":"\/RESTfm\/STEVE\/layout\/Api-Time\/2.json"}]
   @metaFieldExpected = [{"name":"__guid","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"job_id","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"staff_id","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"billed_flag","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"type","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"date","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"date"},{"name":"hours","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"number"},{"name":"note","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"__created_ts","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"timestamp"},{"name":"__created_an","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"__modified_ts","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"timestamp"},{"name":"__modified_an","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"Job.Time::name","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"}]
   @newTime = new @mockModel {job_id: @dataExpected[0].job_id, staff_id: @dataExpected[0].staff_id, type: @dataExpected[0].type, date: @dataExpected[0].date, hours:@dataExpected[0].hours, note:@dataExpected[0].note },'',''
   @dataToSend = {data: [@newTime.data]}
   spyOn(@mockApi,"post").andCallFake @apiResponseFunction
   
  describe "when the api response with success (201)", ->
  
   Given ->
    @infoExpected = {"X-RESTfm-Version":"2.0.2\/r291","X-RESTfm-Protocol":"4","X-RESTfm-Status":201,"X-RESTfm-Reason":"OK","X-RESTfm-Method":"POST"}
    @apiResponse = {'data': {"data":@dataExpected,"meta":@metaExpected,"metaField":@metaFieldExpected,"info":@infoExpected}, 'status': 201}
   
   When ->
    @succeedPromise = true
    @promise = @subject.add(@newTime.data.job_id, @newTime.data.staff_id, @newTime.data.type, @newTime.data.date, @newTime.data.hours, @newTime.data.note)
    @promise.then (response) => @result = response
    @rootScope.$apply()
   
   Then -> expect(@mockApi.post).toHaveBeenCalledWith('layout/Api-Time.json',@dataToSend)
   Then -> expect(@result.msg).toEqual("Your " + @modelName + " was successfully added!")
   Then -> expect(@result.data).toEqual(@expectedTime)
  
  describe "when the api response with error", ->
  
   Given ->
    @reason = "some reason"
    @infoExpected = {"X-RESTfm-Version":"2.0.2\/r291","X-RESTfm-Protocol":"4","X-RESTfm-Status":500,"X-RESTfm-Reason":@reason,"X-RESTfm-Method":"POST"}
    @apiResponse = {'data': {"data": [],"meta": [], "info":@infoExpected}, 'status': 500}
   
   When ->
    @succeedPromise = false
    @promise = @subject.add(@newTime.data.job_id, @newTime.data.staff_id, @newTime.data.type, @newTime.data.date, @newTime.data.hours, @newTime.data.note)
    @promise.then @emptyFunction, (response) => @result = response
    @rootScope.$apply()
   
   Then -> expect(@mockApi.post).toHaveBeenCalledWith('layout/Api-Time.json',@dataToSend)
   Then -> expect(@result).toEqual("There was a problem adding your " + @modelName + ". " + @reason)
  

  
  
 describe "update()", ->
  Given ->
   @dataToSend = {data: [{job_id: @expectedTime.data.job_id, staff_id: @expectedTime.data.staff_id, type: @expectedTime.data.type, date: @expectedTime.data.date, hours:@expectedTime.data.hours, note:@expectedTime.data.note }]}
   spyOn(@mockApi,"put").andCallFake @apiResponseFunction
   
  describe "when the api responds with success (200)", ->
  
   When ->
    @succeedPromise = true
    @apiResponse = { data: {"data": [],"meta": [],"info": {"X-RESTfm-Version": "2.0.1\/r280","X-RESTfm-Protocol": "4","X-RESTfm-Status": 200,"X-RESTfm-Reason": "OK","X-RESTfm-Method": "PUT"}}, status: 200}
    @promise = @subject.update(@expectedTime)
    @promise.then (response) => @result = response
    @rootScope.$apply()
    
   Then -> expect(@mockApi.put).toHaveBeenCalledWith('layout/Api-Time/2.json',@dataToSend)
   Then -> expect(@result).toEqual("Your " + @modelName + " was successfully updated!")
    
  describe "when the api responds with an error", ->
  
   Given ->
    
    @succeedPromise = false
    
   describe "404", ->
    Given ->
     @apiResponse = {data: {"data":[],"meta":[],"info":{"X-RESTfm-FM-Status":"101","X-RESTfm-FM-Reason":"Record is missing","X-RESTfm-Version":"2.0.2\/r291","X-RESTfm-Protocol":"4","X-RESTfm-Status":404,"X-RESTfm-Reason":"Not Found","X-RESTfm-Method":"PUT"}}, status:404}
     
    When ->
     @promise = @subject.update(@expectedTime)
     @promise.then @emptyFunction, (response) => @result = response
     @rootScope.$apply()
     
    Then -> expect(@mockApi.put).toHaveBeenCalledWith('layout/Api-Time/2.json',@dataToSend)
    Then -> expect(@result).toEqual("There was a problem updating your " + @modelName + ". Unable to find the record at layout/Api-Time/2.json")
     
   describe "500 and a non null status", ->
    Given ->
     @status = 'anything not null'
     @apiResponse = { data: {"data":[],"meta":[],"info":{"X-RESTfm-FM-Status":@status,"X-RESTfm-FM-Reason":"Field Not Found","X-RESTfm-Version":"2.0.2\/r291","X-RESTfm-Protocol":"4","X-RESTfm-Status":500,"X-RESTfm-Reason":"FileMaker Error","X-RESTfm-Method":"PUT"}}, status: 500}
     
    When ->
     @promise = @subject.update(@expectedTime)
     @promise.then @emptyFunction, (response) => @result = response
     @rootScope.$apply()
    
    Then -> expect(@mockApi.put).toHaveBeenCalledWith('layout/Api-Time/2.json',@dataToSend)
    Then -> expect(@result).toEqual("There was a problem updating your " + @modelName + ". " +  @apiResponse.data.info['X-RESTfm-FM-Status'] + ': ' + @apiResponse.data.info['X-RESTfm-FM-Reason'])
   
   describe "500 and a null status", ->
    Given ->
     @status = null
     @apiResponse = { data: {"data":[],"meta":[],"info":{"X-RESTfm-FM-Status":@status,"X-RESTfm-FM-Reason":"Field Not Found","X-RESTfm-Version":"2.0.2\/r291","X-RESTfm-Protocol":"4","X-RESTfm-Status":500,"X-RESTfm-Reason":"FileMaker Error","X-RESTfm-Method":"PUT"}}, status: 500}
     
    When ->
     @promise = @subject.update(@expectedTime)
     @promise.then @emptyFunction, (response) => @result = response
     @rootScope.$apply()
    
    Then -> expect(@mockApi.put).toHaveBeenCalledWith('layout/Api-Time/2.json',@dataToSend)
    Then -> expect(@result).toEqual("There was a problem updating your " + @modelName + ". " + @apiResponse.data.info['X-RESTfm-FM-Reason'])
