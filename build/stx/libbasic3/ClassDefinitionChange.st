"
 COPYRIGHT (c) 1993 by Claus Gittinger
 COPYRIGHT (c) 2015 Jan Vrany
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

ClassChange subclass:#ClassDefinitionChange
	instanceVariableNames:'objectType superClassName classType indexedType otherParameters
		instanceVariableString classVariableString
		classInstanceVariableString poolDictionaries category private
		definitionSelector'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Changes'
!

!ClassDefinitionChange class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
 COPYRIGHT (c) 2015 Jan Vrany
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
    instances represent class definition-changes. 
    They are typically held in a ChangeSet.

    [author:]
        Claus Gittinger
"
! !

!ClassDefinitionChange methodsFor:'accessing'!

basicSuperClassName 
    ^ superClassName
!

category
    category isNil ifTrue:[
        self setupFromSource.
    ].
    ^ category

    "Modified: / 11-10-2006 / 14:12:01 / cg"
!

category:something
    category := something.
!

classInstanceVariableNames
    ^ self classInstanceVariableString asCollectionOfWords
!

classInstanceVariableNames:aCollectionOfWords
    self classInstanceVariableString:(aCollectionOfWords asStringWith:' ').
!

classInstanceVariableString
    ^ classInstanceVariableString ? ''
!

classInstanceVariableString:aString
    classInstanceVariableString := aString.
!

classVariableNames
    ^ self classVariableString asCollectionOfWords
!

classVariableNames:aCollectionOfWords
    self classVariableString:(aCollectionOfWords asStringWith:' ').
!

classVariableString
    ^ classVariableString ? ''
!

classVariableString:aString
    classVariableString := aString.
!

deltaDetail
    "Returns a delta to the current state as a ChangeDelta object"

    | class mySource imageSource myTree myClassDefTree imageTree imageClassDefTree same |

    class := self changeClass.
    class isNil ifTrue:[^ ChangeDeltaInformation added ].
    class isLoaded ifFalse:[^ ChangeDeltaInformation different ].
    mySource := self source.
    imageSource := self imageSource.
    same := (mySource = imageSource).
    same ifFalse:[
        same := (self class isSource: mySource sameSourceAs: imageSource ).
        same ifFalse:[
            "/ care for formatting (tabs, indentation etc.)
            myTree := RBParser parseExpression:mySource.
            imageTree := RBParser parseExpression:imageSource.
            same := (myTree = imageTree).
            same ifFalse:[
                "/ some classDefinition strings may contain whitespace
                "/ instVarName string like 'foo bar ' instead of 'foo bar' (i.e. added a space)...

                "/ Kludge for class instance variable definitions.
                "/ In that case, myTree is not the subclass:.. message send node but 
                "/ an sequence. In that case, make it a a subclass:... message send node
                "/ so the following code works...

                myClassDefTree := myTree isSequence 
                                    ifTrue:[ myTree statements first] 
                                    ifFalse:[ myTree ].
                imageClassDefTree := imageTree isSequence 
                                    ifTrue:[ imageTree statements first]
                                    ifFalse:[ imageTree ].

                ((myClassDefTree receiver = imageClassDefTree receiver)
                    and:[ (myClassDefTree selector = imageClassDefTree selector)
                    and:[ ('*ubclass:instanceVariableNames:classVariableNames:poolDictionaries:category:' match: myClassDefTree selector)
                    and:[ (myClassDefTree arguments at:1) = (imageClassDefTree arguments at:1)  

                    and:[ (2 to:5) conform:[:i |
                            ((myClassDefTree arguments at:i) isLiteral
                            and:[ (imageClassDefTree arguments at:i) isLiteral
                            and:[ (myClassDefTree arguments at:i) value asString asCollectionOfWords
                                  = (imageClassDefTree arguments at:i) value asString asCollectionOfWords ]]) ]   

                ]]]])
                    ifTrue:[
                        same := myTree isSequence == imageTree isSequence 
                                    and:[ myTree isSequence not or:[ myTree statements second = imageTree statements second]  ]
                    ]
            ].
        ]
    ].

    ^ same 
        ifTrue:[ ChangeDeltaInformation identical ]
        ifFalse:[ ChangeDeltaInformation different ]

    "Created: / 31-08-2011 / 10:26:42 / cg"
    "Modified: / 15-04-2015 / 11:09:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

