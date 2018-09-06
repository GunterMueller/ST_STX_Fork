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

"{ NameSpace: Smalltalk }"

ParseNodeVisitor subclass:#PluggableParseNodeVisitor
	instanceVariableNames:'actionsPerNodeType'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler-Support'
!

!PluggableParseNodeVisitor class methodsFor:'documentation'!

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
    a pluggable node visitor.
    setup with:
        actionForNodeClass:aClass put:aBlock
        
    for example, if you are only interested in assignments,
    use the following code:
        |v|
        v := PluggableParseNodeVisitor new.
        v actionForNodeClass:AssignmentNode put:[:node | Transcript showCR:node. true].
        v visit:(Parser parse:code in:someClass.
"
! !

!PluggableParseNodeVisitor methodsFor:'setup'!

actionForNodeClass:aNodeClass put:aBlock
    "setup so that for nodes of type aNodeClass, aBlock is invoked.
     If the block returns true, subnodes (eg. right side of assignments, etc.)
     will be enumerated as well.
     Otherwise, no subnodes are visited."

    actionsPerNodeType isNil ifTrue:[
         actionsPerNodeType := Dictionary new.
    ].
    actionsPerNodeType at:aNodeClass put:aBlock
! !

!PluggableParseNodeVisitor methodsFor:'visiting'!

visit:aNodeObject
    "redefined to look for an action for this node's class.
     If there is one, it can specify if subnodes are to be visited too"
     
    |action|

    action := actionsPerNodeType at:aNodeObject class ifAbsent:[nil].
    action notNil ifTrue:[ 
        (action value:aNodeObject) ifFalse:[^ self].
    ].
    super visit:aNodeObject
! !

!PluggableParseNodeVisitor class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

