"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010
"
"{ Package: 'stx:libjava' }"

Object subclass:#JavaAnnotation
	instanceVariableNames:'nameIndex name valuesCount values parent'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Reader-Support'
!

!JavaAnnotation class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010

"
! !

!JavaAnnotation class methodsFor:'instance creation'!

for:parent
    "Create & return a new instance for given parent."

    ^ self basicNew initializeFor:parent

    " 
    JavaAnnotation for: nil.
    "

    "Modified: / 17-12-2010 / 16:32:46 / Marcel Hlopko <hlopik@gmail.com>"
! !

!JavaAnnotation methodsFor:'accessing'!

constantPool
 ^parent constantPool.

    "Created: / 17-12-2010 / 14:21:59 / Marcel Hlopko <hlopik@gmail.com>"
!

name
    name isNil ifTrue: [self constantPool at: nameIndex] ifFalse: [^name].

    "Modified: / 17-12-2010 / 18:01:14 / Marcel Hlopko <hlopik@gmail.com>"
!

name: something
    name := something.

    "Created: / 17-12-2010 / 18:02:30 / Marcel Hlopko <hlopik@gmail.com>"
!

nameIndex
    ^ nameIndex
!

nameIndex: something
    nameIndex := something.
    name := self constantPool at: nameIndex.

    "Created: / 17-12-2010 / 18:02:14 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 17-12-2010 / 19:47:41 / Marcel Hlopko <hlopik@gmail.com>"
!

parent
    ^ parent
!

parent:something
    parent := something.
!

value
    ^ (values at: #value) value

    "Created: / 30-07-2014 / 19:55:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

valueAt: anIndex

^ values at: anIndex value.

    "Created: / 17-12-2010 / 14:26:38 / Marcel Hlopko <hlopik@gmail.com>"
!

values
    ^ values
!

values:something
    values := something.
!

valuesCount
    ^ valuesCount
!

valuesCount:something
    valuesCount := something.
! !

!JavaAnnotation methodsFor:'initialization'!

initialize

    values := Dictionary new.

    "Created: / 17-12-2010 / 16:35:08 / Marcel Hlopko <hlopik@gmail.com>"
!

initializeFor:aParent 
    "Invoked when a new instance is created for aParent."
    
    parent := aParent.
    self initialize.

    "Modified: / 17-12-2010 / 16:33:59 / Marcel Hlopko <hlopik@gmail.com>"
! !

!JavaAnnotation class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaAnnotation.st,v 1.8 2015-03-20 12:07:59 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