imageSource
    "return the source for the in-image version of the method"

    | cls |

    cls := self changeClass.
    cls isNil ifTrue:[ ^ nil ].
    ^ cls class instanceVariableNames isEmptyOrNil ifTrue:[ 
        cls definitionWithoutPackage
    ] ifFalse:[ 
        String streamContents:[ :s|
            s nextPutAll: cls definitionWithoutPackage trimSeparators.
            s nextPut: $.; cr;cr.
            s nextPutAll:cls nameWithoutNameSpacePrefix;
              nextPutAll:' class instanceVariableNames: ';
              nextPutAll:cls class instanceVariableString storeString.     
        ]
    ].

    "Modified: / 15-04-2015 / 11:11:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

indexedType
    ^ indexedType
!

instanceVariableNames
    ^ self instanceVariableString asCollectionOfWords
!

instanceVariableNames:aCollectionOfWords
    self instanceVariableString:(aCollectionOfWords asStringWith:' ')
!

instanceVariableString
    ^ instanceVariableString ? ''
!

instanceVariableString:aString
    instanceVariableString := aString.
!

localClassName
    "for private classes, this returns the name relative to its owner;
     for non-private ones, this is the regular name.
     Notice that className always returns the full name (incl. any owner prefix)"

    self isPrivateClassDefinitionChange ifFalse:[^ self className].
    owningClassName isNil ifTrue:[^ self className].

    (className startsWith:(owningClassName,'::')) ifTrue:[
        ^ className copyFrom:(owningClassName size + 2 + 1).
    ] ifFalse:[
        "/ should not happen
        ^ self className
    ]
!

nameSpaceName
    | nm |

    nm := super nameSpaceName.
    ^nm.

"/    "/ JV: What is the following good for? Please explain..."
"/    objectType == #variable ifTrue:[
"/        ^ nil
"/    ].
"/    ^ self cutNameSpaceOf:(self nameSpaceOverride ? super nameSpaceName)

    "Modified: / 07-09-2011 / 20:47:14 / cg"
    "Modified: / 11-06-2013 / 17:18:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nameSpaceName: aNameSpaceName classType: aClassType otherParameters:otherParametersArg
    "this instance setup message is used when reading from a VW-xml change file.
     Support for this is not yet complete."

    | imports |

    nameSpaceName := aNameSpaceName.
    classType := aClassType.
    otherParameters := Dictionary new addAll:otherParametersArg; yourself.
    private := otherParameters at:#private: ifAbsent:nil.
    category := otherParameters at:#category: ifAbsent:nil.

    aClassType == #defineSharedVariable: ifTrue:[
    ] ifFalse:[
        superClassName := otherParameters at:#superclass: ifAbsent:nil.
        self assert:(superClassName notNil).
        superClassName notNil ifTrue:[
            superClassName := superClassName pathString.
        ].
        indexedType := otherParameters at:#indexedType: ifAbsent:nil.
        instanceVariableString := otherParameters at:#instanceVariableNames: ifAbsent:nil.
        classInstanceVariableString := otherParameters at:#classInstanceVariableNames: ifAbsent:nil.
        imports := otherParameters at:#imports: ifAbsent:nil.
    ].

    "Modified: / 15-06-2010 / 14:50:35 / cg"
    "Modified: / 12-12-2013 / 12:59:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

objectType
    "return the value of the instance variable 'objectType' (automatically generated)"

    ^ objectType
!

objectType:something
    "set the value of the instance variable 'objectType' (automatically generated)"

    objectType := something.
!

poolDictionaries
    poolDictionaries isNil ifTrue:[
        self setupFromSource.
    ].
    ^ poolDictionaries

    "Modified: / 13-06-2012 / 12:23:41 / cg"
!

poolDictionaries:something
    poolDictionaries := something.
!

private:aBoolean
    private := aBoolean.

    "Created: / 30-08-2010 / 13:56:11 / cg"
!

source
    "return the source of the change;
     either the original source or a synthesized"

    |src|

    (src := source) isNil ifTrue:[
        src := self definitionString
    ].
    ^ src

    "Modified: / 10-08-2012 / 11:53:54 / cg"
!

superClassName
    "returns nil, if no superclass"

    |nm|

    nm := superClassName.
    nm isNil ifTrue:[^ nil " 'nil' "].
    "/ convert VW namespace syntax
    (nm includes:$.) ifTrue:[
        ^ nm copyReplaceAll:$. withAll:'::'.
    ].
    ^ nm
