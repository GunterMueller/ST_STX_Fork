"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg2' }"

"{ NameSpace: Smalltalk }"

HierarchicalItem subclass:#HierarchicalItemWithLabel
	instanceVariableNames:'label'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Support'
!

!HierarchicalItemWithLabel class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!HierarchicalItemWithLabel class methodsFor:'instance creation'!

label:aLabel
    ^ self new label:aLabel
! !

!HierarchicalItemWithLabel methodsFor:'accessing'!

label
    ^ label
!

label:aLabel
    (label isString and:[aLabel isString]) ifTrue:[
        (label sameStringAndEmphasisAs:aLabel) ifTrue:[^ self].
    ] ifFalse:[
        (label = aLabel) ifTrue:[^ self].
    ].

    label := aLabel.
    self changed.
! !

!HierarchicalItemWithLabel class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

