describe "staffRepository", ->
 Given -> module('app')
 
 Given angular.mock.inject ($injector,  $rootScope, $q, _fmRestRepository_, _cciApiService_, _fmRestModel_, _fmRestList_) -> 
  @mockRepo = _fmRestRepository_
  @mockModel = _fmRestModel_
  @mockList = _fmRestList_
  @mockApi = _cciApiService_
  @q = $q
  @rootScope = $rootScope
  @subject = $injector.get 'staffRepository', {$q:@q,fmRestModel: @mockModel, fmRestList:@mockList, fmRestRepository:@mockRepo, cciApiService:@mockApi}
  @apiResponse = {'data': {"data":[{"__guid":"16CDF29F-B1B5-4015-8D38-E25D2BF32A65","first_name":"Kevin","last_name":"Vile","filemaker_accountname":"Kevin Vile","__created_ts":"08\/07\/2013 21:04:14","__created_an":"Admin","__modified_ts":"10\/17\/2014 08:41:17","__modified_an":"Kevin Vile","full_name_c":"Kevin Vile","full_name_lastfirst_c":"Vile, Kevin","__icon_repetition_c":"1","__icon_c":"http:\/\/localhost\/fmi\/xml\/cnt\/frame_000003.png?-db=STEVE&-lay=Api-Staff&-recid=1&-field=__icon_c(1)","filemaker_accountprivilege":"[Full Access]","filemaker_accountpassword_date":"02\/04\/2014","filemaker_accountpassword_c":"\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022","filemaker_accountpassword":"letmein","filemaker_account_logged_in_f":"1","filemaker_account_exists_f":"1","filemaker_account_active_f":"1","__account_name":"Kevin Vile","__account_password":"letmein","__account_privilege":"Administrator"},{"__guid":"DC5FB862-E6F0-45FD-AA86-BC9A41003873","first_name":"Johnny Q","last_name":"Dev","filemaker_accountname":"Developer","__created_ts":"08\/09\/2013 06:52:45","__created_an":"Admin","__modified_ts":"10\/16\/2014 12:14:00","__modified_an":"Developer","full_name_c":"Johnny Q Dev","full_name_lastfirst_c":"Dev, Johnny Q","__icon_repetition_c":"1","__icon_c":"http:\/\/localhost\/fmi\/xml\/cnt\/frame_000003.png?-db=STEVE&-lay=Api-Staff&-recid=2&-field=__icon_c(1)","filemaker_accountprivilege":"[Full Access]","filemaker_accountpassword_date":"03\/06\/2014","filemaker_accountpassword_c":"\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022","filemaker_accountpassword":"letmein","filemaker_account_logged_in_f":"1","filemaker_account_exists_f":"1","filemaker_account_active_f":"1","__account_name":"Developer","__account_password":"letmein","__account_privilege":"[Full Access]"}],"meta":[{"recordID":"1","href":"\/RESTfm\/STEVE\/layout\/Api-Staff\/1.json"},{"recordID":"2","href":"\/RESTfm\/STEVE\/layout\/Api-Staff\/2.json"},{"recordID":"9","href":"\/RESTfm\/STEVE\/layout\/Api-Staff\/9.json"},{"recordID":"10","href":"\/RESTfm\/STEVE\/layout\/Api-Staff\/10.json"},{"recordID":"17","href":"\/RESTfm\/STEVE\/layout\/Api-Staff\/17.json"},{"recordID":"18","href":"\/RESTfm\/STEVE\/layout\/Api-Staff\/18.json"},{"recordID":"20","href":"\/RESTfm\/STEVE\/layout\/Api-Staff\/20.json"},{"recordID":"21","href":"\/RESTfm\/STEVE\/layout\/Api-Staff\/21.json"}],"metaField":[{"name":"__guid","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"first_name","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"last_name","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"filemaker_accountname","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"__created_ts","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"timestamp"},{"name":"__created_an","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"__modified_ts","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"timestamp"},{"name":"__modified_an","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"full_name_c","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"full_name_lastfirst_c","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"__icon_repetition_c","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"number"},{"name":"__icon_c","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"container"},{"name":"filemaker_accountprivilege","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"filemaker_accountpassword_date","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"date"},{"name":"filemaker_accountpassword_c","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"filemaker_accountpassword","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"filemaker_account_logged_in_f","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"number"},{"name":"filemaker_account_exists_f","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"number"},{"name":"filemaker_account_active_f","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"number"},{"name":"__account_name","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"__account_password","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"__account_privilege","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"}],"info":{"tableRecordCount":"8","foundSetCount":"8","fetchCount":"8","skip":0,"X-RESTfm-Version":"2.0.2\/r291","X-RESTfm-Protocol":"4","X-RESTfm-Status":200,"X-RESTfm-Reason":"OK","X-RESTfm-Method":"GET"}}, 'status': 200}
  @expectedStaff1 = new @mockModel @apiResponse.data.data[0], @apiResponse.data.meta[0].href, @apiResponse.data.meta[0].recordID
  @expectedStaff2 = new @mockModel @apiResponse.data.data[1], @apiResponse.data.meta[1].href, @apiResponse.data.meta[1].recordID
  @expectedList = new @mockList()
  @expectedList.items = [@expectedStaff1, @expectedStaff2]
  @apiResponseFunction = (path) =>
   if @succeedPromise
    @q.when @apiResponse
   else
    @q.reject @apiResponse
  @emptyFunction = ->
  @modelName = 'staff'
  @path = 'layout/Api-Staff'
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
   
  Then -> expect(@mockApi.get).toHaveBeenCalledWith('layout/Api-Staff.json?')
  Then -> expect(@result).toEqual(@expectedList)
