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

JavaAnnotationValue subclass:#JavaAnnotationEnumValue
	instanceVariableNames:'nameIndex valueIndex'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Reader-Support'
!

!JavaAnnotationEnumValue class methodsFor:'documentation'!

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

!JavaAnnotationEnumValue methodsFor:'accessing'!

name 
    "superclass JavaAnnotationValue says that I am responsible to implement this method"

    ^self constantPool at: nameIndex.

    "Created: / 17-12-2010 / 14:40:42 / Marcel Hlopko <hlopik@gmail.com>"
!

nameIndex
    ^ nameIndex
!

nameIndex:something
    nameIndex := something.
!

value
    "superclass JavaAnnotationValue says that I am responsible to implement this method"

    ^self constantPool at: valueIndex.

    "Modified: / 17-12-2010 / 14:40:01 / Marcel Hlopko <hlopik@gmail.com>"
!

valueIndex
    ^ valueIndex
!

valueIndex:something
    valueIndex := something.
! !

!JavaAnnotationEnumValue class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaAnnotationEnumValue.st,v 1.8 2015-03-20 12:07:59 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

