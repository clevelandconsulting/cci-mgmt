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
  @expectedUserId = 2
  @apiResponseFunction = (path) =>
   if(path == 'layout/Api-Staff.json?RFMsF1=filemaker_accountname&RFMsV1=' + @username || path == 'layout/Api-Staff/2.json')
     @q.when @apiResponse
    else
     @q.when '' 
  spyOn(@mockApi,"get").andCallFake @apiResponseFunction

 Then -> expect(@subject).toBeDefined()
 
 describe "getUserByUsername() when not stored and a valid api response", ->
  Given ->
   @username = 'Developer'
   spyOn(@mockUserStorage,"getUsers").andReturn('')
   spyOn(@mockUserStorage,"addUser")
   
  When -> 
   @promise = @subject.getUserByUsername(@username)
   @promise.then (data) => @result = data
   @rootScope.$apply()
   
  Then -> expect(@mockUserStorage.getUsers).toHaveBeenCalled()
  Then -> expect(@mockApi.get).toHaveBeenCalled()
  Then -> expect(@mockUserStorage.addUser).toHaveBeenCalledWith(@result)
  Then -> expect(@result.data).toEqual(@expectedUser.data)
  Then -> expect(@result.href).toEqual(@expectedUser.href)
  Then -> expect(@result.recordID).toEqual(@expectedUser.recordID)
  Then -> expect(@result.username).toEqual(@expectedUser.username)
  
 describe "getUserByUsername() when not stored and an invalid response", ->
  Given ->
   @username = 'Developer'   
   @apiResponse = 'blah'
   spyOn(@mockUserStorage,"getUsers").andReturn('')
     
  When -> 
   @promise = @subject.getUserByUsername(@username)
   @promise.then undefined, (data) => @result = data
   @rootScope.$apply()
  
  Then -> expect(@mockUserStorage.getUsers).toHaveBeenCalled()
  Then -> expect(@mockApi.get).toHaveBeenCalled()
  Then -> expect(@result).toEqual('Invalid API Response')

 describe "getUserByUsername() when it's being stored", ->
  Given ->
   @username = 'Developer'
   spyOn(@mockUserStorage,"getUsers").andReturn([@expectedUser])
   
  When -> 
   @promise = @subject.getUserByUsername(@username)
   @promise.then (data) => @result = data
   @rootScope.$apply()
   
  Then -> expect(@mockUserStorage.getUsers).toHaveBeenCalled()
  Then -> expect(@mockApi.get).not.toHaveBeenCalled()

  Then -> expect(@result.data).toEqual(@expectedUser.data)
  Then -> expect(@result.href).toEqual(@expectedUser.href)
  Then -> expect(@result.recordID).toEqual(@expectedUser.recordID)
  Then -> expect(@result.username).toEqual(@expectedUser.username)  

 describe "getUserByHref() when not stored and a valid api response", ->
  Given -> 
   @href= "/RESTfm/STEVE/layout/Api-Staff/2.json"
   spyOn(@mockUserStorage,"addUser")
   
  When -> 
   @promise = @subject.getUserByHref(@href)
   @promise.then (data) => @result = data
   @rootScope.$apply()
   
  Then -> expect(@mockApi.get).toHaveBeenCalled()
  Then -> expect(@mockUserStorage.addUser).toHaveBeenCalledWith(@result)
  Then -> expect(@result.data).toEqual(@expectedUser.data)
  Then -> expect(@result.href).toEqual(@expectedUser.href)
  Then -> expect(@result.recordID).toEqual(@expectedUser.recordID)
  Then -> expect(@result.username).toEqual(@expectedUser.username)
  
 describe "getUserById() when it's being stored", ->
  Given ->
   @userid = @expectedUserId
   spyOn(@mockUserStorage,"getUsers").andReturn([@expectedUser])
   
  When -> 
   @promise = @subject.getUserById(@userid)
   @promise.then (data) => @result = data
   @rootScope.$apply()
   
  Then -> expect(@mockUserStorage.getUsers).toHaveBeenCalled()
  Then -> expect(@mockApi.get).not.toHaveBeenCalled()

  Then -> expect(@result.data).toEqual(@expectedUser.data)
  Then -> expect(@result.href).toEqual(@expectedUser.href)
  Then -> expect(@result.recordID).toEqual(@expectedUser.recordID)
  Then -> expect(@result.username).toEqual(@expectedUser.username)

 describe "getUserById() when not stored and a valid api response", ->
  Given ->
   @userid = @expectedUserId
   spyOn(@mockUserStorage,"getUsers").andReturn('')
   spyOn(@mockUserStorage,"addUser")
   
  When -> 
   @promise = @subject.getUserById(@userid)
   @promise.then (data) => @result = data
   @rootScope.$apply()
   
  Then -> expect(@mockUserStorage.getUsers).toHaveBeenCalled()
  Then -> expect(@mockApi.get).toHaveBeenCalled()
  Then -> expect(@mockUserStorage.addUser).toHaveBeenCalledWith(@result)
  Then -> expect(@result.data).toEqual(@expectedUser.data)
  Then -> expect(@result.href).toEqual(@expectedUser.href)
  Then -> expect(@result.recordID).toEqual(@expectedUser.recordID)
  Then -> expect(@result.username).toEqual(@expectedUser.username)
  
 describe "getUserById() when not stored and a valid api response", ->
  Given ->
   @userid = @expectedUserId
   spyOn(@mockUserStorage,"getUsers").andReturn('')
   spyOn(@mockUserStorage,"addUser")
   
  When -> 
   @promise = @subject.getUserById(@userid)
   @promise.then (data) => @result = data
   @rootScope.$apply()
   
  Then -> expect(@mockUserStorage.getUsers).toHaveBeenCalled()
  Then -> expect(@mockApi.get).toHaveBeenCalled()
  Then -> expect(@mockUserStorage.addUser).toHaveBeenCalledWith(@result)
  Then -> expect(@result.data).toEqual(@expectedUser.data)
  Then -> expect(@result.href).toEqual(@expectedUser.href)
  Then -> expect(@result.recordID).toEqual(@expectedUser.recordID)
  Then -> expect(@result.username).toEqual(@expectedUser.username)
  
 describe "getCurrentUser() when a userid is stored", ->
  Given ->
   @userid = @expectedUserId
   spyOn(@mockUserStorage,"getCurrentId").andReturn(@userid)
   spyOn(@mockUserStorage,"getUsers").andReturn([@expectedUser])
  
  When -> 
   @promise = @subject.getCurrentUser()
   @promise.then (data) => @result = data
   @rootScope.$apply()
  
  Then -> expect(@mockUserStorage.getCurrentId).toHaveBeenCalled()
  Then -> expect(@result).toEqual(@expectedUser)
 
 describe "getCurrentUser() when no userid is stored", ->
  Given ->
   spyOn(@mockUserStorage,"getCurrentId").andReturn('')
  
  When -> 
   @promise = @subject.getCurrentUser()
   @promise.then undefined, (data) => @result = data
   @rootScope.$apply()
  
  Then -> expect(@mockUserStorage.getCurrentId).toHaveBeenCalled()
  Then -> expect(@result).toEqual('No User Found')   


 describe "saveCurrentUserId", ->
  Given -> 
   @userid = @expectedUserId
   spyOn(@mockUserStorage,"saveCurrentId")
   
  When -> @subject.saveCurrentUserId(@userId)
  
  Then -> expect(@mockUserStorage.saveCurrentId).toHaveBeenCalledWith(@userId)
 
 describe "getCurrentUserId", ->
  Given -> 
   @userid = @expectedUserId
   spyOn(@mockUserStorage,"getCurrentId").andReturn(@userid)
   
  When -> @result = @subject.getCurrentUserId(@userId)
  
  Then -> expect(@mockUserStorage.getCurrentId).toHaveBeenCalled()
  Then -> expect(@result).toEqual(@userid)
 
 describe "clearCurrentUserId", ->
  Given -> spyOn(@mockUserStorage,"clearCurrentId")
   
  When -> @result = @subject.clearCurrentUserId()
  
  Then -> expect(@mockUserStorage.clearCurrentId).toHaveBeenCalled()