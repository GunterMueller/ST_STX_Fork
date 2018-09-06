"
 COPYRIGHT (c) 1998 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg2' }"

"{ NameSpace: Smalltalk }"

ScrollableView subclass:#SubCanvas
	instanceVariableNames:'builder spec client clientHolder specHolder clientView
		clientViewIsScrolled lateBuild useApplicationSubView
		keepClientView useOwnBuilder enforcedHorizontalMini
		enforcedVerticalMini'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Basic'
!

!SubCanvas class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1998 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

!

documentation
"
    a view for a subApplication.

    Made to be VW compatible as much as possible (try opening a RefactoringBrowser ...).
    However, the default setup is not very useful to embed arbitrary applications
    which are meant to be separate stand-alone applications.

    Use the settings:
        keepClientView          (default: true)
        useApplicationSubView   (default: false)
        useOwnBuilder           (default: false)

    [author:]
        Claus Atzkern
"
! !

!SubCanvas class methodsFor:'defaults'!

defaultHorizontalScrollable
    ^ false


!

defaultVerticalScrollable
    ^ false


! !

!SubCanvas methodsFor:'accessing'!

builder
    ^ builder
!

builder:aBuilder
    builder := aBuilder 
!

client
    ^ client
!

client:anApplication spec:aWindowSpecOrSpecSymbol builder:aBuilder
    "release existing components and generate new components from
     the given windowSpec, using the given builder."

    |myApp|

    (client notNil and:[client ~~ anApplication]) ifTrue:[
        client releaseAsSubCanvas.
        client := nil.
    ].

    (builder := aBuilder) isNil ifTrue:[
        anApplication notNil ifTrue:[
            builder := anApplication perform:#builder ifNotUnderstood:[ nil ]
        ].
        builder isNil ifTrue:[ builder := UIBuilder new ].
    ].

    spec := aWindowSpecOrSpecSymbol.

    "/ check for master application
    (anApplication notNil and:[anApplication masterApplication isNil]) ifTrue:[
        myApp := self application.
        myApp ~~ anApplication ifTrue:[
            anApplication masterApplication:myApp
        ]
    ].

    client := anApplication.
    self rebuild.
    ^ builder
!

clientView
    ^ clientView
!

clientViewIsScrolled
    ^ clientViewIsScrolled
!

horizontalMini:aBoolean
    super horizontalMini:aBoolean.
    enforcedHorizontalMini := aBoolean.
!

isScrollWrapper
    ^ clientViewIsScrolled
!

makeClientViewScrollable:shouldBeScrollable
    |scroller|

    shouldBeScrollable ~~ clientViewIsScrolled ifTrue:[
        clientView isNil ifTrue:[
            useApplicationSubView ifTrue:[
                clientView := ApplicationSubView new.
            ] ifFalse:[
                clientView := View new.
            ]
        ].
        shouldBeScrollable ifTrue:[
            scroller := ViewScroller new.
            scroller viewBackground:self viewBackground.
            self scrolledView:scroller.
            scroller scrolledView:clientView.
        ] ifFalse:[
            self scrolledView:clientView.
        ].
        clientViewIsScrolled := shouldBeScrollable.
    ]

    "Modified: / 30.1.2000 / 21:36:29 / cg"
!

setClient:anApplicationModel
    "set the client - do NOT rebuild"

    client := anApplicationModel 
!

spec
    ^ spec
!

spec:something
    spec := something.
    self rebuild.
!

verticalMini:aBoolean
    super verticalMini:aBoolean.
    enforcedVerticalMini := aBoolean.
!

widget
    "ST80 compatibility. 
     I am my own widget"

    ^ self

    "Created: / 10.3.1998 / 16:20:52 / stefan"
! !

!SubCanvas methodsFor:'accessing-canvasView handling'!

keepClientView:aBoolean
    keepClientView := aBoolean
!

useApplicationSubView:aBoolean
    useApplicationSubView := aBoolean
