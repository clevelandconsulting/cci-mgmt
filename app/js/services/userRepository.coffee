angular.module('app').service 'userRepository', [ '$q', 'cciApiService', 'user', 'userStorageService', 
 class userRepository
  constructor: (@$q, @cciApi, @user, @userStorage) ->
   @path = 'layout/Staff'
  
  createUser: (apiResponse) ->
   new @user apiResponse.data.data[0], apiResponse.data.meta[0].href, apiResponse.data.meta[0].recordID 
  
  getUser: (path) ->
   @d = @$q.defer()
   
   success = (response) => @d.resolve @createUser response
   failure = (response) => @d.reject response
      
   @cciApi.get(path).then success, failure
   
   @d.promise
  
  getUserByUsername: (username) ->
   @getUser(@path + '.json?RFMsF1=filemaker_accountname&RFMsV1=' + username)   

  getUserByHref: (href) -> 
   @getUser(href.replace('/RESTfm/STEVE/','')) 
]