"
jv:libgdbs - GNU Debugger Interface Library
Copyright (C) 2015-now Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
"{ Package: 'jv:libgdbs' }"

"{ NameSpace: Smalltalk }"

ApplicationModel subclass:#GDBMITraceViewer
	instanceVariableNames:'debugger traceView commandHolder traceLastIndex'
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Private-MI Trace'
!

!GDBMITraceViewer class methodsFor:'documentation'!

copyright
"
jv:libgdbs - GNU Debugger Interface Library
Copyright (C) 2015-now Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
! !

!GDBMITraceViewer class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:VDBMITracerApplication andSelector:#windowSpec
     VDBMITracerApplication new openInterface:#windowSpec
     VDBMITracerApplication open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       uuid: 'fc41ab90-2378-11e8-b45a-0021ccd5e3d3'
       window: 
      (WindowSpec
         label: 'GDB/MI Tracer'
         name: 'GDB/MI Tracer'
         uuid: 'fc41ab91-2378-11e8-b45a-0021ccd5e3d3'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 870 497)
       )
       component: 
      (SpecCollection
         collection: (
          (TextEditorSpec
             name: 'RecordView'
             layout: (LayoutFrame 0 0 0 0 0 1 -30 1)
             uuid: 'fc41ab92-2378-11e8-b45a-0021ccd5e3d3'
             hasHorizontalScrollBar: true
             hasVerticalScrollBar: true
             hasKeyboardFocusInitially: false
             postBuildCallback: postBuildTraceView:
             viewClassName: 'TextCollector'
           )
          (InputFieldSpec
             name: 'CommandView'
             layout: (LayoutFrame 0 0 -25 1 0 1 0 1)
             uuid: 'fc41ab93-2378-11e8-b45a-0021ccd5e3d3'
             model: commandHolder
             acceptOnLeave: false
             acceptOnReturn: true
             acceptOnTab: false
             acceptOnLostFocus: false
             acceptOnPointerLeave: false
             acceptIfUnchanged: true
             emptyFieldReplacementText: 'Command to send...'
           )
          )
        
       )
     )

    "Modified: / 09-03-2018 / 10:12:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMITraceViewer class methodsFor:'plugIn spec'!

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

!GDBMITraceViewer methodsFor:'accessing'!

debugger
    ^ debugger
!

debugger:aGDBDebugger
    debugger notNil ifTrue:[ 
        self unsubscribe.
    ].
    debugger := aGDBDebugger.
    debugger notNil ifTrue:[ 
        self subscribe.
    ].

    "Modified: / 09-03-2018 / 10:47:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMITraceViewer methodsFor:'aspects'!

commandHolder
    <resource: #uiAspect>

    commandHolder isNil ifTrue:[
        commandHolder := ValueHolder new.
        commandHolder addDependent:self.
    ].
    ^ commandHolder.

    "Modified (comment): / 09-03-2018 / 09:05:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMITraceViewer methodsFor:'change & update'!

update: aspect with: param from: sender
    sender == commandHolder ifTrue:[ 
        self updateAfterCommandAccepted.
    ].
    super update: aspect with: param from: sender

    "Created: / 09-03-2018 / 10:33:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateAfterCommandAccepted
    | command |

    command := commandHolder value.
    command notEmptyOrNil ifTrue:[ 
        debugger send: command andWait: false.
        commandHolder value: nil.
    ].

    "Created: / 09-03-2018 / 10:39:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateTrace
    | trace |

    trace := debugger connectionTrace.
    traceLastIndex + 1 to: trace size do:[:i | 
        traceView nextPutAll: (trace at: i) printString.
        traceLastIndex := i.
    ].   

    "Created: / 09-03-2018 / 10:10:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMITraceViewer methodsFor:'dependents access'!

release
    "remove all dependencies from the receiver"

    super release.
    self unsubscribe

    "Created: / 06-06-2014 / 22:13:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMITraceViewer methodsFor:'hooks'!

commonPostOpen
    debugger notNil ifTrue:[ 
        self updateTrace.
    ].

    "Created: / 09-03-2018 / 09:45:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

postBuildTraceView:aView 
    traceView := aView scrolledView.
    traceView readOnly:true.

    "Created: / 09-03-2018 / 09:42:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMITraceViewer methodsFor:'initialization'!

initialize
    "nothing done here;
     but can be redefined in concrete applications"

    traceLastIndex := 0.

    "Created: / 09-03-2018 / 09:38:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMITraceViewer methodsFor:'initialization & release'!

subscribe   
    "Register for debugger events. To be overrided by subclasses"

    debugger announcer when: GDBEvent send: #updateTrace to: self

    "Created: / 09-03-2018 / 09:06:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-03-2018 / 10:11:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unsubscribe
    "Unsubscribe myself fo debugger events"
    (debugger notNil and:[debugger isConnected]) ifTrue:[ 
        debugger announcer unsubscribe: self.
    ].

    "Created: / 06-06-2014 / 21:26:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-06-2017 / 13:43:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMITraceViewer class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

