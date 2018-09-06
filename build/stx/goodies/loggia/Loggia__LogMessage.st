"
 COPYRIGHT (c) 2005-2011 by Jan Vrany & Martin Dvorak

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:goodies/loggia' }"

"{ NameSpace: Loggia }"

Object subclass:#LogMessage
	instanceVariableNames:'message severity facility originator attachedObject timestamp
		process'
	classVariableNames:''
	poolDictionaries:'Loggia::LogLevels'
	category:'System-Support-Loggia'
!

!LogMessage class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2005-2011 by Jan Vrany & Martin Dvorak

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
! !

!LogMessage class methodsFor:'instance creation'!

message: messageString at: severitySymbol from: originatorObject with: attachedObject

    ^self new
	message: messageString
	at: severitySymbol
	from: originatorObject
	with: attachedObject
! !

!LogMessage methodsFor:'accessing'!

attachedObject

    ^attachedObject
!

facility

    facility isNil ifTrue:[
	facility := originator
			perform: #logFacility
			ifNotUnderstood: [Logger systemFacilityName]
    ].
    ^facility

    "Modified: / 08-04-2012 / 09:48:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

message

    ^message
!

originator

    ^originator
!

originatorName

    ^originator
	perform: #nameForLog
	ifNotUnderstood: [originator class name]
!

process

    ^process

    "Created: / 27-06-2005 / 14:51:49 / masca"
!

processId

    ^process key

    "Created: / 20-05-2005 / 10:36:04 / masca"
    "Modified: / 27-06-2005 / 14:51:42 / masca"
!

severity

    ^severity
!

time

    ^timestamp asTime

    "Created: / 20-05-2005 / 11:41:25 / masca"
!

timestamp

    ^timestamp
! !

!LogMessage methodsFor:'binary storage'!

readBinaryContentsFromData:representation manager:manager
    1 to: representation size do:[:i | 
        self instVarAt: i put: (representation at: i).
    ].
    severity == #ENTER   ifTrue:[ severity := ENTER ].
    severity == #LEAVE   ifTrue:[ severity := LEAVE ].
    severity == #TRACE3  ifTrue:[ severity := TRACE3 ].
    severity == #TRACE2  ifTrue:[ severity := TRACE2 ].
    severity == #TRACE1  ifTrue:[ severity := TRACE1 ].
    severity == #TRACE0  ifTrue:[ severity := TRACE0 ].
    severity == #TRACE   ifTrue:[ severity := TRACE  ].
    severity == #DEBUG   ifTrue:[ severity := DEBUG  ].
    severity == #INFO    ifTrue:[ severity := INFO  ].
    severity == #WARN    ifTrue:[ severity := WARN  ].
    severity == #ERROR   ifTrue:[ severity := ERROR ].
    severity == #FATAL   ifTrue:[ severity := FATAL ].

    "Created: / 29-10-2014 / 12:09:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

representBinaryOn: manager
    | representation |

    representation := Array new: self class instSize.
    1 to: representation size do:[:i | 
        representation at: i put: (self instVarAt: i).
    ].
    severity == ENTER   ifTrue:[ representation at: 2 put: #ENTER ].
    severity == LEAVE   ifTrue:[ representation at: 2 put: #LEAVE ].
    severity == TRACE3  ifTrue:[ representation at: 2 put: #TRACE3 ].
    severity == TRACE2  ifTrue:[ representation at: 2 put: #TRACE2 ].
    severity == TRACE1  ifTrue:[ representation at: 2 put: #TRACE1 ].
    severity == TRACE0  ifTrue:[ representation at: 2 put: #TRACE0 ].
    severity == TRACE   ifTrue:[ representation at: 2 put: #TRACE  ].
    severity == DEBUG   ifTrue:[ representation at: 2 put: #DEBUG  ].
    severity == INFO    ifTrue:[ representation at: 2 put: #INFO  ].
    severity == WARN    ifTrue:[ representation at: 2 put: #WARN  ].
    severity == ERROR   ifTrue:[ representation at: 2 put: #ERROR ].
    severity == FATAL   ifTrue:[ representation at: 2 put: #FATAL ].   

    ^ representation

    "Created: / 29-10-2014 / 12:06:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LogMessage methodsFor:'initialization'!

message: messageString at: severityObject from: originatorObject with: attachment
    "This should be the only way of setting log message properties. Sets message
    creation timestamp."

    | activeProcess |

    message := messageString.
    severity := severityObject.


    "/ Be backward compatible, allow for symbolic severities
    "/ but when encountered, issue a warning...
    severityObject isSymbol ifTrue:[ 
        severity := LogLevel symbolToLevel: severityObject.  
    ].
    originator := originatorObject.
    attachedObject := attachment.
    timestamp := Timestamp now.

    activeProcess := Processor activeProcess.
    process := activeProcess id -> activeProcess name

    "Modified: / 27-06-2005 / 14:52:39 / masca"
    "Modified: / 22-09-2014 / 15:16:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LogMessage methodsFor:'printing'!

printFull

    | stream |
    stream := (String new: message size * 2) writeStream.
    self printFullOn: stream.
    ^stream contents
!

printFullOn: aStream

    timestamp printOn: aStream.
    aStream
	cr;
	nextPut: $[;
	nextPutAll: self originatorName;
	nextPutAll: '] ';
	nextPutAll: originator printString;
	cr;
	nextPutAll: 'Facility: ';
	nextPutAll: self facility printString;
	cr;
	nextPutAll: 'Severity: ';
	nextPutAll: severity printString;
	cr;
	nextPutAll: 'Process: [';
	nextPutAll: process key printString;
	nextPutAll: '] ';
	nextPutAll: process value;
	cr; cr;
	nextPutAll: message.

    attachedObject ifNotNil: [
	aStream
	    cr; cr;
	    nextPutAll: 'Attachment: ';
	    nextPutAll: attachedObject printString].

    aStream cr

    "Modified: / 14-07-2005 / 11:35:34 / masca"
!

printLimitedTo: anInteger

    | stream |
    stream := (String new: anInteger) writeStream.

    timestamp asTime printOn: stream.
    stream space.
    stream nextPutAll: (message contractAtEndTo: anInteger - 10).

    ^stream contents withoutCRs

    "Modified: / 14-07-2005 / 11:42:08 / masca"
!

printLine

    ^(message contractAtEndTo: self lineLength) withoutCRs

    "Modified: / 14-07-2005 / 11:43:54 / masca"
! !

!LogMessage methodsFor:'private'!

lineLength

    ^100
! !

!LogMessage methodsFor:'utilities'!

dropAttachedObject
    "This can be used for messages held in memory when the attached object should
    be freed."

    attachedObject := nil
!

dropOriginator
    "This can be used for messages held in memory when the originator should
    be freed. It is replaced by a proxy with identical printString and facility code."

    originator := LogOriginatorProxy for: originator
! !

!LogMessage methodsFor:'viewing'!

messageColor

    ^(Logger default facilityFor: self facility) colorFor: severity

    "Created: / 20-05-2005 / 10:19:33 / masca"
! !

!LogMessage class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__LogMessage.st,v 1.7 2014-10-29 12:52:35 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__LogMessage.st,v 1.7 2014-10-29 12:52:35 vrany Exp $'
!

version_SVN
    ^ '$Id: Loggia__LogMessage.st,v 1.7 2014-10-29 12:52:35 vrany Exp $'
! !

