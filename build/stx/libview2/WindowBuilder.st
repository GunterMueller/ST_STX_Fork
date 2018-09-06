"
 COPYRIGHT (c) 1995 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview2' }"

"{ NameSpace: Smalltalk }"

Object subclass:#WindowBuilder
	instanceVariableNames:'window application bindings visuals labels namedComponents
		helpKeys componentCreationHook applicationClass keyboardProcessor
		subCanvasSpecs componentToSpecMapping windowTitle'
	classVariableNames:'StopOnError Verbose'
	poolDictionaries:''
	category:'Interface-Framework'
!

!WindowBuilder class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
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
    a no-op class, for systems which do not use the UIBuilder.
    Concrete subclasses know how to create a view (with components) from
    some interface spec.

    The order of the lookup sequence to access an aspect is defined:
	application
	application class
	additional  class (applicationClass).

    Methods to access any aspect are located in the category
    'spec creation aspect fetch'.

    Currently, an experimantal version of UIBuilder exists,
    and more may be added in the future (for example, to parse different UI
    specs - thinking of motifs UIL specs, Windows DialogSpecs etc.).

    [instance variables:]
	window          <View>
				the topView into which the components
				are (have been) created from the specification

	application     <ApplicationModel>
				the application object (typically an instance
				of a subclass of ApplicationModel).
				That one is usually supposed to provide
				valueHolders for aspects, action methods
				menuSpecs and possibly more windowSpecs.
				Usually means, that most of those can also be
				provided to the builder via a set of bindings,
				which overrides those.

	bindings        <Dictionary>
				can be set (or filled) with bindings for
				aspects to be used when setting up the models
				for components. Useful either to overwrite
				corresponding appModel aspects or if the appModel
				does not want to procide those.
				(for example, to open a dialog and provide the
				 bindings in a dictionary - as opposed to
				 providing them via aspect methods)

	visuals                 not yet used - for compatibility

	focusSequence   <Collection>
				maintained during the build process;
				contains tabable components.
				This will be replaced by a more intelligent
				mechanism in the near future.

	namedComponents <Dictionary>
				contains name->component associations for
				all components which have a non-nil component
				name. Created during the build process.

	helpKeys                not yet used - for compatibility

	componentCreationHook <BlockOrNil>
				can be set before the components are built
				from the spec, to provide an arbitrary
				callBacks-hook which will be invoked after
				a component has been created from a spec.
				The UIPainter uses this to maintain its
				component<->spec assiciations.
				Can be set by the app, to catch creation of
				components and fiddle around during the
				creation process (change extents, colors or whatever)

	applicationClass <ClassOrNil>
				can be set to provide an additional class which
				is asked for aspects during the build process.
				If not set, the app is asked, which itself asks
				its class.

	keyboardProcessor       not yet used - for compatibility
				Will eventually takeover the functionality
				of the focusSequence, shortcuts & provide a hook
				for the app.

	subCanvasSpecs <Dictionary>
				can be set by the app to provide subcanvas
				specs (much like the bindings dictionary)

    [author:]
	Claus Gittinger
"
! !

!WindowBuilder class methodsFor:'debugging'!

stopOnError:aBoolean
    "enable/disable debug halt when aspects are missing.
     Useful during development, to detect missing aspects.
     The default is off."

    StopOnError := aBoolean

    "Modified: / 4.8.1998 / 19:40:09 / cg"
!

verbose:aBoolean
    "enable/disable debug messages on the Transcript.
     Useful during development, to detect missing aspects.
     The default is off."

    Verbose := aBoolean

    "Created: / 4.8.1998 / 19:39:37 / cg"
    "Modified: / 4.8.1998 / 19:40:14 / cg"
! !

!WindowBuilder methodsFor:'Compatibility-VW'!

source
    "same as #application, for ST-80 compatibility"

    ^ application

    "Created: 17.1.1997 / 19:03:51 / cg"
!

source:anApplicationModel
    "same as #application:, for ST-80 compatibility"

    application := anApplicationModel

    "Modified: 17.1.1997 / 19:03:57 / cg"
! !

!WindowBuilder methodsFor:'accessing'!

addBindings:moreBindings
    "used with subDialogs, which provide local bindings.
     All bindings from moreBindings overwrite any local bindings."

    moreBindings notNil ifTrue:[
	bindings isNil ifTrue:[
	    bindings := IdentityDictionary new
	].
	bindings addAll:moreBindings
    ]

    "Created: 28.2.1997 / 14:14:33 / cg"
!

application
    "return the application (an ApplicationModel),
     for which the view is built.
     This one is supposed to provide the aspects, menus etc."

    ^ application

    "Modified: 17.1.1997 / 19:04:40 / cg"
!

application:anApplicationModel
    "set the application (an ApplicationModel),
     for which the view is built.
     This one is supposed to provide the aspects, menus etc."

    application := anApplicationModel

    "Modified: 17.1.1997 / 19:04:47 / cg"
!

applicationClass
    "return the value of the instance variable 'applicationClass' (automatically generated).
     WARNING:
	This is a private interface for the UIPainter to pass down the app-class
	to the specs when editing."

    ^ applicationClass
!

applicationClass:something
    "set the value of the instance variable 'applicationClass' (automatically generated).
     WARNING:
	 This is a private interface for the UIPainter to pass down the app-class
	 to the specs when editing."

    applicationClass := something.
!

aspectAt:aSymbol
    "return the aspect for a symbol or nil."

    ^ self
	aspectAt:aSymbol
	ifAbsent:[self aspectNotFound:aSymbol error:'no aspect for:']

    "Modified: / 4.8.1998 / 19:29:36 / cg"
