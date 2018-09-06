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
"{ Package: 'stx:libcomp' }"

ConstantNode subclass:#ECompletionConstantNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler-Support'
!

!ECompletionConstantNode class methodsFor:'documentation'!

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

!ECompletionConstantNode class methodsFor:'Adding'!

type:t value:val

    ^ (self basicNew) type:t value:val

    "Created: / 23-02-2011 / 18:23:19 / Jakub <zelenja7@fel.cvut.cz>"
! !

!ECompletionConstantNode methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitECompletionConstantNode:self
! !

!ECompletionConstantNode class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libcomp/ECompletionConstantNode.st,v 1.2 2011-07-25 22:36:22 vrany Exp $'
!

version_SVN
    ^ '§ Id: ECompletionConstantNode.st 2038 2011-04-05 13:57:16Z vranyj1  §'
! !
