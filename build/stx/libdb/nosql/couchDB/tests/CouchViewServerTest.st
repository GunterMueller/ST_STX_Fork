"{ Package: 'stx:libdb/nosql/couchDB/tests' }"

TestCase subclass:#CouchViewServerTest
	instanceVariableNames:'server'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-CouchDB-Viewserver-tests'
!


!CouchViewServerTest methodsFor:'as yet unclassified'!

setUp
	server := CouchViewServer new
!

tearDown
	server close
!

testAddFunction
	
	self assert: ((server command: '["add_fun", "[:doc | doc ]"]') asJsonString = 'true').
	
	self assert: ((server command: '["add_fun", "[:barf barf]"]') asJsonString = '{"error": "CouchViewServerCompilationError", "reason": "[:barf Vertical bar expected ->barf]"}').
!

testMapDocument
	
	server command: '["add_fun", "[:doc | self emitKey: nil value: doc]"]'.
	self assert: ((server command: '["map_doc", {"_id":"8877AFF9789988EE","_rev":46874684684,"field":"value","otherfield":"othervalue"}]') asJsonString
					= ('[[[null,{"_rev":46874684684,"field":"value","_id":"8877AFF9789988EE","otherfield":"othervalue"}]]]'))
!

testReduce
	
	self assert: (server command: '["reduce",["[:k :v :r | v sum]"],[[[1,"699b524273605d5d3e9d4fd0ff2cb272"],10],[[2,"c081d0f69c13d2ce2050d684c7ba2843"],20],[[null,"foobar"],3]]]
') asJsonString = '[true,[33]]'
!

testReset
	
	self assert: ((server command: '["reset"]') asJsonString = 'true')
! !

!CouchViewServerTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/couchDB/tests/CouchViewServerTest.st,v 1.1 2013-04-04 14:40:54 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/couchDB/tests/CouchViewServerTest.st,v 1.1 2013-04-04 14:40:54 cg Exp $'
! !

