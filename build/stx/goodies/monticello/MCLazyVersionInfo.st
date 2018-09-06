"{ Package: 'stx:goodies/monticello' }"

"{ NameSpace: Smalltalk }"

MCVersionInfo subclass:#MCLazyVersionInfo
	instanceVariableNames:'ancestorsProps stepChildrenProps'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-St/X support'
!


!MCLazyVersionInfo class methodsFor:'instance creation'!

withProperties: properties

    ^self new initializeWithProperties: properties

    "Created: / 28-10-2010 / 15:34:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCLazyVersionInfo methodsFor:'accessing'!

ancestors

    ancestors isNil ifTrue:
        [ancestorsProps notNil ifTrue:
            [ancestors := ancestorsProps collect:[:p|MCLazyVersionInfo withProperties:p].
            ancestorsProps := nil]].
    ^super ancestors

    "Created: / 28-10-2010 / 17:51:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-09-2015 / 15:45:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stepChildren

    stepChildren ifNil:
        [stepChildrenProps ifNotNil:
            [stepChildren := stepChildrenProps collect:[:p|MCLazyVersionInfo withProperties:p].
            stepChildrenProps := nil]].
    ^super stepChildren

    "Created: / 28-10-2010 / 17:52:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCLazyVersionInfo methodsFor:'initialization'!

initializeWithProperties: dict

    name:= (dict at: #name ifAbsent: ['']).
    id:= (UUID fromString: (dict at: #id)).
    message:= (dict at: #message ifAbsent: ['']).
    date:= ([Date fromString: (dict at: #date) ] on: Error do: [ :ex | ex return: nil ]).
    time:= ([ Time fromString:(dict at: #time)] on: Error do: [ :ex | ex return: nil ]).
    author:= (dict at: #author ifAbsent: ['']).

    (dict includesKey: #ancestors) ifTrue:[ 
        ancestorsProps:= dict at: #ancestors.
        ancestors := nil.
    ].
    stepChildrenProps:= dict at: #stepChildren ifAbsent: [#()].

    "Created: / 28-10-2010 / 15:36:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-05-2015 / 01:05:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCLazyVersionInfo class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCLazyVersionInfo.st,v 1.3 2012-09-11 21:22:41 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCLazyVersionInfo.st,v 1.3 2012-09-11 21:22:41 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '§Id: MCLazyVersionInfo.st 23 2010-10-29 14:41:24Z vranyj1 §'
! !