!

superClassName:aString
    superClassName := aString.
    self assert:(aString notNil).
    self invalidateSource.
!

superClassNameWithoutMyNamespace
    |nm|

    superClassName isNil ifTrue:[^ 'nil'].

    nm := self cutMyNameSpaceOf:superClassName.
    (nm includes:$.) ifTrue:[
        ^ nm copyReplaceAll:$. withAll:'::'.
    ].
    ^ nm

    "Modified: / 03-03-2007 / 13:09:07 / cg"
!

superClassNameWithoutNamespace
    |nm|

    nm := self cutNameSpaceOf:superClassName.
    (nm includes:$.) ifTrue:[
        ^ nm copyReplaceAll:$. withAll:'::'.
    ].
    ^ nm
! !

!ClassDefinitionChange methodsFor:'applying'!

apply
    |changeClass sourceWithNamespace ns|

    superClassName isNil ifTrue:[
        self setupFromSource.
    ].
    "Some classes have nil superclass (such as Object)..."
    superClassName notNil ifTrue:[
        nameSpaceOverride notEmptyOrNil ifTrue:[
            "/ a q&d hack: need to find those which pass in a nameSpace isntead of a string
            (ns := nameSpaceOverride) isString ifFalse:[ ns := ns name ].
            (superClassName startsWith:(ns,'::')) ifFalse:[
                superClassName := (ns,'::',superClassName) asSymbol.
            ].
        ].
        (Smalltalk classNamed:superClassName) isNil ifTrue:[
            Class undeclared:superClassName
        ].
    ].

    "/ here, using the current namespace as provided by the query or the override,
    "/ generate a class definition with full names (i.e. incl. ns prefix).
    sourceWithNamespace := self source. 
    "/ as the namespace is already in the definition string, make sure that the namespace is not
    "/ added twice, by anwering Smalltalk now!!
    Class nameSpaceQuerySignal 
        answer:Smalltalk
        do:[
            Parser evaluate:sourceWithNamespace.       
        ].

    package notNil ifTrue:[
        changeClass := self changeClass.
        changeClass notNil ifTrue:[
            changeClass setPackage:package.
        ].
    ].

    "
      (ClassDefinitionChange className: #TestB source: 'TestA subclass: #TestB
          instanceVariableNames:''''
          classVariableNames:''''
          poolDictionaries:''''
          category:''* remove me *''')
          apply
    "

    "Modified: / 06-10-2011 / 17:01:58 / cg"
    "Modified: / 10-06-2013 / 17:12:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ClassDefinitionChange methodsFor:'comparing'!

isConflict
    "true if this change is different than what is already in the image
     (i.e. it overwrites some existing code)"

    |cls|

    (cls := self changeClass) isNil ifTrue:[^ false].
    cls superclass name ~= superClassName ifTrue:[ ^ true ].
    cls instanceVariableString ~= instanceVariableString ifTrue:[ ^ true ].
    cls classVariableString ~= classVariableString ifTrue:[ ^ true ].
    cls class instanceVariableString ~= (classInstanceVariableString ? '') ifTrue:[ ^ true ].
    cls poolDictionaries ~= poolDictionaries ifTrue:[ ^ true ].
    cls category ~= category ifTrue:[ ^ true ].
    cls isPrivate ifTrue:[
        cls owningClass name ~= owningClassName ifTrue:[ ^ true ].
    ].
    cls definitionSelector ~= self definitionSelector ifTrue:[ ^ true ].
    ^  false

    "Modified: / 12-02-2014 / 20:25:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isForSameAs:changeB
    "return true, if the given change represents a change for the same
     thingy as the receiver (i.e. same method, same definition etc.)."

    changeB isClassDefinitionChange ifFalse:[^ false].   
    ^ self className = changeB className.
!

sameAs:changeB
    "return true, if the given change represents the same change as the receiver."

    (self isForSameAs:changeB) ifFalse:[^ false].
    ^ self sameSourceAs:changeB



! !

!ClassDefinitionChange methodsFor:'converting'!

asAntiChange

    ^ClassRemoveChange className: self className

    "Created: / 02-11-2009 / 11:11:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ClassDefinitionChange methodsFor:'printing & storing'!

