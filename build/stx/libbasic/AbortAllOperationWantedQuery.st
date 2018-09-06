"
 COPYRIGHT (c) 2011 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

Query subclass:#AbortAllOperationWantedQuery
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Control'
!

!AbortAllOperationWantedQuery class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2011 by eXept Software AG
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
    A query to ask, if AbortAllOperationRequest should be offered via an extra
    button from a dialog.

    This is used by dialog boxes, to decide if an extra 'Abort All' button should be
    shown, in situations where an operation might be issued both for a single item
    or for a group of items, and it is not known at the place where the dialog is shown,
    if it is part of a group-operation.
"
! !

!AbortAllOperationWantedQuery methodsFor:'defaults'!

defaultResumeValue
    "the default answer, if no one handles the query and the exception is resumed"

    ^ false

    "
     AbortAllOperationWantedQuery query

     AbortAllOperationWantedQuery 
        answer:true
        do:[
            AbortAllOperationWantedQuery query
        ].
    "

    "Created: / 09-02-2011 / 11:42:28 / cg"
! !

!AbortAllOperationWantedQuery class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic/AbortAllOperationWantedQuery.st,v 1.3 2014-12-31 09:09:55 cg Exp $'
! !

