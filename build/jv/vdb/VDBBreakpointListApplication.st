"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
"{ Package: 'jv:vdb' }"

"{ NameSpace: Smalltalk }"

VDBAbstractListApplication subclass:#VDBBreakpointListApplication
	instanceVariableNames:'selectedBreakpointHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'VDB-UI-Others'
!

!VDBBreakpointListApplication class methodsFor:'documentation'!

copyright
"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
! !

!VDBBreakpointListApplication class methodsFor:'accessing'!

windowTitle
    ^ 'Breakpoints'

    "Created: / 11-07-2017 / 16:37:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBBreakpointListApplication class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:VDBBreakpointListApplication andSelector:#windowSpec
     VDBBreakpointListApplication new openInterface:#windowSpec
     VDBBreakpointListApplication open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'VDBAbstractListApplication'
         name: 'VDBAbstractListApplication'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 300 577)
       )
       component: 
      (SpecCollection
         collection: (
          (VariableVerticalPanelSpec
             name: 'VariableVerticalPanel1'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             showHandle: true
             snapMode: both
             handlePosition: left
             component: 
            (SpecCollection
               collection: (
                (SelectionInListModelViewSpec
                   name: 'SelectionInListModelView1'
                   model: internalSelectionHolder
                   menu: contextMenu
                   hasHorizontalScrollBar: true
                   hasVerticalScrollBar: true
                   listModel: internalListHolder
                   useIndex: false
                   highlightMode: line
                   doubleClickSelector: doDoubleClick
                   postBuildCallback: postBuildInternalListView:
                 )
                (SubCanvasSpec
                   name: 'BreakpointCanvas'
                   hasHorizontalScrollBar: false
                   hasVerticalScrollBar: false
                   majorKey: VDBBreakpointApplication
                   subAspectHolders: 
                  (Array
                     
                    (SubChannelInfoSpec
                       subAspect: breakpointHolder
                       aspect: selectedBreakpointHolder
                     ) 
                    (SubChannelInfoSpec
                       subAspect: debuggerHolder
                       aspect: debuggerHolder
                     )
                   )
                   createNewApplication: true
                   createNewBuilder: false
                 )
                )
              
             )
             handles: (Any 0.5 1.0)
           )
          )
        
       )
     )

    "Modified (format): / 14-07-2017 / 10:28:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBBreakpointListApplication class methodsFor:'plugIn spec'!

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

!VDBBreakpointListApplication class methodsFor:'startup-web applications'!

initialPageSpec
    "this is only required for web-applications"

    ^ self shouldImplement
!

pageSpecs
    "this is only required for web-applications"

    ^ self shouldImplement
! !

!VDBBreakpointListApplication methodsFor:'aspects'!

selectedBreakpointHolder
    "return/create the 'selectedBreakpointHolder' value holder (automatically generated)"

    selectedBreakpointHolder isNil ifTrue:[
        selectedBreakpointHolder := ValueHolder new.
    ].
    ^ selectedBreakpointHolder
!

selectedBreakpointHolder:something
    "set the 'selectedBreakpointHolder' value holder (automatically generated)"

    selectedBreakpointHolder := something.
! !

!VDBBreakpointListApplication methodsFor:'change & update-delayed'!

delayedUpdateInternalList
    | oldBreakpointPs newBreakpointPs |

    oldBreakpointPs := self internalListHolder value.
    newBreakpointPs := debugger breakpoints collect:[ :e| VDBBreakpointPresenter new setBreakpoint: e ].
    self internalListHolder value: newBreakpointPs.

    "Modified: / 10-07-2017 / 13:37:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

delayedUpdateSelection
    | breakpointP |

    breakpointP := self internalSelectionHolder value.    
    self selectedBreakpointHolder value: (breakpointP notNil ifTrue:[ breakpointP breakpoint ] ifFalse:[ nil ])

    "Modified: / 10-07-2017 / 16:44:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 12-07-2017 / 10:37:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBBreakpointListApplication methodsFor:'event handling'!

onBreakpointCreatedEvent: aGDBBreakpointCreatedEvent
    self delayedUpdateInternalList.

    "Created: / 10-07-2017 / 17:59:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

onBreakpointDeletedEvent: aGDBBreakpointDeletedEvent
    self delayedUpdateInternalList.

    "Created: / 10-07-2017 / 17:59:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

onBreakpointModifiedEvent: aGDBBreakpointModifiedEvent
    internalListView scrolledView invalidate.

    "Created: / 10-07-2017 / 18:00:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-07-2017 / 11:34:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBBreakpointListApplication methodsFor:'initialization & release'!

subscribe   
    "Register for debugger events. To be overrided by subclasses"

    debugger announcer  
        when: GDBBreakpointCreatedEvent  send: #onBreakpointCreatedEvent:  to: self;
        when: GDBBreakpointModifiedEvent send: #onBreakpointModifiedEvent: to: self;
        when: GDBBreakpointDeletedEvent  send: #onBreakpointDeletedEvent:  to: self.

    "Created: / 10-07-2017 / 17:59:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBBreakpointListApplication class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

