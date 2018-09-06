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

JavaDescriptor subclass:#JavaFieldDescriptorWithUnionType
	instanceVariableNames:'descriptors'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Support'
!

!JavaFieldDescriptorWithUnionType class methodsFor:'documentation'!

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

!JavaFieldDescriptorWithUnionType class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!JavaFieldDescriptorWithUnionType methodsFor:'accessing'!

addDescriptor: desc

    descriptors add: desc

    "Created: / 10-12-2011 / 21:38:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaFieldDescriptorWithUnionType methodsFor:'comparing'!

match: another

    descriptors do:[:each|
        (each match: another) ifTrue:[ ^ true ].
    ].
    ^false

    "Created: / 10-12-2011 / 21:33:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaFieldDescriptorWithUnionType methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    "/ please change as required (and remove this comment)
    descriptors := Set new

    "/ super initialize.   -- commented since inherited method does nothing

    "Modified: / 10-12-2011 / 21:31:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaFieldDescriptorWithUnionType class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaFieldDescriptorWithUnionType.st,v 1.5 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

