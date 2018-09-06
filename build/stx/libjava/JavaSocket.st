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

Socket subclass:#JavaSocket
	instanceVariableNames:'options'
	classVariableNames:'Defaults'
	poolDictionaries:''
	category:'Languages-Java-Support'
!

!JavaSocket class methodsFor:'documentation'!

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

!JavaSocket class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    "/ please change as required (and remove this comment)

    Defaults := Dictionary new.
    Defaults at: #TCP_NODELAY put: false.
    Defaults at: #SO_LINGER put: -1.

    "Modified: / 13-11-2011 / 23:07:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaSocket methodsFor:'options'!

getSocketOption: option  

    options isNil ifTrue:[options := Dictionary new].
    ^options at: option ifAbsent:[Defaults at: option ifAbsent:[false]]

    "Created: / 13-11-2011 / 20:54:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setSocketOption: option argument: arg1 argument: arg2  

    super setSocketOption: option argument: arg1 argument: arg2.
    options isNil ifTrue:[options := Dictionary new].
    option == #SO_LINGER ifTrue:[
        arg1 == false ifTrue:[
            options at: option put: -1
        ] ifFalse:[
            options at: option put: arg2
        ].
    ] ifFalse:[
        options at: option put: arg1
    ]

    "Created: / 13-11-2011 / 20:51:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

timeout:aSmallInteger
    self sendTimeout: aSmallInteger.
    self receiveTimeout: aSmallInteger

    "Created: / 03-10-2013 / 15:17:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaSocket class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaSocket.st,v 1.5 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !


JavaSocket initialize!
