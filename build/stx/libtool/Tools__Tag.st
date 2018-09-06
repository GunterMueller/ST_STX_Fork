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
"{ Package: 'stx:libtool' }"

"{ NameSpace: Tools }"

Object subclass:#Tag
	instanceVariableNames:'width label pattern lineNumber fileName className'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Tools-File-Tags'
!

Tag subclass:#TElement
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Tag
!

Tag subclass:#TCaseLabel
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Tag
!

Tag subclass:#TClass
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Tag
!

Tag subclass:#TDocumentation
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Tag
!

Tag::TElement subclass:#TAnchorElement
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Tag
!

Tag subclass:#TEnum
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Tag
!

Tag subclass:#TEnumMember
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Tag
!

Tag subclass:#TField
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Tag
!

Tag::TElement subclass:#TFormElement
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Tag
!

Tag subclass:#TFunction
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Tag
!

Tag::TElement subclass:#THeaderElement
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Tag
!

Tag subclass:#TInterface
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Tag
!

Tag subclass:#TLabel
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Tag
!

Tag subclass:#TLispConstant
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Tag
!

Tag subclass:#TLispEval
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Tag
!

Tag subclass:#TLispMacro
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Tag
!

Tag subclass:#TMacro
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Tag
!

Tag subclass:#TMakeRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Tag
!

Tag subclass:#TMakeTarget
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Tag
!

Tag subclass:#TMember
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Tag
!

Tag subclass:#TMethod
	instanceVariableNames:'isMeta'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Tag
!

Tag subclass:#TPackage
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Tag
!

Tag subclass:#TPrologClause
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Tag
!

Tag subclass:#TStruct
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Tag
!

Tag subclass:#TTypedef
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Tag
!

Tag subclass:#TUnion
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Tag
!

Tag subclass:#TVariable
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Tag
!

!Tag class methodsFor:'documentation'!

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
    keeps the info for a single tag (for the fileBrowser, for example);
    either read from an external tool (ctags) or generated internally
"
! !

!Tag class methodsFor:'instance creation'!

label:aLabel pattern:aPattern
    ^ self label:aLabel pattern:aPattern type:nil lineNumber:nil className:nil

!

label:aLabel pattern:aPattern type:tagTypeString

    ^ self label:aLabel pattern:aPattern type:tagTypeString lineNumber:nil className:nil
!

label:aLabel pattern:aPattern type:tagTypeString lineNumber:aLineNumer

    ^ self label:aLabel pattern:aPattern type:tagTypeString lineNumber:aLineNumer className:nil
!

label:aLabel pattern:aPattern type:tagTypeString lineNumber:aLineNumer className:cName
    |tid cls tag|

    ((self == Tag) and:[tagTypeString size == 1]) ifTrue:[
        tid := tagTypeString asString.
        cls := self subclasses detect:[:aClass| aClass typeIdentifier = tid ]
                               ifNone:self.
    ] ifFalse:[
        cls := self
    ].
    tag := cls new.
    tag label:aLabel pattern:aPattern lineNumber:aLineNumer className:cName.
    ^ tag

    "Modified: / 05-05-2011 / 15:42:45 / cg"
! !

!Tag class methodsFor:'accessing'!

typeIdentifier
    ^ nil


! !

!Tag methodsFor:'accessing'!

fileName
    "returns the fileName (project tags only)
    "
    ^ fileName


!

fileName:aFilename
    "set the fileName (project tags only)
    "
    fileName := aFilename

!

label
    ^ label

!

lineNumber
    "returns the lineNumber computed at beginning
    "
    ^ lineNumber ? 0

!

lineNumber:aNumber
    "set the lineNumber computed at beginning
    "
    lineNumber := aNumber.

!

pattern
    "returns the pattern string, used to detect the line into a
     contents
    "
    ^ pattern

!

typeIdentifierInList
    ^ self class typeIdentifier
!

typeString
    ^ '???'
