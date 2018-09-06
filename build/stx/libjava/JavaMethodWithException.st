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

JavaMethod variableSubclass:#JavaMethodWithException
	instanceVariableNames:'exceptionTable'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Classes'
!

!JavaMethodWithException class methodsFor:'documentation'!

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

!JavaMethodWithException class methodsFor:'initialization'!

initialize
    self flags:(self flags bitOr:Behavior flagJavaMethod).
! !

!JavaMethodWithException methodsFor:'accessing'!

exceptionClasses
    "Return a collection of declared exception classes that this method
     throws"    
    exceptionTable isNil ifTrue: [ ^ nil ].
    ^ self exceptionTable collect: [:classRef | classRef resolve ].

    "Created: / 01-08-2012 / 10:09:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-12-2014 / 14:29:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

exceptionTable
    "return exception table - collection of classRefs"

    | cp |

    exceptionTable isNil ifTrue:[ ^ nil ].
    cp := self constantPool.
    ^ exceptionTable collect:[ :classRefIndex | cp at: classRefIndex ]

    "Created: / 05-11-1998 / 19:58:38 / cg"
    "Modified: / 04-06-2011 / 17:20:17 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 04-12-2014 / 14:30:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getExceptionTable
 "return exception table - collection of classRefs"
    ^ exceptionTable

    "Created: / 04-02-2011 / 23:07:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-06-2011 / 17:20:29 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

setExceptionTable: anArray 
     "set exception table - expected arg: collection of classRefs"
    exceptionTable := anArray.

    "Created: / 05-11-1998 / 19:58:43 / cg"
    "Modified: / 04-06-2011 / 17:21:17 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaMethodWithException methodsFor:'misc'!

fromMethod:aJavaMethod
    "copy values from another javaMethod"

    super fromMethod:aJavaMethod.
    exceptionTable := aJavaMethod getExceptionTable

    "Created: / 14-08-2014 / 12:39:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-12-2014 / 14:31:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMethodWithException class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjava/JavaMethodWithException.st,v 1.14 2015-03-20 12:08:00 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaMethodWithException.st,v 1.14 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !


JavaMethodWithException initialize!
