"{ Package: 'stx:goodies/monticello' }"

Dictionary subclass:#MCLazyPropertyDictionary
	instanceVariableNames:'tokens'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-St/X support'
!


!MCLazyPropertyDictionary class methodsFor:'instance creation'!

withTokens: anArray

    ^self new setTokens: anArray

    "Created: / 28-10-2010 / 15:20:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCLazyPropertyDictionary methodsFor:'accessing'!

at: key ifAbsent: block

    tokens ifNotNil:[self associate].
    ^super at: key ifAbsent:block

    "Created: / 28-10-2010 / 15:24:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCLazyPropertyDictionary methodsFor:'initialization'!

setTokens: anArray

    tokens := anArray

    "Created: / 28-10-2010 / 15:20:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCLazyPropertyDictionary methodsFor:'private'!

associate
    
        tokens pairWiseDo: [:key :value | 
                                        | tmp |
                                        tmp := value.
                                        value isString ifFalse: [tmp := value collect: [:ea | MCLazyPropertyDictionary withTokens: ea]].
                                        value = 'nil' ifTrue: [tmp := ''].
                                        self at: key put: tmp].
        tokens := nil.

    "Created: / 28-10-2010 / 15:23:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCLazyPropertyDictionary class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCLazyPropertyDictionary.st,v 1.3 2012-09-11 21:22:36 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCLazyPropertyDictionary.st,v 1.3 2012-09-11 21:22:36 cg Exp $'
!

version_SVN
    ^ '§Id: MCLazyPropertyDictionary.st 23 2010-10-29 14:41:24Z vranyj1 §'
! !
