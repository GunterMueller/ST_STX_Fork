"{ Package: 'stx:libdb/liboracle' }"

"{ NameSpace: SQL }"

OCIDescriptorBuffer subclass:#OCIRowIdDescriptorBuffer
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Oracle-Buffers'
!

!OCIRowIdDescriptorBuffer  primitiveDefinitions!
%{

/*
 * includes, defines, structure definitions
 * and typedefs come here.
 */

#include "oci.h"
%}
! !

!OCIRowIdDescriptorBuffer class methodsFor:'documentation'!

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
! !


!OCIRowIdDescriptorBuffer class methodsFor:'queries'!

elementSize
    "elementSize of rowIdDescriptor"

%{
    RETURN(__mkSmallInteger(sizeof(OCIRowid *)))
%}

    "
     self elementSize
    "
!

ociDataType

     ^ OCI8Handle numericValueForCDataType:#'SQLT_RDD'
! !

!OCIRowIdDescriptorBuffer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/liboracle/OCIRowIdDescriptorBuffer.st,v 1.3 2010-10-11 12:00:05 cg Exp $'
! !
