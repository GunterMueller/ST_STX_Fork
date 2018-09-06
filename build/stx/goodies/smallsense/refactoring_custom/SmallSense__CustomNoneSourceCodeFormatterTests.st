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

Smalltalk::TestCase subclass:#CustomNoneSourceCodeFormatterTests
	instanceVariableNames:'formatter'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Tests'
!

!CustomNoneSourceCodeFormatterTests class methodsFor:'documentation'!

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

!CustomNoneSourceCodeFormatterTests methodsFor:'initialization & release'!

setUp

    formatter := CustomNoneSourceCodeFormatter new

    "Modified: / 31-08-2014 / 15:04:23 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomNoneSourceCodeFormatterTests methodsFor:'tests'!

test_format_parse_tree_source_is_nil
    | expectedSource actualSource parseTree source |

    source := 'selector ^ 777'.
    parseTree := RBParser parseMethod: source.
    parseTree source: nil.

    actualSource := (formatter formatParseTree: parseTree) copyWithRegex: '\s' matchesReplacedWith: ''.    
    expectedSource := 'selector^777'.

    self assert: actualSource = expectedSource.

    "Created: / 31-08-2014 / 15:06:17 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_format_parse_tree_source_not_nil
    | expectedSource actualSource parseTree source |

    source := 'selector ^ 777'.
    parseTree := RBParser parseMethod: source.
    parseTree source: source.

    actualSource := formatter formatParseTree: parseTree.    
    expectedSource := 'selector ^ 777'.

    self assert: actualSource = expectedSource.

    "Created: / 31-08-2014 / 15:07:25 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomNoneSourceCodeFormatterTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

