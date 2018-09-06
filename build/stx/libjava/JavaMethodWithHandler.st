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

JavaMethodWithException variableSubclass:#JavaMethodWithHandler
	instanceVariableNames:'exceptionHandlerTable'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Classes'
!

!JavaMethodWithHandler class methodsFor:'documentation'!

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
!

ght
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

!JavaMethodWithHandler class methodsFor:'initialization'!

alize
    self flags:(self flags bitOr:Behavior flagJavaMethod).
!

initialize
    self flags:(self flags bitOr:Behavior flagJavaMethod).
! !

!JavaMethodWithHandler methodsFor:'accessing'!

exceptionHandlerTable
    ^ exceptionHandlerTable

    "Modified: / 16.4.1996 / 12:49:06 / cg"
    "Created: / 16.10.1998 / 01:18:28 / cg"
!

ptionHandlerTable
    ^ exceptionHandlerTable

    "Modified: / 16.4.1996 / 12:49:06 / cg"
    "Created: / 16.10.1998 / 01:18:28 / cg"
!

setExceptionHandlerTable:anArray
    exceptionHandlerTable := anArray.

    "Created: / 16.10.1998 / 01:19:00 / cg"
!

xceptionHandlerTable:anArray
    exceptionHandlerTable := anArray.

    "Created: / 16.10.1998 / 01:19:00 / cg"
! !

!JavaMethodWithHandler methodsFor:'misc'!

fromMethod:aJavaMethod
    "copy values from another javaMethod"

    super fromMethod:aJavaMethod.
    exceptionHandlerTable := aJavaMethod exceptionHandlerTable

    "Created: / 14-08-2014 / 12:39:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMethodWithHandler methodsFor:'queries'!

FinallyBasedOnExceptionTable
    "Returns true if the exeption table has at least one 
     entry for finally block"
    ^exceptionHandlerTable anySatisfy:[:entry|entry catchType == 0].

    "Created: / 28-03-2012 / 23:17:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasFinallyBasedOnExceptionTable
    "Returns true if the exeption table has at least one 
     entry for finally block"
    ^exceptionHandlerTable hasFinallyBasedOnExceptionTable

    "Created: / 28-03-2012 / 23:17:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-05-2013 / 22:01:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMethodWithHandler class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjava/JavaMethodWithHandler.st,v 1.16 2015-03-20 12:08:00 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaMethodWithHandler.st,v 1.16 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'

! !


JavaMethodWithHandler initialize!
