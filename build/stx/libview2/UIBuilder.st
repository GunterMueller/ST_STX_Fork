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

WindowBuilder subclass:#UIBuilder
	instanceVariableNames:'view currentMenuSelector spec specStack composite lastComponent
		compositeView menuBar isEditing showDefaults isSubBuilder'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Framework'
!

!UIBuilder class methodsFor:'documentation'!

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
    this class allows parsing windowSpecs as created by ST/X's
    UIPainter and should be able to handle most of ST-80's specs.
    (and thereby allow to run applications built with this tool).
    However, it is not guaranteed that all of ST-80's winSpecs are understood.

    It also provides some rudimentary support for building interfaces
    programatically, by using #newComposite .. #add: .. #endComposite.
    This has been added for ST80-compatibility - we do not recommend using
    that for new ST/X programs.
    Those were added to allow execution of some PD applications.
    The programatic building protocol is not complete and certainly not bug free.

    Notice: 
        some of this class was implemented using protocol information
        from alpha testers, literature and by reading public domain code
        - it may not be complete or compatible to
        the corresponding ST-80 class. 
        If you encounter any incompatibilities, please forward a note 
        describing the incompatibility verbal (i.e. no code) to the ST/X team.

    [instance variables:]
        view                    <View>  
                                        temporary - holds the view being built
                                        when creating components using the 
                                        programmatic building interface.

        currentMenuSelector             not yet used

        spec                    <UISpec>        
                                        temporary - holds the spec being parsed
                                        when creating components using the 
                                        programmatic building interface.

        specStack               <Collection>
                                        temporary - holds the spec-stack when
                                        creating composites using newComposite/
                                        endComposite,
                                        while creating components using the 
                                        programmatic building interface.

        composite               <SpecCollection>
                                        temporary - holds the current composite
                                        when using newComposite/ endComposite,
                                        while creating components using the 
                                        programmatic building interface.

        lastComponent           <View>
                                        temporary - holds the last component
                                        being built,
                                        when creating components using the 
                                        programmatic building interface.

        compositeView           <View>
                                        temporary - holds the current composites
                                        view, when creating components using the 
                                        programmatic building interface.

        menuBar                         not yet used

        isEditing               <Boolean>
                                        flag which is set when an interface is built
                                        by the UIPainter (as opposed to being built
                                        for the application).
                                        Changes the way aspects are acquired,
                                        (actually, no models are created/set)
                                        to prevent false building when no
                                        real applicationModel is present.
                                        (as is the case when the painter builds
                                        components).

    [author:]
        Claus Gittinger
"
! !

!UIBuilder class methodsFor:'initialization'!

initialize
    Verbose := false    "/ debugging flag
! !

!UIBuilder methodsFor:'Compatibility-VW'!

wrapper
    "ST/X has no wrappers - return the view here"

    ^ view ? window

    "Created: / 3.3.1997 / 18:28:31 / cg"
    "Modified: / 31.10.1997 / 18:42:52 / cg"
! !

!UIBuilder methodsFor:'accessing'!

isEditing
    "true if building from a GUI builder resource ( UIPainter, ... ),
     false if building for the real thing.
     If true, no models or actions should be set (no application is running)"

    ^ isEditing ? false
!

isEditing:aState
    "true if build from a GUI builder resource ( UIPainter, ... ); if true, no
     models or actions should be set (no application is running)
    "
    isEditing := aState
!

isSubBuilder
    "return true, if this uiBuilder is for a subCanvas (i.e. a subApp)
     as opposed to a topApp builder"

    ^ isSubBuilder ? false

    "Created: / 29.1.2000 / 16:31:31 / cg"
    "Modified: / 31.1.2000 / 15:03:09 / cg"
!

isSubBuilder:aBoolean
    "set/clear the flag, which states that this uiBuilder is for a subCanvas (i.e. a subApp)
     as opposed to a topApp builder. The default is false."

    isSubBuilder := aBoolean

    "Created: / 29.1.2000 / 16:31:19 / cg"
    "Modified: / 31.1.2000 / 15:03:37 / cg"
!

menuBar
    "return the value of the instance variable 'menuBar' (automatically generated)"

    ^ menuBar

    "Created: / 27.10.1997 / 16:30:12 / cg"
!

menuBar:something
    "set the value of the instance variable 'menuBar' (automatically generated)"

    menuBar := something.
    self keyboardProcessor menuBar:menuBar.

    "Created: / 27.10.1997 / 16:30:13 / cg"
!

showDefaults
    "returns true if the builder is in editing mode and the building
     components will build a default contents
    "
    self isEditing ifTrue:[
        ^ showDefaults ? false
    ].
    ^ false

!

showDefaults:aBool
    "true if the builder is in editing mode and the building
     components will build a default contents
    "
    showDefaults := aBool
!

spec
    "return the current spec"

    ^ spec
!

spec:aSpec
    "set the current spec"

    spec := aSpec
!

view

    ^view
!

view: something

    view := something
!

view:viewArg spec:specArg 
    "set instance variables (automatically generated)"

    view := viewArg.
    spec := specArg.
! !

!UIBuilder methodsFor:'building'!

buildFromSpec:aSpecOrSpecArray
    ^ self buildWindowFromSpec:aSpecOrSpecArray
!

buildFromSpec:aSpecArray in:aView
    "build a window hierarchy according to my spec into an existing view"

    spec := UISpecification from:aSpecArray.
    ^ spec buildViewFor:self in:aView.

    "Modified: 3.3.1997 / 18:44:02 / cg"
!

