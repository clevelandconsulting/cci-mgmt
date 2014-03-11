describe "userRepository", ->
 Given -> module('app')
 
 Given angular.mock.inject ($injector, _cciApiService_, _user_, _userStorageService_) ->
  @mockApi = _cciApiService_
  @mockUser = _user_
  @mockUserStorage = _userStorageService_
  @subject = $injector.get 'userRepository', {cciApiService:@mockApi,user:@mockUser,userStorageService:@mockUserStorage}
  
 Then -> expect(@subject).toBeDefined()
 
 describe "getUser()", ->
  Given ->
   @username = 'somename'
   @user = { __guid:'someid', first_name:'John', filemaker_accountname:@username }
   
   spyOn(@mockApi,"get").andCallFake (path) =>
    if(path == 'layout/Staff.json?RFMsF1=filemaker_accountname&RFMsV1=' + @username)
     @user
   
  When -> @result = @subject.getUser(@username)
  Then -> expect(@result).toEqual(@user)