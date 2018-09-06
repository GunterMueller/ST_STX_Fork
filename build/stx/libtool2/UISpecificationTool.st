"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1995 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool2' }"

"{ NameSpace: Smalltalk }"

ApplicationModel subclass:#UISpecificationTool
	instanceVariableNames:'modifiedHolder aspects specification selection specChannel
		buildInView listOfSpecViews'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-UIPainter'
!

ViewScroller subclass:#BuildInView
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:UISpecificationTool
!

!UISpecificationTool class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by eXept Software AG
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
    used by the UIPainter to manipulate the specifications of the selected component

    [author:]
        Claus Atzkern

    [see also:]
        UIPainter
        UILayoutTool
        UIHelpTool
"
! !

!UISpecificationTool class methodsFor:'help specs'!

helpSpec
    "This resource specification was automatically generated
     by the UIHelpTool of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIHelpTool may not be able to read the specification."

    "
     UIHelpTool openOnClass:UISpecificationTool    
    "

    <resource: #help>

    ^ super helpSpec addPairsFrom:#(

#addTabAction
''

#allowNilColor
'Add an option to allow a nil-Color to be choosen'

#allowSymbolicColors
'ColorMenu is allowed to return a symbolic color name'

#allowSymbolicFonts
'FontMenu is allowed to return a symbolic font name'

#browseAction
'Browse/Create the Action method'

#browseAspectMethod
'Browse/Create the Aspect method'

#editListSpec
'Edit the contents of the list (inline)'

#labelsAreColored
'Draw the labels in their color (otherwise, draw the background)'

#showFrame
'Show the frame'

#showUseDefaultToggle
'Add a toggle to choose the "default" color (resulting color will be nil)'

)
! !

!UISpecificationTool class methodsFor:'image specs'!

browseActionImage
    ^ UIPainter browseActionImage
!

editTableIcon
    ^ UIPainter editTableIcon
! !

!UISpecificationTool class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:UISpecificationTool andSelector:#windowSpec
     UISpecificationTool new openInterface:#windowSpec
     UISpecificationTool open
    "

    <resource: #canvas>

    ^ 
    #(FullSpec
       name: windowSpec
       window: 
      (WindowSpec
         label: 'unnamed canvas'
         name: 'unnamed canvas'
         bounds: (Rectangle 0 0 300 300)
       )
       component: 
      (SpecCollection
         collection: (
          (ArbitraryComponentSpec
             name: 'BuildInView'
             layout: (LayoutFrame 0 0.0 0 0.0 0 1.0 0 1.0)
             hasVerticalScrollBar: false
             miniScrollerVertical: false
             autoHideScrollBars: true
             hasBorder: false
             component: buildInView
           )
          )
        
       )
     )
! !

!UISpecificationTool class methodsFor:'resources'!

classResources
    "my translations are found in the UIPainter classes resources"

    ^ UIPainter classResources 
! !

!UISpecificationTool methodsFor:'accessing-channels'!

modifiedHolder:aValueHolder
    "set the value holder set to true in case of modifying attributes
    "

    modifiedHolder removeDependent:self.

    (modifiedHolder := aValueHolder) notNil ifTrue:[
        modifiedHolder addDependent:self.
    ].

! !

!UISpecificationTool methodsFor:'accessing-specification'!

listOfAspects
    ^ masterApplication listOfAspects

    "Created: / 12-01-2008 / 19:24:39 / cg"
!

listOfCallbacks
    ^ masterApplication listOfCallbacks

    "Created: / 12-01-2008 / 19:25:05 / cg"
!

specification
    "gets current edit specification
    "
    ^ specification


!

specification:aSpec
    "sets current edit specification
    "
    aSpec notNil ifTrue:[
        "/ same type of spec - simply change the spec;  no need to setup everything
        specification class == aSpec class ifTrue:[
            specification := aSpec.
            specChannel value:specification.
          ^ self
        ]
    ].

    "/ release resources
    specChannel release.
    aspects     release.
    selection := listOfSpecViews := nil.
    buildInView destroyAllClientViews.

    (specification := aSpec) isNil ifTrue:[
        aspects := specChannel := nil.
      ^ self
    ].
    
    "/ some tricky specs need the builder during the addBindings phase.
    "/ This is passed down in a special UIBindingsDictionary
    "/ (remain backward compatible)

    aspects := UISpecification newBindingsDictionary.
    aspects builder:builder.
    aspects at:#modifiedChannel put:modifiedHolder.
    aspects at:#acceptChannel   put:self acceptChannel.

    aspects at:#listOfAspects put:[self listOfAspects].
    aspects at:#listOfCallbacks put:[self listOfCallbacks].

    specChannel := specification asValue.
    specification class addBindingsTo:aspects for:specification channel:specChannel.

    "/ arrange for being notified, if any aspect changes
    aspects do:[:el| el addDependent:self ].

    "Modified: / 12-01-2008 / 19:28:47 / cg"
! !

!UISpecificationTool methodsFor:'actions'!