!

aspectAt:aSymbol ifAbsent:exceptionBlock
    "return the aspect for a symbol or the value from exceptionBlock."

    |b|

    aSymbol notNil ifTrue:[
        bindings notNil ifTrue:[
            b := bindings at:aSymbol ifAbsent:nil.
            b notNil ifTrue:[^ b].
        ].

        application notNil ifTrue:[
            MessageNotUnderstood
                ignoreNotUnderstoodOf:aSymbol
                in:[
                    ^ application aspectFor:aSymbol
                ].
            MessageNotUnderstood
                ignoreNotUnderstoodOf:aSymbol
                in:[
                    ^ application class aspectFor:aSymbol
                ].

            ^ exceptionBlock value.
        ]
    ].
    ^ nil

    "Created: / 04-08-1998 / 19:28:30 / cg"
    "Modified: / 25-07-2011 / 15:29:25 / cg"
!

aspectAt:aSymbol put:aModel
    "store an aspect identified by its symbol and its value.
     Returns the stored aspect !!"

    bindings isNil ifTrue:[
	bindings := IdentityDictionary new
    ].
    bindings at:aSymbol put:aModel.
    ^ aModel
!

bindingAt:aSymbol
    "return the binding for a symbol or nil if there is none"

    bindings notNil ifTrue:[
	^ bindings at:aSymbol ifAbsent:nil.
    ].
    ^ nil
!

bindings
    "return my bindings"

    bindings isNil ifTrue:[
        bindings := IdentityDictionary new.
    ].
    ^ bindings

    "Modified: / 20-04-2005 / 18:59:28 / janfrog"
!

bindings:aDictionary
    "set bindings to a dictionary"

    bindings := aDictionary
!

componentAt:name
    "return a component identified by its name"

    |widget|

    namedComponents notNil ifTrue:[
        widget := namedComponents at:name asSymbol ifAbsent:nil.
        widget notNil ifTrue:[^ widget].
    ].

    "/ cg the following code looks in any application-
    "/ or master applications builder for the component.
    "/ This has an effect, if a subcanvases builder is asked for
    "/ a component, which is actually held by the real-apps builder
    "/ (in case they have different builders).
    "/ For now, this code is disabled, since I don't know what effect this
    "/ has to existing code ...

"/    application notNil ifTrue:[
"/        |appBuilder masterApplication masterBuilder|
"/
"/        (appBuilder := application builder) notNil ifTrue:[
"/            appBuilder ~~ self ifTrue:[
"/                ^ appBuilder componentAt:name
"/            ]
"/        ].
"/
"/        (masterApplication := application masterApplication) notNil ifTrue:[
"/            (masterBuilder := masterApplication builder) notNil ifTrue:[
"/                masterBuilder ~~ self ifTrue:[
"/                    ^ masterBuilder componentAt:name
"/                ]
"/            ]
"/        ]
"/    ].
    ^ nil
!

componentAt:name put:aComponent
    "store a component identified by its name."

    namedComponents isNil ifTrue:[
	namedComponents := IdentityDictionary new.
    ].
    namedComponents at:name asSymbol put:aComponent
!

componentCreationHook:something
    "set the value of the instance variable 'componentCreationHook' (automatically generated)"

    componentCreationHook := something.
!

componentToSpecMappingAt:aView
    componentToSpecMapping isNil ifTrue:[^ nil].
    ^ componentToSpecMapping at:aView ifAbsent:nil
!

componentToSpecMappingAt:aView put:aSpec

    "/ self assert:(aSpec isKindOf:UISpecification).

    componentToSpecMapping isNil ifTrue:[
	componentToSpecMapping := IdentityDictionary new.
    ].
    componentToSpecMapping at:aView put:aSpec
!

findComponentAt:name
    "recursively search for a component identified by its name in myself
     and all of my subApplications."

    ^ self
	findComponentAt:name
	forWhichViewConformsTo:[:v | true]
	ignoringViews:(IdentitySet new).
!

findComponentAt:name forWhichViewConformsTo:viewCheck ignoringViews:triedViews
    "recursively search for a visible component identified by its name in myself
     and all of my subApplications.
     As a builders applications view might be different from the builders view,
     we must be careful to avoid endless recursion if a subview refers to the topviews builder,
     (sigh)"

    |comp "window" app b|

    (comp := self componentAt:name) notNil ifTrue:[
	^ comp
    ].

    window isNil ifTrue:[
	^ self
    ].
    "/ window := self application window.

    (triedViews includes:window) ifTrue:[^ nil].
    triedViews add:window.

    window allSubViewsDo:[:v |
	(triedViews includes:v) ifFalse:[
	    triedViews add:v.
	    (viewCheck value:v) ifTrue:[
		((app := v application) notNil
		and:[(b := app builder) notNil
		and:[b ~~ self]])
		ifTrue:[
		    comp := b findComponentAt:name forWhichViewConformsTo:viewCheck ignoringViews:triedViews.
		    comp notNil ifTrue:[
			^ comp
		    ]
		]
	    ]
	]
    ].
    ^ nil
!

findVisibleComponentAt:name
    "recursively search for a visible component identified by its name in myself
     and all of my subApplications.
     Be careful: this also searches for components in unmapped canvases."

    ^ self
	findComponentAt:name
	forWhichViewConformsTo:[:v | v shown]
	ignoringViews:(IdentitySet new).
!

helpKeyFor:aComponent
    "return the helpkey for a component or nil"

    |v key|

    v := aComponent.
    [v notNil] whileTrue:[
	(key := v helpKey) notNil ifTrue:[
	    ^ key
	].
"/        helpKeys notNil ifTrue:[
"/            (key := helpKeys at:v ifAbsent:nil) notNil ifTrue:[
"/                ^ key
"/            ].
"/        ].
	v := v superView
    ].
    ^ nil
!

helpKeyFor:aComponent put:aKey
    "assign a key for a component which is used to access the help text
     from the application."

    aComponent helpKey:aKey.

"/    aKey isNil ifTrue:[
"/        helpKeys isNil ifFalse:[
"/            helpKeys removeKey:aComponent ifAbsent:nil
"/        ]
"/    ] ifFalse:[
"/        helpKeys isNil ifTrue:[
"/            helpKeys := IdentityDictionary new
"/        ].
"/        helpKeys at:aComponent put:aKey
"/    ]
!

keyboardProcessor
    "return my keyboard processor"

    keyboardProcessor isNil ifTrue:[
	keyboardProcessor := KeyboardProcessor new
    ].
    ^ keyboardProcessor

    "Created: 3.3.1997 / 18:31:37 / cg"
    "Modified: 3.3.1997 / 18:32:27 / cg"
!

keyboardProcessor:aKeyboardProcessor
    "set my keyboard processor"

    keyboardProcessor := aKeyboardProcessor

    "Created: / 18.6.1998 / 19:59:38 / cg"
!

labelAt:name
    labels isNil ifTrue:[^ nil].
    ^ labels at:name asSymbol ifAbsent:nil

    "Created: / 27.2.1998 / 13:52:28 / cg"
!

labelAt:name put:aLabelString
    labels isNil ifTrue:[
	labels := IdentityDictionary new.
    ].
    labels at:name asSymbol put:aLabelString

    "Created: / 27.2.1998 / 02:30:54 / cg"
!

menuAt:aKey
    "Find a binding for the menu named aKey, either in the bindings
     or from the source"

    ^ self menuFor:aKey


!

menuAt:aSymbol put:someMenuOrHolder
    "add someMenuOrHolder as the binding for the menu named aSymbol to the bindings"

    ^ self aspectAt:aSymbol put:someMenuOrHolder

!

namedComponents
    "return a list of named components"

    ^ namedComponents
!

namedComponentsDo: aBlock
    namedComponents notNil ifTrue:[
	namedComponents do:[:aView|
	    aBlock value: aView
	]
    ]
!

resources
    "return the application's resources -
     that's a ResourcePack containing national language strings"

    application notNil ifTrue:[
        ^ application resources
    ].
    ^ Dialog classResources.
!

subCanvasAt:majorKey at:minorKey
    "get the subCanvas or subSpec specification from major and minor key.
     Here, we first look for a spec in the private subCanvasSpecs dictionary,
     which can be filled via #specificationAt:at:put: messages.
     If not present, or none is found there, we bounce back trying
     #specificationFor: (if majorKey is nil) or by sending the minorKey
     message to the class named as majorKey.
     Notice, that the class named majorKey is first searched in the
     application classes namespace - allowing private classes as majorKey."

    |spec cls dict dkey|

    minorKey isNil ifTrue:[^ nil].

    subCanvasSpecs notNil ifTrue:[
	dkey := majorKey ? #NoMajorKey.
	dict := subCanvasSpecs at:dkey ifAbsent:nil.

	dict notNil ifTrue:[
	    spec := dict at:minorKey ifAbsent:nil.
	    spec notNil ifTrue:[^ spec].
	].
    ].

    majorKey isNil ifTrue:[
	spec := self specificationFor:minorKey.
	spec isNil ifTrue:[
	    "fallback for UIPainter"
	    MessageNotUnderstood catch:[
		spec := applicationClass perform:minorKey.
	    ].
	].
	^ spec
    ].

    application notNil ifTrue:[
	"/ look for class in applications namespace ...
	cls := application resolveName:majorKey.
    ] ifFalse:[
	"/ fallBack - use that global, if it exists
	cls := Smalltalk at:majorKey.
	cls isNil ifTrue:[
	    Transcript showCR:('WindowBuilder[warning]: missing application when fetching majorKey:' , majorKey).
	].
    ].

    cls notNil ifTrue:[
	MessageNotUnderstood catch:[
	    ^ cls specificationFor:minorKey
	].
	MessageNotUnderstood catch:[
	    ^ cls perform:minorKey.
	]
    ].
    ^ nil
!

subCanvasAt:majorKey at:minorKey put:aSpec
    "deposit an interfaceSpecification for major and minor key
     in my private subCanvasSpecs dictionary.
     This will be used later, when building,
     to provide an interfaceSpec for a subcanvas or subSpecification
     (or possibly override an application provided interfaceSpec).
     See #subCanvasAt:at:."

    |dict key|

    subCanvasSpecs isNil ifTrue:[
        "/ lazily initialize
        subCanvasSpecs := IdentityDictionary new
    ].

    key := majorKey ? #NoMajorKey.
    dict := subCanvasSpecs at:key ifAbsent:nil.
    dict isNil ifTrue:[
        dict := IdentityDictionary new.
        subCanvasSpecs at:key put:dict
    ].
    dict at:minorKey put:aSpec

    "Modified: / 27.1.1998 / 12:21:27 / cg"
    "Modified: / 5.2.1998 / 12:05:32 / stefan"
!

visualAt:name
    visuals isNil ifTrue:[^ nil].
    ^ visuals at:name asSymbol ifAbsent:nil

    "Created: 3.3.1997 / 16:24:17 / cg"
!

visualAt:name put:aVisual
    visuals isNil ifTrue:[
	visuals := IdentityDictionary new.
    ].
    visuals at:name asSymbol put:aVisual

    "Created: 3.3.1997 / 16:24:41 / cg"
!

visuals
    ^ visuals

    "Created: 3.3.1997 / 16:24:00 / cg"
!

visuals:aDictionary
    visuals := aDictionary

    "Created: 3.3.1997 / 16:24:06 / cg"
!

window
    "return the top window (view), for which an interface is (being) built"

    ^ window

    "Modified: 17.1.1997 / 19:30:00 / cg"
!

window:aView
    "set the top window (view), for which an interface
     is (being) built"

    window := aView

    "Modified: 17.1.1997 / 19:30:22 / cg"
!

windowGroup
    ^ window windowGroup

    "Modified: 17.6.1997 / 18:04:01 / cg"
!

windowTitle:aString
    "if the window is already created, change its title.
     Otherwise, remember the title to be set when the window is created later"

    windowTitle := aString.
    window notNil ifTrue:[
        window label:aString
    ].
! !

!WindowBuilder methodsFor:'aspect access support'!

booleanValueAspectFor:aKey
    "helper (common code) to generate a boolean aspect if required.
     If no binding exists for aKey, a valueHolder holding false is
     created and added to the bindings.
     Otherwise, the existing binding is returned."

    ^ self valueAspectFor:aKey initialValue:false

    "Modified: 28.7.1997 / 12:53:57 / cg"
!

listAspectFor:aKey
    "helper (common code) to generate a list model aspect if required.
     If no binding exists for aKey, a new List is
     created and added to the bindings.
     Otherwise, the existing binding is returned."

    |list|

    (list := self bindingAt:aKey) isNil ifTrue:[
	self aspectAt:aKey put:(list := List new).
    ].
    ^ list

    "Created: 28.7.1997 / 12:53:45 / cg"
    "Modified: 28.7.1997 / 12:54:13 / cg"
!

nilValueAspectFor:aKey
    "helper (common code) to generate a valueHolder aspect if required.
     If no binding exists for aKey, a valueHolder holding nil is
     created and added to the bindings.
     Otherwise, the existing binding is returned."

    ^ self valueAspectFor:aKey initialValue:nil

    "Modified: 28.7.1997 / 12:54:06 / cg"
!

valueAspectFor:aKey computeInitialValueWith:initialValueBlock
    "helper (common code) to generate a valueHolder aspect if required.
     If no binding exists for aKey, a valueHolder holding initialValue is
     created and added to the bindings.
     Otherwise, the existing binding is returned.
     The initial value is computed by evaluating initialValueBlock"

    |holder|

    (holder := self bindingAt:aKey) isNil ifTrue:[
	self aspectAt:aKey put:(holder := initialValueBlock value asValue).
    ].
    ^ holder
!

valueAspectFor:aKey initialValue:initialValue
    "helper (common code) to generate a valueHolder aspect if required.
     If no binding exists for aKey, a valueHolder holding initialValue is
     created and added to the bindings.
     Otherwise, the existing binding is returned."

    |holder|

    (holder := self bindingAt:aKey) isNil ifTrue:[
	self aspectAt:aKey put:(holder := initialValue asValue).
    ].
    ^ holder

    "Created: 28.7.1997 / 12:53:45 / cg"
    "Modified: 28.7.1997 / 12:54:13 / cg"
! !

!WindowBuilder methodsFor:'building'!

buildFromSpec:aSpec
    ^ self subclassResponsibility
!

makeTabable:aComponent
    "add a component to the list of tabable components"

    aComponent canTab:true

!

setupWindowFor:aWindow
    self subclassResponsibility
! !

!WindowBuilder methodsFor:'error handling'!

aspectNotFound:anAspect error:aString
    "show error message on transcript (if Verbose is true)
     and/or stop (if StopOnError) is true"

    Verbose == true ifTrue:[
	Transcript showCR:('WindowBuilder: %1 aspect: <%2>' bindWith:aString with:anAspect storeString).
	application notNil ifTrue:[
	     Transcript showCR:('WindowBuilder: (while building for %1)' bindWith:application class name).
	].
    ].

    StopOnError == true ifTrue:[
	self halt:'aspect not found'        "/ set StopOnError to true to debug end-user apps
    ].
    ^ nil

    "Modified: / 18.8.2000 / 14:10:59 / cg"
! !

!WindowBuilder methodsFor:'message sending'!

safelyPerform:aSelector ifNone:aBlock
    "send the message aSelector to the application;
     the result returned from the send or nil is returned"

    |handlerBlock|

    aSelector notNil ifTrue:[
	handlerBlock := [:ex|
			    (ex selector ~~ aSelector) ifTrue:[
				ex reject
			    ]
			].

	application notNil ifTrue:[
	    MessageNotUnderstood handle:handlerBlock do:[
		^ application perform:aSelector
	    ].
	    MessageNotUnderstood handle:handlerBlock do:[
		^ application class perform:aSelector
	    ]
	].
	"
	 WARNING:
	    This is a private interface for the UIPainter to pass down the app-class
	"
	applicationClass notNil ifTrue:[
	    MessageNotUnderstood handle:handlerBlock do:[
		^ applicationClass perform:aSelector
	    ]
	]
    ].
    ^ aBlock value

    "Modified: / 20.6.1998 / 11:52:19 / cg"
!

safelyPerform:aSelector with:anArgument ifNone:aBlock
    "send the one-arg-message aSelector to the application;
     the result returned from the send or nil is returned"

    ^ self
	safelyPerform:aSelector
	withArguments:(Array with:anArgument)
	ifNone:aBlock