! !

!Tag methodsFor:'instance creation'!

label:aLabel pattern:aPattern lineNumber:aLineNumer className:cName

    label      := aLabel.
    pattern    := aPattern.
    lineNumber := aLineNumer.

    cName size > 1 ifTrue:[
	cName first isLetter ifFalse:[
	    className := cName copyFrom:2
	] ifTrue:[
	    className := cName
	]
    ]

! !

!Tag methodsFor:'list interface'!

explainString
    |s t|

    s := label , ' is a ' , self typeString.
    fileName notNil ifTrue:[
	s := s , ' in ', fileName pathName.
    ].
    ^ s


!

printString
    "returns the label used in a list
    "
    |l type|

    l := label.
    className notNil ifTrue:[
	l := className , '::' , l
    ].
"/
"/    type := self class typeIdentifier.
"/
"/    type notNil ifTrue:[
"/        ^  type, ' ' , l
"/    ].
    ^ l
!

printStringWithoutClass
    "returns a short label (used in a list when all labels are for the same class)
    "
    |l type|

    l := label.
    className notNil ifTrue:[
	l := '::' , l
    ].
"/
"/    type := self class typeIdentifier.
"/
"/    type notNil ifTrue:[
"/        ^  type, ' ' , l
"/    ].
    ^ l
!

shortInfoString
    |s|

    s := self typeString.
    fileName notNil ifTrue:[
        s := s , ' in ', fileName baseName "pathName".
    ].
    ^ s
! !

!Tag methodsFor:'queries'!

widthOn:aGC

    width isNil ifTrue:[
	width := self printString widthOn:aGC
    ].
    ^ width
! !

!Tag methodsFor:'tag searching'!

lineNumberIn:someText
    |pat lnr atStart atEnd|

    (lineNumber notNil and:[lineNumber ~~ 0]) ifTrue:[
       ^ lineNumber
    ].

    (pat := self pattern) isNil ifTrue:[
        lineNumber := 1.
      ^ lineNumber
    ].

    (pat endsWith:';"') ifTrue:[
        lnr := Integer readFrom:pat onError:nil.
        lnr notNil ifTrue:[
            ^ lnr
        ]
    ].
    lnr := 0.

"/        (pat endsWith:'/;"') ifTrue:[
"/            pat := pat copyButLast:3.
"/        ].
    (pat startsWith:$^) ifTrue:[
        pat := pat copyFrom:2.
        atStart := true.
    ].
    (pat endsWith:$$) ifTrue:[
        pat := pat copyButLast.
        atEnd := true.
    ].
    atStart == true ifTrue:[
        atEnd == true ifTrue:[
            lnr := someText findFirst:[:line | line = pat].
        ] ifFalse:[
            lnr := someText findFirst:[:line | line startsWith:pat].
        ]
    ] ifFalse:[
        atEnd == true ifTrue:[
            lnr := someText findFirst:[:line | line endsWith:pat].
        ] ifFalse:[
            lnr := someText findFirst:[:line | line includesString:pat].
        ].
    ].

    lnr == 0 ifTrue:[
        lnr := someText findFirst:[:line | line includesString:self label].
        lnr == 0 ifTrue:[
            lnr := 1.
        ].
    ].
    ^ lnr
! !

!Tag methodsFor:'testing'!

isClassTag
    "return true, if this is a java class tag 
    "
    ^ false


!

isDocumentationTag
    "return true, if this is a doc tag 
    "
    ^ false

    "Created: / 08-05-2011 / 10:06:11 / cg"
!

isEnumMemberTag
    ^ false

    "Created: / 05-05-2011 / 15:38:56 / cg"
!

isEnumTag
    ^ false

    "Created: / 05-05-2011 / 15:37:23 / cg"
!

isFieldTag
    "return true, if this is a java field tag 
    "
    ^ false


!

isFunctionOrMethodTag
    "return true, if this is a function or a method tag 
    "
    ^ false
