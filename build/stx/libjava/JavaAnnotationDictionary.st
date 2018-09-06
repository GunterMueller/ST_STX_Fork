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

Dictionary subclass:#JavaAnnotationDictionary
	instanceVariableNames:'bytes'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Annotations'
!

JavaAnnotationDictionary class instanceVariableNames:'empty'

"
 No other class instance variables are inherited by this class.
"
!

!JavaAnnotationDictionary class methodsFor:'documentation'!

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

!JavaAnnotationDictionary class methodsFor:'accessing'!

empty
    empty isNil ifTrue:[
        empty := self new
    ].
    empty beImmutable.
    ^ empty.

    "Created: / 03-03-2011 / 22:46:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-03-2011 / 17:42:15 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 04-08-2014 / 15:53:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaAnnotationDictionary methodsFor:'accessing'!

bytes

    ^bytes

    "Created: / 06-02-2011 / 12:41:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

bytes:something
    bytes := something.
!

rawAnnotations
    ^ bytes
!

rawAnnotations:something
    bytes := something.
! !

!JavaAnnotationDictionary class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaAnnotationDictionary.st,v 1.8 2015-03-20 12:07:59 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

