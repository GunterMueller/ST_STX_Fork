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

JavaAnnotationValue subclass:#JavaAnnotationArrayValue
	instanceVariableNames:'count valueIndex values'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Reader-Support'
!

!JavaAnnotationArrayValue class methodsFor:'documentation'!

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

!JavaAnnotationArrayValue methodsFor:'accessing'!

count
    ^ count
!

count:something 
    count := something.
    values := Array new:count.

    "Modified: / 25-02-2011 / 12:14:05 / Marcel Hlopko <hlopik@gmail.com>"
!

value
    "superclass JavaAnnotationValue says that I am responsible to implement this method"
    
    ^ self values.

    "Modified: / 25-02-2011 / 12:12:31 / Marcel Hlopko <hlopik@gmail.com>"
!

valueIndex
    ^ valueIndex
!

valueIndex:something
    valueIndex := something.
!

values
    values isNil ifTrue:[
        self halt:'you should set count before calling me!!'
    ].
    ^ values.

    "Created: / 25-02-2011 / 12:12:31 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 04-08-2014 / 15:53:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaAnnotationArrayValue class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaAnnotationArrayValue.st,v 1.8 2015-03-20 12:07:59 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