!

isFunctionTag
    "return true, if this is a function tag 
    "
    ^ false


!

isInterfaceTag
    "return true, if this is a java interface tag 
    "
    ^ false


!

isLabelTag
    "return true, if this is a label tag 
    "
    ^ false


!

isLispConstantTag
    "return true, if this is a lisp constant tag 
    "
    ^ false


!

isLispEvalTag
    "return true, if this is a lisp eval tag 
    "
    ^ false
!

isLispMacroTag
    "return true, if this is a lisp macro tag 
    "
    ^ false
!

isMacroTag
    "return true, if this is a define macro tag 
    "
    ^ false


!

isMakeTargetTag
    "return true, if this is a make-target tag 
    "
    ^ false


!

isMemberTag
    "return true, if this is a struct/union member tag 
    "
    ^ false


!

isMethodTag
    "return true, if this is a java method tag 
    "
    ^ false


!

isPackageTag
    "return true, if this is a java package tag 
    "
    ^ false


!

isPrologClause
    "return true, if this is a prolog clause tag 
    "
    ^ false
!

isStructOrUnionTag
    "return true, if this is a union tag 
    "
    ^ false

    "Created: / 05-05-2011 / 15:07:33 / cg"
!

isStructTag
    "return true, if this is a struct tag" 
    
    ^ false
!

isTypeTag
    "return true, if this is any type tag (typedef, struct, union, enum, ...)"

    ^ false
!

isTypedefTag
    "return true, if this is a typedef tag"

    ^ false
!

isUnionTag
    "return true, if this is a union tag 
    "
    ^ false

    "Created: / 05-05-2011 / 15:07:29 / cg"
!

isVariableTag
    "return true, if this is a variable tag 
    "
    ^ false


! !

!Tag::TElement class methodsFor:'accessing'!

typeIdentifier
    ^ 'e'

    "Created: / 20-04-2011 / 18:52:31 / cg"
! !

!Tag::TElement class methodsFor:'documentation'!

documentation
"
    an element (as in HTML)
"
! !

!Tag::TElement methodsFor:'accessing'!

typeIdentifierInList
    ^ 'e'

    "Created: / 20-04-2011 / 18:53:49 / cg"
!

typeString
    ^ 'element'

    "Created: / 20-04-2011 / 18:53:29 / cg"
! !

!Tag::TElement methodsFor:'testing'!

isElementTag
    "return true, if this is an element tag 
    "
    ^ true

    "Created: / 20-04-2011 / 18:53:16 / cg"
! !

!Tag::TCaseLabel class methodsFor:'accessing'!

typeIdentifier
    ^ 'L'
! !

!Tag::TCaseLabel methodsFor:'accessing'!

typeString
    ^ 'case label'
! !

!Tag::TCaseLabel methodsFor:'testing'!

isCaseLabelTag
    "return true, if this is a case label tag 
    "
    ^ true
!

isLabelTag
    "return true, if this is a label tag 
    "
    ^ true


! !

!Tag::TClass class methodsFor:'accessing'!

typeIdentifier
    ^ 'C'

    "Modified: / 05-05-2011 / 15:40:47 / cg"
! !

!Tag::TClass class methodsFor:'documentation'!

documentation
"
    a class-like object
"
! !

!Tag::TClass methodsFor:'accessing'!

typeIdentifierInList
    ^ 'C'

!

typeString
    ^ 'class'

! !

!Tag::TClass methodsFor:'testing'!

isClassTag
    "return true, if this is a class tag 
    "
    ^ true


!

isTypeTag
    "return true, if this is any type tag (union, struct, typedef, enum)" 

    ^ true
! !

!Tag::TDocumentation class methodsFor:'accessing'!

typeIdentifier
    ^ 'D'

    "Modified: / 08-05-2011 / 10:06:26 / cg"
! !

!Tag::TDocumentation class methodsFor:'documentation'!