!

useOwnBuilder:aBoolean
    useOwnBuilder := aBoolean
! !

!SubCanvas methodsFor:'accessing-channels'!

clientHolder
    ^ clientHolder
!

clientHolder:aValueHolder
    |oldClient|

    clientHolder notNil ifTrue:[
        oldClient := clientHolder value.
        clientHolder removeDependent:self
    ].
    (clientHolder := aValueHolder) notNil ifTrue:[
        clientHolder addDependent:self
    ].
    oldClient ~~ clientHolder value ifTrue:[
        self updateFromChannels
    ]
!

clientView:aView
    clientView notNil ifTrue:[
        clientView destroy
    ].
    clientView := aView
!

specHolder
    ^ specHolder
!

specHolder:aValueHolder
    |oldSpec|

    specHolder notNil ifTrue:[
        oldSpec := specHolder value.
        specHolder removeDependent:self
    ].
    (specHolder := aValueHolder) notNil ifTrue:[
        specHolder addDependent:self
    ].
    oldSpec ~~ specHolder value ifTrue:[
        self updateFromChannels
    ]
!

specHolder:newSpecHolder clientHolder:newClientHolder
    |oldSpec oldClient|

    clientHolder notNil ifTrue:[
        oldClient := clientHolder value.
        clientHolder removeDependent:self
    ].
    specHolder notNil ifTrue:[
        oldSpec := specHolder value.
        specHolder removeDependent:self
    ].
    (specHolder := newSpecHolder) notNil ifTrue:[
        specHolder addDependent:self
    ].
    (clientHolder := newClientHolder) notNil ifTrue:[
        clientHolder addDependent:self
    ].
    ((oldSpec ~~ specHolder value) or:[oldClient ~~ clientHolder value]) ifTrue:[
        self updateFromChannels
    ]
! !

!SubCanvas methodsFor:'building'!

container:aView
    super container:aView.

    "/ my builder can only build the components, when I have a container
    "/ lateBuild is set, if the spec was set some time ago, when I had no container
    "/ Now, we know where to build the GUI ...
    "/ ... and must hurry up to create the widgets.
    lateBuild == true ifTrue:[
        lateBuild := false.
        self rebuild
    ].
!