buildViewForSpec:aSpecOrSpecArray in:aView
    "used when building a subSpec; moved from the UISPec class to here,
     to allow different behavior in WebBuilder..."

    |spec windowSpec|

    spec := UISpecification from:aSpecOrSpecArray.
    spec class == FullSpec ifTrue:[
        spec component buildViewFor:self in:aView.
        (windowSpec := spec window) notNil ifTrue:[
            aView preferredExtent:(windowSpec bounds extent).
            "/ notice: this assumes, that the embedded spec's attributes are
            "/ used (for example: bg-color).
            "/ it would be a good idea to add some overwrite mechanism in
            "/ the UISubspecification.
            windowSpec setAttributesIn:aView with:self.
        ].
    ] ifFalse:[
        spec buildViewFor:self in:aView.
    ].
!

buildWindowFromSpec:aSpecOrSpecArray
    spec := UISpecification from:aSpecOrSpecArray.
    window notNil ifTrue:[
        spec buildViewFor:self in:window.
    ] ifFalse:[
        window := spec buildViewFor:self in:nil.
    ].
    windowTitle notNil ifTrue:[
        window isTopView ifTrue:[
            window label:windowTitle.
        ].
    ].
    ^ window
!

doFinalHookup

    "Created: 14.2.1997 / 14:52:27 / cg"
!

newSubBuilder
    |builder|

    builder := UIBuilder new.

    builder isEditing:isEditing.
    builder showDefaults:showDefaults.
    builder bindings:(self bindings).
    builder application:(self application).
    "/ builder applicationClass:applicationClass.
  ^ builder
!

rebuildFromSpec:aSpecOrSpecArray
    "remove what I have and rebuild from a possibily different spec"

    |windowBefore|

    windowBefore := self window.
    windowBefore notNil ifTrue:[
        windowBefore destroySubViews
    ].
"/    self buildViewForSpec:aSpecOrSpecArray in:windowBefore.
    self buildFromSpec:aSpecOrSpecArray in:windowBefore.
    windowBefore notNil ifTrue:[
        windowBefore realizeAllSubViews
    ]
! !

!UIBuilder methodsFor:'building-programatically'!

add:aSpec
    |collectedComponents appWinClass|

    composite notNil ifTrue:[
        (collectedComponents := composite collection) isNil ifTrue:[
            composite collection:(collectedComponents := OrderedCollection new).
        ].
        collectedComponents add:aSpec.
        view := aSpec buildViewWithLayoutFor:self in:compositeView.
    ] ifFalse:[
        spec isNil ifTrue:[
            spec := FullSpec new.
        ].

        (aSpec isMemberOf:WindowSpec) ifTrue:[
            spec window:aSpec
        ] ifFalse:[
            ((aSpec isMemberOf:ComponentSpec)
            or:[(aSpec isMemberOf:SpecCollection)]) ifTrue:[
                spec component:aSpec.

                window isNil ifTrue:[
                    application notNil ifTrue:[
                        appWinClass := application applicationWindowClass
                    ] ifFalse:[
                        appWinClass := ApplicationWindow
                    ].
                    window := appWinClass new.
                    window extent:300@300.
                ].
                aSpec buildViewWithLayoutFor:self in:window.
"/ builder window displayBox
                composite := aSpec.
                compositeView := window.
            ] ifFalse:[
                spec component isNil ifTrue:[
                    spec component:SpecCollection new.
                    spec component collection:OrderedCollection new.
                ].
                composite := spec component.
                window isNil ifTrue:[
                    window := ApplicationWindow new.
                    window extent:300@300.
                ].
                compositeView := window.
                spec component collection add:aSpec.
                view := aSpec buildViewWithLayoutFor:self in:compositeView.
            ].
        ]
    ].

    lastComponent := view.
    ^ view

    "Modified: / 18.6.1998 / 19:09:38 / cg"
!

endComposite
    |entry finishedComposite finishedView|

    (specStack notEmptyOrNil) ifTrue:[
        finishedComposite := composite.
        finishedView := compositeView.  

        "/ pop
        entry := specStack removeLast.
        composite := entry key.
        compositeView := entry value.

        lastComponent := finishedView.
        ^ finishedComposite
    ].
    self breakPoint:#cg.
    ^ composite

    "Created: / 3.3.1997 / 17:17:43 / cg"
    "Modified: / 30.10.1997 / 23:28:04 / cg"
!

endCompositeLayout:layout
    composite compositeSpec isNil ifTrue:[
        composite compositeSpec:(CompositeSpec new).
    ].
    composite compositeSpec layout:layout.
    compositeView layout:layout.
    self endComposite

    "Modified: / 30.10.1997 / 23:10:10 / cg"
!

endCompositeLayout:layout properties:props
    self endCompositeLayout:layout

    "Created: 3.3.1997 / 22:15:17 / cg"
!

newComposite
    |newComposite|

    "/ push the composite being built ...
    specStack isNil ifTrue:[
        specStack := OrderedCollection new
    ].
    specStack addLast:(composite->compositeView).

    "/ start creating a new one ...
    newComposite := CompositeSpecCollection new.
    newComposite compositeSpec:(CompositeSpec new).
    compositeView := self add:newComposite.
    composite := newComposite.
    ^ compositeView

    "Created: / 3.3.1997 / 17:15:36 / cg"
    "Modified: / 1.11.1997 / 02:48:44 / cg"
! !

!UIBuilder methodsFor:'initialization'!

setupWindowFor:aView
    |ext|

    window notNil ifTrue:[
        ext := window extent.

        ((window isMemberOf:View) or:[window isMemberOf:SimpleView]) ifTrue:[
            aView addSubView:window.
        ].
    ].

    window := aView.

    (aView container isNil and:[spec notNil]) ifTrue:[
        spec window setupView:window for:self
    ].

    "Modified: / 27.1.1998 / 12:27:45 / cg"
! !

!UIBuilder class methodsFor:'documentation'!

version
    ^ '$Header$'
! !


UIBuilder initialize!
