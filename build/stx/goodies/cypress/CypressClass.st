"{ Package: 'stx:goodies/cypress' }"

"{ NameSpace: Smalltalk }"

CypressModel subclass:#CypressClass
	instanceVariableNames:'comment methods'
	classVariableNames:''
	poolDictionaries:''
	category:'Cypress-New-Model'
!


!CypressClass class methodsFor:'instance creation'!

fromClass: aClass
    "Returns a CypressPackage for given (real) class"

    ^self new initializeFromClass: aClass.

    "Created: / 10-09-2012 / 23:48:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fromDirectory: directory
    "Reads a CypressClass from given directory"

    ^self new initializeFromDirectory: directory

    "Created: / 13-09-2012 / 15:34:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CypressClass methodsFor:'accessing'!

category
    ^properties at:'category' ifAbsent:['* as yet unclassified *']

    "Created: / 18-09-2012 / 10:45:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classInstVarsAsString

    ^String streamContents:[:s|
        (properties at:'classinstvars' ifAbsent:[#()]) 
            do:[:each|s nextPutAll: each]
            separatedBy:[s space]
    ]

    "Created: / 18-09-2012 / 10:51:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classVarsAsString

    ^String streamContents:[:s|
        (properties at:'classvars' ifAbsent:[#()]) 
            do:[:each|s nextPutAll: each]
            separatedBy:[s space]
    ]

    "Created: / 18-09-2012 / 10:51:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

comment
    ^ comment
!

comment:something
    comment := something.
!

fullClassName
    | ns |

    ns := properties at: 'namespace' ifAbsent:[nil].
    ^(ns notNil and:[ns ~= 'Smalltalk'])
        ifFalse:[properties at: 'name']
        ifTrue:[(properties at: 'name'), '::' , ns].

    "Created: / 18-09-2012 / 10:44:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fullSuperName
    | ns |

    ns := properties at: 'superNamespace' ifAbsent:[nil].
    ^(ns notNil and:[ns ~= 'Smalltalk'])
        ifFalse:[properties at: 'super']
        ifTrue:[(properties at: 'super'), '::' , ns].

    "Created: / 18-09-2012 / 10:44:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

instVarsAsString

    ^String streamContents:[:s|
        (properties at:'instvars' ifAbsent:[#()]) 
            do:[:each|s nextPutAll: each]
            separatedBy:[s space]
    ]

    "Created: / 18-09-2012 / 10:50:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

methods

    methods isNil ifTrue:[
        methods := OrderedCollection new
    ].
    ^methods

    "Created: / 11-09-2012 / 00:03:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name
    name isNil ifTrue:[
        properties notNil ifTrue:[
            name := properties at:'name' ifAbsent:[nil]
        ]
    ].
    ^name

    "Created: / 18-09-2012 / 11:02:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

poolsAsString

    ^String streamContents:[:s|
        (properties at:'pools' ifAbsent:[#()]) 
            do:[:each|s nextPutAll: each]
            separatedBy:[s space]
    ]

    "Created: / 18-09-2012 / 10:53:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CypressClass methodsFor:'converting'!

asChange
    "superclass CypressModel says that I am responsible to implement this method"


    ^ClassDefinitionChange new
        className: self fullClassName;
        superClassName: self fullSuperName;
        category: self category;

        instanceVariableString: self instVarsAsString;
        classVariableString: self classVarsAsString;
        classInstanceVariableString: self classInstVarsAsString;
        poolDictionaries: self poolsAsString;

        yourself.

    "Modified: / 05-10-2015 / 18:19:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CypressClass methodsFor:'initialization'!

initializeFromClass: aClass
    name := aClass name.
    properties := Dictionary new.

    properties 
        at:'name'           put: aClass nameWithoutPrefix;
        at:'super'          put: aClass superclass nameWithoutPrefix;
        at:'namespace'      put: aClass nameSpace nameWithoutPrefix;
        at:'superNamespace' put: aClass nameSpace nameSpace name;

        at:'instvars'       put: aClass instVarNames;
        at:'classinstvars'  put: aClass class instVarNames;
        at:'classvars'      put: aClass classVarNames;
        at:'pools'          put: aClass sharedPoolNames;

        at:'category'       put: aClass category.


    aClass definitionSelector ~~ Object definitionSelector ifTrue:[
        properties
        at:'_stx_type'      put: aClass definitionSelector
    ].
    methods := OrderedCollection new.
    (Smalltalk at: name asSymbol) instAndClassMethodsDo:[:mthd|
        methods add: (CypressMethod fromMethod: mthd)
    ]

    "Created: / 10-09-2012 / 23:48:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeFromDirectory: directory
    self readFrom: directory

    "Created: / 13-09-2012 / 15:35:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeWithMethods: aCollection
    methods := aCollection

    "Created: / 11-09-2012 / 11:15:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CypressClass methodsFor:'private'!

changesInto:aChangeSet
    "superclass CypressModel says that I am responsible to implement this method"

    aChangeSet add: self asChange.
    self methods do:[:each|each changesInto: aChangeSet].

    "Modified: / 18-09-2012 / 10:58:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CypressClass methodsFor:'reading & writing - private'!

writeMethodsTo:directory notice:copyrightNotice
     "Writes methods into given 'directory' with copyrightNotice in each file"

    | obsolete instDir classDir |

    instDir := directory / 'instance'.
    classDir := directory / 'class'.

    " collect possibly obsolete directories/files "
    obsolete := Set new.
    instDir exists ifTrue:[
        obsolete add: instDir.
        obsolete add: instDir directoryContentsAsFilenames
    ].
    classDir exists ifTrue:[
        obsolete add: classDir.
        obsolete add: classDir directoryContentsAsFilenames
    ].

    self methods do:[:cpsMthd|
        | dir dottedSel file  |

        dir := cpsMthd meta ifTrue:[classDir] ifFalse:[instDir].
        dir exists ifFalse:[ dir makeDirectory ].
        file := dir / ((dottedSel := cpsMthd selector copyReplaceAll:$: with: $.) , '.st').
        cpsMthd writeTo: file notice:copyrightNotice.
        obsolete := obsolete reject:[:each|
            each withoutSuffix baseName = dottedSel
        ].
    ].

    " wipe out obsolete directories / files  "
    obsolete do:[:each|
        each exists ifTrue:[ each recursiveRemove ]
    ].

    "Created: / 11-09-2012 / 11:19:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CypressClass class methodsFor:'documentation'!

version_SVN
    ^ '$Id::                                                                                                                        $'
! !

