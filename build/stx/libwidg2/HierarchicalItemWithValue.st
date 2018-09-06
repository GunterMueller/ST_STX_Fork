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

HierarchicalItem subclass:#HierarchicalItemWithValue
	instanceVariableNames:'value'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Support'
!

!HierarchicalItemWithValue class methodsFor:'documentation'!

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
!

documentation
"
    I am a Hierarchical Item with a reference to more information.
    This class is usually subclassed, to item specific protocol.

    [Instance variables:]
        value      <any>                  

    [see also:]
        HierarchicalList
        HierarchicalListView
        HierarchicalItemWithLabelAndIconAndValue
"
! !

!HierarchicalItemWithValue class methodsFor:'instance creation'!

label:aLabel
    ^ self new label:aLabel
!

value:aLabel
    ^ self new value:aLabel
! !

!HierarchicalItemWithValue methodsFor:'accessing'!

value
    ^ value
!

value:something
    value := something.
! !

!HierarchicalItemWithValue class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

