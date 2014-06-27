class fmRestRepository
  @fieldNameKey: 'RFMsF'
  @fieldValueKey: 'RFMsV'
  @scriptKey: 'RFMscript'
  @pageKey: 'RFMmax'
  
  constructor: (@$q, @cciApi, @model, @modelList, @path, @modelName) ->
   #@path = 'layout/Api-Time'
   
  getAll: (path) ->
   d = @$q.defer()
   
   successFn = (response) =>
    results = new @modelList response.data, @model
    d.resolve results
   
   @cciApi.get(path).then successFn, (response) => 
    d.reject response
   
   d.promise
  
  getAllWithScript: (path, script, pagesize) -> 
   if !path? || path == ''
    path = @path+'.json?'
   if script? and script != ''
    if path.slice(-1) != '?'
     path = path + '&'
    path = path + fmRestRepository.scriptKey + '='+ script
   if pagesize? and pagesize != ''
    if path.slice(-1) != '?'
     path = path + '&'
    path = path  + fmRestRepository.pageKey + '='+ pagesize
    
   @getAll(path)

  
  getAllForStaff: (staff_id, script, pagesize) -> 
   path = @path+'.json?' + fmRestRepository.fieldNameKey + '1=staff_id&' + fmRestRepository.fieldValueKey + '1=' + staff_id

   @getAllWithScript(path, script, pagesize)
  
  getFailureReason: (info) ->
   fmstatus = info['X-RESTfm-FM-Status']
   fmreason = info['X-RESTfm-FM-Reason']
   reason = info['X-RESTfm-Reason']
   if fmstatus? && fmreason?
    msg = fmstatus + ': ' + fmreason
   else if fmreason? 
    msg = fmreason
   else if reason?
    msg = reason
   
   msg
  
  add: (data) ->
   
   d = @$q.defer()
   
   successFn = (response) => 
    msg = "Your " + @modelName + " was successfully added!"
    data = new @model response.data.data[0], response.data.meta[0].href, response.data.meta[0].recordID
    d.resolve {msg: msg, data:data }
   errorFn = (response) =>
    msg = "There was a problem adding your " + @modelName + ". "
    msg = msg + @getFailureReason(response.data.info) #response.data.info['X-RESTfm-Reason']
    d.reject msg
    
   @cciApi.post(@path+'.json', {data: [data]}).then successFn, errorFn
   
   d.promise
   
  update: (data,href) ->
   dataToSend = {data: [data]}
   
   href = href.replace '/RESTfm/STEVE/',''
   
   d = @$q.defer()
   
   successFn = (response) => 
    d.resolve "Your " + @modelName + " was successfully updated!"
   errorFn = (response) =>
    msg = "There was a problem updating your " + @modelName + ". "
    if response.status == 404
     msg = "There was a problem updating your " + @modelName + ". Unable to find the record at " + href
    else
     msg = msg +  @getFailureReason(response.data.info)
     
    d.reject msg
   
   @cciApi.put(href, dataToSend).then successFn, errorFn
   
   d.promise
   
  delete: (href) ->
   href = href.replace '/RESTfm/STEVE/',''
   
   successFn = (response) => 
    d.resolve "Your " + @modelName + " was successfully deleted!"
   errorFn = (response) =>
    msg = "There was a problem deleting your " + @modelName + ". "
    msg = msg  + @getFailureReason(response.data.info)
    d.reject msg
    
   d = @$q.defer()
   @cciApi.delete(href).then successFn, errorFn
   d.promise

angular.module('app').factory 'fmRestRepository', -> fmRestRepository
 