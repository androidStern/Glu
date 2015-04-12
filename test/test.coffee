expect = require("chai").expect
Glu = require "../src/index"

describe "Glu", ->
  
  describe ".service", ->
    a = Glu()
    it "should register new services", ->
      service = "service"
      a.define "myService", [], -> service
      a.inject ["myService"], (dep)->
        expect(dep).to.equal service

    it "should allow re-registering services", ->
      myService2 = "myService2"
      a.define "myService", [], -> myService2
      a.inject ["myService"], (dep)->
        expect(dep).to.equal "myService2"

    it "should inject dependencies", ->
      dep = {sayHi: -> console.log("hi")}
      a.define "depsService", [], -> dep
      a.inject ["depsService"], (say_hi_er)->
        expect(say_hi_er).to.equal(dep)