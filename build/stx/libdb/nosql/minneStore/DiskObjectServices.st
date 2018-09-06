"{ Package: 'stx:libdb/nosql/minneStore' }"

"{ NameSpace: Minnestore }"

Object subclass:#DiskObjectServices
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-MinneStore'
!


!DiskObjectServices class methodsFor:'As yet unclassified'!

Comments

"

    The classes DOMultiObjectService and DOSingleObjectService are the interface into the

    DiskObjectServices.  In order to update a disk object, it must be read first.



    Here are the transaction rules for the Disk Object System.

	1) All reads during a transaction are executed as if they were readForUpdate.

	2) The objects read during a transaction are cached.  Because they have

	    been locked, the system does not have to go back to disk during the transaction.

	    This is an efficiency feature.

	3) Transactions are meant to be short.  A transaction that includes waiting for user

	    input will lock other users out of those objects.

	4) For most uses, an explicit readForUpdate will not be necessary.  Optimistic

	    locking is the default.  When a conflict occurs, DOInvalidVersionError will be

	    signaled.



    This is how data integrity is maintained in this multi-user environment.

	1) When an object is stored for the first time, it is given a DiskObject Id and a

	    version number.

	2) The DiskObject Id ensures it's identity.  The version number ensures that

	    the object has not been changed since it was read.

	3) If an object is changed and a copy is made, make sure the original object

	    is stored back to disk instead of the copy.  When the copy is stored to disk

	    it will be stored as a brand new object.

"
!

DiskObjectServices

    "This is a dummy method used by the source code filer to

    denote a Disk Object Service class and it's subclasses."
!

ExceptionsToExpect

"

You can expect the following exceptions to be signaled when...



DOObjectIsDeletedError

	When trying to read a deleted object.



DOInvalidVersionError

	When trying to update an object that has been updated since

	it was last read.



DOLockStuckError

	When the system can't read an object because it has been locked

	for a period of time.



"
!

Overview

"

The Disk Object System is intended to provide single-user or multi-user access 

to a binary object filing system.  Also provided is the capability to

store multiple objects, either in their own files, or with n objects in

each file.



The MinneStore System uses the Disk Object System to store

objects and set up indexes for each kind of object.



This code is copyright(c) 1997, 1998 by Jonathan A. Carlson.

"
!

new

    "Answer a new, initialized instance of myself."



    ^self basicNew initialize
! !

!DiskObjectServices methodsFor:'As yet unclassified'!

error: aString



	^ExceptionCompatibility error: aString
!

idFor: anObject

	"Answer the internal database id for this object or nil if it has none."



	^FlavorCompatibility

		propertyNamed: #DOId

		for: anObject.
!

initialize

	"May be reimplemented by my subclasses"
!

signalInvalidVersionError: anObject



	ExceptionCompatibility signal: #DOInvalidVersionError with: anObject
!

signalLockStuckError



	ExceptionCompatibility signal: #DOLockStuckError
!

versionFor: anObject

	"Answer the internal database id for this object or nil if it has none."



	^FlavorCompatibility

		propertyNamed: #DOVersion

		for: anObject.
! !

!DiskObjectServices class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/minneStore/DiskObjectServices.st,v 1.3 2014-02-17 21:19:29 cg Exp $'
! !
