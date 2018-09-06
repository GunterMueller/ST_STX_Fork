"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
"{ Package: 'jv:vdb' }"

"{ NameSpace: Smalltalk }"

ApplicationModel subclass:#VDBAbstractApplication
	instanceVariableNames:'debuggerHolder debugger titleHolder'
	classVariableNames:'DefaultTextFont DefaultMenuFont'
	poolDictionaries:''
	category:'VDB-UI-Abstract'
!

!VDBAbstractApplication class methodsFor:'documentation'!

copyright
"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
! !

!VDBAbstractApplication class methodsFor:'accessing'!

windowTitle
    | m s |

    m := self class lookupMethodFor: #windowSpec.
    m mclass theNonMetaclass isAbstract ifTrue:[ 
        self subclassResponsibility: 'Override #windowTitle in concrete classes'.
    ].
    s := self windowSpec.
    s do: [:e | 
        (e isArray and:[ e first == #WindowSpec ]) ifTrue:[
            ^ e at: 3
        ]
    ].
    ^ self name

    "Created: / 16-12-2017 / 00:45:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-12-2017 / 22:32:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBAbstractApplication class methodsFor:'accessing - defaults'!

defaultMenuFont
    "Return a default font to be used in list and text views. VDB UI is designed
     so that it expects thos font to be monospaced but does not enforce it."     

    DefaultMenuFont isNil ifTrue:[ ^ MenuPanel defaultFont asSize: self defaultTextFont size ].
    ^ DefaultMenuFont

    "Created: / 31-08-2018 / 08:41:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultTextFont
    "Return a default font to be used in list and text views. VDB UI is designed
     so that it expects thos font to be monospaced but does not enforce it."     

    DefaultTextFont isNil ifTrue:[ ^ CodeView defaultFont ].
    ^ DefaultTextFont

    "Created: / 20-08-2018 / 10:49:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultTextFont: aFont
    "Set a default font to be used in list and text views. VDB UI is designed
     so that it expects thos font to be monospaced but does not enforce it."     

    DefaultTextFont := aFont

    "Created: / 20-08-2018 / 10:54:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBAbstractApplication class methodsFor:'interface opening'!

openFor: debugger
    self new 
        debugger: debugger;
        open.

    "Created: / 06-06-2014 / 21:35:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBAbstractApplication class methodsFor:'interface specs'!

windowSpec 
    self subclassResponsibility

    "Created: / 01-06-2017 / 12:14:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBAbstractApplication class methodsFor:'plugin spec'!

aspectSelectors
    ^ #(
        debuggerHolder
    )

    "Created: / 06-06-2014 / 21:47:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBAbstractApplication class methodsFor:'testing'!

isAbstract
    ^ self == VDBAbstractApplication
! !

!VDBAbstractApplication methodsFor:'acessing'!

debugger
    ^ debugger

    "Created: / 06-06-2014 / 21:37:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

debugger: dbg
    self debuggerHolder value: dbg

    "Created: / 06-06-2014 / 21:36:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

masterApplication: anApplicationModel
    super masterApplication: anApplicationModel.
    (anApplicationModel isKindOf: VDBAbstractApplication) ifTrue:[ 
        self debuggerHolder: anApplicationModel debuggerHolder.
    ].

    "Created: / 17-09-2014 / 22:45:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

menuFont
    "Return a Font to be used in pinned menu panels. Default value
     is to use menu's default font at the same size at #textFont"

    ^ self class defaultMenuFont

    "Created: / 31-08-2018 / 08:38:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

textFont
    "Return a Font to be used in list and text views. VDB UI is designed
     so that it expects thos font to be monospaced but does not enforce it."

    ^ self class defaultTextFont

    "Created: / 20-08-2018 / 10:14:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

title
    ^ self titleHolder value

    "Created: / 10-06-2014 / 14:53:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

title: aString
    self titleHolder value: aString

    "Created: / 10-06-2014 / 14:53:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBAbstractApplication methodsFor:'aspects'!

debuggerHolder
    "return/create the 'debuggerHolder' value holder (automatically generated)"

    debuggerHolder isNil ifTrue:[
        debuggerHolder := ValueHolder new.
        debuggerHolder addDependent:self.
    ].
    ^ debuggerHolder
!

debuggerHolder:aValueModel
    "set the 'debuggerHolder' value holder (automatically generated)"

    |oldValue newValue|

    debuggerHolder notNil ifTrue:[
        oldValue := debuggerHolder value.
        debuggerHolder removeDependent:self.
    ].
    debuggerHolder := aValueModel.
    debuggerHolder notNil ifTrue:[
        debuggerHolder addDependent:self.
    ].
    newValue := debuggerHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:debuggerHolder.
    ].
!

titleHolder
    "return/create the 'titleHolder' value holder (automatically generated)"

    titleHolder isNil ifTrue:[
        titleHolder := ValueHolder with: self class windowTitle
    ].
    ^ titleHolder

    "Modified: / 01-06-2017 / 12:13:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBAbstractApplication methodsFor:'binding access'!

menuExtendersFor: key do: block
    "Evaluates a block for each selector that extends particular menu.
     Extender methods have to be annotated by <menuextension: key> annotation
     and must take one argument (an instance of Menu that the menu extension
     extends."

    | cls |

    cls := self class.
    [ cls notNil ] whileTrue:[
        cls selectorsAndMethodsDo:[ :selector :method |
            method annotationsAt: #menuextension: do: [ :annotation |
                annotation arguments first == key ifTrue:[
                    block value: selector
                ].
            ]
        ].
        cls := cls superclass.
    ].

    "Created: / 25-01-2014 / 12:40:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-02-2014 / 22:44:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

