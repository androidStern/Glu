expect = require("chai").expect
Glu = require "../src/index"

describe "Glu", ->
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

  it "should detect circular dependencies", ->
    b = Glu()
    b.define "s1", ["s3"], -> {}
    b.define "s2", ["s3"], -> {}
    b.define "s3", ["s1"], -> {}
    doInject = ->
      b.inject ["s2"], (s2)-> console.log "no"
    expect(doInject).to.throw(/Circular dependency detected/);

  it "allows dependencies to be temorarily provided", ->
    c = Glu()
    c.define "s1", -> "s1"
    c.inject ["s1"], (s1)->
      expect(s1).to.equal("s1")
    c.provide "s1", "provided"
    c.inject ["s1"], (s1)->
      expect(s1).to.equal("provided")
    c.reset()
    c.inject ["s1"], (s1)->
      expect(s1).to.equal("s1")
