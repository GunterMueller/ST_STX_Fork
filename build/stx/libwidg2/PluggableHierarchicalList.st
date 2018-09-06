"
 COPYRIGHT (c) 2015 Jan Vrany
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

HierarchicalList subclass:#PluggableHierarchicalList
	instanceVariableNames:'childBlock labelBlock iconBlock'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Support'
!

!PluggableHierarchicalList class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2015 Jan Vrany
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
    A customizable hierarchical tree list for ad-hoc trees

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]
        protocol examples

"
! !

!PluggableHierarchicalList class methodsFor:'examples'!

example1
    | window view list |
    "
    PluggableHierarchicalList example1
    "

    window := StandardSystemView new; extent:300@300.  
    window label: self class name , '>> #example1'.
    view := ScrollableView for:HierarchicalListView origin:0.0@0.0 corner:1.0@1.0 in: window.

    list := PluggableHierarchicalList new.
    list childBlock:[ :parent | 1 to: 5 collect: [:i | parent copyWith: i ] ].
    list labelBlock:[ :child  | 'Section ' , child printString ].
    list root: #(1).
    view list: list.

    window open.

    "Created: / 21-05-2015 / 19:05:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PluggableHierarchicalList methodsFor:'accessing'!

childBlock
    ^ childBlock
!

childBlock:aBlock
    childBlock := aBlock.
!

iconBlock
    ^ iconBlock
!

iconBlock:aBlock
    iconBlock := aBlock.
!

labelBlock
    ^ labelBlock
!

labelBlock:aBlock
    labelBlock := aBlock.
! !

!PluggableHierarchicalList methodsFor:'accessing-root'!

root:anObject
    | item |

    item := HierarchicalItemWithLabelAndIconAndValue new.
    item label: (labelBlock notNil ifTrue:[ labelBlock value: anObject ] ifFalse:[ anObject displayString ]).
    item icon:  (iconBlock notNil ifTrue:[ iconBlock value: anObject ] ifFalse:[ nil ]).
    item value: anObject. 
    super root: item.

    "Created: / 21-05-2015 / 19:17:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PluggableHierarchicalList methodsFor:'protocol'!

childrenFor: parentItem
    | parent children |

    parent := parentItem value.
    children := childBlock value: parent.
    ^ children collect:[ :child |
        | childItem |
        childItem := HierarchicalItemWithLabelAndIconAndValue new.
        childItem label: (labelBlock notNil ifTrue:[ labelBlock value: child ] ifFalse:[ child displayString ]).
        childItem icon:  (iconBlock notNil ifTrue:[ iconBlock value: child] ifFalse:[ nil ]).
        childItem value: child.   
        childItem parent: parentItem
    ]

    "Created: / 21-05-2015 / 19:19:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

