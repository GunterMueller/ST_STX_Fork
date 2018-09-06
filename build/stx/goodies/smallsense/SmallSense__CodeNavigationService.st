"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany
Copyright (C) 2014 Claus Gittinger
Copyright (C) 2016 Jan Vrany

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

Tools::CodeNavigationService subclass:#CodeNavigationService
	instanceVariableNames:'currentNodeHolder'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Core-Services'
!

Object subclass:#Navigator
	instanceVariableNames:'service button'
	classVariableNames:''
	poolDictionaries:''
	privateIn:CodeNavigationService
!

!CodeNavigationService class methodsFor:'documentation'!

copyright
"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany
Copyright (C) 2014 Claus Gittinger
Copyright (C) 2016 Jan Vrany

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

!CodeNavigationService class methodsFor:'accessing'!

label
    "Answers a short label - for UI"

    ^'SmallSense - Code Navigation'

    "Created: / 27-07-2013 / 22:46:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-09-2013 / 10:27:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeNavigationService methodsFor:'accessing'!

browser
    ^ codeView browser.

    "Created: / 24-09-2013 / 23:38:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

codeView
    ^ codeView

    "Created: / 26-11-2013 / 22:58:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

environment
    | browser |

    browser := self browser.
    ^ browser notNil ifTrue:[browser environment] ifFalse:[Smalltalk]

    "Created: / 24-09-2013 / 23:38:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeNavigationService methodsFor:'event handling'!

button1Press
    | node |

    node := currentNodeHolder value.
    node notNil ifTrue:[
        | navigator |

        navigator := Navigator new
                        service: self;
                        button: 1.
        navigator navigateTo: node.

    ].

    ^self.

    "Created: / 14-02-2010 / 18:43:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-11-2011 / 14:58:02 / cg"
    "Modified: / 24-09-2013 / 10:02:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

button1PressForMessageNode: node

    ^self button1PressForSelector: node parent selector.

    "Created: / 21-02-2012 / 14:30:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

button1PressForVariableNode: node
    | name value |

    value := nil.
    node isGlobalVariable ifTrue:[
        name := node name asSymbolIfInterned.
        name notNil ifTrue:[
            value := Smalltalk at: node name asSymbol.
        ].
        value notNil ifTrue:[
            value isBehavior ifTrue:[
                self browseClass: value.
            ] ifFalse:[
                value inspect.
            ]
        ]
    ]

    "Created: / 21-02-2012 / 14:30:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-12-2013 / 15:41:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

button2Press

    | sel |
    sel := codeView syntaxElementSelection.
    (sel notNil and:[sel node isMessage]) ifTrue:[^self button2PressForSelector: sel node selector].

    "Created: / 14-02-2010 / 18:43:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-03-2012 / 16:49:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeNavigationService methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    "/ please change as required (and remove this comment)
    "/ 

    super initialize.
    currentNodeHolder := ValueHolder new.

    "Modified: / 23-09-2013 / 03:51:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeNavigationService methodsFor:'private'!

highlightElement:element
    super highlightElement:element.
    element notNil ifTrue:[
        currentNodeHolder value: element node.
    ] ifFalse:[
        currentNodeHolder value: nil.
    ].

    "Created: / 23-09-2013 / 03:52:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showMenu: menu
    menuShown := menu.
    menuShown notNil ifTrue:[
        menuShown showAtPointer
    ].

    "Created: / 24-09-2013 / 23:43:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeNavigationService::Navigator methodsFor:'accessing'!

browser
    ^ service browser

    "Created: / 24-09-2013 / 23:37:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

button
    ^ button
!

button:something
    button := something.
!

environment
    ^ service environment

    "Created: / 24-09-2013 / 23:37:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

service
    ^ service
!

service:something
    service := something.
! !

!CodeNavigationService::Navigator methodsFor:'navigation'!

navigateTo: node
    node navigateToUsing: self

    "Created: / 24-09-2013 / 10:03:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeNavigationService::Navigator methodsFor:'navigation - Java'!

navigateToMessageSend: node
    | binding className selector toolbox |

    binding := node binding .
    binding isNil ifTrue:[ ^ nil ].
    className := binding declaringClass compoundName asStringWith: $/.
    binding problemId == 0"NoError" ifTrue:[ 
        selector := binding selector , binding signature.
    ] ifFalse:[
        "/ When a method is a problematic, the signature cannot be
        "/ trusted as eother parameter type or arguments could not
        "/ be resolved. In that case, try to search for the method
        "/ by its name - thiw won't work well with overloaded 
        "/ methods
        | name class method |

        name := binding selector.
        class := self environment allClasses detect:[:c | c isJavaClass and:[c binaryName = className ] ] ifNone: [  nil ].
        class isNil ifTrue:[ ^ nil ].
        method := class methodDictionary detect:[:m | m name = name ] ifNone:[ nil ].
        method isNil ifTrue:[ ^ nil ].
        selector := method selector.
    ].


    toolbox := JavaToolbox new
                browser: self browser;
                environment: self environment;
                yourself.
    button == 1 ifTrue:[
         service showMenu: (toolbox implementorMenuFor: selector inClassNamed: className).
         ^ self.
    ].
    button == 1 ifTrue:[
         service showMenu: (toolbox sendersMenuFor: selector inClassNamed: className).
         ^ self.
    ].

    "Created: / 24-09-2013 / 23:10:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-04-2016 / 17:37:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

navigateToTypeReference: node
    | classType className classes |

    classType := node resolvedType.
    classType notNil ifTrue:[
        className := node resolvedType leafComponentType compoundName asStringWith: $/.
    ] ifFalse:[ 
        | unit typeName |

        unit := service codeView syntaxElements tree.
        typeName := node getTypeName. "/ returns char[][]
        typeName size == 1 ifTrue:[
            "/ Search imports...
            unit imports do:[:import | 
                | importedName typeName |

                importedName := import getImportName. "/ returns char[][].                                
                importedName last = typeName last ifTrue:[ 
                    className := import tokens asStringWith:$/.
                ].
            ].
        ] ifFalse:[ 
            className := typeName asStringWith: $/.
        ].
        "/ If not imported, Try compilation unit's package...
        className isNil ifTrue:[ 
            className := (unit currentPackage tokens asStringWith: $/) , '/' , node token.
        ].
    ].
    "/ Kludge - support both old and new Java class naming scheme
    classes := (JavaClass canUnderstand: #binaryName) 
                    ifTrue:[self environment allClasses select:[:cls | cls isJavaClass and:[cls binaryName = className]]]
                    ifFalse:[self environment allClasses select:[:cls | cls isJavaClass and:[cls name = className]]].

    classes isEmpty ifTrue:[
        service codeView textView flash.
        ^ self.
    ].
    classes size == 1 ifTrue:[
        service browseClass: classes anElement.    
        ^ self.
    ].
    self halt: 'Not yet supported'.

    "Created: / 24-09-2013 / 10:16:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-08-2014 / 15:17:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeNavigationService::Navigator methodsFor:'navigation - Smalltalk'!

navigateToMessageNode: node
    "/ Implementors
    button == 1 ifTrue:[
        "/ Use legacy code...
        service button1PressForSelector: node selector.         
        ^ self
    ].
    button == 2 ifTrue:[
        "/ Use legacy code...
        service button2PressForSelector: node selector.         
        ^ self                                                  
    ].

    "Created: / 24-09-2013 / 10:06:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

navigateToVariableNode: node
    "/ Use legacy code for now...
    button == 1 ifTrue:[
        service button1PressForVariableNode: node .         
    ]

    "Created: / 24-09-2013 / 10:06:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeNavigationService class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

