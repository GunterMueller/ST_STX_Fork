"
 COPYRIGHT (c) 1993 by Claus Gittinger
 COPYRIGHT (c) 2015 Jan Vrany
 COPYRIGHT (c) 2017 Jan Vrany
	       All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic3' }"

"{ NameSpace: Smalltalk }"

ClassChange subclass:#MethodChange
	instanceVariableNames:'selector methodCategory privacy previousVersion'
	classVariableNames:'LastReplacementClass'
	poolDictionaries:''
	category:'System-Changes'
!

MethodChange subclass:#NamedMethodChange
	instanceVariableNames:'changeName'
	classVariableNames:''
	poolDictionaries:''
	privateIn:MethodChange
!

!MethodChange class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
 COPYRIGHT (c) 2015 Jan Vrany
 COPYRIGHT (c) 2017 Jan Vrany
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
    instances represent method-changes (as done in the browser). 
    They are typically held in a ChangeSet.

    [author:]
        Claus Gittinger
"
! !

!MethodChange class methodsFor:'instance creation'!

class:cls selector:sel source:src category:cat
    ^ self basicNew class:cls selector:sel source:src category:cat
!

className:clsName selector:sel source:src category:cat
    ^ self basicNew className:clsName selector:sel source:src category:cat
! !

!MethodChange methodsFor:'accessing'!

category
    ^ methodCategory 
!

category: aCategory
    methodCategory := aCategory

    "Created: / 7.2.1998 / 19:47:53 / cg"
!

changeMethod
    |cls|

    selector isNil ifTrue:[ ^ nil ].
    cls := self changeClass.
    (cls isNil or:[selector isNil]) ifTrue:[^ nil].
    ^ cls compiledMethodAt:selector asSymbol

    "Created: / 07-02-1998 / 19:47:53 / cg"
    "Modified: / 14-07-2014 / 09:43:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeSelector
    ^ selector

    "Created: / 6.2.1998 / 13:29:25 / cg"
!

class:cls selector:sel source:src category:cat
    self className:(cls name) selector:sel source:src category:cat
!

classIsJava
    "Returns true, if this change is for Java class (i.e., if it is for
     Smalltalk method that extends Java class)"

    ^ classIsJava

    "Modified (comment): / 29-01-2013 / 14:11:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classIsJava:aBoolean
    "Sets whether this change is for Java class (i.e., if it is for
     Smalltalk method that extends Java class)"

    classIsJava := aBoolean.

    "Modified (comment): / 29-01-2013 / 14:11:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

className
    classIsJava == true ifTrue:[ ^ className].
    ^ super className

    "Created: / 29-01-2013 / 14:21:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-01-2013 / 10:00:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

className:clsName selector:sel source:src category:cat
    self className:clsName selector:sel source:src category:cat privacy:nil
!

className:clsName selector:sel source:src category:cat privacy:priv
    self assert:(src isString).
    self assert:(sel isString or:[sel isSymbol]).

    className := clsName.
    selector := sel.
    source := src.
    methodCategory := cat.
    privacy := priv.

    "Created: / 16.2.1998 / 12:29:49 / cg"
    "Modified: / 16.2.1998 / 14:28:12 / cg"
!

deltaDetail
    "Returns a delta to the current state as a ChangeDelta object"

    | mth mySource imageSource|

    self isMethodCodeChange ifFalse:[^super deltaDetail].
    mth := self changeMethod.
    mth isNil ifTrue:[^ ChangeDeltaInformation added ].
    mySource := self source.
    imageSource := mth source.

    (self class isSource: mySource sameSourceAs: imageSource) ifTrue:[ 
        ^ ChangeDeltaInformation identical 
    ].
    ^ ChangeDeltaInformation different

    "Created: / 31-08-2011 / 10:27:58 / cg"
!

imageSource
    "return the source for the in-image version of the method"

    | mth |

    self isMethodCodeChange ifFalse:[^ super imageSource].
    mth := self changeMethod.
    ^ mth isNil 
        ifTrue: [nil] 
        ifFalse:[mth source]

    "Created: / 19-07-2011 / 12:02:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 25-07-2012 / 17:37:52 / cg"
!

methodCategory

    ^ methodCategory

    "Created: / 7.2.1998 / 19:47:53 / cg"
!

previousPackage
    | isNewMethod |
    isNewMethod := self previousVersion isNil.
    isNewMethod ifFalse:[
        ^ self previousVersion package.
    ].

    ^ nil
!

previousVersion
    "return the value of the instance variable 'previousVersion' (automatically generated)"

    ^ previousVersion
!

previousVersion:something
    "set the value of the instance variable 'previousVersion' (automatically generated)"

    previousVersion := something.
!

previousVersionSource
    "return the value of the instance variable 'previousVersion' (automatically generated)"

    previousVersion isNil ifTrue:[^ nil].
    ^ previousVersion source
!

privacy

    ^privacy ? #public

    "Created: / 19-03-2012 / 18:16:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selector
    ^ selector

    "Created: / 6.2.1998 / 13:29:25 / cg"
