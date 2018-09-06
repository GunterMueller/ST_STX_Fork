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

JavaClass subclass:#GroovyClass
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Groovy-Classes'
!

!GroovyClass class methodsFor:'documentation'!

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

!GroovyClass methodsFor:'compiler interface'!

programmingLanguage
    ^GroovyLanguage instance

    "Created: / 18-02-2012 / 20:49:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GroovyClass methodsFor:'queries'!

isGroovyClass
    ^ self ~~ GroovyClass

    "Created: / 18-03-1997 / 17:48:01 / cg"
    "Created: / 18-02-2012 / 20:28:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GroovyClass class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/GroovyClass.st,v 1.5 2015-03-20 12:07:59 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !

