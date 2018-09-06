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

Smalltalk::TestCase subclass:#CustomSourceCodeGeneratorTests
	instanceVariableNames:'sourceCodeGenerator'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Tests'
!

!CustomSourceCodeGeneratorTests class methodsFor:'documentation'!

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

!CustomSourceCodeGeneratorTests methodsFor:'initialization & release'!

setUp

    sourceCodeGenerator := CustomSourceCodeGenerator new.
    sourceCodeGenerator formatter: CustomNoneSourceCodeFormatter new.

    "Modified: / 19-09-2014 / 23:42:00 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomSourceCodeGeneratorTests methodsFor:'tests'!

test_new_source_literal_replacement
    |expectedSource actualSource|

    actualSource := sourceCodeGenerator
            replace:'`"comment1' with:'"comment1"';
            replace:'`"comment2' with:'"other comment2"';
            replace:'`#literal' with:'''some info''';
            source:'selector
    `"comment1

    self information: `#literal.

    `"comment2

    ^ 55';
            newSource.
    expectedSource := 'selector
    "comment1"

    self information: ''some info''.

    "other comment2"

    ^ 55'.
    self assert:expectedSource = actualSource.

    "Created: / 19-09-2014 / 23:45:30 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_new_source_selector_as_symbol
    | expectedSource actualSource |

    actualSource := sourceCodeGenerator
        source: '`@selector
            self shouldImplement';
        replace: '`@selector' with: 'aSelector: withParam' asSymbol;
        newSource.    

    expectedSource := 'aSelector: withParam
            self shouldImplement'.

    self assert: expectedSource = actualSource.

    "Created: / 20-09-2014 / 09:36:39 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_new_source_selector_replacement
    |expectedSource actualSource|

    actualSource := sourceCodeGenerator
            source:'`@selector
            self shouldImplement';
            replace:'`@selector' with:'aSelector';
            newSource.
    expectedSource := 'aSelector
            self shouldImplement'.
    self assert:expectedSource = actualSource.

    "Created: / 19-09-2014 / 23:51:19 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_new_source_selector_with_param
    | expectedSource actualSource |

    actualSource := sourceCodeGenerator
        source: '`@selector
            self shouldImplement';
        replace: '`@selector' with: 'aSelector: withParam';
        newSource.    

    expectedSource := 'aSelector: withParam
            self shouldImplement'.

    self assert: expectedSource = actualSource.

    "Created: / 20-09-2014 / 09:39:15 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_replace_comments_in_source
    | expectedSource actualSource |

    actualSource := sourceCodeGenerator
        replace: '`"comment1' with: '"comment1"'; 
        replace: '`"comment2' with: '"other comment2"';
        replaceCommentsInSource:'selector
    `"comment1

    self information: ''some info''.

    `"comment2

    ^ 55'.    

    expectedSource := 'selector
    "comment1"

    self information: ''some info''.

    "other comment2"

    ^ 55'.
    
    self assert: expectedSource = actualSource.

    "Created: / 19-09-2014 / 22:50:29 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomSourceCodeGeneratorTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