definitionString
    | ns  |

    ns := (self nameSpaceName) ? 'Smalltalk'.
    ^String streamContents:[:s|
        s nextPutAll: '"{ NameSpace: '; nextPutAll: ns;  nextPutAll: ' }"'.
        s cr; cr.
        s nextPutAll: (self definitionStringInNamespace: ns).
    ]

    "Modified (comment): / 13-04-2015 / 18:23:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

definitionStringInNamespace: nsOrNil
    | classNameUsed superClassNameUsed selPart ownerNameUsed classNameSymbolString |

    objectType == #variable ifTrue:[
        "/ a visualWorks static variable definition change.
        "/ kludge to be here - should be a separate StaticVariableDefinitionChange
        ^ String streamContents:[:stream |
            nsOrNil notNil ifTrue:[
                stream nextPutAll:((nsOrNil asCollectionOfSubstringsSeparatedBy:$.) asStringWith:'::')
            ] ifFalse:[
                self halt:'can this happen ?'.
                stream nextPutAll:'Smalltalk'
            ].

            stream 
                nextPutAll:' addClassVarName:';
                nextPutAll:className asString storeString
          ].
    ].

    superClassNameUsed := (self superClassName) ? 'nil'.
    "Strip of namespace"
    nsOrNil notNil ifTrue:[
        (superClassNameUsed startsWith: nsOrNil) ifTrue:[
            superClassNameUsed := superClassNameUsed copyFrom: nsOrNil size + 3
        ].
    ].

    "/ careful with private classes: the definition MUST give the
    "/ local name as argument, not the full name                                
    self isPrivateClassDefinitionChange ifTrue:[
        classNameUsed := self localClassName.
    ] ifFalse:[
        classNameUsed := className.
    ].

    "/ selPart is the subclass:/variableSubclass/variableByteSubclass:/... - part
    selPart := (self definitionSelector ? #'subclass:instanceVariableNames:classVariableNames:poolDictionaries:category:')
                    keywords first.         

    (classNameUsed first isLetter not or:[classNameUsed contains:[:c | c isLetterOrDigit not and:[c ~~ $_]]]) ifTrue:[
        classNameSymbolString := classNameUsed asSymbol storeString
    ] ifFalse:[
        classNameSymbolString := '#' , classNameUsed.
    ].

    ^ String streamContents:[:stream |
        stream 
            nextPutAll:superClassNameUsed;
            nextPutAll:' ',selPart;
            nextPutLine: classNameSymbolString;
            tab;
            nextPutAll:'instanceVariableNames:';
            nextPutLine:(instanceVariableString ? '') storeString;
            tab;
            nextPutAll:'classVariableNames:';
            nextPutLine:(classVariableString ? '') storeString;
            tab;
            nextPutAll:'poolDictionaries:';
            nextPutLine:(poolDictionaries ? '') storeString.
        (self isPrivateClassDefinitionChange and:[owningClassName notNil]) ifTrue:[
            ownerNameUsed := self owningClassName.    
            (nsOrNil isNil or:[nsOrNil ~~ nameSpaceName]) ifTrue:[
                (nsOrNil ? nameSpaceName) notNil ifTrue:[
                    ownerNameUsed := (nsOrNil ? nameSpaceName),'::',ownerNameUsed.
                ].
            ].
            stream 
                tab;
                nextPutAll:'privateIn:';
                nextPutAll:ownerNameUsed
        ] ifFalse:[
            stream 
                tab;
                nextPutAll:'category:';
                nextPutAll:(category ? '') asString storeString
        ].

        classInstanceVariableString notEmptyOrNil ifTrue:[
            stream nextPut:$.; cr; cr;
                   nextPutAll:classNameUsed; 
                   nextPutAll:' class instanceVariableNames: ';
                   nextPutAll:classInstanceVariableString storeString. 
        ].
      ]

    "Modified: / 13-06-2012 / 13:01:58 / cg"
    "Modified: / 15-04-2015 / 10:30:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

definitionStringWithoutNamespace
    "cg - huh - who needs that? (the definitionString already does NOT include the classes namespace)"

    |ns classNameUsed superClassNameUsed|

    ns := self nameSpaceOverride.

    objectType == #variable ifTrue:[
        ^ String streamContents:[:stream |
            ns notNil ifTrue:[
                stream 
                    nextPutAll:((ns asCollectionOfSubstringsSeparatedBy:$.) asStringWith:'::')
            ] ifFalse:[
                self halt:'can this happen ?'.
                stream 
                    nextPutAll:'Smalltalk'
            ].

            stream 
                nextPutAll:' addClassVarName:';
                nextPutAll:className asString storeString
          ].
    ].

    superClassNameUsed := self superClassName ? 'nil'.
    classNameUsed := self classNameWithoutNamespace.

    ^ String streamContents:[:stream |
        self isPrivateClassDefinitionChange ifFalse:[
            stream 
                nextPutAll:superClassNameUsed;
                nextPutAll:' subclass:';
                nextPutAll: classNameUsed asSymbol storeString
                ;
                cr;
                tab;
                nextPutAll:'instanceVariableNames:';
                nextPutAll:(instanceVariableString ? '') storeString;
                cr;
                tab;
                nextPutAll:'classVariableNames:';
                nextPutAll:(classVariableString ? '') storeString;
                cr;
                tab;
                nextPutAll:'poolDictionaries:';
                nextPutAll:(poolDictionaries ? '') storeString;
                cr;
                tab;
                nextPutAll:'category:';
                nextPutAll:(category ? '') storeString;
                cr
        ] ifTrue:[
            stream 
                nextPutAll:superClassNameUsed;
                nextPutAll:' subclass:';
                nextPutAll: (self className copyFrom: owningClassName size + 3) asSymbol storeString
                ;
                cr;
                tab;
                nextPutAll:'instanceVariableNames:';
                nextPutAll:(instanceVariableString ? '') storeString;
                cr;
                tab;
                nextPutAll:'classVariableNames:';
                nextPutAll:(classVariableString ? '') storeString;
                cr;
                tab;
                nextPutAll:'poolDictionaries:';
                nextPutAll:(poolDictionaries ? '') storeString;
                cr;
                tab;
                nextPutAll:'privateIn:';
                nextPutAll:
                    ((ns := self nameSpaceName) isNil
                        ifTrue:[owningClassName]
                        ifFalse:[owningClassName copyFrom: ns size + 3]);
                cr
        ]
    ]

    "Modified: / 06-10-2011 / 17:02:05 / cg"
    "Created: / 20-03-2012 / 16:37:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

