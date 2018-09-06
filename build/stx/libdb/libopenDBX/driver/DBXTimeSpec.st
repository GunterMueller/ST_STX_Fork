"{ Package: 'stx:libdb/libopenDBX/driver' }"

ExternalStructure subclass:#DBXTimeSpec
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriver-API'
!


!DBXTimeSpec class methodsFor:'field definition'!

defaultTimeSpec
	^ self seconds: 0 nseconds: 1
!

fields
	^#(
		(seconds 'long')
		(nseconds 'long'))
!

initialize
	super initialize.
	self defineFields
!

seconds: seconds 
	^ self new
		seconds: seconds;
		nseconds: 0;
		yourself
!

seconds: seconds nseconds: nseconds 
	^ self new
		seconds: seconds;
		nseconds: nseconds;
		yourself
! !

!DBXTimeSpec methodsFor:'accessing'!

nseconds
        "This method was automatically generated"
        ^self "handle" signedLongAt: 5
!

nseconds: anObject
        "This method was automatically generated"
        self "handle" signedLongAt: 5 put: anObject
!

seconds
        "This method was automatically generated"
        ^self "handle" signedLongAt: 1
!

seconds: anObject
        "This method was automatically generated"
        self "handle" signedLongAt: 1 put: anObject
! !

!DBXTimeSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXTimeSpec.st,v 1.2 2013-04-15 13:10:56 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXTimeSpec.st,v 1.2 2013-04-15 13:10:56 cg Exp $'
! !


DBXTimeSpec initialize!