menuFor:key
    | menu |

    menu := super menuFor: key.  
    thisContext isRecursive ifFalse:[
        self menuExtendersFor: key do:[:each |
            self perform: each with: menu
        ].
    ].

    ^ menu

    "Modified: / 18-06-1998 / 20:33:56 / cg"
    "Modified (comment): / 06-02-2018 / 20:35:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBAbstractApplication methodsFor:'change & update'!

enqueueDelayedUpdate: selector
    | w |

    w := self window.
    w notNil ifTrue:[
        self window sensor pushUserEvent: selector for:self
    ] ifFalse:[ 
        self perform: selector
    ].

    "Created: / 17-01-2018 / 06:50:29 / jv"
    "Modified: / 03-02-2018 / 08:10:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

enqueueDelayedUpdate: selector with: argument
    | w |

    w := self window.
    w notNil ifTrue:[
        self window sensor pushUserEvent: selector for:self withArgument: argument
    ] ifFalse:[ 
        self perform: selector with: argument
    ].

    "Created: / 17-01-2018 / 06:50:39 / jv"
    "Modified: / 03-02-2018 / 08:10:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

update:something with:aParameter from:changedObject
    "Invoked when an object that I depend upon sends a change notification."

    changedObject == debuggerHolder ifTrue:[
        debuggerHolder value == debugger ifFalse:[
            debugger notNil ifTrue:[ 
                self unsubscribe.
            ].
            debugger := debuggerHolder value.
            debugger notNil ifTrue:[ 
                self subscribe.
            ].
        ].
        ^ self.
    ].
    super update:something with:aParameter from:changedObject

    "Modified: / 06-06-2014 / 22:09:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBAbstractApplication methodsFor:'dependents access'!

release
    "remove all dependencies from the receiver"

    super release.
    self unsubscribe

    "Created: / 06-06-2014 / 22:13:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBAbstractApplication methodsFor:'hooks'!

postBuildWith:aBuilder
    super postBuildWith: aBuilder.  
    (aBuilder window respondsTo: #labelChannel:) ifTrue:[
        aBuilder window labelChannel: self titleHolder.
    ].

    "Created: / 11-07-2017 / 16:33:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-07-2017 / 19:37:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBAbstractApplication methodsFor:'initialization & release'!

subscribe   
    "Register for debugger events. To be overrided by subclasses"

    "Created: / 06-06-2014 / 21:26:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unsubscribe
    "Unsubscribe myself fo debugger events"
    (debugger notNil and:[debugger isConnected]) ifTrue:[ 
        debugger announcer unsubscribe: self.
    ].

    "Created: / 06-06-2014 / 21:26:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-06-2017 / 13:43:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBAbstractApplication methodsFor:'menu actions'!

doInspectApplication
    self inspect

    "Created: / 06-02-2018 / 12:54:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doInspectDebugger
   debugger inspect

    "Modified: / 09-09-2014 / 00:09:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doInspectSessionRecord
   (debugger instVarNamed:#connection) recorder inspect

    "Created: / 09-09-2014 / 00:12:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doOpenToolApplication:application 
    application allButOpen.
    application masterApplication: self topMasterApplication.
    self doOpenToolWindow: application window

    "Created: / 11-06-2017 / 20:21:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-07-2018 / 16:30:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doOpenToolApplicationClass:applicationClassName 
    | applicationClass  application |

    applicationClass := Smalltalk at:applicationClassName asSymbol.
    applicationClass isNil ifTrue:[
        Dialog 
            warn:('No application class named %1' bindWith:applicationClassName).
        ^ self.
    ].
    application := applicationClass new.
    application debuggerHolder:self debuggerHolder.
    self doOpenToolApplication:application

    "Created: / 11-06-2017 / 20:21:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doOpenToolWindow:window 
    | screen |

    window realize.
    "/ On X11, use ICCCM hints to tell the WM about a transient tool window
    "/ and let WM to handle this according to DE standards. It has the nice
    "/ side effect (on most modern WM) that these windows don't show up in
    "/ pager / task list and go away when browser's main window is minimuzed    
    screen := Screen current.
    (screen notNil and:[ screen platformName == #X11 ]) ifTrue:[
        screen setTransient:window topView id for:self window topView id.         
        "/ Also, use EWMH hint to tell the WM that the window is
        "/ a sort of floating tool so WM can decorate it according to
        "/ DE standards.        
        screen setWindowType:#'_NET_WM_WINDOW_TYPE_UTILITY'
            in:window topView id
    ].
    window openInGroup: self window windowGroup.

    "Created: / 14-03-2018 / 09:47:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doPinMenuAs: label item: tearOffMenuItem 
    | menu  window  panel |

    menu := tearOffMenuItem menuPanel asMenu.
     
    "/ Remove the 'Tear Off' menu item...
    
    menu items last value = #doPinMenuAs:item: ifTrue:[
        menu items removeLast.
         
        "/ And possible separator above it...
        
        (menu items last value isNil and:[ menu items last label = '-' ]) ifTrue:[
            menu items removeLast.
        ].
    ].
    window := StandardSystemView new.
    window label: (resources string: label).
    panel := MenuPanel in:window.
    panel
        font: self menuFont;
        originator: self;    
        layout: (0.0 @ 0.0 corner:1.0 @ 1.0) asLayout;
        verticalLayout:true.
    panel
        menu:menu;
        receiver:self.
    window extent:panel preferredExtent.
    self doOpenToolWindow:window

    "Created: / 16-03-2018 / 10:20:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-08-2018 / 08:38:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBAbstractApplication methodsFor:'startup & release'!

releaseAsSubCanvas
    "a subcanvas is closed or switching to a new application.
     Can be redefined to perform a self release in this case."

    self release

    "Created: / 06-06-2014 / 22:12:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBAbstractApplication class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

