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

Object subclass:#JavaAnnotationDefault
	instanceVariableNames:'bytes value'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Annotations'
!

JavaAnnotationDefault class instanceVariableNames:'empty'

"
 No other class instance variables are inherited by this class.
"
!

!JavaAnnotationDefault class methodsFor:'documentation'!

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

!JavaAnnotationDefault class methodsFor:'accessing'!

empty
    empty isNil ifTrue:[
        empty := self new
    ].
    ^ empty

    "Created: / 03-03-2011 / 22:51:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-08-2014 / 15:53:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaAnnotationDefault methodsFor:'accessing'!

bytes
    ^ bytes
!

bytes:something
    bytes := something.
!

value
    ^ value
!

value:something
    value := something.
! !

!JavaAnnotationDefault class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaAnnotationDefault.st,v 1.8 2015-03-20 12:07:59 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

