"
 COPYRIGHT (c) 2017 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#ResourcePackTests
	instanceVariableNames:'resources'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Internationalization-Tests'
!

!ResourcePackTests class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2017 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!ResourcePackTests methodsFor:'running'!

tearDown
    MessageTracer unmockAllMethods

    "Created: / 21-11-2017 / 14:39:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ResourcePackTests methodsFor:'tests'!

test_01

    resources := ResourcePack new.
    resources readFromResourceStream: '
#if 1 == 1
hello ''Hi''
#else
hello ''Welcome''
#endif
' readStream in: Filename currentDirectory pathName.

    self assert: (resources string: 'hello') = 'Hi'

    "Created: / 21-11-2017 / 12:55:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_02

    resources := ResourcePack new.
    MessageTracer mock:#language in: Smalltalk class do: [ #es ].
    resources readFromResourceStream: '
#if Language == #en
hello ''Hi''
#else
hello ''Hola''
#endif
' readStream in: Filename currentDirectory pathName.

    self assert: Smalltalk language == #es.            
    self assert: (resources string: 'hello') = 'Hola'

    "Created: / 21-11-2017 / 12:57:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-11-2017 / 15:09:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ResourcePackTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

