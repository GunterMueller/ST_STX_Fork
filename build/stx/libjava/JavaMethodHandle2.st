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

JavaRef2 subclass:#JavaMethodHandle2
	instanceVariableNames:'referenceKind referenceIndex'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Reader-Support-new'
!

!JavaMethodHandle2 class methodsFor:'documentation'!

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

!JavaMethodHandle2 class methodsFor:'instance creation'!

in:constantPool kind:refType index:refIndex 
    ^ (self basicNew)
        constantPool:constantPool;
        referenceKind:refType;
        referenceIndex:refIndex;
        yourself

    "Created: / 20-05-2014 / 17:29:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMethodHandle2 methodsFor:'accessing'!

referenceIndex
    ^ referenceIndex
!

referenceIndex:something
    referenceIndex := something.
!

referenceKind
    ^ referenceKind
!

referenceKind:something
    referenceKind := something.
! !

