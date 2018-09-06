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

CustomCodeGeneratorOrRefactoringTestCase subclass:#CustomBrowserContextTests
	instanceVariableNames:'state'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom-Tests'
!

!CustomBrowserContextTests class methodsFor:'documentation'!

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

!CustomBrowserContextTests methodsFor:'accessing'!

generatorOrRefactoring

    ^ nil

    "Created: / 28-10-2014 / 19:17:40 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomBrowserContextTests methodsFor:'initialization & release'!

setUp
    super setUp.

    state := Tools::NavigationState new.
    context := CustomBrowserContext perspective: CustomPerspective new state: state

    "Modified: / 25-01-2015 / 16:08:10 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomBrowserContextTests methodsFor:'tests'!

test_selected_classes_empty

    self assert: state selectedClasses value isNil.
    self assert: (context selectedClasses) = #()

    "Modified: / 29-12-2014 / 10:17:46 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_selected_method_protocols_all
    | expectedProtocols actualProtocols class |

    class := model createClassImmediate: #DummyClassForTestsCase01.
    model createMethodImmediate: class protocol: 'protocol_01' source: 'sel_01 ^ 1'.
    model createMethodImmediate: class protocol: 'protocol_02' source: 'sel_02 ^ 2'.

    expectedProtocols := Set new 
        add: #protocol_01;
        add: #protocol_02;
        yourself.

    state selectedProtocols setValue: (Array with: 'protocol_01' with: (Tools::BrowserList nameListEntryForALL)).
    state selectedClasses setValue: (Array with: class).

    actualProtocols := context selectedProtocols.    
    
    self assert: expectedProtocols = actualProtocols.

    "Created: / 28-10-2014 / 19:21:15 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_selected_method_protocols_all_two_classes
    | expectedProtocols actualProtocols class01 class02 |

    class01 := model createClassImmediate: #DummyClassForTestsCase01.
    model createMethodImmediate: class01 protocol: 'protocol_01' source: 'sel_01 ^ 1'.
    model createMethodImmediate: class01 protocol: 'protocol_02' source: 'sel_02 ^ 2'.

    class02 := model createClassImmediate: #DummyClassForTestsCase02.
    model createMethodImmediate: class02 protocol: 'protocol_01' source: 'sel_09 ^ 9'.
    model createMethodImmediate: class02 protocol: 'protocol_03' source: 'sel_03 ^ 3'.

    expectedProtocols := Set new 
        add: #protocol_01;
        add: #protocol_02;
        add: #protocol_03;
        yourself.

    state selectedProtocols setValue: (Array with: 'protocol_01' with: (Tools::BrowserList nameListEntryForALL)).
    state selectedClasses setValue: (Array with: class01 with: class02).

    actualProtocols := context selectedProtocols.    

    self assert: expectedProtocols = actualProtocols.

    "Created: / 28-10-2014 / 19:26:28 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 19-11-2014 / 09:33:30 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_selected_method_protocols_empty
    | expectedProtocols actualProtocols |

    expectedProtocols := nil.
    state selectedProtocols setValue: nil.

    actualProtocols := context selectedProtocols.    
    
    self assert: expectedProtocols = actualProtocols.

    "Created: / 05-11-2014 / 18:55:14 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_selected_method_protocols_subset
    | expectedProtocols actualProtocols |

    expectedProtocols := Array with: 'protocol_01' with: 'protocol_02'.
    state selectedProtocols setValue: expectedProtocols.

    actualProtocols := context selectedProtocols.    
    
    self assert: expectedProtocols = actualProtocols.

    "Modified: / 28-10-2014 / 19:17:22 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

test_selected_methods_empty
    
    self assert: state selectedMethods value isNil.
    self assert: (context selectedMethods) = #()

    "Modified: / 29-12-2014 / 10:20:35 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

