"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
"{ Package: 'jv:vdb' }"

"{ NameSpace: Smalltalk }"

VDBAbstractPresenter subclass:#VDBFramePresenter
	instanceVariableNames:'frame'
	classVariableNames:''
	poolDictionaries:''
	category:'VDB-Presentation'
!

!VDBFramePresenter class methodsFor:'documentation'!

copyright
"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
! !

!VDBFramePresenter class methodsFor:'menu specs'!

contextMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:VDBFramePresenter andSelector:#contextMenu
     (Menu new fromLiteralArrayEncoding:(VDBFramePresenter contextMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Disassemble'
            itemValue: doDisassemble
            isVisible: true
          )
         (MenuItem
            enabled: canCopyFunctionName
            label: 'Copy Function Name'
            itemValue: doCopyFunctionName
            isVisible: true
          )
         )
        nil
        nil
      )
! !

!VDBFramePresenter methodsFor:'accessing'!

frame
    ^ frame
!

icon
    ^ frame thread isRunning 
        ifTrue:[ VDBIconLibrary frameRunning16x16 ]
        ifFalse:[ VDBIconLibrary frameStopped16x16 ]

    "Created: / 22-09-2014 / 22:06:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label
    ^ frame displayString

    "Created: / 22-09-2014 / 00:14:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

subject
    "Return an instance of GDB object that this presenter displays."

    ^ frame

    "Modified: / 05-02-2018 / 13:08:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBFramePresenter methodsFor:'initialization'!

setFrame: aGDBFrame
    ^ frame := aGDBFrame

    "Created: / 21-09-2014 / 23:38:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBFramePresenter methodsFor:'menu-actions'!

doCopyFunctionName
    <resource: #uiCallback>

    self doCopy: frame func.

    "Modified: / 16-01-2018 / 22:36:37 / jv"
!

doDisassemble
    | disassembly |

    disassembly := frame disassemble.
    VDBInstructionListApplication new
        title: (self class classResources string: '%1 (disassembly)' with: frame func ? '?');
        frame: frame;
        instructionList: disassembly;
        open.

    "Modified: / 07-08-2018 / 13:25:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBFramePresenter methodsFor:'menu-queries'!

canCopyFunctionName
   ^ frame func notNil

    "Modified: / 16-01-2018 / 22:19:59 / jv"
    "Modified: / 05-02-2018 / 12:13:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBFramePresenter methodsFor:'protocol-accessing'!

fetchChildren
    "should compute the list of children via the model.
     Be aware, that the somewhat stupid 'optimization' of how the model is fetched may lead to
     a O(n*log n) or even O(n^2) behavior here.
     *** to optimize: redefine by subClass"

    ^  #()

    "Created: / 21-09-2014 / 23:37:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBFramePresenter methodsFor:'testing'!

isFramePresenter
    ^ true

    "Created: / 21-09-2014 / 23:54:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