setMaxExtent
    "set the windows maxExtent from its current extent"

    |canvas currentExtent|

    canvas := self masterApplication canvas.
    currentExtent := canvas extent.
    (self aspectFor:#maxX) value:currentExtent x.
    (self aspectFor:#maxY) value:currentExtent y.

    "Modified: / 29.10.1997 / 18:29:17 / cg"
!

setMinExtent
    "set the windows minExtent from its current extent"

    |canvas currentExtent|

    canvas := self masterApplication canvas.
    currentExtent := canvas extent.
    (self aspectFor:#minX) value:currentExtent x.
    (self aspectFor:#minY) value:currentExtent y.

    "Created: / 29.10.1997 / 18:17:55 / cg"
    "Modified: / 29.10.1997 / 18:28:53 / cg"
! !

!UISpecificationTool methodsFor:'bindings'!

acceptChannel
    ^ masterApplication acceptChannel

    "Modified: / 12-01-2008 / 11:28:38 / cg"
!

aspectFor:aKey
    "returns the aspect for a key or nil"

    aspects notNil ifTrue:[
        ^ aspects at:aKey ifAbsent:nil
    ].
    ^ super aspectFor:aKey

    "Modified: / 12-01-2008 / 11:28:52 / cg"
!

buildInView
    ^ buildInView
!

specificationFor:aKey
    "this is called if our current specification contains 
     subspecifications or subcanvases.
     Get the subspecification from the current specification"

    specification notNil ifTrue:[
        ^ specification class perform:aKey ifNotUnderstood:nil
    ].
    ^ nil
! !

!UISpecificationTool methodsFor:'change & update'!

update
    "reload specification
    "
    specChannel notNil ifTrue:[
        specChannel value:specification.
    ]


!

update:something with:someArgument from:someone
    "any attribute changed its state in the current specification
    "
    someone ~~ modifiedHolder ifTrue:[
        "/ any in the spec has changed.
        "/ update my modified holders value

        modifiedHolder value:true
    ]

    "Modified: / 16.7.1998 / 19:25:59 / cg"
! !

!UISpecificationTool methodsFor:'help'!

basicFlyByHelpTextForKey:aKey
    "activeHelp interface: return some help text for a key.
     Redefined to ask the current components Spec first."

    |helpText|

    "/ first, ask the master (a hook for expecco, to provide different help texts)
    masterApplication notNil ifTrue:[
        helpText := masterApplication basicFlyByHelpTextForKey:aKey.
        helpText notNil ifTrue:[^ helpText ].

        "/ then, ask the master about the spec
        helpText := masterApplication basicHelpTextFromSpecification:specification forKey:aKey.
    ] ifFalse:[
        "/ then, ask the spec
        helpText := (specification helpSpec) at:aKey ifAbsent:nil.
    ].
    helpText notNil ifTrue:[^ helpText ].

    "/ finally, ask myself...
    ^ super basicFlyByHelpTextForKey:aKey.
!

basicHelpTextForKey:aKey
    "activeHelp interface: return some help text for a key.
     Redefined to ask the current components Spec first."

    |helpText|

    "/ first, ask the master (a hook for expecco, to provide different help texts)
    masterApplication notNil ifTrue:[
        helpText := masterApplication basicHelpTextForKey:aKey.
        helpText notNil ifTrue:[^ helpText ].

        "/ then, ask the master about the spec
        helpText := masterApplication basicHelpTextFromSpecification:specification forKey:aKey.
    ] ifFalse:[
        "/ then, ask the spec
        helpText := (specification helpSpec) at:aKey ifAbsent:nil.
    ].
    helpText notNil ifTrue:[^ helpText ].

    "/ finally, ask myself...
    ^ super basicHelpTextForKey:aKey.
! !

!UISpecificationTool methodsFor:'initialization'!

initialize
    super initialize.
    buildInView := BuildInView new.
    buildInView keepViews:true.
! !

!UISpecificationTool methodsFor:'selection'!

selection:something
    "selection changed"

    |slices index spec window|

    specification notNil ifTrue:[
        slices := specification class slices.
        index  := slices findFirst:[:aSlice| aSlice first = something ].

        index ~~ 0 ifTrue:[
            spec := specification class perform:((slices at:index) last)
        ]
    ].

    spec ~= selection ifTrue:[
        (selection := spec) notNil ifTrue:[
            listOfSpecViews isNil ifTrue:[
                listOfSpecViews := Array new:(slices size).
            ] ifFalse:[
                window := listOfSpecViews at:index
            ].
            window isNil ifTrue:[
                builder buildFromSpec:spec in:(window := SimpleView new).
                listOfSpecViews at:index put:window.
            ].
        ].
        buildInView scrolledView:window.
    ].
! !

!UISpecificationTool::BuildInView methodsFor:'accessing'!

mapped
    super mapped.

    scrolledView notNil ifTrue:[
        scrolledView beVisible.
        scrolledView raise.
    ].
!

scrolledView:aView
    "set the view to be scrolled"
    |wrapper y|

    scrolledView == aView ifTrue:[^ self].

    scrolledView notNil ifTrue:[
        scrolledView unmap.
    ].
    (scrolledView := aView) notNil ifTrue:[
        scrolledView superView ~~ frame ifTrue:[
            frame addSubView:scrolledView.
        ].
        true ifTrue:[
            scrolledView borderWidth:0; level:0.
            scrolledView subViews size == 1 ifTrue:[
                wrapper := scrolledView subViews first.
                wrapper isScrollWrapper ifTrue:[
                    "/ give it a full-relative size, and let it do
                    "/ the scrolling itself.
                    y := 1.0
                ]
            ].
            y isNil ifTrue:[
                y := scrolledView preferredHeight
            ].
            scrolledView allViewBackground:(self viewBackground).
            scrolledView origin:0@0 corner:1.0 @ y.
        ].
    ].    
    shown ifTrue:[
        scrolledView beVisible.
        scrolledView raise.
        self sizeChanged:nil.
    ].
    model value:scrolledView.
! !

!UISpecificationTool::BuildInView methodsFor:'initialization'!

initialize
    super initialize.
    resizeScrolledViewHorizontal := true.
    resizeScrolledViewVertical   := true.
!

realize

    super realize.
   superView notNil ifTrue:[superView level:0].
! !

!UISpecificationTool class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

