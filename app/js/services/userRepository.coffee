angular.module('app').service 'userRepository', [ '$q', 'cciApiService', 'user', 'userStorageService', 
 class userRepository
  constructor: (@$q, @cciApi, @user, @userStorage) ->
   @path = 'layout/Staff'
  
  createUser: (apiResponse) ->
   try 
    d = apiResponse.data.data[0]
    h = apiResponse.data.meta[0].href
    r = apiResponse.data.meta[0].recordID
    new @user d, h, r
   catch e then throw Error 'Invalid API Response'
   finally
    
 
  getUser: (path) ->
   @d = @$q.defer()
   
   success = (response) =>
    try 
     @newUser = @createUser response
     @userStorage.addUser(@newUser)
     @d.resolve @newUser
    catch e then @d.reject e.message
    finally
   
   failure = (response) => @d.reject response
   
   @cciApi.get(path).then success, failure
   
   @d.promise
  
  getUserById: (userid) ->
   users = @userStorage.getUsers()
   if users != undefined and users != ''
    for user in users
     if parseInt(user.recordID) == parseInt(userid)
	     foundUser = user
	     break
     
   if foundUser == undefined
    @getUser(@path + '/' + userid + '.json')   
   else
    @d = @$q.defer()
    @d.resolve foundUser
    @d.promise
  
  getUserByUsername: (username) ->
   users = @userStorage.getUsers()
   if(users != undefined and users != '')
    for user in users
     if user.username  == username
      foundUser = user
      break
   
   if foundUser == undefined
    @getUser(@path + '.json?RFMsF1=filemaker_accountname&RFMsV1=' + username)   
   else
    @d = @$q.defer()
    @d.resolve foundUser
    @d.promise
  
  getCurrentUser: ->
   userid = @getCurrentUserId()
   if userid != '' and userid != undefined
    @getUserById(userid)
   else
    @d = @$q.defer()
    @d.reject 'No User Found'
    @d.promise
    
  getUserByHref: (href) -> 
   @getUser(href.replace('/RESTfm/STEVE/','')) 
   
  saveCurrentUserId: (userId) -> @userStorage.saveCurrentId(userId)
  getCurrentUserId: -> @userStorage.getCurrentId()
  clearCurrentUserId: -> @userStorage.clearCurrentId()
]