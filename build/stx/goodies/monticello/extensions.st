"{ Package: 'stx:goodies/monticello' }"!

!Annotation class methodsFor:'instance creation'!

mctimestamp: aString

    ^MCTimestampAnnotation new timestamp: aString

    "Created: / 14-09-2010 / 15:35:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Behavior methodsFor:'*monticello-squeakCompatibility'!

traitCompositionString
        ^ '{}'

    "Created: / 26-08-2009 / 12:43:23 / Jaroslav Havlin <havlij6@fel.cvut.cz>"
! !

!Behavior methodsFor:'*monticello-squeakCompatibility'!

typeOfClass
        "Answer a symbol uniquely describing the type of the receiver"
        "self instSpec = CompiledMethod instSpec ifTrue:[^#compiledMethod]." "Very special!!"
        self isBytes ifTrue:[^#bytes].
        (self isWords and:[self isPointers not]) ifTrue:[^#words].
        self isWeakPointers ifTrue:[^#weak].
        self isVariable ifTrue:[^#variable].
        ^#normal.

    "Created: / 26-08-2009 / 12:45:50 / Jaroslav Havlin <havlij6@fel.cvut.cz>"
! !

!Change methodsFor:'accessing'!

mcDefinition

    ^self objectAttributeAt: #mcDefinition

    "Created: / 08-11-2010 / 17:56:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Change methodsFor:'accessing'!

mcDefinition: aMCDefinition

    ^self objectAttributeAt: #mcDefinition put: aMCDefinition

    "Created: / 08-11-2010 / 17:56:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CharacterArray methodsFor:'*monticello-squeakCompatibility'!

asStringWithNativeLineEndings

    ^self copyReplaceAll:Character return with: Character cr

    "Created: / 12-09-2010 / 16:00:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-10-2010 / 17:27:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CharacterArray methodsFor:'*monticello-squeakCompatibility'!

asStringWithSqueakLineEndings

    ^self copyReplaceAll:Character cr with: Character return

    "Created: / 12-09-2010 / 16:00:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-10-2010 / 17:28:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Class methodsFor:'*monticello'!

asClassDefinition
    ^ MCClassDefinition
        name: self name
        superclassName: (self superclass isNil ifTrue:['nil'] ifFalse:[self superclass name])
        traitComposition: self traitCompositionString
        classTraitComposition: self class traitCompositionString
        category: self category 
        instVarNames: self instVarNames
        classVarNames: self classVarNames
        poolDictionaryNames: self poolDictionaryNames
        classInstVarNames: self class instVarNames
        type: self typeOfClass
        comment: (self organization classComment ? '') asStringWithSqueakLineEndings
        commentStamp: self organization commentStamp

    "Modified: / 12-09-2010 / 17:19:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Class methodsFor:'*monticello'!

classDefinitions
    self isLoaded ifFalse:[self autoload].
	^ Array with: self asClassDefinition
! !

!Class methodsFor:'*monticello'!

poolDictionaryNames
        ^ self sharedPools "/ collect: [:ea | ea name "self environment keyAtIdentityValue: ea"]
! !

!ClassDescription methodsFor:'*monticello-squeakCompatibility'!

mcDefinition

    |s|

    s := WriteStream on:(String new).
    self
        basicFileOutDefinitionOn:s
        withNameSpace:false
        withPackage:false.
    s position: s position - 1.

    ^ s contents

    "Created: / 11-09-2010 / 18:06:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Object methodsFor:'*monticello'!

isConflict
	^false
! !

!PackageInfo methodsFor:'testing'!

isMCStXPackageInfo
    ^ false

    "Created: / 29-05-2013 / 01:08:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectDefinition class methodsFor:'code generation'!

monticelloAncestry_code

    ^'#()'

    "Created: / 25-08-2011 / 16:49:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectDefinition class methodsFor:'accessing - monticello'!

monticelloName
    "Return name of the package for Monticello. 

     Historically, Monticello package membership is based on
     naming conventions. All classes whose category name starts with
     package name are considerer as belonging to the package, others
     do not. If classes' category does not match this naming convention,
     the package will fail to load back properly.

     Here, infer such prefix. Individual packages may override this method
     and return a string to enforce a particular name."
    
    | cats longest prefix index nm |

    cats := (self classes collect:[:each | each autoload; category ]) asSet.
    cats remove:#'* Projects & Packages *'.
    cats size == 1 ifTrue:[
        ^ cats anElement
    ].
    cats isEmpty ifTrue:[
        ^ 'Misc_Changes'
    ].
    longest := cats 
            inject:cats anElement
            into:[:cat :each | 
                each size > cat size ifTrue:[
                    each
                ] ifFalse:[ cat ]
            ].

    prefix := ''.
    [
        (index := longest indexOf:$- startingAt:prefix size + 2) ~~ 0
    ] whileTrue:[
        prefix := longest copyTo:index - 1.
        (cats allSatisfy:[:each | each startsWith:prefix ]) ifTrue:[
            nm := prefix.
        ].
    ].
    nm notNil ifTrue:[
        ^ nm
    ].
    ^ self package asString copyReplaceAny:':/' with:$_.

"/    self 
"/        error:'Cannot infer Monticello package name from class categories. Please define #mcName explicitly'

    "Created: / 29-05-2013 / 01:36:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-06-2013 / 21:12:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectDefinition class methodsFor:'accessing - monticello'!

monticelloNameForMCZ
    "Return the name of package used to build .mcz file.
     Defaults to sanitized monticelloName"

    ^self monticelloName asString copy replaceAll: $/ with: $_; replaceAll: $: with: $_

    "Created: / 07-06-2013 / 01:48:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectDefinition class methodsFor:'accessing - monticello'!

monticelloSplicemap
    "Return a splicemap for this package. This is used to forge a 
     'fake' ancestor when generating ancestry information out of 
     Mercurial (or anyt other) history. This should make merging 
     back into Squeak/Pharo a little easier as Monticello can (in theory)
     find a proper ancestor. 

     All this requires monticelloSplicemap being updated each time a code
     is merged from Monticello.

     The format of splicemap is a flat array of pairs 
     (commit id, MCVersionInfo to splice) as literal encoding.
    "
    ^#()

    "Created: / 07-09-2015 / 18:11:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectDefinition class methodsFor:'code generation'!

monticelloSplicemap_code
    ^ self monticelloSplicemap_codeFor:self monticelloSplicemap

    "Created: / 07-09-2015 / 17:58:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectDefinition class methodsFor:'code generation'!

monticelloSplicemap_codeFor:splicemap 
    ^ String 
        streamContents:[:s | 
            s nextPutLine:'monticelloSplicemap'.
            s
                nextPutAll:'    "';
                nextPutAll:(self class superclass lookupMethodFor:#monticelloSplicemap) 
                            comment;
                nextPutLine:'"'.
            s nextPutLine:''.
            s nextPutLine:'    ^ #('.
            splicemap 
                pairWiseDo:[:changeset :mcversion | 
                    s nextPutAll:'        '.
                    changeset storeOn:s.
                    s space.
                    mcversion storeOn:s.
                    s
                        cr;
                        cr.
                ].
            s nextPutLine:'    )'
        ].

    "
     stx_goodies_petitparser_compiler monticelloSplicemap_code"
    "Created: / 07-09-2015 / 17:58:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectDefinition class methodsFor:'code generation'!

monticelloTimestamps_code

    | methodsWithTimestamp |
    methodsWithTimestamp := OrderedCollection new.

    self classes do:[:cls|
        cls methodsDo:[:mthd|
            (mthd hasAnnotation: #mctimestamp:) ifTrue:[
                methodsWithTimestamp add: mthd
            ]
        ].
    ].
    self extensionMethods do:[:mthd|
        (mthd hasAnnotation: #mctimestamp:) ifTrue:[
            methodsWithTimestamp add: mthd                
        ]
    ].

    ^self monticelloTimestamps_codeFor: methodsWithTimestamp

    "
        stx_goodies_mondrian_core monticelloTimestamps_code
    "

    "Created: / 09-11-2010 / 18:23:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectDefinition class methodsFor:'code generation'!

monticelloTimestamps_codeFor: methods

    | code |
    code := String new writeStream.
    code nextPutAll:'monticelloTimestamps

    ^#('.
    methods do:[:mthd|
     code
        tab; tab; 
        nextPut:$(;
        nextPutAll: mthd mclass fullName;
        space;
        nextPutAll: mthd selector;
        space;
        nextPutAll: (mthd annotationAt: #mctimestamp:) timestamp storeString;        
        nextPut:$); 
        cr.
    ].
    code nextPutAll:'
    )'.

    ^code contents

    "
        stx_goodies_mondrian_core mcTimestamps_code
    "

    "Created: / 09-11-2010 / 18:27:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SequenceableCollection methodsFor:'*monticello-squeakCompatibility'!

copyReplaceAll: oldSubstring with: newSubstring asTokens: ifTokens
        "Answer a copy of the receiver in which all occurrences of
        oldSubstring have been replaced by newSubstring.
        ifTokens (valid for Strings only) specifies that the characters
        surrounding the recplacement must not be alphanumeric.
                Bruce Simth,  must be incremented by 1 and not 
        newSubstring if ifTokens is true.  See example below. "

        | aString startSearch currentIndex endIndex |
        (ifTokens and: [(self isString) not])
                ifTrue: [(self isKindOf: Text) ifFalse: [
                        self error: 'Token replacement only valid for Strings']].
        aString := self.
        startSearch := 1.
        [(currentIndex := aString indexOfSubCollection: oldSubstring startingAt: startSearch)
                         > 0]
                whileTrue: 
                [endIndex := currentIndex + oldSubstring size - 1.
                (ifTokens not
                        or: [(currentIndex = 1
                                        or: [(aString at: currentIndex-1) isAlphaNumeric not])
                                and: [endIndex = aString size
                                        or: [(aString at: endIndex+1) isAlphaNumeric not]]])
                        ifTrue: [aString := aString
                                        copyReplaceFrom: currentIndex
                                        to: endIndex
                                        with: newSubstring.
                                startSearch := currentIndex + newSubstring size]
                        ifFalse: [
                                ifTokens 
                                        ifTrue: [startSearch := currentIndex + 1]
                                        ifFalse: [startSearch := currentIndex + newSubstring size]]].
        ^ aString

"Test case:
        'test te string' copyReplaceAll: 'te' with: 'longone' asTokens: true   "

    "Created: / 26-08-2009 / 12:40:34 / Jaroslav Havlin <havlij6@fel.cvut.cz>"
! !

!Stream methodsFor:'*monticello'!

isMessageStream
	^ false
! !

!String methodsFor:'*monticello'!

extractNumber
	^ ('0', self select: [:ea | ea isDigit]) asNumber
! !

!String methodsFor:'*monticello-squeakCompatibility'!

withSqueakLineEndings
        "Answer a copy of myself in which all sequences of <CR><LF> or <LF> have been changed to <CR>"
        | newText |
        (self includes: Character lf) ifFalse: [ ^self copy ].
        newText := self copyReplaceAll: String crlf with: String cr.
        (newText asString includes: Character lf) ifFalse: [ ^newText ].
        ^newText copyReplaceAll: String lf with: String cr asTokens: false.

    "Created: / 26-08-2009 / 11:35:56 / Jaroslav Havlin <havlij6@fel.cvut.cz>"
! !

!StringCollection methodsFor:'converting'!

asStringWithNativeLineEndings

    ^self asString

    "Created: / 12-09-2010 / 15:58:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!StringCollection methodsFor:'converting'!

asStringWithSqueakLineEndings

    ^ self 
        asStringWith:Character return
        from:1 to:(self size) 
        compressTabs:false 
        final:nil

    "Created: / 12-09-2010 / 15:58:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Symbol methodsFor:'*monticello-squeakCompatibility'!

isDoIt
    ^ (self == #DoIt) or:[ self == #DoItIn: ].

    "Created: / 26-08-2009 / 11:46:44 / Jaroslav Havlin <havlij6@fel.cvut.cz>"
! !

!Timestamp class methodsFor:'*monticello-instance creation'!

fromMethodTimeStamp: aString
	| stream |
	stream := ReadStream on: aString.
	stream skipSeparators.
	stream skipTo: Character space.
	^self readFrom: stream.
! !

!Tools::NewSystemBrowser methodsFor:'menu actions-monticello'!

projectMenuMonticelloCommit
    | packageName package workingCopy |

    packageName := self theSingleSelectedProject.
    packageName isNil ifTrue:[
        Dialog information:'Please select a single project'.
        ^  self.
    ].

    self withWaitCursorDo:[
        SourceCodeManagerUtilities basicNew
            validateConsistencyOfPackage:packageName
            doClasses:true 
            doExtensions:true.

        package := MCPackage named: packageName.
        workingCopy := package workingCopy.
        MCCommitDialog new
            workingCopy: workingCopy;
            open
    ].

    "Created: / 14-09-2010 / 22:54:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UndefinedObject methodsFor:'* monticello'!

typeOfClass
    "Necessary to support disjoint class hierarchies."

    ^#normal
! !

!UserPreferences methodsFor:'accessing-scm-monticello'!

mcEnabled
    "/ needed for MCSettingsApp

    ^self at: #mcEnabled ifAbsent: [true].

    "Created: / 16-09-2010 / 09:44:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-09-2010 / 14:50:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 15-01-2012 / 14:12:53 / cg"
! !

!UserPreferences methodsFor:'accessing-scm-monticello'!

mcEnabled: aBoolean
    "/ needed for MCSettingsApp

    self at: #mcEnabled put: aBoolean.

    "Created: / 16-09-2010 / 09:44:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-08-2012 / 11:54:43 / cg"
! !

!UserPreferences methodsFor:'accessing-scm-monticello'!

mcRepositories
    "Returns a list of MCRepository as in LITERAL ARRAY ENCODING"

    ^self at: #mcRepositories ifAbsent:[#(Array)].

    "
        UserPreferences current mcRepositories
        UserPreferences current mcRepositories: #(Array) 
    "

    "Created: / 16-09-2010 / 09:47:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 04-04-2012 / 11:08:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-scm-monticello'!

mcRepositories: aCollection
    "/ needed for MCSettingsApp

    self at: #mcRepositories put: aCollection.

    "Created: / 27-08-2012 / 11:54:34 / cg"
! !

!VersionInfo methodsFor:'accessing'!

timeStamp

    ^Timestamp
        fromDate: (Date fromString: date)
        andTime:  (Time fromString: time)

    "Created: / 09-09-2010 / 15:20:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_goodies_monticello class methodsFor:'documentation'!

extensionsVersion_HG

    ^ '$Changeset: <not expanded> $'
! !
