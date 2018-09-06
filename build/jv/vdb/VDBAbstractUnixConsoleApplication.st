"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
"{ Package: 'jv:vdb' }"

"{ NameSpace: Smalltalk }"

VDBAbstractApplication subclass:#VDBAbstractUnixConsoleApplication
	instanceVariableNames:'consoleView'
	classVariableNames:''
	poolDictionaries:''
	category:'VDB-UI-Console-Unix'
!

!VDBAbstractUnixConsoleApplication class methodsFor:'documentation'!

copyright
"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
! !

!VDBAbstractUnixConsoleApplication class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:VDBAbstractConsoleApplication andSelector:#windowSpec
     VDBAbstractConsoleApplication new openInterface:#windowSpec
     VDBAbstractConsoleApplication open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'Console'
         name: 'Console'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 782 332)
       )
       component: 
      (SpecCollection
         collection: (
          (ArbitraryComponentSpec
             name: 'Console'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             hasHorizontalScrollBar: true
             hasVerticalScrollBar: true
             miniScrollerHorizontal: true
             autoHideScrollBars: false
             hasBorder: false
             component: consoleView
           )
          )
        
       )
     )
! !

!VDBAbstractUnixConsoleApplication class methodsFor:'plugIn spec'!

aspectSelectors
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this. If it is corrupted,
     the UIPainter may not be able to read the specification."

    "Return a description of exported aspects;
     these can be connected to aspects of an embedding application
     (if this app is embedded in a subCanvas)."

    ^ #(
        #debuggerHolder
      ).

! !

!VDBAbstractUnixConsoleApplication class methodsFor:'testing'!

isAbstract
    ^ self == VDBAbstractUnixConsoleApplication
! !

!VDBAbstractUnixConsoleApplication methodsFor:'accessing'!

consoleInput
    self subclassResponsibility

    "Created: / 01-06-2017 / 09:43:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

consoleOutput
    self subclassResponsibility

    "Created: / 01-06-2017 / 09:44:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBAbstractUnixConsoleApplication methodsFor:'aspects'!

consoleView
    consoleView isNil ifTrue:[ 
        consoleView :=VT100TerminalView new.
        consoleView font: self textFont;
                    cursorType: #block;  
                    foregroundColor: Color white
                    backgroundColor: Color black;
                    cursorForegroundColor: Color white
                          backgroundColor: Color white.
        debugger notNil ifTrue:[ 
            consoleView inStream: self consoleInput.
            consoleView outStream: self consoleOutput.
            consoleView startReaderProcessWhenVisible.
        ].
    ].
    ^ consoleView

    "Created: / 06-06-2014 / 21:33:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-08-2018 / 10:18:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBAbstractUnixConsoleApplication methodsFor:'initialization & release'!

subscribe   
    "Register for debugger events. To be overrided by subclasses"

    super subscribe.
    (debugger notNil and:[consoleView notNil]) ifTrue:[
        consoleView stopReaderProcess.
        consoleView inStream: self consoleInput.
        consoleView outStream: self consoleOutput.            
        consoleView startReaderProcessWhenVisible.
    ].

    "Created: / 10-06-2014 / 21:02:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-06-2017 / 09:47:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unsubscribe
    "Unsubscribe myself fo debugger events"

    super unsubscribe.
    consoleView notNil ifTrue:[ 
        consoleView stopReaderProcess.
        consoleView inStream: nil.
        consoleView outStream: nil.
    ].

    "Created: / 09-06-2014 / 10:09:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBAbstractUnixConsoleApplication class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

