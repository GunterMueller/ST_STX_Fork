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

"{ NameSpace: Smalltalk }"

JavaRef2 subclass:#JavaRefMock
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Tests-RuntimeConstantPool'
!

!JavaRefMock class methodsFor:'documentation'!

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

!JavaRefMock methodsFor:'accessing'!

name
    "superclass JavaRef2 says that I am responsible to implement this method"
    
    ^ 'mock name'

    "Modified: / 08-04-2011 / 16:15:38 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaRefMock methodsFor:'comparing'!

= anotherJavaRef
    "superclass JavaRef2 says that I am responsible to implement this method"

    ^ self shouldImplement
!

hash
    "superclass JavaRef2 says that I am responsible to implement this method"

    ^ self shouldImplement
! !

!JavaRefMock methodsFor:'resolving'!

invalidateForClass: internalJavaClassName 
    "Invalidate (means call invalidate) reference if it has something to do with given class (e.g Class named internalJavaClassName was unloaded).
     Return true, if reference was invalidated."
    
    internalJavaClassName = 'mock' ifTrue: [self invalidate. ^ true] ifFalse: [^ false].

    "Modified: / 08-04-2011 / 16:16:41 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaRefMock class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaRefMock.st,v 1.6 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