!

safelyPerform:aSelector with:arg1 with:arg2 ifNone:aBlock
    "send the two-arg-message aSelector to the application;
     the result returned from the send or nil is returned"

    ^ self
	safelyPerform:aSelector
	withArguments:(Array with:arg1 with:arg2)
	ifNone:aBlock
!

safelyPerform:aSelector with:arg1 with:arg2 with:arg3 ifNone:aBlock
    "send the 3-arg-message aSelector to the application;
     the result returned from the send or nil is returned"

    ^ self
	safelyPerform:aSelector
	withArguments:(Array with:arg1 with:arg2 with:arg3)
	ifNone:aBlock
!

safelyPerform:aSelector withArguments:arguments ifNone:aBlock
    "send the one-arg-message aSelector to the application;
     the result returned from the send or nil is returned"

    |handlerBlock|

    aSelector notNil ifTrue:[
	handlerBlock := [:ex| |badSel|
			    badSel := ex selector.
			    (badSel ~~ aSelector and:[badSel ~~ arguments first]) ifTrue:[
				ex reject
			    ]
			].

	application notNil ifTrue:[
	    MessageNotUnderstood handle:handlerBlock do:[
		^ application perform:aSelector withArguments:arguments
	    ].
	    MessageNotUnderstood handle:handlerBlock do:[
		^ application class perform:aSelector withArguments:arguments
	    ]
	].
	"
	 WARNING:
	    This is a private interface for the UIPainter to pass down the app-class
	"
	applicationClass notNil ifTrue:[
	    MessageNotUnderstood handle:handlerBlock do:[
		^ applicationClass perform:aSelector withArguments:arguments
	    ].
	]
    ].
    ^ aBlock value

    "Modified: / 4.8.1998 / 19:33:52 / cg"
! !

!WindowBuilder methodsFor:'queries'!

isEditing
    "true if building from a GUI builder resource ( UIPainter, ... ),
     false if building for the real thing.
     If true, no models or actions should be set (no application is running)"

    ^ false
! !

!WindowBuilder methodsFor:'resolving fonts'!

resolveFont:fontOrSymbolOrStyle
    "resolve fontOrSymbol to a real font"

    |font txtAttribs charAttribs|

    fontOrSymbolOrStyle isSymbol ifTrue:[
        self isEditing ifTrue:[
            "special for UIPainter setup: check class for font"
            applicationClass notNil ifTrue:[
                font := applicationClass fontFor:fontOrSymbolOrStyle.
            ].
        ] ifFalse:[
            font := application fontFor:fontOrSymbolOrStyle.
        ].
        font notNil ifTrue:[
            ^ font.
        ].

        "/ ST80 style textAttributes
        (TextAttributes notNil and:[TextAttributes isLoaded]) ifTrue:[
            txtAttribs := TextAttributes styleNamed:fontOrSymbolOrStyle ifAbsent:nil.
            txtAttribs notNil ifTrue:[
                charAttribs := txtAttribs characterAttributes.
                charAttribs notNil ifTrue:[
                    font := charAttribs defaultFont.
                ]
            ].
        ].

        font isNil ifTrue:[
            ('Missing font <1p> in <2p>' expandMacrosWith:fontOrSymbolOrStyle with:application class) errorPrintCR.
        ].
        ^ font.
    ].

    ^ Font
        family:(fontOrSymbolOrStyle family)
        face:(fontOrSymbolOrStyle face)
        style:(fontOrSymbolOrStyle style)
        size:(fontOrSymbolOrStyle size)
        encoding:(fontOrSymbolOrStyle encoding)
! !

!WindowBuilder methodsFor:'spec creation aspect fetch'!

actionFor:aKey
    "return an action for aKey. This is invoked during window building
     (by the builder) to ask for an ActionButtons actionBlock.
     Here, first the local bindings are searched, then the application and
     finally the applications class is asked for a corresponding action.
     The returned object is typically a block."

    |b|

    bindings notNil ifTrue:[
	b := bindings at:aKey ifAbsent:nil.
	b notNil ifTrue:[^ b].
    ].

    ^ self safelyPerform:#actionFor:
		    with:aKey
		  ifNone:[ self aspectNotFound:aKey error:'no action for:'. [] ]
!

actionFor:aKey withValue:aValue
    "return an action for aKey/value combonation.
     This is invoked during window building
     (by the builder) to ask for an ActionButtons actionBlock if that button
     specified an action with an argument value.
     Here, first the local bindings are searched, then the application and
     finally the applications class is asked for a corresponding action.
     The returned object is typically a block."

    |b|

    bindings notNil ifTrue:[
	b := bindings at:aKey ifAbsent:nil.
	b notNil ifTrue:[
	    (b isBlock and:[b numArgs == 1]) ifTrue:[
		^ [b value:aValue]
	    ].
	    ^ b
	].
    ].

    ^ self
	safelyPerform:#actionFor:withValue:
	withArguments:(Array with:aKey with:aValue)
	ifNone:[ self aspectNotFound:aKey error:'no action for:'.
		 []
	       ]
!

actionFor:aKey withValue:arg1 withValue:arg2
    "return an action for aKey/value combination.
     This is invoked during window building
     (by the builder) to ask for an ActionButtons actionBlock if that button
     specified an action with an argument value.
     Here, first the local bindings are searched, then the application and
     finally the applications class is asked for a corresponding action.
     The returned object is typically a block."

    |b|

    bindings notNil ifTrue:[
	b := bindings at:aKey ifAbsent:nil.
	b notNil ifTrue:[
	    (b isBlock and:[b numArgs == 2]) ifTrue:[
		^ [b value:arg1 value:arg2]
	    ].
	    ^ b
	].
    ].

    ^ self
	safelyPerform:#actionFor:withValue:withValue:
	withArguments:(Array with:aKey with:arg1 with:arg2)
	ifNone:[ self aspectNotFound:aKey error:'no action for:'.  ]
