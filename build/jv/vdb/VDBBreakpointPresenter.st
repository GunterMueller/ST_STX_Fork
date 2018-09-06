"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
"{ Package: 'jv:vdb' }"

"{ NameSpace: Smalltalk }"

VDBAbstractPresenter subclass:#VDBBreakpointPresenter
	instanceVariableNames:'breakpoint'
	classVariableNames:''
	poolDictionaries:''
	category:'VDB-Presentation'
!

!VDBBreakpointPresenter class methodsFor:'documentation'!

copyright
"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
! !

!VDBBreakpointPresenter class methodsFor:'menu specs'!

contextMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:VDBBreakpointPresenter andSelector:#contextMenu
     (Menu new fromLiteralArrayEncoding:(VDBBreakpointPresenter contextMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Enable'
            itemValue: doEnable
            isVisible: canEnable
          )
         (MenuItem
            label: 'Disable'
            itemValue: doDisable
            isVisible: canDisable
          )
         )
        nil
        nil
      )
! !

!VDBBreakpointPresenter methodsFor:'accessing'!

breakpoint
    ^ breakpoint
!

label
    ^ String streamContents:[ :aStream |
        aStream nextPutAll:(breakpoint enabled ifTrue:[ 'e ' ] ifFalse:[ 'd ' ]).
        breakpoint number printOn:aStream.
        aStream nextPutAll:', '.
        breakpoint func notNil ifTrue:[ 
            aStream nextPutAll:'in '.
            breakpoint func printOn:aStream.   
            aStream nextPutAll:'(), '. 
        ].
        breakpoint file notNil ifTrue:[
            breakpoint file printOn:aStream.
            aStream nextPut:$:.
            breakpoint line printOn:aStream.
        ] ifFalse:[ 
            aStream nextPutAll:'at '.
            breakpoint addr printOn: aStream.
        ].                                                  
    ].

    "Created: / 10-07-2017 / 13:30:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-07-2017 / 12:13:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

subject
    "Return an instance of GDB object that this presenter displays."

    ^ breakpoint

    "Modified: / 05-02-2018 / 13:08:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBBreakpointPresenter methodsFor:'initialization'!

setBreakpoint: aGDBBreakpoint
    breakpoint := aGDBBreakpoint

    "Created: / 10-07-2017 / 13:29:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBBreakpointPresenter methodsFor:'menu-actions'!

doDisable
    breakpoint enabled: false

    "Created: / 05-02-2018 / 12:25:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doEnable
    breakpoint enabled: true

    "Created: / 05-02-2018 / 12:25:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBBreakpointPresenter methodsFor:'menu-queries'!

canDisable
    ^ breakpoint enabled

    "Created: / 05-02-2018 / 12:27:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canEnable
    ^ breakpoint enabled not

    "Created: / 05-02-2018 / 12:26:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBBreakpointPresenter methodsFor:'testing'!

isBreakpointPresenter
    ^ true

    "Created: / 11-07-2017 / 11:50:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

