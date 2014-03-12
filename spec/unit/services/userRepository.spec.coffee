describe "userRepository", ->
 Given -> module('app')
 
 Given angular.mock.inject ($injector, _cciApiService_, _user_, _userStorageService_, $rootScope, $q) ->
  @rootScope = $rootScope
  @q = $q
  @mockApi = _cciApiService_
  @mockUser = _user_
  @mockUserStorage = _userStorageService_
  @subject = $injector.get 'userRepository', {cciApiService:@mockApi,user:@mockUser,userStorageService:@mockUserStorage}
  @apiResponse = {"data":{"nav":[{"name":"start","href":"/RESTfm/STEVE/layout/Staff.json?RFMsF1=filemaker_accountname&RFMsV1=Developer"},{"name":"end","href":"/RESTfm/STEVE/layout/Staff.json?RFMsF1=filemaker_accountname&RFMsV1=Developer&RFMskip=end"}],"data":[{"__guid":"DC5FB862-E6F0-45FD-AA86-BC9A41003873","first_name":"Johnny Q","last_name":"Dev","filemaker_accountname":"Developer","__created_ts":"08/09/2013 06:52:45","__created_an":"Admin","__modified_ts":"03/11/2014 16:53:34","__modified_an":"Developer","full_name_c":"Johnny Q Dev","full_name_lastfirst_c":"Dev, Johnny Q","__icon_repetition_c":"1","__icon_c":"http://localhost/fmi/xml/cnt/frame_000003.png?-db=STEVE&-lay=Staff&-recid=2&-field=__icon_c(1)","filemaker_accountprivilege":"[Full Access]","filemaker_accountpassword_date":"03/06/2014","filemaker_accountpassword_c":"••••••••••","filemaker_accountpassword":"letmein","filemaker_account_logged_in_f":"1","filemaker_account_exists_f":"1","filemaker_account_active_f":"1","__account_name":"Developer","__account_password":"letmein","__account_privilege":"[Full Access]"}],"meta":[{"recordID":"2","href":"/RESTfm/STEVE/layout/Staff/2.json"}],"metaField":[{"name":"__guid","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"first_name","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"last_name","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"filemaker_accountname","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"__created_ts","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"timestamp"},{"name":"__created_an","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"__modified_ts","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"timestamp"},{"name":"__modified_an","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"full_name_c","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"full_name_lastfirst_c","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"__icon_repetition_c","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"number"},{"name":"__icon_c","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"container"},{"name":"filemaker_accountprivilege","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"filemaker_accountpassword_date","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"date"},{"name":"filemaker_accountpassword_c","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"filemaker_accountpassword","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"filemaker_account_logged_in_f","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"number"},{"name":"filemaker_account_exists_f","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"number"},{"name":"filemaker_account_active_f","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"number"},{"name":"__account_name","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"__account_password","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"__account_privilege","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"}],"info":{"tableRecordCount":"4","foundSetCount":"1","fetchCount":"1","skip":0,"X-RESTfm-Version":"2.0.2/r291","X-RESTfm-Protocol":"4","X-RESTfm-Status":200,"X-RESTfm-Reason":"OK","X-RESTfm-Method":"GET"}},"status":200,"config":{"method":"GET","transformRequest":[null],"transformResponse":[null],"url":"https://fms.clevelandconsulting.com/RESTfm/STEVE/layout/Staff.json?RFMsF1=filemaker_accountname&RFMsV1=Developer","headers":{"Accept":"application/json, text/plain, */*","Authorization":"Basic RGV2ZWxvcGVyOmxldG1laW4="}}}
  @expectedUser = new @mockUser @apiResponse.data.data[0], @apiResponse.data.meta[0].href, @apiResponse.data.meta[0].recordID
  
  @apiResponseFunction = (path) =>
   if(path == 'layout/Staff.json?RFMsF1=filemaker_accountname&RFMsV1=' + @username || path == 'layout/Staff/2.json')
     @q.when @apiResponse
    else
     @q.when '' 
  spyOn(@mockApi,"get").andCallFake @apiResponseFunction

 Then -> expect(@subject).toBeDefined()
 
 describe "getUserByUsername()", ->
  Given ->
   @username = 'somename'     
     
  When -> 
   @promise = @subject.getUserByUsername(@username)
   @promise.then (data) =>
    @result = data
   @rootScope.$apply()
   
  Then -> expect(@result.data).toEqual(@expectedUser.data)
  Then -> expect(@result.href).toEqual(@expectedUser.href)
  Then -> expect(@result.recordID).toEqual(@expectedUser.recordID)
  
 describe "getUserByHref()", ->
  Given -> 
   @href= "/RESTfm/STEVE/layout/Staff/2.json"
  
  When -> 
   @promise = @subject.getUserByHref(@href)
   @promise.then (data) =>
    @result = data
   @rootScope.$apply()
   
  Then -> expect(@result.data).toEqual(@expectedUser.data)