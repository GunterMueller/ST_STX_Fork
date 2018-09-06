"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

OrderedCollection subclass:#XQuerySequence
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Sequence'
!


!XQuerySequence class methodsFor:'instance creation'!

withAtomicValue:value asType:type 
    ^self with: (AtomicItem withValue:value asType:type)

    "Created: / 10-05-2009 / 21:40:33 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 05-10-2009 / 14:30:16 / Jan Kurs <kursj1@fel.cvut.cz>"
!

withBoolean:aBoolean 
    ^self with:(AtomicItem withBoolean:aBoolean)

    "Created: / 21-03-2007 / 13:49:23 / janfrog"
    "Modified: / 05-10-2009 / 14:30:23 / Jan Kurs <kursj1@fel.cvut.cz>"
!

withNumber:aNumber 
    ^self with:(AtomicItem withNumber:aNumber)

    "Created: / 21-03-2007 / 13:49:23 / janfrog"
    "Modified: / 05-10-2009 / 14:30:30 / Jan Kurs <kursj1@fel.cvut.cz>"
!

withNumbers:aCollection 
    "of numbers"
    
    ^self withAll:(aCollection collect:[:num | AtomicItem withNumber:num])

    "Created: / 21-03-2007 / 14:23:43 / janfrog"
    "Modified: / 05-10-2009 / 14:30:37 / Jan Kurs <kursj1@fel.cvut.cz>"
!

withString:string 
    ^self with:(AtomicItem withString:string)

    "Created: / 21-03-2007 / 15:45:37 / janfrog"
    "Modified: / 21-03-2007 / 19:11:37 / janfrog"
    "Modified: / 05-10-2009 / 14:30:41 / Jan Kurs <kursj1@fel.cvut.cz>"
!

withStrings:stringCollection 
    ^self 
        withAll:(stringCollection collect:[:str | AtomicItem withString:str])

    "Created: / 29-08-2007 / 10:29:19 / janfrog"
    "Modified: / 05-10-2009 / 14:30:45 / Jan Kurs <kursj1@fel.cvut.cz>"
!

withText:string 
    ^self with:(NodeItem withText:string)

    "Created: / 28-03-2007 / 22:49:53 / janfrog"
    "Modified: / 05-10-2009 / 14:30:50 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XQuerySequence methodsFor:'accessing'!

dmStringValue

     ^self isSingletonSequence 
        ifTrue:[self anyOne dmStringValue]
        ifFalse:['[...]']

    "Created: / 04-05-2010 / 18:53:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

typeName

    ^self isSingletonSequence 
        ifTrue:[self anyOne typeName]
        ifFalse:['sequence']

    "Created: / 04-05-2010 / 18:52:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XQuerySequence methodsFor:'converting'!

asAtomizedSequence
    ^ self collect: [ :item |
        item atomizedValue.
    ].

    "Created: / 04-10-2009 / 19:15:29 / Jan Kurs <kursj1@fel.cvut.cz>"
!

asDocumentFragment

    | reader builder |
    reader := XQueryResultXMLReader new.
    builder := XMLv2::DOM3Builder new.
    reader setContentHandler: builder.
    self do:[:each|reader visit: each].
    ^builder document

    "Created: / 15-07-2010 / 15:56:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

asInteger

    self assert:self containsSingleAtomicValue .
    ^self first value asInteger .

    "Created: / 21-03-2007 / 20:24:16 / janfrog"
    "Modified: / 05-10-2009 / 15:56:56 / Jan Kurs <kursj1@fel.cvut.cz>"
!

asNumber

    self assert:self containsSingleAtomicValue .
    ^self first value asNumber .

    "Created: / 04-10-2009 / 18:01:06 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 05-10-2009 / 15:56:43 / Jan Kurs <kursj1@fel.cvut.cz>"
!

asString

    self assert:self containsSingleAtomicValue .
    ^self first stringValue

    "Created: / 05-10-2009 / 15:55:57 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XQuerySequence methodsFor:'evaluation'!

effectiveBooleanValue
    "
      If $arg is the empty sequence, fn:boolean returns false.

      If $arg is a sequence whose first item is a node, fn:boolean returns true.

      If $arg is a singleton value of type xs:boolean or a derived from xs:boolean, fn:boolean returns $arg.

      If $arg is a singleton value of type xs:string or a type derived from xs:string,
      xs:anyURI or a type derived from xs:anyURI or xs:untypedAtomic, fn:boolean returns false
      if the operand value has zero length; otherwise it returns true.

      If $arg is a singleton value of any numeric type or a type derived from a numeric type,
      fn:boolean returns false if the operand value is NaN or is numerically equal to zero; otherwise it returns true.

      In all other cases, fn:boolean raises a type error [err:FORG0006]."
    
    self isEmpty ifTrue:[
        ^ false
    ].
    (self first isNode) ifTrue:[
        ^ true
    ].
    self assert: (self size = 1).
    (self first isSubtypeOf:'xs:boolean') 
            ifTrue:[ ^ self first value ].
    (self first isSubtypeOf:'xs:decimal') 
            ifTrue:[ ^ self first ~= 0 ].
    (self first isSubtypeOf:'xs:float') 
            ifTrue:[ ^ self first ~= 0 ].
    (self first isSubtypeOf:'xs:double') 
            ifTrue:[ ^ self first ~= 0 ].
    (self first isSubtypeOf:'xs:string' or: 'xs:untypedAtomic' or: 'xs:anyURI') 
            ifTrue:[ ^ self first isEmpty not ].

    TypeError raiseErrorString: 'err:FORG0006'.
    ^ false

    "Created: / 21-03-2007 / 14:58:03 / janfrog"
    "Modified: / 05-12-2007 / 15:50:51 / janfrog"
    "Modified: / 21-11-2009 / 20:09:37 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XQuerySequence methodsFor:'queries'!

