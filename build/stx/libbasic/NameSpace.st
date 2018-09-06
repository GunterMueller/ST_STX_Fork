"
 COPYRIGHT (c) 1996 by Claus Gittinger
 COPYRIGHT (c) 2010 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

Object subclass:#NameSpace
	instanceVariableNames:'category'
	classVariableNames:'Imports'
	poolDictionaries:''
	category:'Kernel-Classes'
!

!NameSpace class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996 by Claus Gittinger
 COPYRIGHT (c) 2010 Jan Vrany
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
    A NameSpace is actually a dummy class, providing a home
    for its private classes. 
    Thus, internally, the same mechanism is used for classes in
    a NameSpace and private classes.
    This has two advantages:
        - we only need one mechanism for both namespaces
          and private classes

        - there are no possible conflicts between a class
          and a namespace named alike.


    [author:]
        Claus Gittinger

    [see also:]
        Behavior ClassDescription Class Metaclass
        PrivateMetaclass
"

! !

!NameSpace class methodsFor:'instance creation'!

fullName:aFullNameSpacePathName
    "given a possibly nested name of a namespace, create all required
     intermediate spaces (if not already existing) and return the
     bottom-level space."

    ^ self fullName:aFullNameSpacePathName createIfAbsent:true

    "Created: 8.11.1996 / 13:41:59 / cg"
    "Modified: 4.1.1997 / 16:50:59 / cg"
!

fullName:aFullNameSpacePathName createIfAbsent:createIfAbsent
    "given a possibly nested name of a namespace, lookup and return
     a namespace instance for it.
     If createIfAbsent is true, create all required intermediate spaces (if not already existing) 
     and return the bottom-level space.
     If false, and if any namespace along the path does not exist, reutrn nil."

    |list thisNamespace|

    "/ break it up, check for all intermediate spaces to exist
    "/ create them as required.

    (aFullNameSpacePathName includes:$:) ifTrue:[
        "/ old style
        list := aFullNameSpacePathName asCollectionOfSubstringsSeparatedByAll:'::'.
    ] ifFalse:[
        "/ new style
        list := aFullNameSpacePathName asCollectionOfSubstringsSeparatedBy:$..
    ].

    "/ now, look and create 'em

    thisNamespace := nil.
    list do:[:aName |
        |key x|

        key := aName asSymbol.

        thisNamespace isNil ifTrue:[
            (Smalltalk includesKey:key) ifTrue:[
                thisNamespace := Smalltalk at:key.
                (thisNamespace notNil
                and:[thisNamespace isBehavior not]) ifTrue:[
                    createIfAbsent ifFalse:[ ^ nil ].
                    self error:'name conflict: namespace ' , aName , ' vs. global'.
                ]
            ].
            thisNamespace isNil ifTrue:[
                createIfAbsent ifFalse:[ ^ nil ].
                thisNamespace := self name:key
            ].
        ] ifFalse:[
            thisNamespace isNameSpace ifTrue:[
                x := thisNamespace at:key.
            ] ifFalse:[
                thisNamespace isBehavior ifTrue:[
                    x := thisNamespace privateClassesAt:key.
                ].
            ].

            x isNil ifTrue:[
                createIfAbsent ifFalse:[ ^ nil ].
                thisNamespace isNameSpace ifTrue:[
                    thisNamespace == Smalltalk ifTrue:[
                        x := self name:key
                    ] ifFalse:[
                        x := thisNamespace name:key.
                    ]
                ] ifFalse:[
                    x :=
                        self subclass:key
                           instanceVariableNames:''
                           classVariableNames:''
                           poolDictionaries:''
                           privateIn:thisNamespace.
                ].

                "/ nameSpaces are not in any package (yet)
                x setPackage:nil.
            ].
            thisNamespace := x.
        ].
    ].

    ^ thisNamespace

    "Created: 8.11.1996 / 13:41:59 / cg"
    "Modified: 4.1.1997 / 16:50:59 / cg"
!

name:aStringOrSymbol
    "create a new nameSpace, named aStringOrSymbol.
     Notice, that the nameSpace is created in the current one -
     don't get confused; we recommend, not to nest them too much."

    |currentNameSpace newNameSpace existing ok nameSym fullName|

    ok := aStringOrSymbol first isLetterOrUnderline.
    ok ifTrue:[
        (aStringOrSymbol 
            findFirst:[:ch | (ch isLetterOrDigit or:[ch == $_]) not]
            startingAt:2) ~~ 0
        ifTrue:[
            ok := false.
        ]
    ].
    ok ifFalse:[
        self error:'invalid namespace name:''' , aStringOrSymbol printString , ''' (must be a valid identifier)'.
    ].

    nameSym := aStringOrSymbol asSymbol.

    self == NameSpace ifTrue:[
        "/ currentNameSpace := Class nameSpaceQuerySignal query.
        currentNameSpace isNil ifTrue:[
            currentNameSpace := Smalltalk
        ].
        fullName := nameSym
    ] ifFalse:[
        currentNameSpace := self.
        fullName := (self name , '::' , nameSym) asSymbol
    ].

    (existing := currentNameSpace at:nameSym) notNil ifTrue:[
        ^ existing
    ].
    newNameSpace := self 
        subclass:fullName
        instanceVariableNames:''
        classVariableNames:''
        poolDictionaries:''
        category:'uncategorized namespace'
        inEnvironment:Smalltalk.

    "/ nameSpaces are not in any package
    newNameSpace notNil ifTrue:[newNameSpace setPackage:nil].
    ^ newNameSpace

    "
     NameSpace name:'foo'
     (NameSpace name:'foo') category:'my name space'
     foo at:#bar put:(Metaclass new new)
     (NameSpace name:'foo') name:'bar'
    "
    "
     NameSpace name:'an-invalid++name'
     NameSpace name:'another:invalidName'
     NameSpace name:'another::invalidName'
    "

    "Modified: / 14-09-1997 / 09:46:59 / cg"
    "Modified: / 18-03-1999 / 18:24:13 / stefan"
    "Modified (comment): / 23-03-2012 / 11:49:00 / cg"
!

new
    "catch new - namespaces are not to be created by the user"

    self error:'namespaces are not to be created with new'

    "Modified: 8.11.1996 / 21:38:00 / cg"
! !

!NameSpace class methodsFor:'Compatibility-VW5.4'!

defineClass: name
                superclass: superclass
                indexedType: indexed
                private: private
                instanceVariableNames: instVars
                classInstanceVariableNames: classInstVars
                imports: imports
                category: category

    "VW5i compatibility class/namespace creation"

    ^ self
        defineClass: name
        superclass: superclass
        indexedType: indexed
        private: private
        instanceVariableNames: instVars
        classInstanceVariableNames: classInstVars
        imports: imports
        category: category
        attributes: nil
!

defineClass: name
                superclass: superclassOrName
                indexedType: indexed
                private: private
                instanceVariableNames: instVars
                classInstanceVariableNames: classInstVars
                imports: imports
                category: category
                attributes: annotations

    "VW5i compatibility class/namespace creation"

    |variable words pointers superclass|

    variable := words := pointers := false.
    indexed ~~ #none ifTrue:[
        indexed == #objects ifTrue:[
            variable := pointers := true.
        ] ifFalse:[
            self shouldImplement.
        ]
    ].
    superclassOrName isSymbol ifTrue:[
        superclass := Smalltalk at:superclassOrName.
        superclass isNil ifTrue:[
            self error:'missing superclass: ' , superclassOrName.
        ]
    ] ifFalse:[   
        superclass := superclassOrName
    ].
    ^ superclass value class
        name:name 
        inEnvironment:self
        subclassOf:superclass value
        instanceVariableNames:instVars
        variable:variable
        words:words
        pointers:pointers
        classVariableNames:''
        poolDictionaries:''
        category:category
        comment:nil
        changed:true
        classInstanceVariableNames:classInstVars
!

defineNameSpace:nameSymbol private:private imports:imports category:category
    "VW5i compatibility class/namespace creation"

    |newNameSpace|

    private ifTrue:[self shouldImplement].     "/ what to do ?
    imports withoutSeparators notEmpty ifTrue:[self shouldImplement].     "/ what to do ?
    newNameSpace := NameSpace name:nameSymbol.
    newNameSpace setCategory:category.    
    ^ newNameSpace
! !

!NameSpace class methodsFor:'accessing'!

allClasses
    |classes|

    classes := OrderedCollection new.
    self allClassesDo:[:aClass | classes add:aClass].
    ^ classes

    "Modified: 20.12.1996 / 15:34:50 / cg"
!

allClassesWithAllPrivateClasses
    |classes|

    classes := OrderedCollection new.
    self allClassesDo:[:aClass | 
        classes add:aClass.
        aClass addAllPrivateClassesTo:classes.
    ].
    ^ classes

    "Modified: 20.12.1996 / 15:34:50 / cg"
!

at:classNameSymbol
    "return a class from the namespace defined by the receiver"

    ^ self privateClassesAt:classNameSymbol

    "Modified: 8.11.1996 / 21:39:41 / cg"
!

at:classNameSymbol ifAbsent:exceptionBlock
    "return a class or an alternative
     from the namespace defined by the receiver"

    |cls|

    cls := self privateClassesAt:classNameSymbol.
    cls isNil ifTrue:[
        ^ exceptionBlock value
    ].
    ^ cls

    "Modified: 8.11.1996 / 21:40:01 / cg"
!

at:aKey ifPresent:aBlock
    "try to retrieve the value stored at aKey.
     If there is nothing stored under this key, do nothing.
     Otherwise, evaluate aBlock, passing the retrieved value as argument."

    (self includesKey:aKey) ifTrue:[
        ^ aBlock value:(self at:aKey)
    ].
    ^ nil

    "Modified: / 31-05-2007 / 17:50:46 / cg"
!

at:classNameSymbol put:aClass
    "add a class to the namespace defined by the receiver"

    ^ self privateClassesAt:classNameSymbol put:aClass

    "Modified: 8.11.1996 / 21:40:12 / cg"
!

classNamed:aString
    "return the class with name aString, or nil if absent.
     To get to the metaClass, append ' class' to the string."

    ^ Smalltalk classNamed:(self name , '::' , aString)

    "Created: 9.9.1997 / 03:33:56 / cg"
!

classNames
    ^ self allClasses collect:[:each | each nameWithoutPrefix]
!

import: aNameSpace

    (aNameSpace isNameSpace or: [aNameSpace isProgrammingLanguage])
        ifFalse:[self error: 'Not a namespace or prog. language'].

    (self imports includes: aNameSpace) ifFalse:
        [self setImports: (self imports copyWith: aNameSpace)]

    "Created: / 21-07-2010 / 15:16:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-07-2010 / 17:18:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

imports
    Imports isNil ifTrue:[^#()].
    ^Imports at: self ifAbsent:[#()].

    "Created: / 19-05-2010 / 16:06:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-07-2010 / 17:17:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-11-2011 / 14:48:56 / cg"
!

includesKey:aClassNameStringOrSymbol
    "{ Pragma: +optSpace }"

    "return true if such a key is present"

    |nmSym|

    nmSym := (self name , '::' , aClassNameStringOrSymbol) asSymbolIfInterned.
    nmSym isNil ifTrue:[^ false].
    ^ Smalltalk includesKey:nmSym.


!

loadedClassNamed:aString
    "return the class with name aString, or nil if absent.
     To get to the metaClass, append ' class' to the string.
     Do not autoload the owning class of a private class."

    ^ Smalltalk loadedClassNamed:(self name , '::' , aString)

    "Created: 9.9.1997 / 03:33:56 / cg"
!

package
    self isNameSpace ifTrue:[    
        ^ nil       "all nameSpaces are outside of any package"
    ].
    ^ super package "the nameSpace class itself has a package"

    "Created: / 16-08-2006 / 18:48:29 / User"
! !

!NameSpace class methodsFor:'enumerating'!

allBehaviorsDo:aBlock
    "enumerate all classes in this namespace"

    Smalltalk allBehaviorsDo:[:aClass |
        (aClass isBehavior and:[aClass isMeta not]) ifTrue:[
            aClass nameSpace == self ifTrue:[
                aBlock value:aClass
            ].
        ]
    ].

    "Modified: / 18.3.1999 / 17:21:06 / cg"
!

allClassesDo:aBlock
    "enumerate all classes in this namespace"

    Smalltalk allClassesDo:[:aClass |
        (aClass isBehavior and:[aClass isMeta not]) ifTrue:[
            aClass nameSpace == self ifTrue:[
                aBlock value:aClass
            ].
        ]
    ].

    "Modified: / 18.3.1999 / 17:21:06 / cg"
!

allClassesForWhich:filter
    "return a collection with all classes in the system,
     for which filter evaluates to true."

    |collectedClasses|

    collectedClasses := OrderedCollection new.
    self allClassesForWhich:filter do:[:cls |
        collectedClasses add:cls
    ].
    ^ collectedClasses

    "
     Smalltalk
        allClassesForWhich:[:cls | cls name startsWith:'Po']
    "

    "Created: / 10-08-2006 / 12:11:31 / cg"
!

allClassesForWhich:filter do:aBlock
    "evaluate the argument, aBlock for all classes in the system, for which filter evaluates to true."

    self allClassesDo:[:cls |
        (filter value:cls) ifTrue:[ aBlock value:cls ].
    ].

    "
     Smalltalk
        allClassesForWhich:[:cls | cls name startsWith:'Po']
        do:[:aClass | Transcript showCR:aClass name]
    "
!

allMethodsDo:aBlock
    "enumerate all methods in this namespace's classes"

    self allClassesDo:[:eachClass |
        eachClass instAndClassSelectorsAndMethodsDo:[:sel :mthd |
            aBlock value:mthd
        ]
    ].
!

allMethodsWithSelectorDo:aBlock
    "enumerate all methods in the Smalltalk namespace's classes"

    self allClassesDo:[:eachClass |
        eachClass instAndClassSelectorsAndMethodsDo:[:sel :mthd |
            aBlock value:mthd value:sel
        ]
    ].
!

keyAtValue:anObject
    "return the symbol under which anObject is stored - or nil"

    self keysDo:[:aKey |
        (self at:aKey) == anObject ifTrue:[^ aKey]
    ].
    ^ nil

    "Smalltalk keyAtValue:Object"

    "Created: / 19-12-2010 / 14:35:49 / cg"
!

keys
    "enumerate all class names in this namespace"

    |setOfKeys|

    setOfKeys := OrderedCollection new.
    self keysDo:[:eachKey |setOfKeys add:eachKey].
    ^ setOfKeys

    "
     Benchmarks keys
    "
!

keysDo:aBlock
    "enumerate all class names in this namespace"

    |prefix prefixLen|

    prefix := self name , '::'.
    prefixLen := prefix size.

    Smalltalk keysAndValuesDo:[:aName :aClass |
        |key|

        (aName startsWith:prefix) ifTrue:[
            key := (aName copyFrom:prefixLen+1) asSymbol.
            aBlock value:key
        ]
    ].

    "
     Benchmarks keysDo:[:k | Transcript showCR:k]
    "
! !

!NameSpace class methodsFor:'fileOut'!

fileOutDefinitionOn:aStream
    "redefined to generate another definition message"

    self == NameSpace ifTrue:[
        super fileOutDefinitionOn:aStream
    ] ifFalse:[
        aStream nextPutAll:('NameSpace name:' , self name storeString)
    ]

    "Modified: 8.11.1996 / 21:39:03 / cg"
    "Created: 4.1.1997 / 20:36:32 / cg"
! !

!NameSpace class methodsFor:'fileOut-xml'!

fileOutXMLDefinitionOn:aStream
    "redefined to generate another definition message"

    self == NameSpace ifTrue:[
        super fileOutXMLDefinitionOn:aStream
    ] ifFalse:[
        aStream nextPutLine:'<name-space>'.
        aStream nextPutLine:'  <name>' , self name , '</name>'.
        aStream nextPutLine:'  <environment>Smalltalk</environment>'.
        aStream nextPutLine:'  <private>false</private>'.
        aStream nextPutLine:'  <imports>Smalltalk.*</imports>'.
        aStream nextPutLine:'  <category>none</category>'.
        aStream nextPutLine:'</name-space>'.
    ]
! !


!NameSpace class methodsFor:'printing & storing'!

displayOn:aGCOrStream
    "Compatibility
     append a printed desription on some stream (Dolphin,  Squeak)
     OR:
     display the receiver in a graphicsContext at 0@0 (ST80).
     This method allows for any object to be displayed in some view
     (although the fallBack is to display its printString ...)"

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    aGCOrStream isStream ifFalse:[
        ^ super displayOn:aGCOrStream.
    ].

    "return a printed represenation - here, a reminder is appended,
     that this is not a regular class"

    self == NameSpace ifTrue:[
        super displayOn:aGCOrStream.
    ] ifFalse:[
        aGCOrStream 
            nextPutAll:self name;
            nextPutAll:' (* NameSpace *)'.
    ].
! !

!NameSpace class methodsFor:'private'!

setImports: anArrayOrNil

    "Sets namespace imports. Private entry, 
     Use 'self import: theNamespace' instead"

    Imports isNil ifTrue:[Imports := IdentityDictionary new].
    Imports at: self put: (anArrayOrNil ? #()).

    "Created: / 21-07-2010 / 15:29:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-11-2011 / 14:49:10 / cg"
! !

!NameSpace class methodsFor:'queries'!

allNameSpaces
    "return a list of all namespaces"

    ^ self allNameSpacesIn:Smalltalk
!

allNameSpacesIn:anEnvironment
    "return a list of all namespaces"

    |set|

    set := IdentitySet with:anEnvironment.
    anEnvironment allClassesDo:[:aClass |
        (aClass isRealNameSpace 
        and:[aClass ~~ anEnvironment]) ifTrue:[
            set add:aClass
        ]
    ].
    ^ set

    "Modified: / 10-11-2006 / 17:12:02 / cg"
!

allNamespaces
    "return a list of all namespaces"

    <resource: #obsolete>

    ^ self allNameSpaces
!

allNamespacesIn:anEnvironment
    "return a list of all namespaces"

    <resource: #obsolete>

    ^ self allNameSpacesIn:anEnvironment
!

canHaveExtensions
    "return true, if this class allows extensions from other packages.
     Private classes, namespaces and projectDefinitions don't allow this"

    ^ self == NameSpace

    "
     Smalltalk allClasses select:[:each | each canHaveExtensions not]
    "

    "Created: / 30-08-2006 / 15:28:39 / cg"
!

hasNameSpaces
    "return true - if I support sub-namespaces"

    ^ false
!

hasNamespaces
    "return true - if I support sub-namespaces"

    <resource: #obsolete>

    ^ self hasNameSpaces
!

isNameSpace
    "return true, if the receiver is a nameSpace.
     Unconditionally true here for subclasses - my subclasses are namespaces"

    ^ self ~~ NameSpace .

    "Modified: / 10-11-2006 / 17:01:56 / cg"
!

isRealNameSpace
    "return true, if the receiver is a nameSpace, but not Smalltalk (which is also a class).
     Unconditionally true here for subclasses - my subclasses are namespaces"

    ^ self ~~ NameSpace .

    "Created: / 10-11-2006 / 17:01:52 / cg"
!

isTopLevelNameSpace
    ^ (self name includes:$:) not
!

isTopLevelNamespace
    "obsolete - use isTopLevelNameSpace"

    <resource: #obsolete>

    ^ (self name includes:$:) not
! !

!NameSpace class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$ Id: NameSpace.st 10643 2011-06-08 21:53:07Z vranyj1  $'
! !