!

selector:aSymbol
    self assert:(aSymbol isSymbol).

    selector := aSymbol

    "Created: / 6.2.1998 / 13:29:25 / cg"
! !

!MethodChange methodsFor:'applying'!

apply
    "apply the change"

    |class replacementClassName suggestion oldMethodOrNil oldPackage 
     newPackage newMethod defClass|

    class := self changeClass.
    class isNil ifTrue:[
        "/ try the same replacement class again
        (LastReplacementClass notEmptyOrNil 
            and:[ (class := Smalltalk classNamed:LastReplacementClass) notNil
            and:[ 
                (className endsWith:' class') ifTrue:[
                    class := class theMetaclass
                ] ifFalse:[
                    class := class theNonMetaclass
                ].
                class nameWithoutPrefix = className    
            ]])
        ifFalse:[
            "/ try a replacement class in the same namespace again
            (className includesString:'::') ifTrue:[
                suggestion := className copyFrom:(className lastIndexOf:$:)+1.
                (Smalltalk classNamed:suggestion) isBehavior ifFalse:[
                    suggestion := nil.
                ].
            ].
            suggestion := suggestion ? LastReplacementClass.
            
            (class notNil
            and:[ (class := class nameSpace classNamed:className) notNil
            and:[ 
                (className endsWith:' class') ifTrue:[
                    class := class theMetaclass
                ] ifFalse:[
                    class := class theNonMetaclass
                ].
                class nameWithoutPrefix = className    
            ]])
            ifFalse:[
                |action resources|

                resources := self class projectDefinitionClass classResources.
                
                "/ ask for a repair action
                action := OptionBox
                            request:(resources stringWithCRs:'Cannot apply change for missing class: %1\\Please choose a repair action:\- choose a replacement class\- define a dummy class\- skip this change\- cancel the load operation' 
                                     with:className) 
                            buttonLabels:(resources array:#('Replace...' 'Create New...' 'Skip' 'Cancel'))
                            values:#(replace create skip cancel).
                action == #skip ifTrue:[^ self].
                action == #cancel ifTrue:[ AbortOperationRequest raise].
                action == #replace ifTrue:[
                    replacementClassName := Dialog 
                                    requestClassName:(resources 
                                                            string:'Replacement class for "%1"?' 
                                                            with:className)
                                    initialAnswer:suggestion.
                ] ifFalse:[
                    replacementClassName := Dialog 
                                    requestClassName:(resources 
                                                            stringWithCRs:'Create dummy class for "%1"?\(will be created in Namespace "%2")' 
                                                            with:className with:(Class nameSpaceQuerySignal query ? Smalltalk) name)
                                    initialAnswer:suggestion.
                ].    
                replacementClassName isEmptyOrNil ifTrue:[ AbortOperationRequest raise ].

                action == #create ifTrue:[
                    Object 
                        subclass:(replacementClassName asSymbol)
                        instanceVariableNames:''
                        classVariableNames:''
                        poolDictionaries:''
                        category:'* dummy for porting *'
                ].    
                class := Smalltalk classNamed:replacementClassName.
                class isNil ifTrue:[
                    class := (Class nameSpaceQuerySignal query ? Smalltalk) classNamed:replacementClassName.
                    class isNil ifTrue:[
                        self error:(resources string:'Cannot apply change for missing class: %1' with:replacementClassName) mayProceed:true.
                        ^ self
                    ].
                ].
"/                (className endsWith:' class') ifTrue:[
"/                    class := class theMetaclass
"/                ] ifFalse:[
"/                    class := class theNonMetaclass
"/                ].

                LastReplacementClass := replacementClassName.
            ]
        ]
    ].
    class autoload.

    newPackage := package notNil ifTrue:[package] ifFalse:[Class packageQuerySignal query].

    "/ if overwriting an existing method from another package,
    "/ put the existing method into the packagessafe
    oldMethodOrNil := class compiledMethodAt:selector.
    oldMethodOrNil notNil ifTrue:[
        oldPackage := oldMethodOrNil package.
        (newPackage notNil and:[newPackage ~= oldPackage]) ifTrue:[
            defClass := oldPackage asPackageId projectDefinitionClass.
            defClass notNil ifTrue:[
                defClass rememberOverwrittenMethod:oldMethodOrNil inClass:class.
            ]
        ].
    ].

    newMethod := class compile:source classified:methodCategory logged:true.
    newMethod notNil ifTrue:[
        newMethod package: newPackage.
    ].

    "Modified: / 07-09-2011 / 21:09:19 / cg"
    "Modified: / 29-03-2014 / 23:29:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-07-2017 / 21:17:56 / jv"
! !

!MethodChange methodsFor:'comparing'!

isConflict
    "true if this change is different than what is already in the image
     (i.e. it overwrites some existing code)"

    |cls mthd|

    (cls := self changeClass) isNil ifTrue:[^ false].
    (mthd := cls compiledMethodAt:selector) isNil ifTrue:[^ false].
    ^ mthd category ~= methodCategory
    or:[ mthd source ~= self source ]
