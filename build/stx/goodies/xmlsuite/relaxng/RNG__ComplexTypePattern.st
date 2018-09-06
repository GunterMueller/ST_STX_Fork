"{ Package: 'stx:goodies/xmlsuite/relaxng' }"

"{ NameSpace: RNG }"

Pattern subclass:#ComplexTypePattern
	instanceVariableNames:'name automaton isAttribute'
	classVariableNames:''
	poolDictionaries:''
	category:'Relax NG-Patterns'
!


!ComplexTypePattern methodsFor:'accessing'!

contentModelAutomaton

    automaton ifNil:[
        automaton := Automaton new initializeFor:self.
    ].
    ^automaton

    "Created: / 01-05-2005 / 16:10:45 / janfrog"
    "Modified: / 14-05-2005 / 22:30:23 / janfrog"
!

isForAttribute:aBoolean
    isAttribute := aBoolean.

    "Created: / 01-05-2005 / 12:40:46 / janfrog"
!

localName

    ^(self name tokensBasedOn:$#) last

    "Created: / 02-05-2005 / 16:56:58 / janfrog"
!

name
    ^ name

    "Created: / 30-04-2005 / 14:37:56 / janfrog"
!

name:aString

    "aString must be expaned tag name, i.e a string in
    form <namespace>#<localName>"

    name := aString.

    "Created: / 30-04-2005 / 14:38:04 / janfrog"
!

namespace

    ^(self name includes:$#) 
        ifTrue:[(self name readStream upTo:$#)]
        ifFalse:[''].

    "Created: / 02-05-2005 / 16:57:40 / janfrog"
    "Modified: / 06-05-2005 / 12:22:27 / janfrog"
!

pcDataContentPattern

    ^node pcDataContentPattern

    "Created: / 02-05-2005 / 17:26:31 / janfrog"
! !

!ComplexTypePattern methodsFor:'initialization'!

postParseFor:aSchema

    "automaton := Automaton new initializeFor:self."

    "Created: / 14-05-2005 / 21:20:41 / janfrog"
    "Modified: / 16-05-2005 / 09:30:17 / masca"
!

setNamespace:ns localName:localName

    "must convert ns and localName into expanded name form"

    name := ns isNilOrEmptyCollection ifFalse:[ns , '#' , localName] ifTrue:[localName]

    "Created: / 30-04-2005 / 14:49:05 / janfrog"
    "Modified: / 14-05-2005 / 11:36:35 / janfrog"
! !

!ComplexTypePattern methodsFor:'printing'!

nameForPrint

    ^((self isForAttribute) ifTrue:['@'] ifFalse:[''])  ,self name

    "Created: / 30-04-2005 / 17:41:33 / janfrog"
    "Modified: / 01-05-2005 / 12:40:26 / janfrog"
!

printOn:aStream

    aStream nextPutAll:self name.
    aStream space; nextPut:$< ; space.
    self node printChildrenOn:aStream.
    aStream space; nextPut:$> ; space;
        cr; cr; nextPutAll:'Content model automaton' ; cr.
    self contentModelAutomaton printOn:aStream

    "Created: / 30-04-2005 / 17:42:58 / janfrog"
    "Modified: / 02-05-2005 / 14:28:17 / janfrog"
! !

!ComplexTypePattern methodsFor:'queries'!

hasComplexContentModel

    ^(self node children size > 2) or:
        [(self node firstChild isPatternNode and:[self node firstChild pattern isPCDataPattern]) not]

    "Created: / 16-05-2005 / 16:32:37 / masca"
! !

!ComplexTypePattern methodsFor:'testing'!

hasBinding
    ^self bindingInfo hasBinding

    "Created: / 02-05-2005 / 16:55:23 / janfrog"
!

isComplexTypePattern
    ^ true

    "Created: / 14-05-2005 / 20:34:31 / janfrog"
!

isForAttribute
    ^ isAttribute ? false

    "Created: / 01-05-2005 / 12:40:42 / janfrog"
! !

!ComplexTypePattern methodsFor:'validation/binding'!

newBinderContext

    ^ValidatorContext for:self

    "Created: / 02-05-2005 / 14:55:46 / janfrog"
    "Modified: / 02-05-2005 / 16:17:58 / janfrog"
!

newValidatorContext

    ^ValidatorContext for:self

    "Created: / 01-05-2005 / 16:15:29 / janfrog"
! !

!ComplexTypePattern class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/relaxng/RNG__ComplexTypePattern.st,v 1.1.1.1 2005-11-01 22:07:12 vranyj1 Exp $'
! !
