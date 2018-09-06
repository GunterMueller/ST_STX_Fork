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

ByteArray variableByteSubclass:#JavaBooleanArray
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Support'
!

!JavaBooleanArray class methodsFor:'documentation'!

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
!

documentation
"
    This class represents Java boolean[]. Internally, java
    represents boolean arrays as bytearrays and access values 
    by BALOAD/BASTORE, but it has to be separate class to correctly 
    support reflection.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!JavaBooleanArray class methodsFor:'accessing-java'!

javaArrayClass
    ^ JavaArray javaArrayClassFor: self

    "Created: / 06-12-2011 / 17:29:22 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

javaComponentClass

    ^Boolean

    "Created: / 20-12-2010 / 22:13:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaName

    ^'[Z'.

    "Modified: / 31-08-2011 / 23:57:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaBooleanArray class methodsFor:'queries'!

isJavaArrayClass

    ^true

    "Created: / 20-12-2010 / 22:47:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isJavaReferenceType

    "Java arrays are reference types"
    ^true

    "Created: / 20-12-2010 / 22:30:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaBooleanArray class methodsFor:'testing'!

isInterface

    ^false
! !

!JavaBooleanArray methodsFor:'vm support'!

_ARRAYLENGTH: cls
    ^self basicSize

    "Created: / 14-05-2013 / 10:10:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_CHECKCAST: cls
    ^cls == JavaBooleanArray ifTrue:[self] ifFalse:[JavaVM throwClassCastException]

    "Created: / 14-05-2013 / 10:09:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-01-2014 / 12:31:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_INSTANCEOF: cls
    ^JavaBooleanArray == cls ifTrue:[1] ifFalse:[0]

    "Created: / 14-05-2013 / 10:09:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-01-2014 / 12:31:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaBooleanArray class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

