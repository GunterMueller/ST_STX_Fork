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

TestCase subclass:#GroovyEvaluatorTests
	instanceVariableNames:'savedWorkspaceVariables'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Groovy-Tests'
!

!GroovyEvaluatorTests class methodsFor:'documentation'!

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

!GroovyEvaluatorTests methodsFor:'running'!

setUp
    savedWorkspaceVariables := Workspace workspaceVariables copy.
    Workspace workspaceVariables removeAll.

    "Created: / 19-02-2014 / 08:26:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tearDown
    Workspace workspaceVariables removeAll.
    Workspace workspaceVariables declareAllFrom: savedWorkspaceVariables

    "Created: / 19-02-2014 / 08:28:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GroovyEvaluatorTests methodsFor:'tests'!

test_inspector_01
    | point retval|

    point := 10 @ 20.

    retval := GroovyEvaluator evaluate: 'x' in: nil receiver: point notifying: nil logged: false ifFail: [ self assert: false ].
    self assert: retval = 10.

    "Created: / 19-02-2014 / 10:15:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_inspector_02
    | point retval|

    point := 10 @ 20.

    retval := GroovyEvaluator evaluate: 'x = 20' in: nil receiver: point notifying: nil logged: false ifFail: [ self assert: false ].
    self assert: point x == 20

    "Created: / 19-02-2014 / 10:15:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_inspector_03
    | point retval|

    point := 10 @ 20.

    retval := GroovyEvaluator evaluate: 'x = y' in: nil receiver: point notifying: nil logged: false ifFail: [ self assert: false ].
    self assert: point x == 20

    "Created: / 19-02-2014 / 10:16:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_workspace_01
    | ws retval |

    "/ self skipIf: Screen current isNil description: 'This test needs connection to display'.

    ws := Workspace basicNew.
    retval := GroovyEvaluator evaluate: 'a = 1; a' notifying: ws.
    self assert: retval = 1.
    self assert: (Workspace workspaceVariables includesKey: 'a').
    self assert: (Workspace workspaceVariableAt: 'a') value == 1.

    "Created: / 19-02-2014 / 09:02:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_workspace_02a
    | ws retval |

    "/ self skipIf: Screen current isNil description: 'This test needs connection to display'.

    ws := Workspace basicNew.
    Workspace workspaceVariables at: 'x' put: 10 asValue.
    retval := GroovyEvaluator evaluate: '10 + x' notifying: ws.

    self assert: retval = 20.

    "Created: / 19-02-2014 / 10:09:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-06-2014 / 08:40:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_workspace_02b
    | ws retval obj |

    "/ self skipIf: Screen current isNil description: 'This test needs connection to display'.

    ws := Workspace basicNew.
    obj := JAVA java lang Object new.
    Workspace workspaceVariables at: 'x' put: obj asValue.
    retval := GroovyEvaluator evaluate: 'x.hashCode()' notifying: ws.

    self assert: retval = obj hash.

    "Created: / 19-02-2014 / 10:10:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_workspace_03
    | ws retval o |

    "/ self skipIf: Screen current isNil description: 'This test needs connection to display'.

    ws := Workspace basicNew.
    o := Object new.
    Workspace workspaceVariables at: 'y' put: o asValue.
    retval := GroovyEvaluator evaluate: 'y' notifying: ws.
    self assert: retval == o.

    "Created: / 19-02-2014 / 09:07:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GroovyEvaluatorTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

