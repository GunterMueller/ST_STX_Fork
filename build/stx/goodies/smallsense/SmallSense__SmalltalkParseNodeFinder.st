"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany
Copyright (C) 2014 Claus Gittinger

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

SmalltalkParseNodeVisitor subclass:#SmalltalkParseNodeFinder
	instanceVariableNames:'position match previous'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Smalltalk'
!

!SmalltalkParseNodeFinder class methodsFor:'documentation'!

copyright
"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany
Copyright (C) 2014 Claus Gittinger

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
! !

!SmalltalkParseNodeFinder methodsFor:'finding'!

findNodeIn: source tree: tree comments: comments line: line column: col

    | sourceS |
    sourceS := source readStream.
    line - 1 timesRepeat:[
        (sourceS nextLine) isNil ifTrue:[
            "No such line"                                
            ^nil
        ].        
    ].
    ^self findNodeIn: source tree: tree comments: comments position: sourceS position + col

    "Created: / 29-01-2014 / 10:20:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

findNodeIn:source tree:tree comments:comments position:pos 
    | i s e |

    position := pos - 1.
    i := 1.
    [
        i < comments size and:[ (s := comments at:i) notNil ]
    ] whileTrue:[
        e := "s + "(comments at:i + 1)" - 1".
        (pos between:s and:e) ifTrue:[
            ^ nil -> pos.
        ].
        i := i + 2.
    ].
    (s notNil and:[ source size == e ]) ifTrue:[ 
        ^ nil -> pos.     
    ].
    self visit:tree.
    ^ (match ? previous) -> pos.

    "Created: / 29-01-2014 / 10:20:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-06-2014 / 16:04:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkParseNodeFinder methodsFor:'visiting'!

visit:anObject 

    anObject isNil ifTrue:[^self].

    (anObject endPosition notNil and:[position > anObject endPosition]) ifTrue:[
        previous := anObject.
        anObject acceptVisitor: self.
        ^self.
    ].

    (anObject startPosition notNil 
        and:[anObject endPosition notNil 
        and:[position between: anObject startPosition and: anObject endPosition]]) ifTrue:[
        match := anObject.
    ].
    anObject acceptVisitor: self.

    "Created: / 26-11-2011 / 15:40:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-09-2013 / 11:15:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitStatementNode:anObject 

    self visit: anObject expression.
    self visit: anObject nextStatement.

    "Modified: / 25-07-2011 / 22:34:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 26-11-2011 / 15:40:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkParseNodeFinder class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

