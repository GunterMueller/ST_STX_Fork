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

JavaCompletionEngineSimple subclass:#GroovyCompletionEngineSimple
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Groovy'
!

!GroovyCompletionEngineSimple class methodsFor:'documentation'!

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

!GroovyCompletionEngineSimple class methodsFor:'accessing-definitions'!

patternDefinitionsForAnalysis
    ^ super patternDefinitionsForAnalysis , {
        #analyzeLocalDef1:              .  '[[:def:]] [[:Identifier:]] ( = | ; )' .
    }

    "
    self flush; patternsForAnalysis
    "

    "Created: / 23-05-2014 / 10:24:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

patternDefinitionsForCompletion

    ^super patternDefinitionsForCompletion , {
        #completeLocalDef:              . '( ', PatternPrimitiveType , ' | ' , PatternReferenceType , ' | [[:def:]] ) [[:Identifier:]] [[:CARET:]]' .
    }

    "
    self flush.
    self patternsForCompletion
    "

    "Created: / 19-05-2014 / 12:32:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GroovyCompletionEngineSimple methodsFor:'accessing-class'!

scannerClass
    "raise an error: this method should be implemented (TODO)"

    ^ GroovyScanner

    "Created: / 13-05-2014 / 17:46:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GroovyCompletionEngineSimple methodsFor:'analysis'!

analyzeLocalDef1: match
    "Analyze:

    def <identifier> ;

    "
    | name |

    self assert: match size = 3.
    name := (match at: match size - 1) value.
    locals at: name put: nil.

    "Created: / 23-05-2014 / 10:26:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GroovyCompletionEngineSimple class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

