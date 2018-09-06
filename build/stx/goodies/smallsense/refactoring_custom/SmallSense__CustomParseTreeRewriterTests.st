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

Smalltalk::TestCase subclass:#CustomParseTreeRewriterTests
	instanceVariableNames:'rewriter'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Tests'
!

!CustomParseTreeRewriterTests class methodsFor:'documentation'!

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
! !

!CustomParseTreeRewriterTests methodsFor:'initialization & release'!

setUp
    super setUp.

    rewriter := CustomParseTreeRewriter new

    "Modified: / 10-12-2014 / 22:29:15 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomParseTreeRewriterTests methodsFor:'tests'!

test_execute_tree_expression_01
    | parseTree originalSource foundMatch expectedSource actualSource |

    originalSource := 'condition ifTrue: [
        self doStuff
    ]'.

    expectedSource := 'condition ifTrue: [
        self doAnotherStuff
    ]'.

    parseTree := RBParser parseExpression: originalSource.

    rewriter
        oldSource: originalSource;  
        replace: 'self doStuff' with: 'self doAnotherStuff'.

    foundMatch := rewriter executeTree: parseTree.
    self assert: foundMatch.

    actualSource := rewriter newSource.

    self assert: expectedSource = actualSource

    "Modified: / 10-12-2014 / 22:40:59 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_execute_tree_expression_02
    | parseTree originalSource foundMatch expectedSource actualSource |

    originalSource := 'condition ifTrue: [
        self doStuff
    ]'.

    expectedSource := '''a literal string'''.

    parseTree := RBParser parseExpression: originalSource.

    rewriter
        oldSource: originalSource;  
        replace: '`@something' with: ' ''a literal string'' '.

    foundMatch := rewriter executeTree: parseTree.
    self assert: foundMatch.

    actualSource := rewriter newSource.

    self assert: expectedSource = actualSource

    "Created: / 10-12-2014 / 22:42:09 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_execute_tree_expression_new_source_empty
    | parseTree originalSource foundMatch actualSource |

    originalSource := 'condition ifTrue: [
        self doStuff
    ]'.

    parseTree := RBParser parseExpression: originalSource.

    rewriter
        oldSource: originalSource;  
        replace: '`#literal' with: ' ''a literal string'' '.

    foundMatch := rewriter executeTree: parseTree.
    self deny: foundMatch.

    actualSource := rewriter newSource.

    self assert: actualSource isNil

    "Created: / 10-12-2014 / 22:46:04 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 15:20:06 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_execute_tree_expression_old_source_error
    | parseTree originalSource |

    originalSource := 'condition ifTrue: [
        self doStuff
    ]'.

    parseTree := RBParser parseExpression: originalSource.

    rewriter replace: '`@something' with: ' ''a literal string'' '.

    self should: [ 
        rewriter executeTree: parseTree.
    ] raise: Error

    "Created: / 10-12-2014 / 22:45:16 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 15:20:20 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_execute_tree_method_01
    | parseTree originalSource foundMatch expectedSource actualSource |

    originalSource := 'method: arg01
    arg01 isSomething ifTrue: [
        self doStuff
    ]'.

    expectedSource := 'method: arg01
    arg01 isSomething ifTrue: [
        self doAnotherStuff
    ]'.

    parseTree := RBParser parseMethod: originalSource.

    rewriter
        oldSource: originalSource;  
        replace: 'self doStuff' with: 'self doAnotherStuff'.

    foundMatch := rewriter executeTree: parseTree.
    self assert: foundMatch.

    actualSource := rewriter newSource.

    self assert: expectedSource = actualSource

    "Created: / 10-12-2014 / 22:49:39 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_execute_tree_method_02
    | parseTree originalSource foundMatch expectedSource actualSource |

    originalSource := 'method: arg01
    arg01 isSomething ifTrue: [
        self doStuff
    ]'.

    expectedSource := 'method: arg01
    arg01 isAnotherThing ifTrue: [
        self doAnotherStuff
    ]'.

    parseTree := RBParser parseMethod: originalSource.

    rewriter
        replace: '`@receiver isSomething' with: '`@receiver isAnotherThing';
        replace: 'self doStuff' with: 'self doAnotherStuff'.

    foundMatch := rewriter executeTree: parseTree.
    self assert: foundMatch.

    actualSource := rewriter newSource.

    self assert: expectedSource = actualSource

    "Created: / 10-12-2014 / 22:53:29 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

