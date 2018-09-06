"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

Object subclass:#DOMErrorMonitor
	instanceVariableNames:'errors'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-Tests W3C'
!


!DOMErrorMonitor class methodsFor:'instance creation'!

new
    ^ self basicNew initialize.

    "Created: / 15-11-2005 / 13:54:07 / janfrog"
! !

!DOMErrorMonitor methodsFor:'DOM3 interface'!

assertLowerSeverityFor: aTestCase message: aString severity: anInteger

    errors do:[:error|
        (error severity >= anInteger) ifFalse:[
            aTestCase 
                assert:false
                description:(aString , ' ' , error message)                
        ]
    ]

    "Created: / 15-11-2005 / 14:00:10 / janfrog"
!

errors

    ^errors

    "Created: / 15-11-2005 / 13:56:20 / janfrog"
!

handleError: aDOMError

    errors add: aDOMError.

    ^true

    "Created: / 15-11-2005 / 13:55:56 / janfrog"
! !

!DOMErrorMonitor methodsFor:'initialization'!

initialize

    errors := OrderedCollection new

    "Modified: / 15-11-2005 / 13:54:28 / janfrog"
! !

!DOMErrorMonitor class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__DOMErrorMonitor.st,v 1.2 2005-11-15 16:14:41 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
