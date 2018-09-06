"{ Package: 'stx:libdb/nosql/minneStore' }"

"{ NameSpace: Minnestore }"

DOUserPolicy subclass:#DOSingleUserPolicy
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-MinneStore'
!


!DOSingleUserPolicy methodsFor:'As yet unclassified'!

isLocked: fileNameString

	"Answer a boolean.  Answer true since there is only one user."



	^true
!

isSingleUser



	^true
!

readForUpdate: aFullFileNameString

	"Read whatever is in aFileNameString.  Used by DOObjectPolicy>>readForUpdate:.

	The default is no locking.  DOMultiUserPolicy overrides this."



	^self readFileNamed: aFullFileNameString
!

unlockFileNamed: aString
! !

!DOSingleUserPolicy class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/minneStore/DOSingleUserPolicy.st,v 1.3 2014-02-17 21:19:29 cg Exp $'
! !
