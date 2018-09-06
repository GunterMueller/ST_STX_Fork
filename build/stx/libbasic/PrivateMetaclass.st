"
 COPYRIGHT (c) 1996 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

Metaclass subclass:#PrivateMetaclass
	instanceVariableNames:'owningClass'
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Classes'
!

!PrivateMetaclass class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"


!

documentation
"
    A PrivateMetaclass is much like a regular Metaclass, but it is only visible (known)
    to some owningClass (which is also true for the PrivateMetaclasses sole instance).

    Its sourceCode, package and revision is forced to be the same as the owning classes'.
    Therefore, privateClasses delegate some queries to their owning class.

    Caution: support for private classes is an ST/X special feature.
             This mechanism may not be provided by other smalltalk systems,
             making your code unportable.
             (However, private classes can be simulated pretty easily, using classVariables
              or classInstance variables ...)

    [author:]
        Claus Gittinger

    [see also:]
        Behavior ClassDescription Class Metaclass
"
! !

!PrivateMetaclass methodsFor:'accessing'!

nameSpace
    "return the nameSpace I am contained in.
     For private classes, this is my owning class"

    owningClass isNil ifTrue:[
        ^ super nameSpace
    ].
    ^ owningClass

    "Created: 7.11.1996 / 13:19:18 / cg"
!

owningClass
    "return my owningClass"

    ^ owningClass

    "Created: 11.10.1996 / 16:55:43 / cg"
    "Modified: 11.10.1996 / 17:35:13 / cg"
!

setOwningClass:something
    "set my owningClass - this is not a public entry"

    owningClass := something.

    "Created: 11.10.1996 / 17:11:05 / cg"
    "Modified: 11.10.1996 / 17:35:24 / cg"
!

topOwningClass
    "return my outermost owningClass; that is the first non-private
     class along the owner-chain."

    |outerOwner|

    owningClass isNil ifTrue:[^ nil].

    (outerOwner := owningClass owningClass) notNil ifTrue:[
        ^ owningClass topOwningClass
    ].
    ^ owningClass

    "Created: 3.1.1997 / 19:19:58 / cg"
    "Modified: 3.1.1997 / 19:50:05 / cg"
! !

!PrivateMetaclass methodsFor:'queries'!

isBuiltInClass
     ^ self == PrivateMetaclass
!

package
    "return my package-id"

    owningClass notNil ifTrue:[
        ^ owningClass package
    ].
    ^ super package

    "Created: 15.10.1996 / 19:45:04 / cg"
! !

!PrivateMetaclass class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/PrivateMetaclass.st,v 1.13 2004/03/05 17:53:16 cg Exp $'
!

version_SVN
    ^ '$Id: PrivateMetaclass.st 10761 2012-01-19 11:46:00Z vranyj1 $'
! !



