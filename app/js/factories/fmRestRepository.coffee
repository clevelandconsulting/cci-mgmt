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
   
  getAllForStaff: (staff_id, script, pagesize) -> 
   path = @path+'.json?' + fmRestRepository.fieldNameKey + '1=staff_id&' + fmRestRepository.fieldValueKey + '1=' + staff_id
   if script? and script != ''
    path = path + '&' + fmRestRepository.scriptKey + '='+ script
   if pagesize? and pagesize != ''
    path = path + '&' + fmRestRepository.pageKey + '='+ pagesize
    
   @getAll(path)
   
  add: (data) ->
   
   d = @$q.defer()
   
   successFn = (response) => 
    msg = "Your " + @modelName + " was successfully added!"
    data = new @model response.data.data[0], response.data.meta[0].href, response.data.meta[0].recordID
    d.resolve {msg: msg, data:data }
   errorFn = (response) =>
    msg = "There was a problem adding your " + @modelName + ". "
    msg = msg + response.data.info['X-RESTfm-Reason']
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
     fmstatus = response.data.info['X-RESTfm-FM-Status']
     fmreason = response.data.info['X-RESTfm-FM-Reason']
     if fmstatus?
      msg = msg + fmstatus + ': ' + fmreason
     else 
      msg = msg + fmreason
     
    d.reject msg
   
   @cciApi.put(href, dataToSend).then successFn, errorFn
   
   d.promise
   
  delete: (href) ->
   href = href.replace '/RESTfm/STEVE/',''
   
   successFn = (response) => 
    d.resolve "Your " + @modelName + " was successfully deleted!"
   errorFn = (response) =>
    msg = "There was a problem deleting your " + @modelName + ". "
    msg = msg + response.data.info['X-RESTfm-Reason']
    d.reject msg
    
   d = @$q.defer()
   @cciApi.delete(href).then successFn, errorFn
   d.promise

angular.module('app').factory 'fmRestRepository', -> fmRestRepository
 