"
A custom code generation and refactoring support for Smalltalk/X
Copyright (C) 2013-2015 Jakub Nesveda
Copyright (C) 2015 Jan Vrany

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
"{ Package: 'stx:goodies/smallsense/refactoring_custom' }"

"{ NameSpace: SmallSense }"

ParseTreeSourceRewriter subclass:#CustomParseTreeRewriter
	instanceVariableNames:'oldSource newSource'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom'
!

!CustomParseTreeRewriter class methodsFor:'documentation'!

copyright
"
A custom code generation and refactoring support for Smalltalk/X
Copyright (C) 2013-2015 Jakub Nesveda
Copyright (C) 2015 Jan Vrany

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
    Extension for ParseTreeSourceRewriter so that it work even for expressions and not just methods.

    [author:]
        Jakub Nesveda <nesvejak@fit.cvut.cz>

"
! !

!CustomParseTreeRewriter methodsFor:'accessing'!

executeTree: aParseTree
    "Like ParseTreeSourceRewriter >> executeTree:, but with
    additional support for expressions"
    | oldContext treeFromRewrittenSource |

    oldContext := context.
    context := (RBSmallDictionary ? Dictionary) new.
    answer := false.
    oldSource isNil ifTrue: [
        oldSource := aParseTree source
    ].  

    oldSource isNil ifTrue: [ 
        self error: 'We need the oldSource string to be set'.
    ].

    "/Rewrite the tree as usual and then (try to) rewrite the original source code
    tree := self visitNode: aParseTree.
    replacements notNil ifTrue:[
        newSource := self executeReplacementsInSource: oldSource.
    ] ifFalse:[
        ^answer
    ].
    "/DO NOT forget rewrites here!!!!!!"

    "/Now, validates that rewritten parse tree is the same as
    "/the one we get from the rewritten source:
    aParseTree isMethod ifTrue: [ 
        treeFromRewrittenSource := RBParser parseRewriteMethod: newSource onError:[:error :position|nil].
    ] ifFalse: [ 
        treeFromRewrittenSource := RBParser parseExpression: newSource onError:[:error :position|nil].
    ].
    treeFromRewrittenSource = tree ifTrue:[
        (tree respondsTo: #source:) ifTrue: [ 
            tree source: newSource.
        ].
    ] ifFalse: [
        "Better set newSource to nil in order to indicate that something went wrong"
        newSource := nil.
    ].
    context := oldContext.
    ^answer

    "Created: / 09-12-2014 / 21:16:33 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 05-02-2015 / 22:07:20 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

newSource
    "Returns the source code string after the replacements were executed"

    ^ newSource

    "Modified (comment): / 09-12-2014 / 22:19:03 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

oldSource
    "Returns custom old source code string - the code before replacements were made"

    ^ oldSource

    "Modified (comment): / 09-12-2014 / 21:19:04 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

oldSource: aString
    "see oldSource"

    oldSource := aString

    "Modified (comment): / 09-12-2014 / 21:19:59 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

