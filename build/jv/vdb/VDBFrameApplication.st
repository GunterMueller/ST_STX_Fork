"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
"{ Package: 'jv:vdb' }"

"{ NameSpace: Smalltalk }"

VDBAbstractApplication subclass:#VDBFrameApplication
	instanceVariableNames:'frameHolder variableObjectListHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'VDB-UI-Others'
!

!VDBFrameApplication class methodsFor:'documentation'!

copyright
"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
! !

!VDBFrameApplication class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:VDBFrameApplication andSelector:#windowSpec
     VDBFrameApplication new openInterface:#windowSpec
     VDBFrameApplication open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       uuid: 'aa3ebd80-08c8-11e8-bb5a-0021ccd5e3d3'
       window: 
      (WindowSpec
         label: 'Frame'
         name: 'Frame'
         uuid: '8a56b5e1-08c8-11e8-bb5a-0021ccd5e3d3'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 300 300)
       )
       component: 
      (SpecCollection
         collection: (
          (SubCanvasSpec
             name: 'VariableObjectList'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             uuid: '8a56dcf0-08c8-11e8-bb5a-0021ccd5e3d3'
             hasHorizontalScrollBar: false
             hasVerticalScrollBar: false
             miniScrollerVertical: false
             majorKey: VDBVariableObjectListApplication
             subAspectHolders: 
            (Array
               
              (SubChannelInfoSpec
                 subAspect: debuggerHolder
                 aspect: debuggerHolder
               ) 
              (SubChannelInfoSpec
                 subAspect: variableObjectListHolder
                 aspect: variableObjectListHolder
               )
             )
             createNewApplication: true
             createNewBuilder: false
           )
          )
        
       )
     )
! !

!VDBFrameApplication class methodsFor:'plugIn spec'!

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
        #frameHolder
      ).

! !

!VDBFrameApplication methodsFor:'accessing'!

frame
    ^ self frameHolder value

    "Created: / 05-07-2018 / 11:55:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

frame: aGDBFrame
    self frameHolder value: aGDBFrame

    "Created: / 05-07-2018 / 11:55:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBFrameApplication methodsFor:'aspects'!

frameHolder
    "return/create the 'frameHolder' value holder (automatically generated)"

    frameHolder isNil ifTrue:[
        frameHolder := ValueHolder new.
        frameHolder addDependent:self.
    ].
    ^ frameHolder
!

frameHolder:something
    "set the 'frameHolder' value holder (automatically generated)"

    |oldValue newValue|

    frameHolder notNil ifTrue:[
        oldValue := frameHolder value.
        frameHolder removeDependent:self.
    ].
    frameHolder := something.
    frameHolder notNil ifTrue:[
        frameHolder addDependent:self.
    ].
    newValue := frameHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:frameHolder.
    ].
!

variableObjectListHolder
    "return/create the 'variableObjectListHolder' value holder (automatically generated)"

    variableObjectListHolder isNil ifTrue:[
        variableObjectListHolder := ValueHolder with: #().
        variableObjectListHolder addDependent:self.
    ].
    ^ variableObjectListHolder

    "Modified: / 03-02-2018 / 07:33:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

variableObjectListHolder:something
    "set the 'variableObjectListHolder' value holder (automatically generated)"

    |oldValue newValue|

    variableObjectListHolder notNil ifTrue:[
        oldValue := variableObjectListHolder value.
        variableObjectListHolder removeDependent:self.
    ].
    variableObjectListHolder := something.
    variableObjectListHolder notNil ifTrue:[
        variableObjectListHolder addDependent:self.
    ].
    newValue := variableObjectListHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:variableObjectListHolder.
    ].
! !

!VDBFrameApplication methodsFor:'change & update'!

enqueueDelayedUpdateVariableObjectList
    self enqueueDelayedUpdate:#delayedUpdateVariableObjectList

    "Created: / 03-02-2018 / 07:28:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

update:aspect with:param from:sender
    "Invoked when an object that I depend upon sends a change notification."

    sender == frameHolder ifTrue:[ 
         self enqueueDelayedUpdateVariableObjectList.
         ^ self.
    ].
    super update:aspect with:param from:sender

    "Created: / 03-02-2018 / 09:48:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBFrameApplication methodsFor:'change & update-delayed'!

delayedUpdateVariableObjectList
    | frame  list |

    debugger isNil ifTrue:[
        self variableObjectListHolder value:#().
        ^ self.
    ].
    frame := frameHolder value.
    frame isNil ifTrue:[
        self variableObjectListHolder value:#().
        ^ self.
    ].
    "/ It may happen that the variable is out of scope. In that case, we get an error
    "/ '-var-create: unable to create variable object'. So, ignore all such variables.
    "/ See GDB source code:
    "/ 
    "/    gdb/mi/mi-cmd-var.c
    "/    gdb/testsuite/gdb.mi/mi-var-cmd.exp
    list := frame variables.
    self variableObjectListHolder value:list.

    "Created: / 03-02-2018 / 07:30:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-07-2018 / 11:57:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBFrameApplication class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

