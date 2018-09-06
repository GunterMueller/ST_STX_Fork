"{ Package: 'stx:libdb/nosql/goods' }"

Object subclass:#KKPlatform
	instanceVariableNames:''
	classVariableNames:'Default'
	poolDictionaries:''
	category:'DataBase-GOODS-Database'
!

KKPlatform comment:''
!


!KKPlatform class methodsFor:'accessing'!

default

	^Default ifNil: [self error: 'The default platform must be set with KKPlatform class>>default:.  This should be given an instance of some concrete subclass of KKPlatform.  Normally this is done during code loading so something is wrong with your GOODS package.']
!

default: aPlatform

	Default := aPlatform
!

makeDefault

	self default: self new
! !

!KKPlatform methodsFor:'factories'!

integerDictionary
	"Answer a dictionary well-suited for integer keys."

	self subclassResponsibility
!

weakIdentityKeyDictionary
	"Answer a dictionary whose keys are stored weakly and compared using object identity."

	self subclassResponsibility
! !

!KKPlatform methodsFor:'special objects'!

addPlatformSpecialObjectsTo: specialObjects
	"Add all objects which are unique (singleton) on this platform to specialObjects."

	self subclassResponsibility
! !

!KKPlatform class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKPlatform.st,v 1.3 2013-03-31 12:14:25 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKPlatform.st,v 1.3 2013-03-31 12:14:25 cg Exp $'
! !

