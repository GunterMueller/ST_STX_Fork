"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
"{ Package: 'stx:goodies/smallsense' }"

"{ NameSpace: SmallSense }"

Object subclass:#SmalltalkParseNodeVisitor
	instanceVariableNames:'class'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Smalltalk'
!

!SmalltalkParseNodeVisitor class methodsFor:'documentation'!

copyright
"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
!

documentation
"
    An abstract parse tree visitor. Copied from libcomp
    as ParseNodeVisitor is autoloaded and we need smallsense
    to be fully compiled.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!SmalltalkParseNodeVisitor class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!SmalltalkParseNodeVisitor class methodsFor:'processing'!

process:tree in:class manager:manager 
    ^ self new 
        process:tree
        in:class
        manager:manager

    "Created: / 26-11-2011 / 13:48:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-08-2015 / 16:01:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkParseNodeVisitor methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    "/ please change as required (and remove this comment)

    "/ super initialize.   -- commented since inherited method does nothing
! !

!SmalltalkParseNodeVisitor methodsFor:'processing'!

process:tree in:cls manager:anObject 
    class := cls.
    self visit:tree

    "Created: / 26-11-2011 / 13:48:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkParseNodeVisitor methodsFor:'visiting'!

visit:anObject 

    | stmt |

    anObject isNil ifTrue:[ ^ self ].

    ^anObject isStatementNode ifTrue:[
        stmt := anObject.
        [ stmt notNil and:[stmt isStatementNode ] ] whileTrue:[
            stmt acceptVisitor:self.
            stmt := stmt nextStatement.
        ].
        stmt notNil ifTrue:[
            stmt acceptVisitor: self.
        ].
    ] ifFalse:[
        anObject acceptVisitor: self.
    ]

    "Modified: / 26-02-2014 / 22:45:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitAssignmentNode:anObject

    self visit: anObject variable.
    self visit: anObject expression.

    "Modified: / 26-11-2011 / 13:20:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitBinaryNode:anObject 

    ^self visitMessageNode: anObject

    "Modified: / 25-07-2011 / 22:30:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitBlockNode:anObject 

    anObject statements ifNotNil:[
        self visit: anObject statements
    ].

    "Modified: / 25-07-2011 / 22:45:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitCascadeNode:anObject 

    self visitMessageNode: anObject.

    "Modified: / 25-07-2011 / 22:37:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitConstantNode:anObject

    "Modified: / 25-07-2011 / 22:41:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitECompletionConstantNode:anObject 
    "dispatched back from the visited eCompletionConstantNode-object (visitor pattern)"

    "fall back to general object-case - please change as required"

    ^ self visitObject:anObject
!

visitMessageNode:anObject 

    self visit: anObject receiver.
    anObject arguments do:[:arg|
        self visit: arg.
    ]

    "Modified: / 25-07-2011 / 22:37:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitObject:anObject 
    "dispatched back from the visited objects (visitor pattern)"

    "general fallBack - please change as required"

    self halt:'not yet implemented'
!

visitParseErrorNode:anObject
    anObject children notNil ifTrue:[
        anObject children do:[:each|self visit: each].
    ]

    "Modified: / 15-08-2013 / 12:34:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitPrimitiveNode:anObject

    "Modified: / 25-07-2011 / 22:38:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitReturnNode:anObject 

    self visitStatementNode: anObject

    "Modified: / 25-07-2011 / 22:34:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitSelfNode:anObject

    "Modified: / 25-07-2011 / 22:38:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitStatementNode:anObject 

    self visit: anObject expression.

    "Modified: / 25-07-2011 / 22:34:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitSuperNode:anObject

    "Modified: / 25-07-2011 / 22:38:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitUnaryNode:anObject 

    self visitMessageNode: anObject

    "Modified: / 25-07-2011 / 22:38:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitVariableNode:anObject

    "Modified: / 25-07-2011 / 22:38:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkParseNodeVisitor class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