documentation
"
    this is a synthetic element, used to mark special
    documentation found in some languages:
        lisp:   lines starting with ';;;'
        java    (could detect @xxx javadoc or similar in the future)
"
! !

!Tag::TDocumentation methodsFor:'accessing'!

typeString
    ^ 'documentation'

    "Modified: / 08-05-2011 / 10:05:52 / cg"
! !

!Tag::TDocumentation methodsFor:'testing'!

isDocumentationTag
    "return true, if this is a doc tag 
    "
    ^ true

    "Created: / 08-05-2011 / 10:06:03 / cg"
! !

!Tag::TAnchorElement class methodsFor:'accessing'!

typeIdentifier
    ^ 'a'

    "Created: / 20-04-2011 / 18:52:31 / cg"
! !

!Tag::TAnchorElement class methodsFor:'documentation'!

documentation
"
    an anchor element (in HTML)
"
! !

!Tag::TAnchorElement methodsFor:'accessing'!

typeIdentifierInList
    ^ 'a'

    "Created: / 20-04-2011 / 18:53:49 / cg"
!

typeString
    ^ 'anchor element'

    "Created: / 20-04-2011 / 18:53:29 / cg"
! !

!Tag::TEnum class methodsFor:'accessing'!

typeIdentifier
    ^ 'E'

    "Modified: / 05-05-2011 / 15:40:54 / cg"
! !

!Tag::TEnum methodsFor:'accessing'!

typeString
    ^ 'enum'

    "Modified: / 05-05-2011 / 15:37:03 / cg"
! !

!Tag::TEnum methodsFor:'testing'!

isEnumTag
    ^ true

    "Created: / 05-05-2011 / 15:37:15 / cg"
!

isTypeTag
    "return true, if this is any type tag (union, struct, typedef, enum)" 

    ^ true
! !

!Tag::TEnumMember class methodsFor:'accessing'!

typeIdentifier
    ^ 'e'

    "Modified: / 05-05-2011 / 15:40:57 / cg"
! !

!Tag::TEnumMember methodsFor:'accessing'!

typeString
    ^ 'enum member'

    "Modified: / 05-05-2011 / 15:39:05 / cg"
! !

!Tag::TEnumMember methodsFor:'testing'!

isEnumMemberTag
    ^ true

    "Created: / 05-05-2011 / 15:38:49 / cg"
! !

!Tag::TField class methodsFor:'accessing'!

typeIdentifier
    ^ 'f'


! !

!Tag::TField methodsFor:'accessing'!

typeString
    ^ 'field'

! !

!Tag::TField methodsFor:'testing'!

isFieldTag
    "return true, if this is a java field tag 
    "
    ^ true


! !

!Tag::TFormElement class methodsFor:'accessing'!

typeIdentifier
    ^ 'f'

    "Created: / 20-04-2011 / 18:52:31 / cg"
! !

!Tag::TFormElement class methodsFor:'documentation'!

documentation
"
    a form element (in HTML)
"
! !

!Tag::TFormElement methodsFor:'accessing'!

typeIdentifierInList
    ^ 'f'

    "Created: / 20-04-2011 / 18:53:49 / cg"
!

typeString
    ^ 'form element'

    "Created: / 20-04-2011 / 18:53:29 / cg"
! !

!Tag::TFunction class methodsFor:'accessing'!

typeIdentifier
    ^ 'F'

    "Modified: / 05-05-2011 / 15:41:04 / cg"
! !

!Tag::TFunction methodsFor:'accessing'!

typeIdentifierInList
    ^ 'F'


!

typeString
    ^ 'function'


! !

!Tag::TFunction methodsFor:'testing'!

isFunctionOrMethodTag
    "return true, if this is a function or method tag 
    "
    ^ true
!

isFunctionTag
    "return true, if this is a function tag 
    "
    ^ true


! !

!Tag::THeaderElement class methodsFor:'accessing'!

