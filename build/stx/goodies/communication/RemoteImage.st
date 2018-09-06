"{ Package: 'stx:goodies/communication' }"

Object subclass:#RemoteImage
	instanceVariableNames:'rpcConnection memory globals cachedBehaviors'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support'
!

!RemoteImage class methodsFor:'documentation'!

documentation
"
    I simulate a Smalltalk environment as present in a living remote image.
    My protocol mimics the NameSpace (i.e. class-environment) protocol,
    and I can be used as a Browsers environment, in order to open a
    browser into another running smalltalk.

    This enables a standard browser to peek into another image... (well, almost)

    [author:]
        Claus Gittinger
"
!

examples
"
     SystemBrowser openOnRemoteImageOnHost:'funkfix' port:nil
     SystemBrowser openOnRemoteImageOnHost:'192.168.8.1' port:nil
"
! !

!RemoteImage class methodsFor:'instance creation'!

onHost:aHostName port:portOrNil
    ^ self new onHost:aHostName port:portOrNil
! !

!RemoteImage methodsFor:'private'!

finalize
    rpcConnection close
!

hostName
    ^ rpcConnection hostName
!

onHost:aHostName port:portOrNil
    rpcConnection := SmalltalkShareClient toHost:aHostName port:portOrNil.
    rpcConnection isNil ifTrue:[
        self error:'cannot connect'
    ].
    rpcConnection null.   "/ ping it
    self registerForFinalization.

"/    memory := SnapShotImageMemory forRemoteHost:aHostName port:portOrNil.
"/    memory image:self.
"/    memory readHeader
!

remoteImageClient
    ^ rpcConnection
! !

!RemoteImage methodsFor:'smalltalk protocol'!

allClassesDo:aBlock
    cachedBehaviors isNil ifTrue:[
        self fetchAllClasses
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
            (aClass category = aCategory) ifTrue:[
                aBlock value:aClass
            ]
        ]
    ]
!

at:aKey
    globals isNil ifTrue:[
        self fetchAllClasses
    ].
    ^ globals at:aKey ifAbsent:nil
!

at:aKey ifAbsent:exceptionValue
    globals isNil ifTrue:[
        self fetchAllClasses
    ].
    ^ globals at:aKey ifAbsent:nil
!

fetchAllClasses
    cachedBehaviors := OrderedCollection new.

    cachedBehaviors addAll:(rpcConnection getAllShortClassStubsFor:self).

    globals := IdentityDictionary new.
    cachedBehaviors do:[:eachClass |
        globals at:(eachClass name asSymbol) put:eachClass.
    ].
!

keysAndValuesDo:aTwoArgBlock
"/    globals isNil ifTrue:[
"/        self fetchGlobals
"/    ].
"/    globals keysAndValuesDo:aTwoArgBlock
self halt.
! !

!RemoteImage class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/RemoteImage.st,v 1.4 2013-07-05 10:40:15 stefan Exp $'
! !

