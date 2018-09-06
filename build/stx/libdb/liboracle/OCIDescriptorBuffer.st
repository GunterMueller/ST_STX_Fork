"{ Package: 'stx:libdb/liboracle' }"

"{ NameSpace: SQL }"

OCIBuffer subclass:#OCIDescriptorBuffer
	instanceVariableNames:'descriptors'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Oracle-Buffers'
!

!OCIDescriptorBuffer class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2003 by eXept Software AG
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
    Descriptor buffers store OCI descriptors like OCILob or
    OCIRowId. Element size is the pointer size.

    [author:]
	Stefan Vogel (stefan@zwerg)

    [instance variables:]
	descriptors     Array of OCI8Descriptor     the Smalltalk descriptor

    [class variables:]

    [see also:]

"
! !

!OCIDescriptorBuffer methodsFor:'decoding'!

at:index
    "convert an internal Oracle Descriptor to a Timestamp value"

    (self indicatorAt:index) == -1 ifTrue:[
	^ nil
    ].

    ^ descriptors at:index.
! !

!OCIDescriptorBuffer methodsFor:'encoding'!

visitDescriptor:aDescriptor with:index

    |startIndex|

"/    self alenAt:index put:maxElementLen.
    descriptors at:index put:aDescriptor.
    startIndex := ((index-1)*maxElementLen)+1.
    buffer pointerAt:startIndex put:aDescriptor.
! !

!OCIDescriptorBuffer methodsFor:'instance creation'!

elements:elements maxElementLen:size containerClass:containerClass

    super elements:elements maxElementLen:size containerClass:containerClass.
    descriptors := Array new:elements.
! !

!OCIDescriptorBuffer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/liboracle/OCIDescriptorBuffer.st,v 1.4 2016-10-13 00:15:08 cg Exp $'
! !