typeIdentifier
    ^ 'h'

    "Created: / 20-04-2011 / 18:52:31 / cg"
! !

!Tag::THeaderElement class methodsFor:'documentation'!

documentation
"
    a header element (in HTML)
"
! !

!Tag::THeaderElement methodsFor:'accessing'!

typeIdentifierInList
    ^ 'h'

    "Created: / 20-04-2011 / 18:53:49 / cg"
!

typeString
    ^ 'header element'

    "Created: / 20-04-2011 / 18:53:29 / cg"
! !

!Tag::TInterface class methodsFor:'accessing'!

typeIdentifier
    ^ 'I'

    "Modified: / 05-05-2011 / 15:41:08 / cg"
! !

!Tag::TInterface methodsFor:'accessing'!

typeString
    ^ 'interface'


! !

!Tag::TInterface methodsFor:'testing'!

isInterfaceTag
    "return true, if this is a java interface tag 
    "
    ^ true


!

isTypeTag
    "return true, if this is any type tag (union, struct, typedef, enum)" 

    ^ true
! !

!Tag::TLabel class methodsFor:'accessing'!

typeIdentifier
    ^ 'l'


! !

!Tag::TLabel methodsFor:'accessing'!

typeString
    ^ 'label'


! !

!Tag::TLabel methodsFor:'testing'!

isLabelTag
    "return true, if this is a label tag 
    "
    ^ true


! !

!Tag::TLispConstant class methodsFor:'accessing'!

typeIdentifier
    ^ 'c'


! !

!Tag::TLispConstant methodsFor:'accessing'!

typeString
    ^ 'const'


! !

!Tag::TLispConstant methodsFor:'testing'!

isLispConstantTag
    "return true, if this is a lisp constant tag 
    "
    ^ true


! !

!Tag::TLispEval class methodsFor:'accessing'!

typeIdentifier
    ^ 'E'


! !

!Tag::TLispEval methodsFor:'accessing'!

printString
    ^ "'eval '," super printString
!

typeString
    ^ 'eval'


! !

!Tag::TLispEval methodsFor:'testing'!

isLispEvalTag
    "return true, if this is a lisp eval tag 
    "
    ^ true


! !

!Tag::TLispMacro class methodsFor:'accessing'!

typeIdentifier
    ^ 'm'


! !

!Tag::TLispMacro methodsFor:'accessing'!

typeString
    ^ 'macro'


! !

!Tag::TLispMacro methodsFor:'testing'!

isLispMacroTag
    "return true, if this is a define macro tag 
    "
    ^ true


! !

!Tag::TMacro class methodsFor:'accessing'!

typeIdentifier
    ^ 'd'


! !

!Tag::TMacro methodsFor:'accessing'!

typeString
    ^ 'macro'


! !

!Tag::TMacro methodsFor:'testing'!

isMacroTag
    "return true, if this is a define macro / macro tag 
    "
    ^ true
! !

!Tag::TMakeRule class methodsFor:'accessing'!

typeIdentifier
    ^ 'R'
! !

!Tag::TMakeRule methodsFor:'accessing'!

typeString
    ^ 'rule'
! !

!Tag::TMakeRule methodsFor:'testing'!

isMakeTargetTag
    "return true, if this is a make-target tag 
    "
    ^ true


! !

!Tag::TMakeTarget class methodsFor:'accessing'!

typeIdentifier
    ^ 'T'


! !

!Tag::TMakeTarget methodsFor:'accessing'!

typeString
    ^ 'target'


! !

!Tag::TMakeTarget methodsFor:'testing'!

isMakeTargetTag
    "return true, if this is a make-target tag 
    "
    ^ true


! !

!Tag::TMember class methodsFor:'accessing'!

typeIdentifier
    ^ 'm'


! !

!Tag::TMember methodsFor:'accessing'!

typeString
    ^ 'struct/union member'


! !

!Tag::TMember methodsFor:'testing'!