rebuild
    "rebuild my GUI from the spec."

    |subSpec subWindowSpec savedView savedBuilder builderClass hasHScroller hasVScroller|

    "/ if the superView is not yet created,
    "/ we MUST delay building... (sigh)
    superView isNil ifTrue:[          
        lateBuild := true.
        ^ self
    ].

    clientView notNil ifTrue:[
        clientView destroySubViews.
    ].

    spec notNil ifTrue:[
        subSpec := spec.
        subSpec isSymbol ifTrue:[
            client isNil ifTrue:[
                clientHolder isNil ifTrue:[
                    ('SubCanvas [warning]: no client - cannot build spec: ' , spec) infoPrintCR.
                ].
                ^ self
            ].
            (subSpec := client interfaceSpecFor:spec) isNil ifTrue:[
                "/ Transcript showCR:'SubCanvas: nil spec'.
                ^ self
            ]
        ].
        subSpec isArray ifTrue:[
            subSpec := subSpec decodeAsLiteralArray.
            subSpec isArray ifTrue:[self halt:'oops - decode failed'].
        ].
        builder isNil ifTrue:[
            client isNil ifTrue:[
                builderClass := UIBuilder
            ] ifFalse:[
                builderClass := client builderClass
            ].
            builder := builderClass new.
        ].

        "/ old:
        "/  builder buildFromSpec:subSpec in:clientView.

        "/ new (let app know (somehow) that this is a build
        "/ for a subcanvas (i.e. it can redefine the buildSubCanvas-method):

        keepClientView ifFalse:[
            (clientView notNil and:[clientView application ~~ client]) ifTrue:[
                clientView destroy.
                clientView := nil.
            ].
        ].

        clientView isNil ifTrue:[
            "/ create a new view

            useApplicationSubView ifTrue:[
                clientView := ApplicationSubView new.
            ] ifFalse:[
                clientView := View new.
            ].
            clientView viewBackground:self viewBackground.
        ].
        useApplicationSubView ifTrue:[
            clientView application:client.
        ].

        savedView := builder window.
        builder window:clientView.
        useOwnBuilder ifTrue:[
            savedBuilder := client builder.
            client builder:builder.
        ].

        [   
            |savedSuperView|

            "/ kludge: need superView to be set correctly, in order for
            "/ postBuildAsSubCanvas to be invoked (instead of postBuild)
            "/ however, must unset the superView for code below ...
            savedSuperView := clientView superView.
            savedSuperView isNil ifTrue:[clientView setContainer:self].
            client buildSubCanvas:subSpec withBuilder:builder.

            subSpec class == FullSpec ifTrue:[
                subWindowSpec := subSpec window.
                "/ mhmh - should we take the attributes from the windowSpec or from my spec ????
                subWindowSpec setBackgroundColorAttributesIn:clientView with:builder.
            ].
            savedSuperView isNil ifTrue:[
                clientView setContainer:nil. 
                self removeSubView:clientView.
            ].

            keepClientView ifFalse:[    
                self assert:(scrolledView isNil or:[(clientView isComponentOf:scrolledView) not]).
                self scrolledView:clientView.
            ] ifTrue:[
                (clientView isComponentOf:self) ifFalse:[
                    self scrolledView:clientView.
                ]
            ]
        ] ensure:[
            savedView notNil ifTrue:[
                builder window:savedView.
            ].
            useOwnBuilder ifTrue:[
                savedBuilder notNil ifTrue:[
                    client builder:savedBuilder.
                ]
            ]
        ].

        clientViewIsScrolled ifTrue:[
            (subWindowSpec notNil and:[subWindowSpec layout notNil]) ifTrue:[
                "/ mhmh - what should we base the size computation on ?
                "/ (I don't see any reason to look at the windows spec at all;
                "/  isn't the user of the spec the only one to control the size).
                clientView extent:(subWindowSpec bounds extent)
            ] ifFalse:[
                "/ clientView extent:(subWindowSpec bounds extent)
            ].
            self sizeChanged:nil.   "/ to force recomputation of the scrollbar
        ] ifFalse:[
            "/ clientView extent:(clientView preferredExtent)
        ].
        hasVScroller := hasHScroller := false.
        subWindowSpec notNil ifTrue:[
            hasVScroller := hasHorizontalScrollBar and:[subWindowSpec hasVerticalScrollBar].
            hasHScroller := hasVerticalScrollBar and:[subWindowSpec hasHorizontalScrollBar].
        ].

        hasVScroller ifFalse:[
            "/ clientView gets my size
            clientView height:1.0.
        ] ifTrue:[
            "/ clientView takes what it wants, but is scrolled by the viewScroller
            clientView height:(clientView preferredExtent y).
            super verticalMini:(enforcedVerticalMini or:[subWindowSpec miniScrollerVertical]).
        ].
        hasHScroller ifFalse:[
            "/ clientView gets my size
            clientView width:1.0.
        ] ifTrue:[
            "/ clientView takes what it wants, but is scrolled by the viewScroller
            clientView width:(clientView preferredExtent x).
            super horizontalMini:(enforcedHorizontalMini or:[subWindowSpec miniScrollerHorizontal]).
        ].
        clientViewIsScrolled ifTrue:[
            scrolledView resizeScrolledViewVertical:hasVScroller not.
            scrolledView resizeScrolledViewHorizontal:hasHScroller not.
        ] ifFalse:[
            "/ self halt.
        ].

        self realized ifTrue:[
            "/ cg: I think we should call
            "/ clientView recursiveRealizeAllSubViews.
            "/ instead of: 
            clientView realizeAllSubViews.

            clientViewIsScrolled ifTrue:[
                scrolledView repositionScrolledView.
                scrolledView resizeScrolledView
            ].
        ].
    ]

    "Modified: / 30.1.2000 / 21:36:40 / cg"
