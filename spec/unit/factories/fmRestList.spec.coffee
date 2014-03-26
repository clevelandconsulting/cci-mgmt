describe "fmRestList", ->
 Given -> module('app')
 
 Given angular.mock.inject ($injector, fmRestModel) ->
  @mockModel = fmRestModel
  @objectClass = $injector.get 'fmRestList', {fmRestModel:@mockModel}
  start = {"name":"start","href":"\/RESTfm\/STEVE\/layout\/Api-Time.json?RFMmax=3"}
  end = {"name":"end","href":"\/RESTfm\/STEVE\/layout\/Api-Time.json?RFMmax=3&RFMskip=end"}
  prev = {"name":"prev","href":"\/RESTfm\/STEVE\/layout\/Api-Time.json?RFMmax=3"}
  next = {"name":"next","href":"\/RESTfm\/STEVE\/layout\/Api-Time.json?RFMmax=3&RFMskip=6"}
  @fullNav = [start,prev,next,end]
  @minNav = [start,end]
  @firstNav = [start,next,end]
  @lastNav = [start,prev,end]
  data1 = {"__guid":"BE772AA3-C9EE-41FC-A625-9425DC4936D7","job_id":"D0968EDF-E1B8-43AE-8738-3AC2CA040354","staff_id":"DC5FB862-E6F0-45FD-AA86-BC9A41003873","type":"Project Mgmt","date":"03\/21\/2014","hours":"3","note":"Test test test","__created_ts":"03\/21\/2014 07:56:37","__created_an":"Developer","__modified_ts":"03\/21\/2014 07:57:46","__modified_an":"Developer","Job.Time::name":"Test Job","Job.Time::company_name_c":"Test Company"}
  data2 = {"__guid":"409B2F11-5CFE-4C11-B5A3-05C1D55E8AA6","job_id":"D0968EDF-E1B8-43AE-8738-3AC2CA040354","staff_id":"DC5FB862-E6F0-45FD-AA86-BC9A41003873","type":"Development\/Design","date":"03\/21\/2014","hours":"4","note":"Don't Delete these.","__created_ts":"03\/21\/2014 07:56:49","__created_an":"Developer","__modified_ts":"03\/21\/2014 07:57:11","__modified_an":"Developer","Job.Time::name":"Test Job","Job.Time::company_name_c":"Test Company"}
  data3 = {"__guid":"CCFA5CF7-7CAA-472B-A0A8-D2FBC67D2677","job_id":"D0968EDF-E1B8-43AE-8738-3AC2CA040354","staff_id":"DC5FB862-E6F0-45FD-AA86-BC9A41003873","type":"Development\/Design","date":"03\/21\/2014","hours":"5","note":"More Testing","__created_ts":"03\/21\/2014 07:56:59","__created_an":"Developer","__modified_ts":"03\/21\/2014 07:57:11","__modified_an":"Developer","Job.Time::name":"Test Job","Job.Time::company_name_c":"Test Company"}
  meta1 = {"recordID":"7","href":"\/RESTfm\/STEVE\/layout\/Api-Time\/7.json"}
  meta2 = {"recordID":"8","href":"\/RESTfm\/STEVE\/layout\/Api-Time\/8.json"}
  meta3 = {"recordID":"9","href":"\/RESTfm\/STEVE\/layout\/Api-Time\/9.json"}
  @fullObject = {"nav":@fullNav,"data":[data1,data2,data3],"meta":[meta1,meta2,meta3],"metaField":[{"name":"__guid","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"job_id","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"staff_id","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"type","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"date","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"date"},{"name":"hours","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"number"},{"name":"note","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"__created_ts","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"timestamp"},{"name":"__created_an","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"__modified_ts","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"timestamp"},{"name":"__modified_an","autoEntered":1,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"Job.Time::name","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"},{"name":"Job.Time::company_name_c","autoEntered":0,"global":0,"maxRepeat":1,"resultType":"text"}],"info":{"tableRecordCount":"12","foundSetCount":"12","fetchCount":"3","skip":"3","X-RESTfm-Version":"2.0.2\/r291","X-RESTfm-Protocol":"4","X-RESTfm-Status":200,"X-RESTfm-Reason":"OK","X-RESTfm-Method":"GET"}}
  
  @model1 = new @mockModel data1,meta1.href,meta1.recordID
  @model2 = new @mockModel data2,meta2.href,meta2.recordID
  @model3 = new @mockModel data3,meta3.href,meta3.recordID
  
 Then -> expect(@objectClass).toBeDefined()
 
 describe "constructor when full nav", ->
  Given -> @expectedNav = {start:@fullNav[0].href,prev:@fullNav[1].href,next:@fullNav[2].href,end:@fullNav[3].href}
   
  When ->  @subject = new @objectClass(@fullNav)
  
  Then -> expect(@subject).toBeDefined()
  Then -> expect(@subject.nav).toEqual(@expectedNav)
  Then -> expect(@subject.items).toEqual([])
 
 describe "constructor when no nav", ->
  Given -> @expectedNav = {}
   
  When ->  @subject = new @objectClass()
  
  Then -> expect(@subject).toBeDefined()
  Then -> expect(@subject.nav).toEqual(@expectedNav)
  Then -> expect(@subject.items).toEqual([])
 
 describe "constructor when nav is full object and model provided", ->
  Given -> 
   @expectedNav = {start:@fullNav[0].href,prev:@fullNav[1].href,next:@fullNav[2].href,end:@fullNav[3].href}
   @expectedItems = [@model1,@model2,@model3]
  When -> @subject = new @objectClass(@fullObject,@mockModel)
  
  Then -> expect(@subject).toBeDefined()
  Then -> expect(@subject.nav).toEqual(@expectedNav)
  Then -> expect(@subject.items).toEqual(@expectedItems)
 
 describe "next() when it exists", ->
  Given ->
   @subject = new @objectClass(@fullNav) 
   
  When -> @result = @subject.next()
  
  Then -> expect(@result).toEqual(@fullNav[2].href)
  
 describe "next() when it does not exist", ->
  Given ->
   @subject = new @objectClass(@minNav) 
   
  When -> @result = @subject.next()
  
  Then -> expect(@result).not.toBeDefined()
  
 describe "next() when the nav does not exist", ->
  Given ->
   @subject = new @objectClass() 
   
  When -> @result = @subject.next()
  
  Then -> expect(@result).not.toBeDefined()


 describe "previous() when it exists", ->
  Given ->
   @subject = new @objectClass(@fullNav) 
   
  When -> @result = @subject.previous()
  
  Then -> expect(@result).toEqual(@fullNav[1].href)
  
 describe "previous() when it does not exist", ->
  Given ->
   @subject = new @objectClass(@minNav) 
   
  When -> @result = @subject.previous()
  
  Then -> expect(@result).not.toBeDefined()
  
 describe "previous() when the nav does not exist", ->
  Given ->
   @subject = new @objectClass() 
   
  When -> @result = @subject.previous()
  
  Then -> expect(@result).not.toBeDefined()
  
  
 describe "start() when it exists", ->
  Given ->
   @subject = new @objectClass(@fullNav) 
   
  When -> @result = @subject.start()
  
  Then -> expect(@result).toEqual(@fullNav[0].href)
  
 describe "start() when it does not exist", ->
  Given ->
   @subject = new @objectClass() 
   
  When -> @result = @subject.start()
  
  Then -> expect(@result).not.toBeDefined()
  
 describe "end() when it exists", ->
  Given ->
   @subject = new @objectClass(@fullNav) 
   
  When -> @result = @subject.end()
  
  Then -> expect(@result).toEqual(@fullNav[3].href)
  
 describe "end() when it does not exist", ->
  Given ->
   @subject = new @objectClass() 
   
  When -> @result = @subject.end()
  
  Then -> expect(@result).not.toBeDefined()
  
 describe "hasPaging() when next or prev exists", ->
  Given ->
   @subject = new @objectClass(@firstNav)
   
  When -> @result = @subject.hasPaging()
  
  Then -> expect(@result).toBe(true)
  
 describe "hasPaging() when next or prev does not exist", ->
  Given ->
   @subject = new @objectClass(@minNav)
   
  When -> @result = @subject.hasPaging()
  
  Then -> expect(@result).toBe(false)
  
 describe "hasNext() when next exists", ->
  Given ->
   @subject = new @objectClass(@fullNav)
   
  When -> @result = @subject.hasNext()
  
  Then -> expect(@result).toBe(true)
  
 describe "hasNext() when next does not exist", ->
  Given ->
   @subject = new @objectClass(@minNav)
   
  When -> @result = @subject.hasNext()
  
  Then -> expect(@result).toBe(false)
  
 describe "hasPrevious() when prev exists", ->
  Given ->
   @subject = new @objectClass(@fullNav)
   
  When -> @result = @subject.hasPrevious()
  
  Then -> expect(@result).toBe(true)
  
 describe "hasPrevious() when prev does not exist", ->
  Given ->
   @subject = new @objectClass(@minNav)
   
  When -> @result = @subject.hasPrevious()
  
  Then -> expect(@result).toBe(false)

  
  
  