printOn:aStream
    aStream 
        nextPutAll:className; nextPutAll:' {definition}'

    "Modified: / 12-10-2006 / 17:48:28 / cg"
!

printWithoutClassNameOn:aStream
    aStream nextPutAll:('definition of ' , className)


! !

!ClassDefinitionChange methodsFor:'queries'!

definitionSelector
    definitionSelector isNil ifTrue:[
        self setupFromSource.
        definitionSelector isNil ifTrue:[ 
            definitionSelector := #'subclass:instanceVariableNames:classVariableNames:poolDictionaries:category:'
        ].
    ].
    ^ definitionSelector

    "Modified: / 11-10-2006 / 14:11:44 / cg"
    "Modified: / 12-02-2014 / 20:25:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

definitionSelector:aSelector
    definitionSelector := aSelector

    "Created: / 13-06-2012 / 12:45:02 / cg"
!

owningClassName
    "the owner's name, excluding the namespace"

    self isPrivateClassDefinitionChange ifTrue:[
        owningClassName isNil ifTrue:[
            self setupFromSource.
        ].
    ].
    ^ owningClassName

    "Created: / 12-10-2006 / 23:07:25 / cg"
!

owningClassName:aStringOrSymbol
    owningClassName := aStringOrSymbol

    "Created: / 30-08-2010 / 13:55:37 / cg"
! !

!ClassDefinitionChange methodsFor:'special'!

installAsAutoloadedClassIfPublicWithFilename:aFilenameString
    "install the class defined by this change as autoloaded.
     Skip private classes.
     Enter class file name as abbreviation"

    |parseTree sel cat clsName cls catIdx pkg|

    private == true ifTrue:[^ self].

    parseTree := Parser parseExpression:self source.
    parseTree isMessage ifFalse:[
        self error:'bad change source'.
    ].

    sel := parseTree selector.
    (sel endsWith:':privateIn:') ifTrue:[^ self].

    catIdx := sel keywords indexOf:'category:'.  
    catIdx ~~ 0 ifTrue:[
        cat := (parseTree args at:catIdx) evaluate.
    ].

    clsName := self fullClassName "className" asSymbol.
    cls := Smalltalk at:clsName.

    pkg := package ? Project current package.   

    (cls isNil 
     or:[cls isBehavior not
     or:[cls isLoaded not]]) ifTrue:[
        |autoloadedClass|

        autoloadedClass := Smalltalk 
           installAutoloadedClassNamed:clsName 
           category:cat 
           package:pkg 
           revision:nil.
        aFilenameString notNil ifTrue:[
            autoloadedClass setClassFilename:aFilenameString.
            "/ Smalltalk setFilename:aFilenameString forClass:clsName package:pkg.
        ]
    ] ifFalse:[
        cls notNil ifTrue:[
            cls isBehavior ifTrue:[
                cls package ~= pkg ifTrue:[
Transcript showCR:('Autoloaded class: %1 (%4) not installed (package would change from %2 to %3)' 
                        bindWith:clsName with:cls package with:pkg with:aFilenameString).
                ]
            ].
        ].
    ].

    "Modified: / 03-07-2011 / 18:34:05 / cg"