!

releaseAllComponents
    clientView notNil ifTrue:[
        clientView destroySubViews.
    ].
    builder := nil.
    spec    := nil.
    client  := nil.

    "Modified: / 31.1.2000 / 16:56:14 / cg"
! !

!SubCanvas methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    (changedObject == clientHolder or:[changedObject == specHolder]) ifTrue:[
        self updateFromChannels.
        ^ self
    ].
    super update:something with:aParameter from:changedObject.
!

updateFromChannels
    "some of our channels (clientHolder, specHolder) changed"

    |newClient newSpec uiBuilder|

    clientHolder isNil ifTrue:[
        newClient := self application.
        "/ new code added Jun,7 2014 (used to always create new builder)
useOwnBuilder ifFalse:[
    uiBuilder := newClient builder.
] ifTrue:[
        uiBuilder := UIBuilder new.
        uiBuilder isSubBuilder:true.
].
    ] ifFalse:[
        newClient := clientHolder value
    ].

    specHolder isNil ifTrue:[
        newSpec := #windowSpec
    ] ifFalse:[
        newSpec := specHolder value
    ].

    (newClient notNil and:[newSpec notNil]) ifTrue:[
    ] ifFalse:[
"/        spec notNil ifTrue:[
"/            self halt:'spec but no app'.
"/        ].
        newClient := nil.
        newSpec := #windowSpec.  "/ is that true ?
    ].
    self client:newClient spec:newSpec builder:uiBuilder

    "Modified: / 5.8.1999 / 13:35:26 / cg"
! !

!SubCanvas methodsFor:'delegation'!

viewBackground:aColor
    "convenient method: forward this to the scrolledView"

    super viewBackground:aColor.
    (scrolledView notNil and:[scrolledView ~= clientView]) ifTrue:[
        scrolledView viewBackground:aColor
    ].
! !

!SubCanvas methodsFor:'initialization'!

initialize
    super initialize.
    clientViewIsScrolled := false.
    enforcedVerticalMini := enforcedHorizontalMini := false.

    "/ these defaults make subCanvas compatible with VW;
    "/ however, they make our life difficult sometimes.
    keepClientView := true.
    useApplicationSubView := true "false".
    useOwnBuilder := false.

    spec := #windowSpec.

    "Modified: / 31.1.2000 / 16:56:31 / cg"
!

release
    client notNil ifTrue:[
        client == self application ifTrue:[
            client releaseAsSubCanvas.
        ] ifFalse:[
            client release
        ].
    ].

    clientHolder notNil ifTrue:[
        clientHolder removeDependent:self.
        clientHolder := nil.
    ].
    specHolder notNil ifTrue:[
        specHolder removeDependent:self.
        specHolder := nil.
    ].
    super release.

    "Modified: / 13.2.2000 / 23:31:12 / cg"
! !

!SubCanvas methodsFor:'layout'!

usedScrolledViewHMarginWhenHasV:hasV andHasH:hasH
    "return the horizontal margin around (outer margin).
     Redefined to avoid margin when no scrollers are present"

    ^ (hasV or:[hasH]) ifTrue:[scrolledViewHMargin] ifFalse:[0]


!

usedScrolledViewVMarginWhenHasV:hasV andHasH:hasH
    "return the horizontal margin around (outer margin).
     Redefined to avoid margin when no scrollers are present"

    ^ (hasV or:[hasH]) ifTrue:[scrolledViewVMargin] ifFalse:[0]


! !

!SubCanvas methodsFor:'queries'!

application
    "return the application, under which this view was opened"

    ^ client notNil ifTrue:[ client ] ifFalse:[ super application ]

    "Modified: / 18-07-2011 / 09:55:11 / cg"
! !

!SubCanvas class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

