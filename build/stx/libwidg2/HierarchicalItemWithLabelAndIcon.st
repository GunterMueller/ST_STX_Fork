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

HierarchicalItemWithLabel subclass:#HierarchicalItemWithLabelAndIcon
	instanceVariableNames:'icon'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Support'
!

!HierarchicalItemWithLabelAndIcon class methodsFor:'documentation'!

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

!HierarchicalItemWithLabelAndIcon class methodsFor:'instance creation'!

label:aLabel icon:anIcon
    ^ self new label:aLabel icon:anIcon
! !

!HierarchicalItemWithLabelAndIcon methodsFor:'accessing'!

icon
    "returns the icon"

    ^ icon
!

icon:anIcon
    "set the value of the instance variable 'icon' (automatically generated)"

    icon ~= anIcon ifTrue:[
        icon := anIcon.
        self iconChanged
    ].
!

label:aLabel icon:anIcon
    |anyChange labelChanged|

    anyChange := false.
    (icon ~= anIcon) ifTrue:[
        icon := anIcon.
        anyChange := true
    ].
    
    labelChanged := false.
    (label isString and:[aLabel isString]) ifTrue:[
        labelChanged := (label sameStringAndEmphasisAs:aLabel) not.
    ] ifFalse:[
        labelChanged := (label ~= aLabel)
    ].
    labelChanged ifTrue:[
        label := aLabel.
        anyChange := true
    ].
    anyChange ifTrue:[ self changed ].
!

labeled:aLabel icon:anIcon
    "backward compatibility"

    self label:aLabel icon:anIcon
! !

!HierarchicalItemWithLabelAndIcon class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