!

aspectFor:aKey
    "return a model for aKey. This is invoked during window building
     (by the builder) to ask for an Editfields, a Toggles etc. model.
     Here, first the local bindings are searched, then the application and
     finally the applications class is asked for a corresponding action.
     The returned object is typically a valueHolder."

    |b|

    bindings notNil ifTrue:[
	b := bindings at:aKey ifAbsent:nil.
	b notNil ifTrue:[^ b].
    ].

    ^ self
	safelyPerform:#aspectFor:
	with:aKey
	ifNone:[ self aspectAt:aKey ]
!

aspectFor:aKey ifAbsent:exceptionBlock
    "return a model for aKey. This is invoked during window building
     (by the builder) to ask for an Editfields, a Toggles etc. model.
     Here, first the local bindings are searched, then the application and
     finally the applications class is asked for a corresponding action.
     The returned object is typically a valueHolder."

    |b|

    bindings notNil ifTrue:[
	b := bindings at:aKey ifAbsent:nil.
	b notNil ifTrue:[^ b].
    ].

    ^ self
	safelyPerform:#aspectFor:
	with:aKey
	ifNone:[ self aspectAt:aKey ifAbsent:exceptionBlock ]
!

componentFor:aKey
    "return a component for aKey. This is invoked during window building
     (by the builder) to ask for an ArbitraryComponents view.
     Here, first the local bindings are searched, then the application and
     finally the applications class is asked for a corresponding action.
     The returned object is typically a view."

    ^ self safelyPerform:#componentFor:
		    with:aKey
		  ifNone:[ self aspectAt:aKey ]
!

labelFor:aKey
    "return a label for aKey. This is invoked during window building
     (by the builder) to ask for a ???'s label.
     Here, first the local bindings are searched, then the application and
     finally the applications class is asked for a corresponding action.
     The returned object is typically a string."

    ^ self
	safelyPerform:#labelFor:
	with:aKey
	ifNone:[ self aspectAt:aKey ]
!

listFor:aKey
    "return a list for aKey. This is invoked during window building
     (by the builder) to ask for a ???'s label.
     Here, first the local bindings are searched, then the application and
     finally the applications class is asked for a corresponding action.
     The returned object is typically a list."

    ^ self safelyPerform:#listFor:
		    with:aKey
		  ifNone:[ self aspectAt:aKey ]
!

menuFor:aKey
    "Find a binding for the menu named aKey, either in the bindings
     or from the source"

    |menu|

    aKey isNil ifTrue:[^ nil].

    (menu := self bindingAt:aKey) notNil ifTrue:[
	^ menu
    ].

    menu := self safelyPerform:#menuFor: with:aKey ifNone:[
		    self safelyPerform:aKey ifNone:[
			self aspectNotFound:aKey error:'no menu for:'.
			nil
		    ]
		 ].

    menu isBlock ifFalse:[
	((menu := menu value) notNil and:[application notNil]) ifTrue:[
	    menu isCollection ifTrue:[
		menu := Menu decodeFromLiteralArray:menu.
		"/ menu receiver:application. -- now done in findGuiResources ...
	    ].
	    menu findGuiResourcesIn:application
	]
    ].
    ^ menu

    "Modified: / 27-03-2007 / 11:17:22 / cg"
!

specificationFor:aKey
    "return a specification for aKey. This is invoked during window building
     (by the builder) to ask for the interfaceSpec for a subCanvas or subSpecification.
     Here, first the local bindings are searched, then the application and
     finally the applications class is asked for a corresponding interfaceSPec.
     The returned object is typically an interfaceSpec array."

    ^ self
	safelyPerform:#specificationFor:
	with:aKey
	ifNone:[ self aspectFor:aKey ]
!

visualFor:aKey
    "return a visual (icon, image) for aKey. This is invoked during window building
     (by the builder) to ask for some graphical labels.
     Here, first the local bindings are searched, then the application and
     finally the applications class is asked for a corresponding action.
     The returned object is typically an image or form."

    ^ self safelyPerform:#visualFor:
		    with:aKey
		  ifNone:[ self aspectAt:aKey ]
! !

!WindowBuilder methodsFor:'spec creation callbacks'!

createdComponent:aView forSpec:spec named:name
    "callback from the UISpec after a view has been
     created for a spec.
     If it has a name, add it to the namedComponents dictionary;
     if I have a creationHook (application callBack), evaluate it."

    |createCallBackSelector app|

    name notNil ifTrue:[
"/        "/ debugging ...
"/        (namedComponents notNil and:[namedComponents includesKey:name asSymbol]) ifTrue:[
"/            Transcript showCR:'WARNING multiple UI-build of: ',name asSymbol
"/        ].
	self componentAt:name put:aView.
    ].
    spec addView:aView toMappingOfBuilder:self.
    componentCreationHook notNil ifTrue:[
	componentCreationHook value:aView value:spec value:self
    ].

    self isEditing ifFalse:[
	(createCallBackSelector := spec postBuildCallback) notNil ifTrue:[
	    app := self application.
	    app
		perform:createCallBackSelector
		withOptionalArgument:aView
		and:spec
		and:self.
	].
    ].

    "Modified: / 5.9.1995 / 21:42:54 / claus"
    "Created: / 31.10.1997 / 18:47:01 / cg"
    "Modified: / 31.10.1997 / 18:51:22 / cg"
