"
 COPYRIGHT (c) 2002 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/communication' }"

"{ NameSpace: Smalltalk }"

SunRPC::RPCClient subclass:#SmalltalkShareClient
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-SmallTeam'
!

Class subclass:#RemoteClass
	instanceVariableNames:'superclassName classInstVarNames owningClass myMetaclass'
	classVariableNames:''
	poolDictionaries:''
	privateIn:SmalltalkShareClient
!

Metaclass subclass:#RemoteMetaclass
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:SmalltalkShareClient
!

Method variableSubclass:#RemoteMethod
	instanceVariableNames:'selector'
	classVariableNames:''
	poolDictionaries:''
	privateIn:SmalltalkShareClient
!

!SmalltalkShareClient class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2002 by eXept Software AG
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
    a client for remote image access.

    [author:]
        Claus Gittinger

    [start with (server side):]
        SmalltalkShareServer start
        SmalltalkShareServer startUDP

    [start with (client side):]
        |client matchArg list|
        client := SmalltalkShareClient toHost:'localhost'.
        matchArg := Dictionary new.
        matchArg at:'classNamePattern' put:'*'.
        matchArg at:'categoryPattern' put:'*'.
        matchArg at:'packagePattern' put:'*'.
        list := client getClassList:matchArg.
        client close.
        list inspect.

        SystemBrowser openOnRemoteImageOnHost:'localhost' port:nil

    [see also:]
        SmalltalkShareServer
"
!

examples
"
  get list of class categories:
                                                                [exBegin]
    |shareClient list|

    shareClient := SmalltalkShareClient toHost:'localhost'.
    list := shareClient getCategories.
    shareClient close.
    list inspect.
                                                                [exEnd]


  get list of classes (name starting with A) from other image:
                                                                [exBegin]
    |shareClient matchArg list|

    shareClient := SmalltalkShareClient toHost:'localhost'.

    matchArg := Dictionary new.
    matchArg at:'classNameMatchPattern' put:'A*'.
    matchArg at:'categoryMatchPattern' put:'*'.
    matchArg at:'packageMatchPattern' put:'*'.
    list := shareClient getClasses:matchArg.
    shareClient close.
    list inspect.
                                                                [exEnd]

  get list of classes (in category Magnitude-Numbers) from other image:
                                                                [exBegin]
    |shareClient matchArg list|

    shareClient := SmalltalkShareClient toHost:'localhost'.

    matchArg := Dictionary new.
    matchArg at:'classNameMatchPattern' put:'*'.
    matchArg at:'categoryMatchPattern' put:'Magnitude-Numbers'.
    matchArg at:'packageMatchPattern' put:'*'.
    list := shareClient getClasses:matchArg.
    shareClient close.
    list inspect.
                                                                [exEnd]

  get list of classes of a package from other image:
                                                                [exBegin]
    |shareClient matchArg list|

    shareClient := SmalltalkShareClient toHost:'localhost'.

    matchArg := Dictionary new.
    matchArg at:'classNameMatchPattern' put:'*'.
    matchArg at:'categoryMatchPattern' put:'*'.
    matchArg at:'packageMatchPattern' put:'stx:goodies/communication'.
    list := shareClient getClasses:matchArg.
    shareClient close.
    list inspect.
                                                                [exEnd]

"
! !

!SmalltalkShareClient class methodsFor:'spec'!

xdr
    ^ SmalltalkShareServer xdr

    "Modified: / 30.1.2002 / 15:55:29 / cg"
! !

!SmalltalkShareClient methodsFor:'operations'!

getCategories
    |reply|

    reply := self operation:#getCategories.
    ^ reply

    "
     |client list|

     client := self new host:'localhost'.
     list := client getCategories.
     client close.
     list inspect.
    "
!

getClassNames:getClassNamesArg
    |reply|

    reply := self operation:#getClassNames argument:getClassNamesArg.
    ^ reply

    "
     |client arg list|

     arg := Dictionary new.
     arg at:'classNameMatchPattern' put:'A*'.
     arg at:'categoryMatchPattern' put:'*'.
     arg at:'packageMatchPattern' put:'*'.
     client := self new host:'localhost'.
     list := client getClassNames:arg.
     client close.
     list inspect.
    "
!

getClasses:getClassNamesArg
    |reply|

    reply := self operation:#getClasses argument:getClassNamesArg.
    ^ reply

    "
     |client arg list|

     arg := Dictionary new.
     arg at:'classNameMatchPattern' put:'A*'.
     arg at:'categoryMatchPattern' put:'*'.
     arg at:'packageMatchPattern' put:'*'.
     client := self new host:'localhost'.
     list := client getClasses:arg.
     client close.
     list inspect.
    "
!

getMethodInfo:getMethodInfoArg
    |reply|

    reply := self operation:#getMethodInfo argument:getMethodInfoArg.
    ^ reply
!

getMethodNames:getMethodNamesArg
    |reply|

    reply := self operation:#getMethodNames argument:getMethodNamesArg.
    ^ reply

    "
     |client arg list|

     arg := Dictionary new.
     arg at:'className' put:'Array'.
     arg at:'meta' put:false.
     client := self new host:'localhost'.
     list := client getMethodNames:arg.
     client close.
     list inspect.
    "
! !

!SmalltalkShareClient methodsFor:'utilities'!

downLoad
    "synchronize from the other smalltalk - i.e. for all
     classes which are newer in the other image, download the class
     and install it."

    self downLoadPackagesMatching:'*'.

    "
     |client arg|

     arg := Dictionary new.
     arg at:'classNamePattern' put:'A*'.
     arg at:'categoryPattern' put:'*'.
     arg at:'packagePattern' put:'*'.
     client := self new host:'localhost'.
     client downLoad.
     client close
    "

    "Modified (comment): / 22-05-2017 / 12:09:01 / mawalch"
!

downLoadPackagesMatching:packageMatchPattern
    "synchronize from the other smalltalk - i.e. for all
     classes which are newer in the other image, download the class
     and install it."

    |list classNames|

    list := self getClassNamesInPackagesMatching:packageMatchPattern.
    classNames := list collect:[:eachEntry | eachEntry at:'className'].
    self halt.

    "
     |client arg|

     client := self new host:'localhost'.
     client downLoadPackagesMatching:#'stx:goodies/communication'.
     client close
    "

    "Modified (comment): / 22-05-2017 / 12:09:04 / mawalch"
!

getAllClassNames
    |arg list|

    arg := Dictionary new.
    arg at:'classNameMatchPattern' put:'*'.
    arg at:'categoryMatchPattern' put:'*'.
    arg at:'packageMatchPattern' put:'*'.
    list := self getClassNames:arg.
    ^ list collect:[:eachEntry | eachEntry at:'className']

    "
     |service list|

     service := self toHost:'localhost'.
     list := service getAllClassNames.
     service close.
     list inspect.

     |service list|

     service := self toHost:'funkfix'.
     list := service getAllClassNames.
     service close
    "
!

getAllShortClassStubsFor:anEnvironment
    |arg list prevCat|

    arg := Dictionary new.
    arg at:'classNameMatchPattern' put:'*'.
    arg at:'categoryMatchPattern' put:'*'.
    arg at:'packageMatchPattern' put:'*'.
    list := self getClassNames:arg.
    ^ list 
        collect:
            [:eachEntry | 
                |nm cat|

                nm := eachEntry at:'className'.
                cat := eachEntry at:'classCategoryOrEmptyIfSame'.
                cat size == 0 ifTrue:[
                    cat := prevCat
                ].
                prevCat := cat.
                RemoteClass basicNew
                    setName:nm;
                    environment:anEnvironment;
                    category:cat.
            ]

    "
     |service list|

     service := self toHost:'localhost'.
     list := service getAllShortClassStubs.
     service close.
     list inspect.

     |service list|

     service := self toHost:'funkfix'.
     list := service getAllClassNames.
     service close
    "
!

getAllShortMethodStubsFor:aClass
    |arg list prevCat prevPkg|

    arg := Dictionary new.
    arg at:'className' put:aClass theNonMetaclass name.
    arg at:'meta' put:(aClass isMeta).
    list := self getMethodNames:arg.
    ^ list 
        collect:
            [:eachEntry | 
                |sel cat pkg|

                sel := (eachEntry at:'selector') asSymbol.
                cat := eachEntry at:'methodCategoryOrEmptyIfSame'.
                cat size == 0 ifTrue:[
                    cat := prevCat
                ].
                prevCat := cat.

                pkg := eachEntry at:'packageOrEmptyIfSame'.
                pkg size == 0 ifTrue:[
                    pkg := prevPkg
                ].
                prevPkg := pkg.

                RemoteMethod basicNew
                    mclass:aClass;
                    selector:sel;
                    setPackage:pkg;
                    setCategory:cat.
            ]
!

getClassNamed:className
    |arg list entry cls|

    arg := Dictionary new.
    arg at:'classNameMatchPattern' put:className.
    arg at:'categoryMatchPattern' put:'*'.
    arg at:'packageMatchPattern' put:'*'.
    list := self getClasses:arg.
    list isEmpty ifTrue:[
        ^ nil
    ].
    entry := list first.
    cls := RemoteClass basicNew.
    cls environment:self.
    cls name:(entry at:'className').
    cls category:(entry at:'categoryName').
    cls package:(entry at:'packageName').
    cls superclassName:(entry at:'superclassName').
    cls instVarNames:(entry at:'instVarNames').
    cls classVarNames:(entry at:'classVarNames').
    cls classInstVarNames:(entry at:'classInstVarNames').
    cls flags:(entry at:'flags').
    ^ cls

    "
     |client cls|

     client := self new host:'localhost'.
     cls := client getClassNamed:'Array'.
     client close.
     cls inspect
    "
!

getClassNamesInPackagesMatching:packageMatchPattern
    |arg|

    arg := Dictionary new.
    arg at:'classNameMatchPattern' put:'*'.
    arg at:'categoryMatchPattern' put:'*'.
    arg at:'packageMatchPattern' put:packageMatchPattern.
    ^ self getClassNames:arg.

    "
     |client list|

     client := self new host:'localhost'.
     list := client getClassNamesInPackagesMatching:'stx:libbasic3'.
     client close.
     list inspect
    "
!

getInfoForClassNamed:className
    |arg list|

    arg := Dictionary new.
    arg at:'classNameMatchPattern' put:className.
    arg at:'categoryMatchPattern' put:'*'.
    arg at:'packageMatchPattern' put:'*'.
    list := self getClasses:arg.
    list isEmpty ifTrue:[
        ^ nil
    ].
    ^ list first.

    "
     |client cls|

     client := self new host:'localhost'.
     cls := client getInfoForClassNamed:'Array'.
     client close.
     cls inspect
    "

    "
     |client cls|

     client := self new host:'localhost'.
     cls := client getInfoForClassNamed:'Collection'.
     client close.
     cls inspect
    "

    "
     |client cls|

     client := self new host:'localhost'.
     cls := client getInfoForClassNamed:'Object'.
     client close.
     cls inspect
    "
!

getInfoForMethodNamed:selector inClass:aClass
    |arg|

    arg := Dictionary new.
    arg at:'className' put:aClass theNonMetaclass name.
    arg at:'meta' put:aClass isMeta.
    arg at:'selector' put:selector.
    ^ self getMethodInfo:arg.

    "
     |client info|

     client := self new host:'localhost'.
     info := client getInfoForMethodNamed:#at:put: inClass:Array.
     client close.
     info inspect
    "
! !

!SmalltalkShareClient::RemoteClass methodsFor:'accessing'!

classInstVarNames
    "return the value of the instance variable 'classInstVarNames' (automatically generated)"

    ^ classInstVarNames
!

classInstVarNames:something
    "set the value of the instance variable 'classInstVarNames' (automatically generated)"

    classInstVarNames := something.
!

environment
    "return the value of the instance variable 'environment' (automatically generated)"

    ^ environment
!

environment:something
    "set the value of the instance variable 'environment' (automatically generated)"

    environment := something.
!

methodDictionary
    methodDictionary isNil ifTrue:[
        "/ methodDictionary := IdentityDictionary new.
        methodDictionary := IdentityDictionary new.
        (environment remoteImageClient getAllShortMethodStubsFor:self) do:[:remoteMethod |
            methodDictionary at:(remoteMethod selector) put:remoteMethod.
        ].
    ].

    ^ super methodDictionary
!

nameSpace
    |env name idx nsName|

"/    (env := self environment) notNil ifTrue:[^ env].
    env := Smalltalk. "/ default
    name := self name.
    idx := name lastIndexOf:$:.
    idx ~~ 0 ifTrue:[
        (name at:idx-1) == $: ifTrue:[
            nsName := name copyTo:(idx - 2).
            env := Smalltalk at:nsName asSymbol.
        ]
    ].
    ^ env
!

owningClass
    ^ owningClass
!

package
    package isNil ifTrue:[
        self fetchFullInfo
    ].
    ^ package
!

superclassName
    ^ superclassName
!

superclassName:something
    superclassName := something.
!

topOwningClass
    |outerOwner|

    owningClass isNil ifTrue:[^ nil].

    (outerOwner := owningClass owningClass) notNil ifTrue:[
        ^ owningClass topOwningClass
    ].
    ^ owningClass
! !

!SmalltalkShareClient::RemoteClass methodsFor:'class behavior'!

fileOutAs:fileName
self halt.
    ^ super fileOutAs:fileName
!

instSize
    instSize isNil ifTrue:[
        self fetchFullInfo
    ].
    ^ instSize
!

isMeta
    ^ false
!

superclass
    superclass isNil ifTrue:[
        superclassName isNil ifTrue:[
            self fetchFullInfo
        ].
        superclassName size > 0 ifTrue:[
            superclass := environment at:superclassName asSymbol
        ]
    ].
    ^ superclass
!

theMetaclass
    myMetaclass isNil ifTrue:[
        myMetaclass := SmalltalkShareClient::RemoteMetaclass basicNew.
        myMetaclass setSoleInstance:self.
    ].
    ^ myMetaclass
! !

!SmalltalkShareClient::RemoteClass methodsFor:'printing'!

displayString
    ^ String streamContents:[:s | self printOn:s]
!

printOn:aStream
    aStream nextPutAll:'RemoteClass('.
    aStream nextPutAll:(name ? '?').
    environment notNil ifTrue:[
        aStream nextPutAll:' on '.
        aStream nextPutAll:environment hostName.
    ].
    aStream nextPutAll:')'.
! !

!SmalltalkShareClient::RemoteClass methodsFor:'private'!

fetchFullInfo
    |info superclass|

    info := environment remoteImageClient getInfoForClassNamed:name.
    category isNil ifTrue:[
        category := (info at:'categoryName') asSymbol.
    ].
    package isNil ifTrue:[
        package := (info at:'packageName') asSymbol.
    ].
    superclassName isNil ifTrue:[
        superclassName := (info at:'superclassName') asSymbol.
    ].
    flags isNil ifTrue:[
        flags := (info at:'flags').
    ].
    instvars isNil ifTrue:[
        instvars := (info at:'instVarNames').
        superclass := self superclass.
        instSize := instvars asCollectionOfWords size.
        superclass notNil ifTrue:[
            instSize := instSize + self superclass instSize.
        ]
    ].
    classvars isNil ifTrue:[
        classvars := (info at:'classVarNames').
    ].
    classInstVarNames isNil ifTrue:[
        classInstVarNames := (info at:'classInstVarNames').
    ].
! !

!SmalltalkShareClient::RemoteMetaclass methodsFor:'accessing'!

methodDictionary
    methodDictionary isNil ifTrue:[
        methodDictionary := IdentityDictionary new.
        (myClass environment remoteImageClient getAllShortMethodStubsFor:self) do:[:remoteMethod |
            methodDictionary at:(remoteMethod selector) put:remoteMethod.
        ].
    ].

    ^ super methodDictionary
! !

!SmalltalkShareClient::RemoteMethod methodsFor:'accessing'!

containingClass
mclass isNil ifTrue:[self halt].
    ^ mclass 
!

mclass
mclass isNil ifTrue:[self halt].
    ^ mclass 
!

privacy
    ^ #public
!

selector
    ^ selector
!

selector:aSymbol
    selector := aSymbol
!

source
    source isNil ifTrue:[
        self fetchFullInfo
    ].
    ^ source
!

who
mclass isNil ifTrue:[self halt].
    ^ Method::MethodWhoInfo class:mclass selector:selector
!

wrapper
    ^ nil
! !

!SmalltalkShareClient::RemoteMethod methodsFor:'private'!

fetchFullInfo
    |info|

    info := mclass theNonMetaclass environment remoteImageClient getInfoForMethodNamed:selector inClass:mclass.
    category isNil ifTrue:[
        category := (info at:'category') asSymbol.
    ].
    package isNil ifTrue:[
        package := (info at:'package') asSymbol.
    ].
    source isNil ifTrue:[
        source := (info at:'source') asSymbol.
    ].
    flags isNil ifTrue:[
        flags := (info at:'flags').
    ].
    byteCode isNil ifTrue:[
        byteCode := info at:'byteCode' ifAbsent:nil.
    ].
! !

!SmalltalkShareClient::RemoteMethod methodsFor:'queries'!

isExecutable
    ^ false

    "Created: / 15.2.2002 / 15:43:09 / cg"
!

isUnloaded
    ^ false
! !

!SmalltalkShareClient class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/SmalltalkShareClient.st,v 1.7 2017-05-22 10:22:37 mawalch Exp $'
! !

