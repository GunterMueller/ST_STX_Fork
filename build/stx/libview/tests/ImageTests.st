"
 COPYRIGHT (c) 2018 Jan Vrany
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

TestCase subclass:#ImageTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Graphics-Images-Tests'
!

!ImageTests class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2018 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!ImageTests methodsFor:'running'!

setUp
    Screen current isNil ifTrue:[
        Smalltalk openDisplay
    ].
    self skipIf: Screen current isNil description: 'Display connection not available'

    "Created: / 25-04-2016 / 20:30:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-01-2018 / 21:27:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ImageTests methodsFor:'tests - regression'!

test_fromScreen_01
    | image |

    self skipIf: true  description: 'Image fromScreen: is broken on XWayland'.
    image := Image fromScreen.

    "Created: / 04-01-2018 / 09:22:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_fromView_01
    | view image |

    [ 
        view := Button new.
        view label: 'Hello world'.
        view open.
        image := Image fromView: view grab: false.  
    ] ensure:[ 
        view topView close.
    ].
    self assert: image notNil.

    "Created: / 03-01-2018 / 21:28:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ImageTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