! !

!WindowBuilder methodsFor:'startup'!

closeRequest
    window destroy

    "Modified: 17.1.1997 / 19:30:32 / cg"
!

open
    "open my topView, as previously created"

    |type|

    application isNil ifTrue:[
	type := #normal
    ] ifFalse:[
	type := application defaultWindowType
    ].
    ^ self
	openAt:nil
	withExtent:nil
	andType:type

!

openAt:aPoint
    "open my topView at some location"

    ^ self
	openAt:aPoint
	withExtent:nil
	andType:(application defaultWindowType)

    "Created: 14.2.1997 / 20:21:57 / cg"
    "Modified: 28.2.1997 / 22:50:29 / cg"
!

openDialog
    "open my topView, as previously created as a modal view,
     blocking interaction to the currently active view."

    ^ self
	openAt:nil
	withExtent:nil
	andType:#dialog
!

openDialogAt:aPoint
    "open my topView, as previously created as a modal view,
     blocking interaction to the currently active view."

    ^ self
	openAt:aPoint
	withExtent:nil
	andType:#dialog

    "Modified: 17.1.1997 / 19:59:36 / cg"
    "Created: 14.2.1997 / 20:24:19 / cg"
!

openDialogAt:aPoint withExtent:ext
    "open my topView, as previously created as a modal view,
     blocking interaction to the currently active view."

    ^ self
	openAt:aPoint
	withExtent:ext
	andType:#dialog

    "Modified: 17.1.1997 / 19:59:36 / cg"
    "Created: 14.2.1997 / 20:24:19 / cg"
!

openDialogWithExtent:ext
    "open my topView, as previously created as a modal view,
     blocking interaction to the currently active view."

    ^ self
	openAt:nil
	withExtent:ext
	andType:#dialog

    "Modified: 17.1.1997 / 19:59:36 / cg"
!

openModal
    "open my topView as a modal dialog, as previously created,
     blocking interaction to the currently active view."

    ^ self
	openAt:nil
	withExtent:nil
	andType:#dialog

    "Modified: 3.3.1997 / 19:43:57 / cg"
!

openPopUpAt:aPoint
    "open my topView, as previously created as a popUp view,
     blocking interaction to the currently active view."

    ^ self
	openAt:aPoint
	withExtent:nil
	andType:#popUp

    "Modified: 17.1.1997 / 19:59:29 / cg"
    "Created: 14.2.1997 / 20:24:38 / cg"
!

openPopUpIn:aRectangle
    "open my topView, as previously created as a popUp view,
     blocking interaction to the currently active view."

    ^ self
	openAt:aRectangle origin
	withExtent:aRectangle extent
	andType:#popUp
!

openWindow
    "open my topView"

    ^ self
	openAt:nil
	withExtent:nil
	andType:(application defaultWindowType)

!

openWindowAt:aPoint
    "open my topView at some location"

    ^ self
	openAt:aPoint
	withExtent:nil
	andType:(application defaultWindowType)

!

openWindowAt:origin withExtent:ext andType:type
    "open my window, as previously created, optionally defining the
     windows origin and/or extent.
     The type argument may be #dialog or #normal, and specifies if the view
     should be opened as a modal view, blocking interaction to the currently
     active view, or as a normal view."

    ^ self
	openAt:origin
	withExtent:ext
	andType:type
!

openWindowCenter
    "open my topView centered on the screen (dialog & normal only)"

    ^ self
	openAt:#center
	withExtent:nil
	andType:(application defaultWindowType)

!

openWithExtent:aPoint
    "open my topView, as previously created, but override
     the extent."

    ^ self
	openAt:nil
	withExtent:aPoint
	andType:(application defaultWindowType)

    "Modified: 17.1.1997 / 19:58:48 / cg"
!

openWithExtent:ext andType:type
    "open my window, as previously created. The type argument
     may be #dialog or #normal, and specifies if the view should
     be opened as a modal view, blocking interaction to the currently
     active view, or as a normal view."

    ^ self
	openAt:nil
	withExtent:ext
	andType:type

    "Modified: 14.2.1997 / 20:22:47 / cg"
! !

!WindowBuilder methodsFor:'startup-basic'!