!

invalidateSource
    "internal - flush the sourceString if it got invalidated due to a
     className, superclassName, etc... change"

    source := nil.
!

setupFromSource
    "Extract data from class definition string in source. 
     WARNING: This overwrites values in instvars!!"

    |parseTree catIdx poolIdx instVarIdx classVarIdx |

    source notNil ifTrue:[
        parseTree := Parser parseExpression:source.
        (parseTree notNil and:[parseTree isMessage]) ifFalse:[
            self error:'bad change source' mayProceed:true.
            ^ self
        ].

        definitionSelector := parseTree selector.

        private := (definitionSelector endsWith:':privateIn:').
        private ifTrue:[
            owningClassName := parseTree args last name.
        ].

        catIdx := definitionSelector keywords indexOf:'category:'.  
        catIdx ~~ 0 ifTrue:[
            category := (parseTree args at:catIdx) evaluate.
        ].

        poolIdx := definitionSelector keywords indexOf:'poolDictionaries:'.  
        poolIdx ~~ 0 ifTrue:[
            poolDictionaries := (parseTree args at:poolIdx) evaluate.
        ].

        instVarIdx := definitionSelector keywords indexOf:'instanceVariableNames:'.
        instVarIdx ~~ 0 ifTrue:[
            instanceVariableString := (parseTree args at:instVarIdx) value.
        ].

        classVarIdx := definitionSelector keywords indexOf:'classVariableNames:'.
        classVarIdx ~~ 0 ifTrue:[
            classVariableString := (parseTree args at:classVarIdx) value.
        ].


        "Care about nil superclasss (that's valid for certain
         classes like Object, ProtoObject or custom proxies"
        parseTree receiver isVariable ifTrue:[            
            superClassName := parseTree receiver name.
        ] ifFalse:[
            parseTree receiver isLiteral ifTrue:[
                superClassName := parseTree receiver value.
                superClassName notNil ifTrue:[
                    self error: 'Invalid superclass - can be either a class or nil'
                ]        
            ]        
        ].
    ].

    "Created: / 11-10-2006 / 14:10:02 / cg"
    "Modified: / 13-06-2012 / 12:25:10 / cg"
    "Modified: / 10-06-2013 / 17:07:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ClassDefinitionChange methodsFor:'testing'!

isClassDefinitionChange
    ^ true
!

isOrContainsClassDefinitionChange
    ^ true
!

isPrivateClassDefinitionChange
    "compute lazily; remember in private"

    private isNil ifTrue:[
        (className includes:$:) ifFalse:[
            "/ cannot be private
            private := false
        ] ifTrue:[
            source isNil ifTrue:[^ false ].
            (source includesString:'private') ifFalse:[
                private := false.
            ] ifTrue:[
"/                (self changeClass notNil
"/                and:[self changeClass isLoaded not]) ifTrue:[
"/                    "/ cannot be private
"/                    private := false
"/                ] ifTrue:[
                    self setupFromSource.
"/                ].
            ].
        ].
    ].
    ^ private

    "Created: / 11-10-2006 / 14:19:03 / cg"
    "Modified: / 16-11-2006 / 16:34:19 / cg"
!

isVariable
    indexedType notNil ifTrue:[
        self halt.
        ^ true.
    ].
    ^ false.
! !

!ClassDefinitionChange methodsFor:'visiting'!

acceptChangeVisitor:aVisitor
    ^ aVisitor visitClassDefinitionChange:self.

    "Created: / 25-11-2011 / 17:13:13 / cg"
! !

!ClassDefinitionChange class methodsFor:'documentation'!

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

