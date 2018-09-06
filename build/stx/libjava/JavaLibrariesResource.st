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

TestResource subclass:#JavaLibrariesResource
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Tests'
!

!JavaLibrariesResource class methodsFor:'documentation'!

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

!JavaLibrariesResource methodsFor:'running'!

setUp
    JavaLibraries update.

    "Created: / 08-04-2011 / 17:02:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-06-2011 / 20:36:07 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 25-07-2016 / 21:22:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLibrariesResource class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaLibrariesResource.st,v 1.6 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !
