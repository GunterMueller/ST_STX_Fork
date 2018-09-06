"
 COPYRIGHT (c) 1988 by Claus Gittinger
 COPYRIGHT (c) 2009 Jan Vrany
 COPYRIGHT (c) 2016 Jan Vrany
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

ClassDescription subclass:#Metaclass
	instanceVariableNames:'myClass'
	classVariableNames:'ConfirmationQuerySignal'
	poolDictionaries:''
	category:'Kernel-Classes'
!

!Metaclass class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1988 by Claus Gittinger
 COPYRIGHT (c) 2009 Jan Vrany
 COPYRIGHT (c) 2016 Jan Vrany
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
    every classes class is a subclass of Metaclass.
    (i.e. every class is the sole instance of its Metaclass)
    Metaclass provides support for creating new (sub)classes and/or
    changing the definition of an already existing class.

    [author:]
	Claus Gittinger

    [see also:]
	Behavior ClassDescription Class
"
! !

!Metaclass class methodsFor:'Signal constants'!

confirmationQuerySignal
    "return the query signal which is raised to ask if user
     confirmation dialogs should be opened.
     If unhandled, they are."

    ^ ConfirmationQuerySignal

    "Created: 31.7.1997 / 21:55:39 / cg"
! !

!Metaclass class methodsFor:'class initialization'!

initialize
    ConfirmationQuerySignal isNil ifTrue:[
        ConfirmationQuerySignal := Query newSignal defaultAnswer:true.
    ].

    "Modified: 31.7.1997 / 21:54:44 / cg"
! !

!Metaclass class methodsFor:'creating metaclasses'!

new
    "creating a new metaclass - have to set the new classes
     flags correctly to have it behave like a metaclass ...
     Not for normal applications - creating new metaclasses is a very
     tricky thing; should be left to the gurus ;-)"

    |newMetaclass|

    newMetaclass := super new.
    newMetaclass instSize:(Class instSize).
    newMetaclass setSuperclass:Class.

    ^ newMetaclass

    "
     Metaclass new           <- new metaclass
     Metaclass new new       <- new class
     Metaclass new new new   <- new instance
    "
! !

!Metaclass class methodsFor:'queries'!

asPrivate
    ^ PrivateMetaclass
!

isBuiltInClass
    "return true if this class is known by the run-time-system.
     Here, true is returned for myself, false for subclasses."

    ^ self == Metaclass class or:[self == Metaclass]

    "Modified: 23.4.1996 / 15:59:44 / cg"
! !

!Metaclass methodsFor:'Compatibility-ST80'!

comment:aString
    "ignored - sometimes found in ST-80 fileOut files.
     Comments are supposed to be defined via class messages."

    "Created: 9.10.1997 / 18:14:34 / cg"
!

sourceCodeTemplate
    "ST80 compatibility - return a definition message for myself.
     Same as #definition"

    ^ self soleInstance definition

    "Created: / 1.11.1997 / 13:16:45 / cg"
! !


!Metaclass methodsFor:'autoload check'!

isLoaded
    "return true, if the class has been loaded;
     redefined in Autoload; see comment there"

    ^ myClass isNil or:[ myClass isLoaded ]


! !

!Metaclass methodsFor:'class instance variables'!

instanceVariableNames:aString
    "changing / adding class-inst vars -
     this actually creates a new metaclass and class, leaving the original
     class hanging around as obsolete classes. 
     This may also be true for all subclasses, if class instance variables are added/removed in a superclass.
     Existing instances (i.e. insts of the class) are migrated to become instances of the new class(es).

     However, if the old class is referenced somewhere (in a collection),
     that reference will still point to the old, now obsolete class.
     Time will show, if that is a problem and will be fixed."

    |builder|

    self instanceVariableString asStringCollection = aString asStringCollection ifTrue:[^ self].

    builder := ClassBuilder new.
    builder oldMetaclass:self instanceVariableNames:aString.
    builder rebuildForChangedClassInstanceVariables.
! !

!Metaclass methodsFor:'compiler interface'!

browserClass
    "return the browser to use for this class -
     this can be redefined in special classes, to get different browsers"

    ^ UserPreferences systemBrowserClass.

    "Created: 3.5.1996 / 12:36:40 / cg"
!

compilerClass
    "return the compiler to use for this class -
     this can be redefined in special classes, to compile classes with
     JavaScript, Ruby, Lisp, Prolog, ASN1, Basic :-) or whatever syntax."

    ^ self programmingLanguage compilerClass.

    "
     Array compilerClass
    "
!

dllPath
    ^ myClass dllPath

    "Created: / 19-02-2016 / 14:08:59 / jv"
!

evaluatorClass
    "return the compiler to use for expression evaluation for this class -
     this can be redefined in special classes, to evaluate expressions with
     JavaScript, Ruby, Lisp, Prolog, ASN1, Basic :-) or whatever syntax."

    ^ self programmingLanguage evaluatorClass.

    "
     Array evaluatorClass
    "
!

formatterClass
    "return the parser to use for formatting (prettyPrinting) this class -
     this can be redefined in special classes, to format classes with
     JavaScript, Ruby, Lisp, Prolog, ASN1, Basic :-) or whatever syntax."

    ^ self programmingLanguage formatterClass.

    "
     Array formatterClass
    "
!

parserClass
    "return the parser to use for parsing this class -
     this can be redefined in special classes, to parse classes with
     JavaScript, Ruby, Lisp, Prolog, ASN1, Basic :-) or whatever syntax."

    ^ self programmingLanguage parserClass.

    "
     Array parserClass
    "
!

programmingLanguage
    "return the programming language in which this class is written"

    ^ SmalltalkLanguage instance

    "Created: / 15-08-2009 / 09:06:25 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 16-08-2009 / 10:37:08 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

realSubclassDefinerClass
    "Answer an evaluator class appropriate for evaluating definitions of new
     subclasses of this class."

    "cg: @jan - what is the difference to the subclassDefinerClass?"
    ^ self evaluatorClass
!

subclassDefinerClass
    "Answer an evaluator class appropriate for evaluating definitions of new
     subclasses of this class."

    ^ self evaluatorClass


!

syntaxHighlighterClass
    "return the class to use for syntaxHighlighting (prettyPrinting) this class -
     this can be redefined in special classes, to highlight classes with
     JavaScript, Ruby, Lisp, Prolog, ASN1, Basic :-) or whatever syntax."

    ^ self programmingLanguage syntaxHighlighterClass.

    "
     Array syntaxHighlighterClass
    "
! !

!Metaclass methodsFor:'copying'!

postCopy
    "redefined - a copy may have a new instance"

    myClass := nil
! !

!Metaclass methodsFor:'creating classes'!

name:newName inEnvironment:aNameSpaceOrOwningClass
	     subclassOf:aClass
	     instanceVariableNames:stringOfInstVarNames
	     variable:variableBoolean
	     words:wordsBoolean
	     pointers:pointersBoolean
	     classVariableNames:stringOfClassVarNames
	     poolDictionaries:stringOfPoolNames
	     category:categoryString
	     comment:commentString
	     changed:changed

    ^ self
	name:newName
	inEnvironment:aNameSpaceOrOwningClass
	subclassOf:aClass
	instanceVariableNames:stringOfInstVarNames
	variable:variableBoolean
	words:wordsBoolean
	pointers:pointersBoolean
	classVariableNames:stringOfClassVarNames
	poolDictionaries:stringOfPoolNames
	category:categoryString
	comment:commentString
	changed:changed
	classInstanceVariableNames:nil

    "Modified: 16.6.1997 / 11:53:58 / cg"
!

name:newName inEnvironment:aNameSpaceOrOwningClass
             subclassOf:aClass
             instanceVariableNames:stringOfInstVarNames
             variable:variableBoolean
             words:wordsBoolean
             pointers:pointersBoolean
             classVariableNames:stringOfClassVarNames
             poolDictionaries:stringOfPoolNames
             category:categoryString
             comment:commentString
             changed:changed
             classInstanceVariableNames:stringOfClassInstVarNamesOrNil

    "this is the main workhorse for installing new classes - special care
     has to be taken, when changing an existing classes definition. In this
     case, some or all of the methods and subclasses methods have to be
     recompiled.
     Also, the old class(es) are still kept (but not accessible as a global),
     to allow existing instances some life.
     This might change in the future.
    "
    |builder|

    builder := self newClassBuilder.
    builder name:newName
        inEnvironment:aNameSpaceOrOwningClass
        subclassOf:aClass
        instanceVariableNames:stringOfInstVarNames
        variable:variableBoolean
        words:wordsBoolean
        pointers:pointersBoolean
        classVariableNames:stringOfClassVarNames
        poolDictionaries:stringOfPoolNames
        category:categoryString
        comment:commentString
        changed:changed
        classInstanceVariableNames:stringOfClassInstVarNamesOrNil.
    ^ builder buildClass.
!

new
    "create & return a new metaclass (a classes class).
     Since metaclasses only have one instance (the class),
     complain if there is already one.
     You get a new class by sending #new to the returned metaclass
     (confusing - isn't it ?)"

    |newClass|

    myClass notNil ifTrue:[
	self error:'Each metaclass may only have one instance'.
    ].
    newClass := self basicNew.
    newClass
	setSuperclass:Object
	methodDictionary:(MethodDictionary new)
	instSize:0
	flags:(Behavior flagBehavior).
    myClass := newClass.
    ^ newClass

    "Modified: 1.4.1997 / 15:44:50 / stefan"
!

newClassBuilder
    ^ ClassBuilder new metaclass:self class.
! !

!Metaclass methodsFor:'enumerating'!

instAndClassSelectorsAndMethodsDo:aTwoArgBlock
    myClass instAndClassSelectorsAndMethodsDo:aTwoArgBlock
!

subclassesDo:aBlock
    "evaluate the argument, aBlock for all immediate subclasses.
     This will only enumerate globally known classes - for anonymous
     behaviors, you have to walk over all instances of Behavior."

    "metaclasses are not found via Smalltalk allClassesDo:
     here, walk over classes and enumerate corresponding metas"

    self soleInstance subclassesDo:[:aSubClass |
	aBlock value:aSubClass class
    ].
! !

!Metaclass methodsFor:'fileOut'!

basicFileOutDefinitionOf:aClass on:aStream withNameSpace:forceNameSpace withPackage:showPackage
    "append an expression on aStream, which defines myself."

    |syntaxHilighting|

    UserPreferences isNil ifTrue:[
	syntaxHilighting := false
    ] ifFalse:[
	syntaxHilighting := UserPreferences current syntaxColoring.
    ].
    self
	basicFileOutDefinitionOf:aClass
	on:aStream
	withNameSpace:forceNameSpace
	withPackage:showPackage
	syntaxHilighting:syntaxHilighting
!

basicFileOutDefinitionOf:aClass on:aStream withNameSpace:forceNameSpace withPackage:showPackage syntaxHilighting:syntaxHilighting
    "append an expression on aStream, which defines myself."

    |s owner namespace nsName fullName forceNoNameSpace superNameWithoutNameSpacePrefix cls topOwner
     superclass superclassNamespace nm useStoreString boldOn boldOff pkg|

    syntaxHilighting ifTrue:[
        boldOn := [aStream bold].
        boldOff := [aStream normal].
    ].

    fullName := FileOutNameSpaceQuerySignal query == true.
    owner := aClass owningClass.
    namespace := aClass topNameSpace.

    (showPackage and:[owner isNil]) ifTrue:[
        pkg := aClass getPackage.
        (pkg notNil and:[pkg ~= PackageId noProjectID]) ifTrue:[
            aStream nextPutAll:'"{ Package: '''.
            aStream nextPutAll:aClass package asString.
            aStream nextPutAll:''' }"'; cr; cr.
        ]
    ].


"/  No, always use namespace pragma, otherwise when reading back
"/  from stream, we need somehow to tell what's namespace and what's
"/  a private class in another class. So namespaces are **aleays** denoted by
"/  namespace pragma.

    "/ the backward compatible namespace directive is only used
    "/ for non-private classes.
    "/ Private classes cannot be filed into another smalltalk anyway,
    "/ and there is no need to complicate global lookup in stc...
"/ 
"/    owner notNil ifTrue:[
"/        forceNoNameSpace := ForceNoNameSpaceQuerySignal query == true.
"/        forceNoNameSpace ifFalse:[
"/            fullName := true.
"/        ]
"/    ].

    fullName ifFalse:[
        (owner isNil or:[forceNameSpace]) ifTrue:[
            (namespace notNil and:[namespace ~~ Smalltalk]) ifTrue:[
                nsName := namespace name.
                (nsName includes:$:) ifTrue:[
                    nsName := '''' , nsName , ''''
                ].
                aStream nextPutAll:'"{ NameSpace: '.
                boldOn value.
                aStream nextPutAll:nsName.
                boldOff value.
                aStream nextPutAll:' }"'; cr; cr.
            ] ifFalse:[
                "/ always write a namespace directive - even for smalltalk classes.
                "/ reason: the fileout might go into a big file containing multiple classes
                "/ in different namespaces (otherwise, the smalltalk class would later be filed into
                "/ the previous class's namespace)
                aStream nextPutAll:'"{ NameSpace: Smalltalk }"'; cr; cr.
            ].
        ].
    ].

    "take care of nil-superclass"
    superclass := aClass superclass.
    superclass isNil ifTrue:[
        s := 'nil'
    ] ifFalse:[
        superclassNamespace := superclass nameSpace.

        "/ be careful: if the superclasses ns is Smalltalk,
        "/ AND this is the definition of a private class,
        "/ AND a private class with the same name as my superclas
        "/ exists in my owning class,
        "/ THEN we MUST add the smalltalk-prefix.
        "/ (otherwise, we get the private class as superclass when accepting the
        "/  next time)
        (owner notNil
        and:[ superclassNamespace == Smalltalk
        and:[ (owner privateClassesAt:superclass name) notNil ]]) ifTrue:[
            s := superclass nameWithNameSpacePrefix.
        ] ifFalse:[
            fullName ifTrue:[
                s := superclass name.
            ] ifFalse:[
                (namespace == superclassNamespace
                and:[superclass owningClass isNil]) ifTrue:[
                    "/ superclass is in the same namespace and not private;
                    "/ still prepend namespace prefix for private classes,
                    "/  to avoid confusing stc, which needs that information.
                    "/ LATE note (AUG2002) - no longer; stc was fixed.
"/                owner notNil ifTrue:[
"/                    s := superclass name
"/                ] ifFalse:[
                        s := superclass nameWithoutPrefix
"/                ]
                ] ifFalse:[
                    "/ a very special (rare) situation:
                    "/ my superclass resides in another nameSpace,
                    "/ but there is something else named like this
                    "/ to be found in my nameSpace (or a private class)

                    superNameWithoutNameSpacePrefix := superclass nameWithoutNameSpacePrefix asSymbol.
                    cls := aClass privateClassesAt:superNameWithoutNameSpacePrefix.
                    cls isNil ifTrue:[
                        (topOwner := aClass topOwningClass) isNil ifTrue:[
                            namespace := aClass nameSpace.
                            namespace notNil ifTrue:[
                                cls := namespace privateClassesAt:superNameWithoutNameSpacePrefix
                            ] ifFalse:[
                                "/ aClass error:'unexpected nil namespace'
                            ]
                        ] ifFalse:[
                            cls := topOwner nameSpace at:superNameWithoutNameSpacePrefix.
                        ]
                    ].
                    (cls notNil and:[cls ~~ superclass]) ifTrue:[
                        s := superclassNamespace name , '::' , superNameWithoutNameSpacePrefix
                    ] ifFalse:[
                        "/ no class with that name found in my namespace ...
                        "/ if the superclass resides in Smalltalk,
                        "/ suppress prefix; otherwise, use full prefix.
                        (superclassNamespace notNil
                         and:[superclassNamespace ~~ Smalltalk]) ifTrue:[
                            (owner notNil
                             and:[(topOwner := owner topOwningClass) notNil
                             and:[superclass topOwningClass notNil
                             and:[topOwner nameSpace == superclass topOwningClass "owningClass" nameSpace]
                            ]]) ifTrue:[
                                s := superNameWithoutNameSpacePrefix
                            ] ifFalse:[
                                namespace == superclass topNameSpace ifTrue:[
                                    s := superNameWithoutNameSpacePrefix
                                ] ifFalse:[
                                    s := superclass name
                                ]
                            ]
                        ] ifFalse:[
                            s := superNameWithoutNameSpacePrefix
                        ]
                    ]
                ]
            ]
        ]
    ].

    boldOn value.
    aStream nextPutAll:s.   "/ superclass
    boldOff value.
    aStream space.
    aClass basicFileOutInstvarTypeKeywordOn:aStream.

    useStoreString := false.
    (fullName and:[owner isNil]) ifTrue:[
        nm := aClass name.
        useStoreString := true.
    ] ifFalse:[
        nm := aClass nameWithoutPrefix.
        nm isValidSmalltalkIdentifier ifFalse:[
            useStoreString := true.
        ].
    ].
    aStream nextPut:$#.
    useStoreString ifTrue:[
        aStream nextPutAll:''''.
    ].
    boldOn value.
    aStream nextPutAll:nm.
    boldOff value.
    useStoreString ifTrue:[
        aStream nextPutAll:''''.
    ].

    aStream crtab.
    aStream nextPutAll:'instanceVariableNames:'''.
    boldOn value.
    aClass printInstVarNamesOn:aStream indent:16.
    boldOff value.
    aStream nextPutAll:''''.

    aStream crtab.
    aStream nextPutAll:'classVariableNames:'''.
    boldOn value.
    aClass printClassVarNamesOn:aStream indent:16.
    boldOff value.
    aStream nextPutAll:''''.

    aStream crtab.
    aStream nextPutAll:'poolDictionaries:'''.
    boldOn value.
    aClass printSharedPoolNamesOn:aStream indent:16.
    boldOff value.
    aStream nextPutAll:''''.

    aStream crtab.
    owner isNil ifTrue:[
        "/ a public class
        aStream nextPutAll:'category:'.
        aClass category isNil ifTrue:[
            s := ''''''
        ] ifFalse:[
            s := aClass category asString storeString
        ].
        aStream nextPutAll:s.
    ] ifFalse:[
        "/ a private class
        aStream nextPutAll:'privateIn:'.
        boldOn value.
        fullName ifTrue:[
            s := owner name.
        ] ifFalse:[
            s := owner nameWithoutNameSpacePrefix.
        ].
        aStream nextPutAll:s.
        boldOff value.
    ].
    aStream cr

    "Created: / 04-01-1997 / 20:38:16 / cg"
    "Modified: / 18-03-1999 / 18:15:46 / stefan"
    "Modified: / 08-10-2007 / 13:28:59 / cg"
    "Modified: / 06-03-2014 / 10:32:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOutClassInstVarDefinitionOn:aStream withNameSpace:withNameSpace
    "append an expression to define my classInstanceVariables on aStream"

    |anySuperClassInstVar|

    myClass isLoaded ifFalse:[
	^ myClass basicFileOutDefinitionOn:aStream withNameSpace:withNameSpace
    ].

    withNameSpace ifTrue:[
	myClass name printOn:aStream.
    ] ifFalse:[
	myClass printClassNameOn:aStream.
    ].
    aStream nextPutAll:' class instanceVariableNames:'''.
    self printInstVarNamesOn:aStream indent:8.
    aStream nextPutAll:''''.

    "mhmh - good idea; saw this in SmallDraw sourcecode ..."

    anySuperClassInstVar := false.
    myClass allSuperclassesDo:[:aSuperClass |
	aSuperClass class instVarNames do:[:ignored | anySuperClassInstVar := true].
    ].

    aStream cr; cr; nextPut:(Character doubleQuote); cr; space.
    anySuperClassInstVar ifFalse:[
	aStream
	    nextPutLine:'No other class instance variables are inherited by this class.'.
    ] ifTrue:[
	aStream
	    nextPutLine:'The following class instance variables are inherited by this class:'.
	aStream cr.
	myClass allSuperclassesDo:[:aSuperClass |
	    aStream tab; nextPutAll:aSuperClass name; nextPutAll:' - '.
	    aStream nextPutLine:(aSuperClass class instanceVariableString).
	].

    ].
    aStream nextPut:(Character doubleQuote); cr.

    "Created: / 10.12.1995 / 16:31:25 / cg"
    "Modified: / 1.4.1997 / 16:00:33 / stefan"
    "Modified: / 3.2.2000 / 23:05:28 / cg"
!

fileOutDefinitionOn:aStream
    myClass fileOutClassInstVarDefinitionOn:aStream

    "Modified: / 21.6.1998 / 04:10:02 / cg"
!

fileOutOn:outStreamArg withTimeStamp:stampIt withInitialize:initIt withDefinition:withDefinition methodFilter:methodFilter encoder:encoderOrNil
    "file out my definition and all methods onto aStream.
     If stampIt is true, a timeStamp comment is prepended.
     If initIt is true, and the class implements a class-initialize method,
     append a corresponding doIt expression for initialization.
     The order by which the fileOut is done is used to put the version string at the end.
     Thus, if the version string is expanded (by CVS), the characterPositions of methods should not move"

    self programmingLanguage sourceFileWriterClass new
        fileOut:myClass on:outStreamArg withTimeStamp:stampIt
        withInitialize:initIt withDefinition:withDefinition
        methodFilter:methodFilter encoder:encoderOrNil
! !

!Metaclass methodsFor:'method templates'!

versionMethodTemplateForSourceCodeManager:aSourceCodeManager
    ^ aSourceCodeManager versionMethodTemplateForSmalltalk
! !

!Metaclass methodsFor:'misc ui support'!

iconInBrowserSymbol
    "can be redefined for a private icon in the browser.
     The returned symbol must be a selector of the ToolbarIconLibrary."

    ^ nil
! !

!Metaclass methodsFor:'private'!

setSoleInstance:aClass
    myClass := aClass

    "Created: 12.12.1995 / 13:46:22 / cg"
! !

!Metaclass methodsFor:'queries'!

category
    "return my category"

    myClass isNil ifTrue:[^ nil].
    ^ myClass category

    "Created: 2.4.1997 / 00:46:11 / stefan"
!

comment
    "return my comment"

    ^ myClass comment

    "Created: 2.4.1997 / 00:51:35 / stefan"
!

getPackage
    "return my package-id"

    ^ myClass getPackage

    "Created: 15.10.1996 / 19:44:51 / cg"
!

hasExtensions
    "return true if I have extensions"

    ^ myClass hasExtensions

!

hasExtensionsFrom:aPackageID
    "return true if I have extensions from a package"

    ^ myClass hasExtensionsFrom:aPackageID
!

isBuiltInClass
    "return true if this class is known by the run-time-system.
     Here, true is returned for myself, false for subclasses."

    ^ self == Metaclass class or:[self == Metaclass]

    "Created: 15.4.1996 / 17:17:34 / cg"
    "Modified: 23.4.1996 / 15:59:37 / cg"
!

isMeta
    "return true, if the receiver is some kind of metaclass;
     true is returned here. Redefines isMeta in Object"

    ^ true
!

name
    "return my name - that is the name of my sole class, with ' class'
     appended."

    |nm|

    myClass isNil ifTrue:[
	^ #someMetaclass
    ].

    (nm := myClass name) isNil ifTrue:[
	'Metaclass [warning]: no name in my class' errorPrintCR.
	^ #'unnamed class'
    ].
    ^ nm , ' class'

    "Modified: 10.1.1997 / 17:55:08 / cg"
    "Modified: 1.4.1997 / 15:53:11 / stefan"
!

nameSpace
    "return the nameSpace I am contained in.
     Due to the implementation of nameSpaces (as classVariables),
     a class can only be contained in one nameSpace (which is the desired)"

    "/ this information is in the class

    ^ myClass nameSpace

    "Created: 7.11.1996 / 13:18:52 / cg"
!

owningClass
    "return nil here - regular metaclasses are never private"

    ^ nil

    "Created: 12.10.1996 / 20:12:16 / cg"
!

package
    "return my package-id"

    ^ myClass package

    "Created: 15.10.1996 / 19:44:51 / cg"
!

sharedPools
    ^ myClass sharedPools
!

soleInstance
    "return my sole class."

    ^ myClass
!

subclasses
    "ask my non-meta for subclasses"

    ^ myClass subclasses collect:[:theNonMetaClass | theNonMetaClass class].

    "
     Integer class subclasses
    "
!

theMetaclass
    "return the metaClass of the class-meta pair.
     Here, return myself, because I am the metaclass.
     Also implemented in my class, which also returns me."

    ^ self

    "Created: / 30.1.2000 / 23:08:15 / cg"
    "Modified: / 31.1.2000 / 16:15:00 / cg"
!

theNonMetaclass
    "return the nonMetaClass of the class-meta pair.
     Here, return my class object, because I am the metaclass.
     Also implemented in my class, which returns itself.
     Sigh: ST/X naming; Squeak calls this theNonMetaClass"

    ^ self soleInstance

    "Created: / 30.1.2000 / 23:08:11 / cg"
    "Modified: / 31.1.2000 / 16:17:02 / cg"
!

topOwningClass
    "return nil here - regular metaclasses are never private"

    ^ nil

    "Created: 3.1.1997 / 19:18:06 / cg"
! !

!Metaclass methodsFor:'source management'!

binaryRevision
    ^ myClass binaryRevision

    "
     Object binaryRevision
     Object class binaryRevision
    "

    "Modified: 2.4.1997 / 01:17:04 / stefan"
!

binaryRevisionString
    ^ myClass binaryRevisionString

    "
     Object binaryRevisionString
     Object class binaryRevisionString
    "

    "Modified: / 02-04-1997 / 01:17:04 / stefan"
    "Created: / 01-07-2011 / 10:55:39 / cg"
!

sourceCodeManagerFromBinaryRevision

    ^ myClass sourceCodeManagerFromBinaryRevision

    "Modified: / 01-04-1997 / 14:36:31 / stefan"
    "Created: / 06-10-2011 / 09:34:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourceFileSuffix
    ^ self programmingLanguage sourceFileSuffix

    "Modified: / 15-08-2009 / 22:46:44 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 28-06-2011 / 13:44:36 / cg"
!

sourceStream
    "return the classes source stream"

    ^ myClass sourceStream

    "Modified: 1.4.1997 / 14:36:31 / stefan"
!

sourceStreamFor:sourceFileName
    "return the sourceStream for a sourceFileName"

    ^ myClass sourceStreamFor:sourceFileName

    "Modified: 1.4.1997 / 14:36:38 / stefan"
! !

!Metaclass class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


Metaclass initialize!
