"{ Package: 'stx:goodies/communication/jupyterTalk/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#IPMessaggingTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'JupyterTalk-Tests'
!


!IPMessaggingTest methodsFor:'accessing'!

ipMessage
	^ IPMsg newFromWireMessage: self wireMessage 
!

session
	^ IPSession newSessionFor: self ipMessage header
!

wireMessage
	"jupyter client sends:
		UUID 
		a message delimiter '<IDS|MSG>'
		'HMAC'
		'HEADER dictionary'
		'PARENT HEADER Dictionary'
		'METADATA Dictionary'
		'CONTENT Dictionary'
	we recieve one line at a time we check if there are more frames to come using.
	more:= self zmqSocket getOption: ZmqApiConstants zmqRcvMore"
	^	IPWireMessage new
		push: '0F50B50EF8A74BAB8208F9CD4220A10D';
		push: 'faa64554c56c018f7ba1fe76a7a99d37a59a75721c5dc362be9acce838e1b643';
		push: '{"msg_id":"6FB84513B7DA4A9B8ACBE5656B55B115","username":"username","session":"0F50B50EF8A74BAB8208F9CD4220A10D","msg_type":"execute_request","version":"5.0","date":"2018-05-04T14:31:03.597540Z"}';
		push: '{}';
		push: '{}';
		push: '{"code":"self display openInJupyter:(paisos column:#CONTINENT) asStringTable   ","silent":false,"store_history":true,"user_expressions":{},"allow_stdin":true,"stop_on_error":true}';
		yourself 
! !

!IPMessaggingTest methodsFor:'tests'!

testIPWireMessageHMAC
	|wm|
	wm := self wireMessage.
	self assert:wm hmacIsValid 		
		
!

testRespondsTo
	|wm executeMessage wmResp |
	"parentHeader field in a response message must have exactly the same header than the request message
	normally we create response message instance using the session object (IPSession currentSession, it has factory methods for each kind of message
	You have to transform the message to a wireMessage before you send it back to the client"
	wm := self wireMessage.
	executeMessage := self session executeResultMessage  respondsToWireMessage: wm.
	wmResp := IPWireMessage newFromMessage: executeMessage.
	self assert:wm header equals:	wmResp parentHeader	
		
! !

!IPMessaggingTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/tests/IPMessaggingTest.st,v 1.1 2018-05-11 00:47:50 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/jupyterTalk/tests/IPMessaggingTest.st,v 1.1 2018-05-11 00:47:50 cg Exp $'
! !

