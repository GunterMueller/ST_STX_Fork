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

Smalltalk::TestCase subclass:#CustomSourceCodeSelectionTests
	instanceVariableNames:'codeSelection'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Tests'
!

!CustomSourceCodeSelectionTests class methodsFor:'documentation'!

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

!CustomSourceCodeSelectionTests methodsFor:'initialization & release'!

setUp

    codeSelection := CustomSourceCodeSelection new.

    "Created: / 24-08-2014 / 22:51:50 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomSourceCodeSelectionTests methodsFor:'tests'!

test_current_source_code_class_and_selector_filled

    codeSelection 
        selectedClass: self class;
        selectedSelector: #setUp.    
    
    self assert: (codeSelection currentSourceCode startsWith: 'setUp').

    "Created: / 24-08-2014 / 22:56:33 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_current_source_code_filled

    codeSelection currentSourceCode: 'src'.
    
    self assert: codeSelection currentSourceCode = 'src'.

    "Created: / 24-08-2014 / 22:54:09 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_current_source_code_method_filled

    codeSelection selectedMethod: (self class compiledMethodAt: #setUp).    
    
    self assert: (codeSelection currentSourceCode startsWith: 'setUp').

    "Created: / 24-08-2014 / 22:55:25 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_current_source_code_not_filled
    
    self assert: codeSelection currentSourceCode isNil.

    "Created: / 24-08-2014 / 22:57:47 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_is_whole_method_selected_all_empty
    
    self deny: codeSelection isWholeMethodSelected

    "Created: / 07-12-2014 / 18:51:54 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_is_whole_method_selected_complete_selection
    | method |

    method := self class compiledMethodAt: #test_is_whole_method_selected_complete_selection.  

    codeSelection
        selectedInterval: (1 to: method source size);
        selectedMethod: method.    
    
    self assert: codeSelection isWholeMethodSelected

    "Created: / 07-12-2014 / 19:11:40 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_is_whole_method_selected_empty_method

    codeSelection
        selectedInterval: (3 to: 6);
        currentSourceCode: 'some code'.    
    
    self deny: codeSelection isWholeMethodSelected

    "Created: / 07-12-2014 / 19:09:30 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_is_whole_method_selected_empty_selection

    codeSelection selectedMethod: (self class compiledMethodAt: #test_is_whole_method_selected_empty_selection).    
    
    self assert: codeSelection isWholeMethodSelected

    "Modified: / 07-12-2014 / 18:53:15 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_print_on_all_filled
    | expectedString actualString stream method |

    method := (self class compiledMethodAt: #test_print_on_all_filled).

    expectedString := 'a SmallSense::CustomSourceCodeSelection (selectedInterval: 2 to:5; ',
        'currentSourceCode: test_print_on_all_filled ^ 265; ',
        'selectedMethod: ', method asString, '; ',
        'selectedClass: SmallSense::CustomSourceCodeSelectionTests; selectedSelector: test_print_on_all_filled)'.

    stream := WriteStream on:(String new).

    codeSelection
        selectedClass: self class;
        selectedMethod: method;
        selectedInterval: (2 to: 5);
        selectedSelector: #test_print_on_all_filled;
        currentSourceCode: 'test_print_on_all_filled ^ 265'.

    codeSelection printOn:stream.    

    actualString := stream contents.
    
    self assert: expectedString = actualString.

    "Modified: / 25-01-2015 / 14:36:11 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 12-06-2015 / 21:07:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_selected_selector_from_method
    | expectedSelector actualSelector |

    expectedSelector := #test_selected_selector_from_method.
    codeSelection selectedMethod: (self class compiledMethodAt: #test_selected_selector_from_method).

    actualSelector := codeSelection selectedSelector.

    self assert: expectedSelector = actualSelector.

    "Created: / 28-10-2014 / 09:31:45 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_selected_selector_from_source
    | expectedSelector actualSelector |

    expectedSelector := #test_selector_01.
    codeSelection currentSourceCode: 'test_selector_01 ^ 101'.

    actualSelector := codeSelection selectedSelector.

    self assert: expectedSelector = actualSelector.

    "Created: / 28-10-2014 / 10:52:31 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_selected_selector_known
    | expectedSelector actualSelector |

    expectedSelector := #selector_01.
    codeSelection selectedSelector: expectedSelector.

    actualSelector := codeSelection selectedSelector.

    self assert: expectedSelector = actualSelector.

    "Created: / 28-10-2014 / 09:30:30 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_selected_selector_unknown
    | expectedSelector actualSelector |

    expectedSelector := nil.
    actualSelector := codeSelection selectedSelector.

    self assert: expectedSelector = actualSelector.

    "Created: / 28-10-2014 / 09:29:36 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_selected_source_code_nil_when_unknown
    
    self assert: codeSelection selectedSourceCode isNil

    "Modified: / 05-11-2014 / 22:51:35 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_selected_source_code_part_code

    codeSelection
        currentSourceCode: 'selector ^ self otherSelector.';
        selectedInterval: (12 to: 15).

    self assert: codeSelection selectedSourceCode = 'self'.

    "Created: / 24-08-2014 / 23:06:10 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_selected_source_code_whole_code

    codeSelection
        currentSourceCode: 'selector ^ self otherSelector.';
        selectedInterval: (1 to: 30).

    self assert: codeSelection selectedSourceCode = 'selector ^ self otherSelector.'.

    "Created: / 24-08-2014 / 22:58:19 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_selected_source_code_with_exceeding_interval

    codeSelection
        currentSourceCode: 'selector ^ self otherSelector.';
        selectedInterval: (1 to: 9999999).

    self assert: codeSelection selectedSourceCode = 'selector ^ self otherSelector.'.

    "Created: / 18-10-2014 / 13:13:34 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_selected_source_interval_empty

    codeSelection
        currentSourceCode: 'selector ^ self otherSelector.';
        selectedInterval: (1 to: 0).

    self assert: codeSelection selectedSourceCode isNil.

    "Created: / 14-10-2014 / 10:22:52 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_selected_source_interval_wrong

    codeSelection
        currentSourceCode: 'selector ^ self otherSelector.';
        selectedInterval: (9999 to: 99999).

    self should: [
        codeSelection selectedSourceCode
    ]  raise: Error

    "Created: / 18-10-2014 / 13:06:44 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_selected_source_unknown
    | expectedSource |

    expectedSource := 'selector ^ self otherSelector.'.

    codeSelection
        currentSourceCode: expectedSource.

    self assert: expectedSource = (codeSelection selectedSourceCode).

    "Created: / 14-10-2014 / 10:19:44 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 28-10-2014 / 09:13:24 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomSourceCodeSelectionTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

