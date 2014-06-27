describe "timeTypeRepository", ->
 Given -> module('app')
 
 Given angular.mock.inject ($injector,  $rootScope, $q, _fmRestRepository_, _cciApiService_, _fmRestModel_, _fmRestList_) -> 
  @mockRepo = _fmRestRepository_
  @mockModel = _fmRestModel_
  @mockList = _fmRestList_
  @mockApi = _cciApiService_
  @q = $q
  @rootScope = $rootScope
  @subject = $injector.get 'timeTypeRepository', {$q:@q,fmRestModel: @mockModel, fmRestList:@mockList, fmRestRepository:@mockRepo, cciApiService:@mockApi}
  @apiResponse = {'data': {"data":[{"__guid":"1D284AD7-6F93-4AFB-91A6-AB62EA616170","name":"Development"},{"__guid":"CF672231-0932-4474-B224-68319379655C","name":"Design"}],"meta":[{"recordID":"1","href":"\/RESTfm\/STEVE\/layout\/Api-TimeType\/1.json"},{"recordID":"2","href":"\/RESTfm\/STEVE\/layout\/Api-TimeType\/2.json"}],"metaField":[{"name":"__guid","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"name","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"}],"info":{"tableRecordCount":"2","foundSetCount":"2","fetchCount":"2","skip":0,"X-RESTfm-Version":"2.0.2\/r291","X-RESTfm-Protocol":"4","X-RESTfm-Status":200,"X-RESTfm-Reason":"OK","X-RESTfm-Method":"GET"}}, 'status': 200}
  @expectedTimeType1 = new @mockModel @apiResponse.data.data[0], @apiResponse.data.meta[0].href, @apiResponse.data.meta[0].recordID
  @expectedTimeType2 = new @mockModel @apiResponse.data.data[1], @apiResponse.data.meta[1].href, @apiResponse.data.meta[1].recordID
  @expectedList = new @mockList()
  @expectedList.items = [@expectedTimeType1, @expectedTimeType2]
  @apiResponseFunction = (path) =>
   if @succeedPromise
    @q.when @apiResponse
   else
    @q.reject @apiResponse
  @emptyFunction = ->
  @modelName = 'timeType'
  @path = 'layout/Api-TimeType'
  spyOn(@mockApi,"get").andCallFake @apiResponseFunction
  
 Then -> expect(@subject).toBeDefined()
 Then -> expect(@subject.path).toEqual(@path)
 Then -> expect(@subject.modelName).toEqual(@modelName)

 describe "getAllSorted()", ->
  Given ->
   @succeedPromise = true 
  
  When ->
   @promise = @subject.getAllSorted()
   @promise.then (data) => @result = data
   @rootScope.$apply()
   
  Then -> expect(@mockApi.get).toHaveBeenCalledWith('layout/Api-TimeType.json?RFMscript=Api-TimeType.sort')
  Then -> expect(@result).toEqual(@expectedList)
