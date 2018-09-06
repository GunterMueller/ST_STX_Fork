"{ Package: 'stx:libdb/nosql/minneStore' }"

"{ NameSpace: Minnestore }"

DiskObjectServices subclass:#DODeletedObject
	instanceVariableNames:'id version'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-MinneStore'
!

DODeletedObject class instanceVariableNames:'id version'

"
 No other class instance variables are inherited by this class.
"
!


!DODeletedObject class methodsFor:'As yet unclassified'!

fromArray: anArray



	^self new setId: (anArray at: 2) version: (anArray at: 3).

! !

!DODeletedObject methodsFor:'As yet unclassified'!

asDeletedObjectArray

	"This method is polymorphic with DOWrapper.

	An array is really what wraps this object when it is stored."



	^Array with: #deleted with: id with: self newVersion.
!

id



	^id
!

isDODeletedObject



	^true
!

newVersion



	^version + 1
!

object

	"Polymorphic with DOWrapper"



	FlavorCompatibility atPropertyNamed: #DOId for: self put: id.

	FlavorCompatibility atPropertyNamed: #DOVersion for: self put: version.

	^self
!

setId: idInteger version: verInteger



	id := idInteger.

	version := verInteger.
!

version



	^version
! !

!DODeletedObject class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/minneStore/DODeletedObject.st,v 1.3 2014-02-17 21:19:29 cg Exp $'
! !