containsSingleAtomicValue

    ^self isSingletonSequence 
        and:[self first isAtomicValue]

    "Created: / 21-11-2007 / 10:31:23 / janfrog"
    "Modified: / 21-11-2007 / 12:27:18 / janfrog"
    "Modified: / 05-10-2009 / 15:58:37 / Jan Kurs <kursj1@fel.cvut.cz>"
!

containsSingleAttribute
    ^ self containsSingleNode 
        and:[ self first type isSubtypeOf: (TypeFactory getType:'attribute')]

    "Created: / 21-03-2007 / 20:25:01 / janfrog"
    "Modified: / 05-12-2007 / 15:50:51 / janfrog"
    "Modified: / 09-05-2009 / 12:47:04 / Jan Kurs <kursj1@fel.cvut.cz>"
!

containsSingleDocument
    ^ self size = 1 
        and:[
            (self first type isSubtypeOf: (TypeFactory getType:'document')) 

        ]

    "Created: / 14-11-2007 / 11:20:27 / janfrog"
    "Modified: / 05-12-2007 / 15:52:24 / janfrog"
    "Modified: / 09-05-2009 / 12:47:17 / Jan Kurs <kursj1@fel.cvut.cz>"
!

containsSingleElement
    ^ self containsSingleNode 
        and:[ self first type isSubtypeOf: (TypeFactory getType:'element')]

    "Created: / 21-03-2007 / 20:25:01 / janfrog"
    "Modified: / 05-12-2007 / 21:55:29 / janfrog"
    "Modified: / 09-05-2009 / 12:47:31 / Jan Kurs <kursj1@fel.cvut.cz>"
!

containsSingleElementOrDocument

    ^self containsSingleElement
        or:[self containsSingleDocument].
    "Created: / 21-03-2007 / 20:25:01 / janfrog"
    "Modified: / 05-12-2007 / 21:55:29 / janfrog"
!

containsSingleInteger
    ^ self size = 1 
        and:[ TypeFactory isType: (self first dmTypeName) subtypeOf: 'xs:integer' ]

    "Created: / 21-03-2007 / 20:25:01 / janfrog"
    "Modified: / 05-12-2007 / 15:50:51 / janfrog"
    "Modified: / 04-10-2009 / 17:17:57 / Jan Kurs <kursj1@fel.cvut.cz>"
!

containsSingleNode

    ^(self size = 1) and:[self first isNode]

    "Created: / 14-11-2007 / 10:11:45 / janfrog"
    "Modified: / 21-11-2007 / 09:10:21 / janfrog"
    "Modified: / 18-01-2012 / 16:47:57 / Adam Senk <senkadam@fit.cvut.cz>"
!

containsSingleNumber
    ^ self size = 1
        and:[ self first isAtomicValue ]
        and:[ self first isSubtypeOf: 'xs:decimal' ]

    "Created: / 21-03-2007 / 20:25:01 / janfrog"
    "Modified: / 05-12-2007 / 15:50:51 / janfrog"
    "Modified: / 06-11-2009 / 20:13:26 / Jan Kurs <kursj1@fel.cvut.cz>"
!

containsSingleString
    ^ self size = 1 
        and:[ self first itemValueType isSubtypeOf: (TypeFactory getType:'xs:string') ]

    "Created: / 21-03-2007 / 20:25:01 / janfrog"
    "Modified: / 05-12-2007 / 15:50:51 / janfrog"
    "Modified: / 29-06-2009 / 16:41:08 / Jan Kurs <kursj1@fel.cvut.cz>"
!

containsSingleText

    ^self containsSingleNode and:[self first item isTextNode]

    "Created: / 21-11-2007 / 10:06:34 / janfrog"
!

containsSingleTextOrAtomicValue

    ^self containsSingleAtomicValue or:[self containsSingleText]

    "Created: / 21-11-2007 / 10:30:27 / janfrog"
    "Modified: / 21-11-2007 / 12:27:26 / janfrog"
!

error: message

    ^ XQuerySequenceError raiseErrorString: message.

    "Modified: / 21-11-2007 / 12:27:18 / janfrog"
    "Created: / 22-09-2009 / 15:14:20 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XQuerySequence methodsFor:'testing'!

isAtomicValue

    ^self isSingletonSequence 
        ifTrue:[self anyOne isAtomicValue]
        ifFalse:['sequence']

    "Created: / 04-05-2010 / 18:53:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isSingletonSequence

    ^self size = 1

    "Created: / 21-11-2007 / 12:26:01 / janfrog"
! !

!XQuerySequence class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