openAt:origin withExtent:ext andType:type
    "open my window, as previously created, optionally defining the
     windows origin and/or extent.
     The type argument may be #dialog, #popup or #normal,
     and specifies if the view should be opened as a
        modal view (blocking interaction to the currently active view),
        as popUp (also blocking)
        or as a normal view."

    |appWinClass windowsDevice wg mainWin x y monitorBounds newOrigin|

    windowsDevice := window device.

    "/ ********* MULTI SCREEN

    wg := WindowGroup activeGroup.
    wg notNil ifTrue:[
        |mainGroup focusView|

        mainGroup := wg mainGroup ? wg.
        focusView := mainGroup focusView.
        focusView notNil ifTrue:[
            mainWin := focusView topView
        ] ifFalse:[
            mainGroup notNil ifTrue:[
                mainWin := (mainGroup topViews ? #())  firstIfEmpty:nil
            ].
        ].
    ].

    origin isPoint ifTrue:[
        monitorBounds := windowsDevice monitorBoundsAt:origin.
        window origin:origin.
    ] ifFalse:[
        mainWin isNil ifTrue:[
            monitorBounds := windowsDevice monitorBoundsAt:(windowsDevice pointerPosition).
        ] ifFalse:[
            monitorBounds := windowsDevice monitorBoundsAt:(mainWin origin).
        ].
    ].

    ext notNil ifTrue:[
        window extent:ext.
    ] ifFalse:[
        ((type == #dialog) or:[type == #toolDialog]) ifTrue:[
            window fixSize
        ]
    ].

    ((type == #dialog) or:[type == #toolDialog or:[ type == #popUp or:[type == #popUpWithFrame]] ]) ifTrue:[
        ((origin isNil and:[window class forceModalBoxesToOpenAtCenter])
         or:[origin == #center]) ifTrue:[
            newOrigin := nil.
        ] ifFalse:[
            origin isPoint ifTrue:[
                newOrigin := origin
            ] ifFalse:[
                mainWin notNil ifTrue:[
                    "/ newOrigin := device pointerPosition
                    newOrigin := mainWin bounds center rounded - (window extent // 2).
                ]
            ]
        ].
        newOrigin isNil ifTrue:[
            newOrigin := monitorBounds center rounded - (window extent // 2).
        ].

        UserPreferences current forceWindowsIntoMonitorBounds ifTrue:[
            |usableHeight|

            (newOrigin x + window width) > monitorBounds right ifTrue:[
                x := monitorBounds right - window width - 20.
                newOrigin := x @ newOrigin y.
            ].
            (newOrigin y + window height) > monitorBounds bottom ifTrue:[
                y := monitorBounds bottom - window height - 20.
                newOrigin := newOrigin x @ y.
            ].
            usableHeight := windowsDevice usableHeightAt:newOrigin+window extent.
            (newOrigin y + window height) > usableHeight ifTrue:[
                y := usableHeight - window height - 20.
                newOrigin := newOrigin x @ y.
            ].
        ].
        window origin:newOrigin.
        type == #toolDialog ifTrue:[
            window beToolDialog
        ] ifFalse:[
            type == #popUp ifTrue:[
                window bePopUpView.
            ] ifFalse:[
                type == #popUpWithFrame ifTrue:[
                    "/ window windowType:type.
                    window beUndecorated.
                ]
            ].
        ].
        ^ window openModal.
    ].

    (type == #normal 
    or:[type = #slave or:[type = #partner 
    or:[type = #popUpNotModal 
    or:[type = #undecorated
    or:[type = #undecoratedResizable]]]]]) ifTrue:[
        window isNil ifTrue:[
            application notNil ifTrue:[
                appWinClass := application applicationWindowClass
            ] ifFalse:[
                appWinClass := ApplicationWindow
            ].
            self setupWindowFor:appWinClass new.
        ].
        origin isPoint ifFalse:[
            |windowExtent newOrg|

            windowExtent := window extent.

            mainWin notNil ifTrue:[
                (windowExtent x > mainWin extent x or:[windowExtent y > mainWin extent y]) ifFalse:[
                    newOrg := mainWin bounds center - (windowExtent // 2).
                ].
            ].
            newOrg isNil ifTrue:[
                newOrg := monitorBounds center - (windowExtent // 2).
            ].
            window origin:newOrg rounded.
        ].
        y := window origin y.
        x := window origin x.

        window corner y > monitorBounds bottom ifTrue:[
            y := (monitorBounds bottom - window height) max:(monitorBounds top).

        ].
        window corner x > monitorBounds right ifTrue:[
            x := (monitorBounds right - window width) max:(monitorBounds left).
        ].
        window origin:(x @ y ).


        "/ the following code creates a master-slave relationship, if
        "/ the masterApplication is not nil.
        "/ Disabled, because: the masterApplication is used to fulfill missing aspects,
        "/ which has nothing to do with a window master-slave relationship.

"/        application masterApplication notNil ifTrue:[
"/            masterWindow := application masterApplication window.
"/            (masterWindow isMaster or:[masterWindow isSlave or:[masterWindow isPartner]])
"/            ifFalse:[
"/                "/ master is neutral - make him a master
"/                masterWindow beMaster
"/            ].
"/            window beSlave.
"/        ].

        "/ must be done explicit, by passing an appropriate windowType

        type = #slave ifTrue:[
            window beSlave.
        ] ifFalse:[
            type = #partner ifTrue:[
                window bePartner.
            ] ifFalse:[
                type == #popUpNotModal ifTrue:[
                    window bePopUpView.
                ] ifFalse:[
                    type == #undecorated ifTrue:[
                        window beUndecorated.
                    ] ifFalse:[
                        type == #undecoratedResizable ifTrue:[
                            window beUndecoratedResizable.
                        ]
                    ].
                ]
            ].
        ].

        ((type = #slave or:[type = #partner])
        and:[ window windowGroup isNil ])
        ifTrue:[
            window openInGroup:(WindowGroup activeGroup).
        ] ifFalse:[
            window open.
        ].

"/ the following automatism is probably too cryptic and has too much of a side effect.
"/ I prefer to leave things as they are: i.e. enforce the programmer to
"/ do things explicit.

"/        type = #slave ifTrue:[
"/            window windowGroup topViews first beMaster
"/        ].
        ^ self
    ].

"/    type == #popUp ifTrue:[
"/        window fixPosition:(device pointerPosition).
"/        ^ window openAsPopUp.
"/    ].

    "
     if ST-80 supports more types - these may be added later
    "
    self shouldImplement

    "Created: / 14-02-1997 / 20:22:24 / cg"
    "Modified: / 22-03-2011 / 13:31:52 / cg"
! !

!WindowBuilder methodsFor:'translating'!

translateString:aString
    "translate aString to the current language.
     If there is an application, it knows best what to do"

    application isNil ifTrue:[
	^ self resources string:aString
    ].
    ^ application translateString:aString
! !

!WindowBuilder class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