isMemberTag
    "return true, if this is a struct/union member tag 
    "
    ^ true


! !

!Tag::TMethod class methodsFor:'accessing'!

typeIdentifier
    ^ 'M'

    "Modified: / 05-05-2011 / 15:41:29 / cg"
! !

!Tag::TMethod methodsFor:'accessing'!

isMeta
    ^ isMeta
!

isMeta:aBoolean
    isMeta := aBoolean.
!

typeIdentifierInList
    ^ isMeta ifTrue:['M'] ifFalse:['m']
!

typeString
    ^ 'method'

! !

!Tag::TMethod methodsFor:'testing'!

isFunctionOrMethodTag
    "return true, if this is a function or method tag 
    "
    ^ true
!

isMethodTag
    "return true, if this is a method tag 
    "
    ^ true
! !

!Tag::TPackage class methodsFor:'accessing'!

typeIdentifier
    ^ 'P'

    "Modified: / 05-05-2011 / 15:41:35 / cg"
! !

!Tag::TPackage methodsFor:'accessing'!

typeString
    ^ 'package'


! !

!Tag::TPackage methodsFor:'testing'!

isPackageTag
    "return true, if this is a java package tag 
    "
    ^ true


! !

!Tag::TPrologClause class methodsFor:'accessing'!

typeIdentifier
    ^ 'C'


! !

!Tag::TPrologClause methodsFor:'accessing'!

typeString
    ^ 'clause'


! !

!Tag::TPrologClause methodsFor:'testing'!

isPrologClause
    "return true, if this is a prolog clause tag 
    "
    ^ true


! !

!Tag::TStruct class methodsFor:'accessing'!

typeIdentifier
    ^ 'S'

    "Modified: / 05-05-2011 / 15:41:42 / cg"
! !

!Tag::TStruct methodsFor:'accessing'!

typeString
    ^ 'struct'


! !

!Tag::TStruct methodsFor:'testing'!

isStructOrUnionTag
    ^ true

    "Created: / 05-05-2011 / 15:07:51 / cg"
!

isStructTag
    "return true, if this is a struct tag 
    "
    ^ true


!

isTypeTag
    "return true, if this is any type tag (union, struct, typedef, enum)" 
    
    ^ true
! !

!Tag::TTypedef class methodsFor:'accessing'!

typeIdentifier
    ^ 'T'

    "Modified: / 05-05-2011 / 15:41:46 / cg"
! !

!Tag::TTypedef methodsFor:'accessing'!

typeString
    ^ 'typedef'


! !

!Tag::TTypedef methodsFor:'testing'!

isTypeTag
    "return true, if this is any type tag (typedef, struct, union, enum, ...)"

    ^ true
!

isTypedefTag
    "return true, if this is a typedef tag"

    ^ true
! !

!Tag::TUnion class methodsFor:'accessing'!

typeIdentifier
    ^ 'U'

    "Modified: / 05-05-2011 / 15:41:50 / cg"
! !

!Tag::TUnion methodsFor:'accessing'!

typeString
    ^ 'union'

    "Modified: / 05-05-2011 / 15:07:12 / cg"
! !

!Tag::TUnion methodsFor:'testing'!

isStructOrUnionTag
    ^ true

    "Created: / 05-05-2011 / 15:07:41 / cg"
!

isTypeTag
    "return true, if this is any type tag (union, struct, typedef, enum)" 

    ^ true
!

isUnionTag
    "return true, if this is a union tag 
    "
    ^ true

    "Created: / 05-05-2011 / 15:07:00 / cg"
! !

!Tag::TVariable class methodsFor:'accessing'!

typeIdentifier
    ^ 'v'


! !

!Tag::TVariable methodsFor:'accessing'!

typeString
    ^ 'variable'


! !

!Tag::TVariable methodsFor:'testing'!

isVariableTag
    "return true, if this is a variable tag 
    "
    ^ true


! !

!Tag class methodsFor:'documentation'!

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

