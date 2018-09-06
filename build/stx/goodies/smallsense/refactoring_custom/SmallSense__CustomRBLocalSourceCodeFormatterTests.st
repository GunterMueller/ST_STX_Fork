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

Smalltalk::TestCase subclass:#CustomRBLocalSourceCodeFormatterTests
	instanceVariableNames:'spaceAfterReturnToken maxLengthForSingleLineBlocks
		blockArgumentsOnNewLine formatter'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Tests'
!

!CustomRBLocalSourceCodeFormatterTests class methodsFor:'documentation'!

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

!CustomRBLocalSourceCodeFormatterTests methodsFor:'initialization & release'!

setUp
    "Original RBFormatter settings"

    spaceAfterReturnToken := RBFormatter spaceAfterReturnToken.
    maxLengthForSingleLineBlocks := RBFormatter maxLengthForSingleLineBlocks.
    blockArgumentsOnNewLine := RBFormatter blockArgumentsOnNewLine.

    formatter := CustomRBLocalSourceCodeFormatter new.

    "Modified: / 30-08-2014 / 23:18:26 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

tearDown

    RBFormatter spaceAfterReturnToken: spaceAfterReturnToken.
    RBFormatter maxLengthForSingleLineBlocks: maxLengthForSingleLineBlocks.
    RBFormatter blockArgumentsOnNewLine: blockArgumentsOnNewLine.

    "Modified: / 21-08-2014 / 11:54:09 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomRBLocalSourceCodeFormatterTests methodsFor:'private'!

initilizeFormatterSettings: aFormatter

    aFormatter
        tabIndent: 4;  
        spaceAroundTemporaries: false;  
        emptyLineAfterTemporaries: true;  
        emptyLineAfterMethodComment: true;
        spaceAfterReturnToken: true;  
        spaceAfterKeywordSelector: false;  
        spaceAfterBlockStart: true;  
        spaceBeforeBlockEnd: true;  
        cStyleBlocks: true;  
        blockArgumentsOnNewLine: false;  
        maxLengthForSingleLineBlocks: 4;
        periodAfterLastStatementPolicy: #keep.

    "Created: / 30-08-2014 / 23:27:15 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomRBLocalSourceCodeFormatterTests methodsFor:'tests'!

test_format_parse_tree_source_is_nil
    | expectedSource actualSource parseTree source |

    source := 'selector ^ 777'.
    parseTree := RBParser parseMethod: source.
    parseTree source: nil.

    formatter tabIndent: 4.
    formatter spaceAfterReturnToken: true.

    actualSource := formatter formatParseTree: parseTree.    
    expectedSource := 'selector
    ^ 777'.

    self assert: actualSource = expectedSource.

    "Created: / 31-08-2014 / 14:59:03 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_format_parse_tree_source_not_nil
    | expectedSource actualSource parseTree source |

    source := 'selector ^ 777'.
    parseTree := RBParser parseMethod: source.
    parseTree source: source.

    formatter tabIndent: 4.
    formatter spaceAfterReturnToken: true.

    actualSource := formatter formatParseTree: parseTree.    
    expectedSource := 'selector
    ^ 777'.

    self assert: actualSource = expectedSource.

    "Created: / 31-08-2014 / 14:58:26 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_format_source_code
    "Assert that some formatting is made."

    | sourceCodeString actualSource |

    sourceCodeString := 'selector ^ 563'.

    actualSource := formatter formatSourceCode: sourceCodeString.    
    
    self deny: sourceCodeString = actualSource.

    "Created: / 30-08-2014 / 23:24:36 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 09-09-2014 / 21:47:28 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_formatter_setting_set_and_get

    | expectedTabIndent actualTabIndent |

    self deny: (formatter class canUnderstand: #tabIndent:).  
    self deny: (formatter class canUnderstand: #tabIndent).  

    formatter tabIndent: 10.    

    expectedTabIndent := 10.
    actualTabIndent := formatter tabIndent.

    self assert: expectedTabIndent = actualTabIndent.

    "Created: / 31-08-2014 / 14:42:46 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_formatter_setting_unknown

    self deny: (formatter class canUnderstand: #someUnknownSetting:).  

    self should: [
        formatter someUnknownSetting: 10
    ] raise: MessageNotUnderstood

    "Created: / 31-08-2014 / 14:44:59 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_formatter_settings_modified_and_then_restored

    formatter
        spaceAfterReturnToken: (spaceAfterReturnToken isNil ifTrue: [ true ] ifFalse: [ spaceAfterReturnToken not ]);  
        maxLengthForSingleLineBlocks: (spaceAfterReturnToken isNil ifTrue: [ 21 ] ifFalse: [ maxLengthForSingleLineBlocks + 10 ]);
        blockArgumentsOnNewLine: (blockArgumentsOnNewLine isNil ifTrue: [ true ] ifFalse: [ blockArgumentsOnNewLine not ]).

    formatter setUpFormatterSettings.

    self assert: (RBFormatter spaceAfterReturnToken) == (spaceAfterReturnToken isNil ifTrue: [ true ] ifFalse: [ spaceAfterReturnToken not ]).
    self assert: (RBFormatter maxLengthForSingleLineBlocks) == (spaceAfterReturnToken isNil ifTrue: [ 21 ] ifFalse: [ maxLengthForSingleLineBlocks + 10 ]).
    self assert: (RBFormatter blockArgumentsOnNewLine) == (blockArgumentsOnNewLine isNil ifTrue: [ true ] ifFalse: [ blockArgumentsOnNewLine not ]).

    formatter restoreFormatterSettings.

    self assert: (RBFormatter spaceAfterReturnToken) == spaceAfterReturnToken.
    self assert: (RBFormatter maxLengthForSingleLineBlocks) == maxLengthForSingleLineBlocks.
    self assert: (RBFormatter blockArgumentsOnNewLine) == blockArgumentsOnNewLine.

    "Created: / 21-08-2014 / 11:44:28 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 30-08-2014 / 23:40:26 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomRBLocalSourceCodeFormatterTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