!

isForSameAs:changeB
    "return true, if the given change represents a change for the same
     thingy as the receiver (i.e. same method, same definition etc.)."

    "/ I am a methodChange - B must be as well.
    changeB isMethodChange ifFalse:[^ false].   

    selector ~= changeB selector ifTrue:[^ false].
    className ~= changeB className ifTrue:[^ false].

    ^ true
!

sameAs:changeB
    "return true, if the given change represents the same change as the receiver."

    (self isForSameAs:changeB) ifFalse:[^ false].   
    (self sameSourceAs:changeB) ifTrue:[^ true].

    ^ false.

    "Modified: / 25-07-2006 / 11:23:27 / cg"
! !

!MethodChange methodsFor:'converting'!

asNamedMethodChange
    ^ NamedMethodChange fromMethodChange:self
! !

!MethodChange methodsFor:'fileout'!

basicFileOutOn: aStream

    |cat |

    self isMethodCodeChange ifFalse:[^super basicFileOutOn: aStream].

    aStream nextPutChunkSeparator.
    nameSpaceName notEmptyOrNil ifTrue:[
        nameSpaceName printOn:aStream.
        aStream nextPutAll:'::'.
    ].
    self className printOn:aStream.
"/        self printClassNameOn:aStream.

    (privacy ? #public) ~~ #public ifTrue:[
        aStream space; nextPutAll:privacy; nextPutAll:'MethodsFor:'.
    ] ifFalse:[
        aStream nextPutAll:' methodsFor:'.
    ].

    cat := methodCategory ? ''.
    aStream nextPutAll:cat asString storeString.
    aStream nextPutChunkSeparator; cr; cr.

    source := self source.
    source isNil ifTrue:[
        ClassDescription fileOutErrorSignal
            raiseRequestWith:self
            errorString:(' - no source for method: ' ,
                         self className , '>>' , selector).

    ] ifFalse:[
        aStream nextChunkPut:source.
    ].
    aStream space.
    aStream nextPutChunkSeparator.
    aStream cr; cr

    "Modified: / 05-12-2009 / 12:38:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MethodChange methodsFor:'printing & storing'!

printOn:aStream
    "append a user printed representation of the receiver to aStream.
     The format is suitable for a human - not meant to be read back."

    aStream
        nextPutAll:(self fullClassName ? 'unnamed');
        nextPutAll:' >> ';
        nextPutAll:(selector ? '?');
        nextPutAll:' {';
        nextPutAll:(methodCategory ? '?');
        nextPutAll:'}'

    "Modified: / 04-10-2006 / 16:46:01 / cg"
    "Modified: / 07-11-2008 / 08:29:03 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

printWithoutClassNameOn:aStream
    (className endsWith:' class') ifTrue:[
        aStream nextPutAll:'class '
    ].
    aStream nextPutAll:selector 
!

printWithoutOwningClassOn:aStream
    self breakPoint:#cg.
    (className endsWith:' class') ifTrue:[
        aStream nextPutAll:'class '
    ].
    aStream nextPutAll:selector 
!

sourceForMethod
    ^ '(' , className , ' compiledMethodAt:' , selector asSymbol storeString, ')'

    "Created: / 09-10-2006 / 13:58:09 / cg"
! !


!MethodChange methodsFor:'testing'!

isMethodChange
    "true if this is a method related change"

    ^ true

    "Created: / 7.2.1998 / 19:26:59 / cg"
!

isMethodChangeForCopyrightMethod
    ^self isMethodCodeChange and: [ self isForMeta and: [ self selector == #copyright ] ]

    "Created: / 01-08-2012 / 16:33:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isMethodChangeForExtensionsVersionMethod
    "true if this is a change for an extensionsVersion method"

    ^  self isMethodCodeChange
    and:[ AbstractSourceCodeManager isExtensionsVersionMethodSelector:self selector ]
!

isMethodChangeForVersionMethod
    "true if this is a change for a version method"

    ^  self isMethodCodeChange
    and:[ AbstractSourceCodeManager isVersionMethodSelector:self selector ]
!

isMethodCodeChange
    "true if this is a method's code change (not package, category etc.)"

    ^ true
! !

!MethodChange methodsFor:'visiting'!

acceptChangeVisitor:aVisitor
    ^ aVisitor visitMethodChange:self.

    "Created: / 25-11-2011 / 17:13:50 / cg"
! !

!MethodChange::NamedMethodChange class methodsFor:'instance creation'!

fromMethodChange:aMethodChange
    ^ self new cloneInstanceVariablesFrom:aMethodChange
! !

!MethodChange::NamedMethodChange methodsFor:'accessing'!

changeName:something
    changeName := something.
! !

!MethodChange::NamedMethodChange methodsFor:'printing & storing'!

printOn:aStream
    changeName notNil ifTrue:[
        changeName printOn:aStream.
        ^ self.
    ].
    super printOn:aStream
! !

!MethodChange class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

