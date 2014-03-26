describe "fmRestRepository", ->
 Given -> module('app')
 
 Given angular.mock.inject ($injector, _cciApiService_, _fmRestModel_, _fmRestList_, $rootScope, $q) ->
  @rootScope = $rootScope
  @q = $q
  @mockApi = _cciApiService_
  @mockModel = _fmRestModel_
  @mockList = _fmRestList_
  @subjectClass = $injector.get 'fmRestRepository'
  @path = 'layout/Api-Time'
  @modelName = 'time'
  @subject = new @subjectClass(@q, @mockApi, @mockModel, @mockList, @path, @modelName)
  
  @apiResponse = {'data': {"data":[{"__guid":"D35E2D2B-949E-4110-B11D-6AB193EF32C0","job_id":"5304D753-BDEF-403A-A347-74CCCFA2F71D","staff_id":"DC5FB862-E6F0-45FD-AA86-BC9A41003873","billed_flag":"0","type":"Development\/Design","date":"03\/10\/2014","hours":"34","note":"Great note!","__created_ts":"03\/10\/2014 08:05:32","__created_an":"Developer","__modified_ts":"03\/10\/2014 08:05:39","__modified_an":"Developer","Job.Time::name":"Test Project"}],"meta":[{"recordID":"2","href":"\/RESTfm\/STEVE\/layout\/Api-Time\/2.json"}],"metaField":[{"name":"__guid","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"job_id","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"staff_id","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"billed_flag","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"type","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"date","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"date"},{"name":"hours","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"number"},{"name":"note","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"__created_ts","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"timestamp"},{"name":"__created_an","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"__modified_ts","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"timestamp"},{"name":"__modified_an","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"Job.Time::name","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"}],"info":{"X-RESTfm-Version":"2.0.2\/r291","X-RESTfm-Protocol":"4","X-RESTfm-Status":200,"X-RESTfm-Reason":"OK","X-RESTfm-Method":"GET"}}, 'status': 200}
  @expectedTime = new @mockModel @apiResponse.data.data[0], @apiResponse.data.meta[0].href, @apiResponse.data.meta[0].recordID
  @expectedTimeId = @expectedTime.recordID
  @expectedList = new @mockList
  @expectedList.items = [@expectedTime]
  
  @staff_id = @expectedTime.data.staff_id  #'DC5FB862-E6F0-45FD-AA86-BC9A41003873'
  @apiResponseFunction = (path) =>
   if @succeedPromise
    @q.when @apiResponse
   else
    @q.reject @apiResponse
  @emptyFunction = ->
  spyOn(@mockApi,"get").andCallFake @apiResponseFunction
  
 Then -> expect(@subject).toBeDefined()
 Then -> expect(@subject.path).toEqual(@path)
 Then -> expect(@subject.modelName).toEqual(@modelName)
 
 describe "getAllForStaff() with a script", ->
  Given -> 
   @scriptkey = 'RFMscript'
   @scriptvalue = 'anyvalue'
   
  When -> @subject.getAllForStaff(@staff_id,@scriptvalue)
  
  Then -> expect(@mockApi.get).toHaveBeenCalledWith(@path + '.json?RFMsF1=staff_id&RFMs
V1=' + @staff_id + '&' + @scriptkey + '=' + @scriptvalue )

 describe "getAllForStaff() with a script and page size", ->
  Given -> 
   @scriptkey = 'RFMscript'
   @scriptvalue = 'anyvalue'
   @pagekey = 'RFMmax'
   @pagesize = 'anything'
   
  When -> @subject.getAllForStaff(@staff_id,@scriptvalue, @pagesize)
  
  Then -> expect(@mockApi.get).toHaveBeenCalledWith(@path + '.json?RFMsF1=staff_id&RFMs
V1=' + @staff_id + '&' + @scriptkey + '=' + @scriptvalue + '&' + @pagekey + '=' + @pagesize )



 describe "getAllForStaff() with no script and page size", ->
  Given -> 
   @pagekey = 'RFMmax'
   @pagesize = 'anything'
   
  When -> @subject.getAllForStaff(@staff_id,'', @pagesize)
  
  Then -> expect(@mockApi.get).toHaveBeenCalledWith(@path + '.json?RFMsF1=staff_id&RFMs
V1=' + @staff_id + '&' + @pagekey + '=' + @pagesize )

 

 
 describe "getAll() with a path", ->
  Given ->
   @succeedPromise = true 
   @path = 'somepath'
   
  When ->
   @promise = @subject.getAll(@path)
   @promise.then (data) => @result = data
   @rootScope.$apply()
   
  Then -> expect(@mockApi.get).toHaveBeenCalledWith(@path)
  Then -> expect(@result).toEqual(@expectedList)
