"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/communication/zeromq' }"

"{ NameSpace: Smalltalk }"

ExternalStructure subclass:#ZmqApiSize
	instanceVariableNames:''
	classVariableNames:'OFFSET_SIZE'
	poolDictionaries:''
	category:'ZeroMQ-Api'
!

!ZmqApiSize class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
        cg

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"

  more examples to be added:
                                                                [exBegin]
    ... add code fragment for 
    ... executable example here ...
                                                                [exEnd]
"
! !

!ZmqApiSize class methodsFor:'class initialization'!

initialize
    OFFSET_SIZE := 1.
! !

!ZmqApiSize class methodsFor:'field definition'!

fieldsDesc
	^#(size_t size)
! !

!ZmqApiSize methodsFor:'accessing'!

size: anObject
        "This method was automatically generated"
        ^self "handle"  platformUnsignedLongAt: OFFSET_SIZE put: anObject
! !

!ZmqApiSize methodsFor:'evaluating'!

size
        "This method was automatically generated"
        ^ self "handle" platformUnsignedLongAt: OFFSET_SIZE
! !

!ZmqApiSize methodsFor:'printing'!

printOn: aStream
	aStream nextPutAll: self size asString.
! !

!ZmqApiSize class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqApiSize.st,v 1.2 2018-05-11 00:03:10 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/zeromq/ZmqApiSize.st,v 1.2 2018-05-11 00:03:10 cg Exp $'
! !


ZmqApiSize initialize!
