"{ Package: 'stx:goodies/xmlsuite/relaxng' }"

"{ NameSpace: RNG }"

Object subclass:#Pattern
	instanceVariableNames:'node bindingInfo'
	classVariableNames:''
	poolDictionaries:''
	category:'Relax NG-Patterns'
!


!Pattern class methodsFor:'instance creation'!

new
    ^ self basicNew initialize.

    "Created: / 14-05-2005 / 22:41:43 / janfrog"
! !

!Pattern methodsFor:'accessing'!

bindingInfo

    ^(node inDefine and:[node parent notNil])
        ifTrue:[bindingInfo mergeWith:node parent bindingInfo]
        ifFalse:[bindingInfo]

    "Modified: / 13-05-2005 / 15:32:24 / masca"
    "Created: / 14-05-2005 / 22:30:15 / janfrog"
!

name
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility

    "Created: / 14-05-2005 / 18:22:18 / janfrog"
!

node
    ^ node

    "Created: / 14-05-2005 / 18:20:29 / janfrog"
!

node:aPatternNode
    node := aPatternNode.

    "Created: / 14-05-2005 / 18:20:29 / janfrog"
! !

!Pattern methodsFor:'initialization'!

initialize

    bindingInfo := BindingInfo new

    "Created: / 14-05-2005 / 22:42:09 / janfrog"
!

initializeBindingInfoFromAttributes:anAttributes 

    bindingInfo initializeFromAttributes:anAttributes

    "Created: / 14-05-2005 / 22:39:03 / janfrog"
    "Modified: / 16-05-2005 / 15:08:00 / masca"
!

postParseFor:aSchema

    "Created: / 14-05-2005 / 21:21:00 / janfrog"
! !

!Pattern methodsFor:'printing'!

nameForPrint
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility

    "Created: / 19-05-2005 / 09:54:54 / masca"
! !

!Pattern methodsFor:'queries'!

acceptsEmptyStringAsContent

    ^false

    "Created: / 14-06-2005 / 12:15:20 / masca"
!

hasComplexContentModel

    ^false

    "Created: / 16-05-2005 / 16:31:35 / masca"
!

isValidObject: anObject

    ^self bindingInfo isValidObject: anObject

    "Created: / 25-08-2005 / 12:45:49 / masca"
! !

!Pattern methodsFor:'testing'!

isComplexTypePattern
    ^ false

    "Created: / 14-05-2005 / 20:34:31 / janfrog"
!

isForAttribute
    ^false

    "Created: / 14-05-2005 / 20:32:25 / janfrog"
!

isForElement
    ^ self isForAttribute not

    "Created: / 14-05-2005 / 20:32:06 / janfrog"
!

isListPattern
    ^ false

    "Created: / 14-05-2005 / 20:34:31 / janfrog"
!

isPCDataPattern
    ^ false

    "Created: / 14-05-2005 / 20:34:31 / janfrog"
! !

!Pattern class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/relaxng/RNG__Pattern.st,v 1.1.1.1 2005-11-01 22:07:14 vranyj1 Exp $'
! !
