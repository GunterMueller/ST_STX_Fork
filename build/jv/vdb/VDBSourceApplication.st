"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
"{ Package: 'jv:vdb' }"

"{ NameSpace: Smalltalk }"

VDBAbstractApplication subclass:#VDBSourceApplication
	instanceVariableNames:'frameHolder sourceFileHolder sourceStringHolder sourceView'
	classVariableNames:''
	poolDictionaries:''
	category:'VDB-UI-Source'
!

!VDBSourceApplication class methodsFor:'documentation'!

copyright
"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
! !

!VDBSourceApplication class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:VDBSourceApplication andSelector:#windowSpec
     VDBSourceApplication new openInterface:#windowSpec
     VDBSourceApplication open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'Source View'
         name: 'Source View'
         min: (Point 10 10)
         bounds: (Rectangle 0 0 300 300)
       )
       component: 
      (SpecCollection
         collection: (
          (NonScrollableArbitraryComponentSpec
             name: 'SourceView'
             layout: (LayoutFrame 0 0 0 0 0 1 0 1)
             model: sourceStringHolder
             component: sourceView
           )
          )
        
       )
     )
! !

!VDBSourceApplication class methodsFor:'plugIn spec'!

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

!VDBSourceApplication methodsFor:'aspects'!

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

sourceFileHolder
    "return/create the 'sourceFileHolder' value holder (automatically generated)"

    sourceFileHolder isNil ifTrue:[
        sourceFileHolder := ValueHolder new.
        sourceFileHolder addDependent:self.
    ].
    ^ sourceFileHolder
!

sourceFileHolder:something
    "set the 'sourceFileHolder' value holder (automatically generated)"

    |oldValue newValue|

    sourceFileHolder notNil ifTrue:[
        oldValue := sourceFileHolder value.
        sourceFileHolder removeDependent:self.
    ].
    sourceFileHolder := something.
    sourceFileHolder notNil ifTrue:[
        sourceFileHolder addDependent:self.
    ].
    newValue := sourceFileHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:sourceFileHolder.
    ].
!

sourceStringHolder
    "return/create the 'sourceStringHolder' value holder (automatically generated)"

    sourceStringHolder isNil ifTrue:[
        sourceStringHolder := ValueHolder new.
        sourceStringHolder addDependent:self.
    ].
    ^ sourceStringHolder
!

sourceStringHolder:something
    "set the 'sourceStringHolder' value holder (automatically generated)"

    |oldValue newValue|

    sourceStringHolder notNil ifTrue:[
        oldValue := sourceStringHolder value.
        sourceStringHolder removeDependent:self.
    ].
    sourceStringHolder := something.
    sourceStringHolder notNil ifTrue:[
        sourceStringHolder addDependent:self.
    ].
    newValue := sourceStringHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:sourceStringHolder.
    ].
!

sourceView
    sourceView isNil ifTrue:[ 
        sourceView := Tools::CodeView2 new.
        sourceView font: self textFont.
        sourceView compilerClass: (VDBEvaluator new setDebugger: debugger).    
        sourceView readOnly: true.
        sourceView services: #()        
    ].
    ^ sourceView

    "Created: / 21-09-2014 / 01:42:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-08-2018 / 11:03:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBSourceApplication methodsFor:'change & update'!

update:aspect with:param from:sender
    "Invoked when an object that I depend upon sends a change notification."

    sender == frameHolder ifTrue:[ 
        self updateAfterFrameHolderChanged.
        ^ self.
    ].

    sender == sourceFileHolder ifTrue:[
        | file source |

        source := nil.
        file := sourceFileHolder value.
        file notNil ifTrue:[ 
            file := file asFilename.
            file exists ifTrue:[ 
                source := file contents asString.
            ]
        ].
        self sourceStringHolder value: source.  
        ^ self.
    ].
    super update:aspect with:param from:sender

    "Modified: / 01-02-2018 / 15:15:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateAfterFrameHolderChanged
    | frame |

    frame := frameHolder value.
    frame notNil ifTrue:[ 
        | line |

        self sourceFileHolder value: frame file.
        line := frame line.
        line notNil ifTrue:[  
            sourceView selectLine: line.
            sourceView makeSelectionVisible.
        ]
    ].

    "Created: / 01-02-2018 / 15:16:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBSourceApplication methodsFor:'change & update-delayed'!

delayedUpdateAfterFrameChanged
    self updateAfterFrameHolderChanged

    "Created: / 01-02-2018 / 15:28:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBSourceApplication methodsFor:'event handling'!

onStoppedEvent: aGDBStoppedEvent
    self enqueueDelayedUpdate: #delayedUpdateAfterFrameChanged

    "Created: / 01-02-2018 / 15:23:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBSourceApplication methodsFor:'initialization & release'!

subscribe   
    "Register for debugger events. To be overrided by subclasses"

    debugger announcer
        when: GDBStoppedEvent               send: #onStoppedEvent: to: self.

    sourceView notNil ifTrue:[ 
        sourceView compilerClass setDebugger: debugger.
    ].

    "Created: / 01-02-2018 / 15:18:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-03-2018 / 22:18:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBSourceApplication class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

