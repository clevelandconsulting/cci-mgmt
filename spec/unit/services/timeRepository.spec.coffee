describe "timeRepository", ->
 Given -> module('app')
 
 Given angular.mock.inject ($injector, _cciApiService_, _fmRestModel_, $rootScope, $q) ->
  @rootScope = $rootScope
  @q = $q
  @mockApi = _cciApiService_
  @mockModel = _fmRestModel_
  @subject = $injector.get 'timeRepository', {cciApiService:@mockApi,fmRestModel:@mockModel}
  @apiResponse = {'data': {"data":[{"__guid":"5A5751B4-6F4A-4C7B-BE0E-36493E7CE2D1","job_id":"3B052C63-BE27-433A-94FC-3B82B23ADF44","staff_id":"DC5FB862-E6F0-45FD-AA86-BC9A41003873","billed_flag":"0","type":"Client Support","date":"03\/10\/2014","hours":"500","note":"Client Hand-holding.","__created_ts":"03\/10\/2014 11:35:29","__created_an":"Developer","__modified_ts":"03\/10\/2014 11:35:42","__modified_an":"Developer"}],"meta":[{"recordID":"3","href":"\/RESTfm\/STEVE\/layout\/Time\/3.json"}],"metaField":[{"name":"__guid","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"job_id","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"staff_id","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"billed_flag","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"type","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"date","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"date"},{"name":"hours","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"number"},{"name":"note","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"__created_ts","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"timestamp"},{"name":"__created_an","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"__modified_ts","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"timestamp"},{"name":"__modified_an","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"}],"info":{"X-RESTfm-Version":"2.0.2\/r291","X-RESTfm-Protocol":"4","X-RESTfm-Status":200,"X-RESTfm-Reason":"OK","X-RESTfm-Method":"GET"}}, 'status': 200}
  @expectedTime = new @mockModel @apiResponse.data.data[0], @apiResponse.data.meta[0].href, @apiResponse.data.meta[0].recordID
  @expectedTimeId = @expectedTime.recordID
  @staff_id = @expectedTime.data.staff_id  #'DC5FB862-E6F0-45FD-AA86-BC9A41003873'
  @apiResponseFunction = (path) =>
   if(path == 'layout/Api-Time.json?RFMsF1=staff_id&RFMsV1=' + @staff_id || path == 'layout/Api-Time/3.json')
     @q.when @apiResponse
    else
     @q.when '' 
  spyOn(@mockApi,"get").andCallFake @apiResponseFunction

 Then -> expect(@subject).toBeDefined()
 
 describe "getAllForStaff()", ->
  When -> 
   @promise = @subject.getAllForStaff(@staff_id)
   @promise.then (data) => @result = data
   @rootScope.$apply()
   
  Then -> expect(@mockApi.get).toHaveBeenCalledWith('layout/Api-Time.json?RFMsF1=staff_id&RFMsV1=' + @staff_id)
  Then -> expect(@result).toEqual([@expectedTime])
   
  

