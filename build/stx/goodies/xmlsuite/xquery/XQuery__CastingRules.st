"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Object subclass:#CastingRules
	instanceVariableNames:'rules'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-TypeCasting'
!


!CastingRules methodsFor:'accessing'!

rules
    rules ifNil: 
    [
        self initRules.
    ].
    ^ rules

    "Modified: / 18-11-2009 / 00:57:43 / Jan Kurs <kursj1@fel.cvut.cz>"
!

rules:something
    rules := something.
! !

!CastingRules methodsFor:'casting'!

cast: atomicValue to: anotherTypeName
    | type anotherType castingRule |

    type := TypeFactory getType: atomicValue typeName.
    anotherType := TypeFactory getType: anotherTypeName.

    ((TypeFactory current isType: type subtypeOf: TypeXSAnyAtomicType instance) and:
        [ TypeFactory current isType: anotherType subtypeOf: TypeXSAnyAtomicType instance]) ifFalse:
    [
        TypeError raiseErrorString: 'casting is allowed only for simple atomic types'.
    ].

    castingRule := self selectCastingRuleFor: type and: anotherType.
    ^ castingRule cast: atomicValue to: anotherType.

    "Created: / 07-11-2009 / 16:19:16 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 21-11-2009 / 18:50:13 / Jan Kurs <kursj1@fel.cvut.cz>"
!

selectCastingRuleFor: type and: anotherType
    self rules do:
    [ : rule |
        (rule accept: type and: anotherType) ifTrue:
        [
"/            Transcript showCR: 'selected rule: ', rule asString.
            ^ rule
        ]
    ].
    self shouldNeverBeReached.

"/    (self primitiveToPrimitive accept: type and: anotherType) ifTrue:
"/    [
"/        ^ self primitiveToPrimitive.
"/    ].
"/    (self parentToDerived accept: type and: anotherType) ifTrue:
"/    [
"/        ^ self parentToDerived.
"/    ].
"/    (self derivedToParent accept: type and: anotherType) ifTrue:
"/    [
"/        ^ self derivedToParent.
"/    ].
"/    (self withinBranch accept: type and: anotherType) ifTrue:
"/    [
"/        ^ self withinBranch.
"/    ].
"/    (self accrossType accept: type and: anotherType) ifTrue:
"/    [
"/    ].


    self shouldNeverBeReached.

    "Created: / 07-11-2009 / 16:40:44 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 21-11-2009 / 18:34:59 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!CastingRules methodsFor:'initialization'!

initRules
    rules := OrderedCollection new.
    rules add: PrimitiveToPrimitiveCasting new.
    rules add: ParentToDerivedCasting new.
    rules add: DerivedToParentCasting new.
    rules add: WithinBranchCasting new.
    rules add: CrossTypeHierarchyCasting new.

    "Created: / 18-11-2009 / 00:40:33 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!CastingRules class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
