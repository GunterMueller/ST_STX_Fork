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

TestResource subclass:#JavaInitializedResource
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Tests'
!

!JavaInitializedResource class methodsFor:'documentation'!

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

!JavaInitializedResource methodsFor:'running'!

setUp

    | java_lang_System |

    Smalltalk loadPackage: 'stx:libjava/tools'.
    (java_lang_System := Java at: 'java.lang.System') ifNil:[
        Java initialize.
        JavaVM initializeVM.
    ] ifNotNil:[
        java_lang_System classInit.       
    ].
    super setUp.

    "Created: / 16-03-2011 / 14:42:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 02-01-2013 / 15:16:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaInitializedResource class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaInitializedResource.st,v 1.6 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

