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

CustomContext subclass:#CustomBrowserContext
	instanceVariableNames:'state'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom'
!

!CustomBrowserContext class methodsFor:'documentation'!

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

!CustomBrowserContext class methodsFor:'instance creation'!

perspective: perspective state: state
    ^ self new perspective: perspective state: state

    "Created: / 26-01-2014 / 11:00:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomBrowserContext methodsFor:'accessing'!

perspective:perspectiveArg state:stateArg 
    perspective := perspectiveArg.
    state := stateArg.

    "Created: / 26-01-2014 / 11:00:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomBrowserContext methodsFor:'accessing-selection'!

selectClassNamed:className
    self browser switchToClassNamed: className

    "Created: / 29-08-2015 / 13:25:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectClassNamed:className selector:selector
    | browser class |

    browser := self browser.
    class := browser findClassNamed: className.
    class notNil ifTrue:[ 
        browser switchToClass: class selector: selector
    ].

    "Modified: / 29-08-2015 / 13:28:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectClassesNamed:classNames
    classNames size == 1 ifTrue:[ 
        self selectClassNamed: classNames
    ].
    self notYetImplemented

    "Modified: / 29-08-2015 / 13:25:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectedClassCategories

    ^ state selectedCategories value

    "Modified: / 05-08-2014 / 21:35:11 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

selectedClasses
    "Returns a set of classes currently selected in
     the browser"

    ^ state selectedClasses value ? #() collect:[ :cls | self asRBClass: cls ]

    "Created: / 26-01-2014 / 22:06:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-11-2014 / 20:08:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-12-2014 / 09:43:11 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

selectedCodes
    | codeSelection currentMethod codeView |

    currentMethod := state theSingleSelectedMethod.
    codeView := state codeView.

    (codeView isNil or: [ currentMethod isNil ]) ifTrue: [ 
        ^ nil
    ].

    codeSelection := CustomSourceCodeSelection new.
    codeSelection
        selectedInterval: codeView selectedInterval;
        currentSourceCode: codeView contentsAsString; 
        selectedMethod: currentMethod; 
        selectedClass: currentMethod mclass;
        selectedSelector: currentMethod selector.
        

    ^ Array with: codeSelection

    "Created: / 18-08-2014 / 21:34:56 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 18-08-2014 / 23:51:57 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

selectedMethods

    ^ state selectedMethods value ? #() collect:[ :m | self asRBMethod: m ]

    "Modified: / 14-11-2014 / 20:17:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-12-2014 / 10:10:29 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

selectedPackages

    ^ state packageFilter value

    "Modified: / 05-08-2014 / 21:38:14 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

selectedProtocols
    "Returns a collection of method protocols which are visible and selected in the Browser."
    
    |protocols allIncluded|

    protocols := state selectedProtocols value.
     "Support to return all protocols when all protocol ('* all *') is selected in the Browser.
     This is a little duplicate as in Tools::NewSystemBowser >> selectedProtocolsDo: ,
     but using this method would require a referece to the Browser and furthermore is marked as private."
    allIncluded := protocols ? #() 
            includes:(Tools::BrowserList nameListEntryForALL).
    allIncluded ifTrue:[
        protocols := Set new.
        self selectedClasses do:[:class | 
            protocols addAll:class categories
        ]
    ].
    ^ protocols

    "Modified: / 19-11-2014 / 08:45:13 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

selectedVariables

    ^ state variableFilter value

    "Modified: / 17-05-2014 / 13:29:57 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomBrowserContext methodsFor:'private'!

browser
    "raise an error: this method should be implemented (TODO)"

    ^ state canvas application

    "Created: / 29-08-2015 / 13:25:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomBrowserContext methodsFor:'testing'!

isInteractiveContext
    "Return true, if this generator/refactoring context is interactive,
     i.e., if it may interact with user (like asking for class name or
     similar) or not. 

     Generally speaking, only top-level context is interactive an only
     if generator/refactoring was triggerred from menu.
    "
    ^ true

    "Created: / 16-09-2014 / 09:23:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CustomBrowserContext class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

