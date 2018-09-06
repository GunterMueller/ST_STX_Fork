"{ Package: 'stx:libtool2' }"

Object subclass:#SnapShotImage
	instanceVariableNames:'memory globals cachedBehaviors'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support'
!

!SnapShotImage class methodsFor:'documentation'!

documentation
"
    I simulate a Smalltalk environment as present in a snapshot image.
    My protocol mimics the NameSpace (i.e. class-environment) protocol,
    and I can be used as a Browsers environment, in order to open a
    browser into an old snapShot image (st.img - file).

    I am not used directly; instead, via the SystemBrowsers entry:
        SystemBrowser openOnSnapShotImage:'/export/home/cg/work/stx/projects/smalltalk/st.img'

        SystemBrowser openOnSnapShotImage:'st.img'

    This enables a standard browser to peek into a snapshot image... (well, almost)

    [author:]
        Claus Gittinger
"
!

examples
"
    |i m|

    i := self for:'st.img'.
    m := i memory.
    m  fetchObjectAt:16r38000000
"
! !

!SnapShotImage class methodsFor:'instance creation'!

for:aFilename
    ^ self new for:aFilename
! !

!SnapShotImage methodsFor:'accessing'!

memory
    ^ memory
! !

!SnapShotImage methodsFor:'private'!

fetchGlobals
    globals := IdentityDictionary new.
    memory globalEntries do:[:eachEntry |
        |nameSymRef valRef nameSym value|

        nameSymRef := eachEntry key.
        valRef := eachEntry value.
        nameSymRef isImageSymbol ifFalse:[self halt].

        nameSym := (memory printStringOfSymbol:nameSymRef) asSymbol.
        globals at:nameSym put:valRef
    ].
!

for:aFilename
    memory := SnapShotImageMemory for:aFilename.
    memory image:self.
    memory readHeader
! !

!SnapShotImage methodsFor:'smalltalk protocol'!

allClassesDo:aBlock
    cachedBehaviors isNil ifTrue:[
        cachedBehaviors := OrderedCollection new.

        self keysAndValuesDo:[:key :valRef |
            valRef isInteger ifFalse:[
                valRef ~~ true ifTrue:[
                    valRef ~~ false ifTrue:[
                        valRef notNil ifTrue:[
                            valRef isImageBehavior ifTrue:[
                                cachedBehaviors add:valRef
                            ]
                        ]
                    ]
                ]
            ]
        ].
    ].
    cachedBehaviors do:aBlock
!

allClassesInCategory:aCategory
    |coll|

    coll := OrderedCollection new.
    self allClassesInCategory:aCategory do:[:aClass |
        coll add:aClass
    ].
    ^ coll
!

allClassesInCategory:aCategory do:aBlock
    "evaluate the argument, aBlock for all classes in the aCategory;
     The order of the classes is not defined."

    aCategory notNil ifTrue:[
        self allClassesDo:[:aClass |
            aClass isMeta ifFalse:[
                (aClass category = aCategory) ifTrue:[
                    aBlock value:aClass
                ]
            ]
        ]
    ]
!

at:aKey
    globals isNil ifTrue:[
        self fetchGlobals
    ].
    ^ globals at:aKey ifAbsent:nil
!

at:aKey ifAbsent:exceptionValue
    globals isNil ifTrue:[
        self fetchGlobals
    ].
    ^ globals at:aKey ifAbsent:exceptionValue
!

classNamed:aString
    "return the class with name aString, or nil if absent.
     To get to the metaClass, append ' class' to the string."

    |cls sym meta|

    "be careful, to not invent new symbols ..."
    sym := aString asSymbol.
    cls := self at:sym ifAbsent:[].
    cls isBehavior ifTrue:[^ cls].

    (aString endsWith:' class') ifTrue:[

        meta := self classNamed:(aString copyWithoutLast:6).
        meta notNil ifTrue:[
            ^ meta class
        ].
    ].
    ^ nil
!

hasNameSpaces
    ^ true

    "Created: / 19-10-2006 / 01:06:31 / cg"
!

hasNamespaces
    ^ true
!

keysAndValuesDo:aTwoArgBlock
    globals isNil ifTrue:[
        self fetchGlobals
    ].
    globals keysAndValuesDo:aTwoArgBlock
!

keysDo:aTwoArgBlock
    globals isNil ifTrue:[
        self fetchGlobals
    ].
    globals keysDo:aTwoArgBlock
! !

!SnapShotImage class methodsFor:'documentation'!

version
    ^ '$Header$'
! !
