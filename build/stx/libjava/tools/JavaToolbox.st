"{ Package: 'stx:libjava/tools' }"

Tools::Toolbox subclass:#JavaToolbox
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Tools'
!

!JavaToolbox class methodsFor:'documentation'!

documentation
"
    JavaToolbox contains various utility method used by other tools
    to perform language-specific tasks.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!JavaToolbox methodsFor:'browsing'!

spawnBrowserOnAllImplementorsOf: selector class: class 
    | label |

    self ensureBrowser.
    browser withWaitCursorDo:[
        label := browser resources string:'Implementors of %1' with: (self displayStringForSelector: selector in: class name).
        browser 
            spawnMethodBrowserForSearch:[self searchForImplementorsOf: selector class: class]
            sortBy:#class
            in:#newBuffer
            label:label.
    ]

    "Created: / 01-09-2013 / 17:59:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-09-2013 / 12:44:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

spawnBrowserOnAllSendersOf: selector class: class 
    | label search |

    self ensureBrowser.
    browser withWaitCursorDo:[
        label := browser resources string:'Senders of %1' with: (self displayStringForSelector: selector in: class name).
        search := selector upTo: $(.
        browser 
            spawnMethodBrowserForSearch:[self searchForSendersOf: selector class: class]
            sortBy:#class
            in:#newBuffer
            label:label.
        browser autoSearchSelector:search ignoreCase:false doMatch:false.     
    ]

    "Created: / 01-09-2013 / 17:59:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

spawnBrowserOnClass: class selector: selector
    self spawnBrowserOnMethod: (class compiledMethodAt: selector asSymbol)

    "Created: / 25-09-2013 / 00:12:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

spawnBrowserOnMethod: method
    browser isNil ifTrue:[
         Tools::NewSystemBrowser openInMethod:method.
         ^ self
    ].
    (UserPreferences current alwaysOpenNewTabWhenCtrlClick
        or:[self browser navigationState modified])
        ifTrue:
            [self browser
                spawnFullBrowserInClass: method mclass
                selector:method selector
                in:#newBuffer]
        ifFalse:
            [self browser
                switchToClass: method containingClass
                    selector: method selector].

    "Created: / 25-09-2013 / 00:12:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaToolbox methodsFor:'menus'!

implementorMenuFor: selector inClassNamed: className
    | menu definingClasses implementors |

    menu := Menu new.
    definingClasses := environment allClasses select:[:cls | cls isJavaClass and:[cls binaryName = className ]].
    definingClasses do:[:cls|
        menu addItem: 
            (MenuItem label: (self displayStringForSelector: selector in: cls binaryName withClassName: true)
                itemValue:[ self spawnBrowserOnClass: cls selector: selector]). 
    ].
    implementors := Set new.
    definingClasses do:[:cls | implementors addAll: (self searchForImplementorsOf: selector class: cls)].
    implementors := implementors reject:[:m | definingClasses includes: m mclass ].
    implementors := implementors asSortedCollection:[:a :b | a mclass lastName < b mclass lastName ].
    implementors notEmptyOrNil ifTrue:[
        menu addSeparator.
        implementors do:[:m|
            menu addItem: 
                (MenuItem label: (self displayStringForSelector: selector in: m mclass binaryName withClassName: true)
                    itemValue:[ self spawnBrowserOnMethod: m]). 
        ].
    ].

    ^ menu

    "Created: / 24-09-2013 / 23:48:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-10-2013 / 22:31:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

messagesMenuFor:actionSelector
    withMethods: methods
    withMethodSelectors:withMethodSelectors
    withSentSelectors: withSentSelectors
    withSelfSelectorsOnly: withSelfSelectorsOnly    

    | xlatedSelector menu builder sent |

    actionSelector == #spawnBrowserOnAllSendersOf: ifTrue:[
        xlatedSelector := #spawnBrowserOnAllSendersOf:class:
    ] ifFalse:[actionSelector == #spawnBrowserOnAllImplementorsOf: ifTrue:[
        xlatedSelector := #spawnBrowserOnAllImplementorsOf:class:
    ] ifFalse:[
        ^ Menu new
            addItem: ((MenuItem label: 'Not supported for Java') enabled: false);
            yourself.
    ]].

    builder := [:class :selector |
        menu addItem:
            (MenuItem 
                label: (self displayStringForSelector: selector in: class name)
                itemValue: [ self perform: xlatedSelector with: selector with: class ])
    ].

    menu := Menu new.
    withMethodSelectors ifTrue:[
        methods do:[:m | builder value: m originalMethodIfWrapped javaClass value: m selector ].
    ].
    withSentSelectors ifTrue:[
        sent := Set new.
        methods do:[:m | sent addAll: m originalMethodIfWrapped analyzer methodsInvoked ].
        sent notEmptyOrNil ifTrue:[
            withMethodSelectors ifTrue:[
                menu addSeparator.
            ].
            sent := sent asSortedCollection:[:a :b|a selector < b selector ].
            sent do:[:mref |
                builder value: mref classRef javaClass value: mref selector
            ]
        ].
    ].
    ^ menu.

    "Created: / 01-09-2013 / 17:03:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-10-2013 / 01:14:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sendersMenuFor: selector inClassNamed: className
    | menu definingClasses senders |

    menu := Menu new.
    definingClasses := environment allClasses select:[:cls | cls isJavaClass and:[cls binaryName = className ]].
    senders := Set new.
    definingClasses do:[:cls | senders addAll: (self searchForSendersOf: selector class: cls)].
    senders := senders reject:[:m | definingClasses includes: m mclass ].
    senders := senders asSortedCollection:[:a :b | a mclass lastName < b mclass lastName ].
    senders notEmptyOrNil ifTrue:[
        senders do:[:m|
            menu addItem: 
                (MenuItem label: (self displayStringForSelector: selector in: m mclass binaryName withClassName: true)
                    itemValue:[ self spawnBrowserOnMethod: m]). 
        ].
    ].

    ^ menu

    "Created: / 25-09-2013 / 10:08:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-10-2013 / 22:30:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaToolbox methodsFor:'private-presentation'!

displayStringForSelector: selector in: className
    ^ self displayStringForSelector: selector in: className withClassName: false.

    "Created: / 31-08-2013 / 23:31:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-09-2013 / 00:37:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

displayStringForSelector: selector in: className withClassName: withClassName
    | i name descriptor package localName displayString|

    i := selector indexOf: $(.
    name := selector copyTo: i - 1.


    descriptor := selector copyFrom: i.
    i := className lastIndexOf: $/.
    package := className copyTo: i - 1.
    localName := className copyFrom: i + 1.

    name = #'<clinit>' ifTrue:[
        displayString :=  'static' asText allBold , ' {}'
    ] ifFalse:[
        name = '<init>' ifTrue:[
            displayString := JavaMethod specTextFromSignature:descriptor in: package withName: localName isConstructor: true
        ] ifFalse:[
            displayString := JavaMethod specTextFromSignature:descriptor in: package withName: name isConstructor: true
        ].
    ].
    withClassName ifTrue:[
         displayString := displayString , ' in ' , (localName asText allBold).
    ].
    ^ displayString

    "Created: / 25-09-2013 / 00:37:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-10-2013 / 08:18:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaToolbox methodsFor:'searching'!

searchForDeclarationOf: selector class: class in: classes
    "Return 'declaration' of method with given selector in given class.
     By 'declaration' we mean top-most definition of the method or
     definition of the method in one of class's interface. 
     Returns the class (ot interface) in which the method is
     first declared."

    | current declaring |

    current := declaring := class.
    [ current ~~ JavaObject ] whileTrue:[
        (current canUnderstand: selector) ifTrue:[
            declaring := current.
        ].
        current allInterfaces do:[:iface|
            (iface canUnderstand: selector) ifTrue:[
                ^ iface
            ].
        ].
        current := current superclass.
    ].

    ^ declaring

    "Created: / 05-09-2013 / 13:10:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

searchForImplementorsOf: selector class: class
    ^ self searchForImplementorsOf: selector class: class in: environment allClasses

    "Created: / 05-09-2013 / 12:44:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

searchForImplementorsOf: selector class: class in: classes
    | implementors |

    implementors := Set new.
    self searchForImplementorsOf: selector class: class in: classes whenFoundDo: [:mthd | implementors add: mthd ].
    ^ implementors

    "Created: / 05-09-2013 / 12:45:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

searchForImplementorsOf: selector class: class in: classes whenFoundDo: block 
    | searchSelector searchClass |

    searchSelector := selector asSymbolIfInterned.
    searchSelector isNil ifTrue:[ ^ self ].
    searchClass := self searchForDeclarationOf: selector class: class in: classes.

    classes do: [:cls | 
        cls isJavaClass ifTrue: [
            ((cls methodDictionary includesKey: searchSelector) and:[ JavaVM canCast: cls to: searchClass]) ifTrue:[
                | m |

                m := cls compiledMethodAt: searchSelector.
                m isNil ifTrue:[ self error: 'Should not happen' ].
                block value:  m.
            ]
        ]
    ].

    "Created: / 05-09-2013 / 12:45:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-09-2013 / 10:05:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

searchForSendersOf: selector class: class
    ^ self searchForSendersOf: selector class: class in: environment allClasses

    "Created: / 01-09-2013 / 10:07:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-09-2013 / 12:46:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

searchForSendersOf: selector class: class in: classes
    | senders |

    senders := Set new.
    self searchForSendersOf: selector class: class in: classes whenFoundDo: [:mthd | senders add: mthd ].
    ^ senders

    "Created: / 01-09-2013 / 10:07:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

searchForSendersOf: selector class: class in: classes whenFoundDo: block 
    | searchSelector searchClass |

    searchSelector := selector asSymbolIfInterned.
    searchSelector isNil ifTrue:[ ^ self ].
    searchClass := self searchForDeclarationOf: selector class: class in: classes.

    classes do: [:cls | 
        cls isJavaClass ifTrue: [
            | matching |

            matching := Set new.
            "/ Quickly scan constant pool without need of analyzing
            "/ each method...
            cls constantPool do:[:ref|
                ref isJavaMethodRef ifTrue:[
                    (ref selector == searchSelector and:[ JavaVM canCast: ref classRef javaClass to: searchClass]) ifTrue:[
                        matching add: ref.
                    ]
                ]
            ].
            matching notEmpty ifTrue:[
                cls methodDictionary keysAndValuesDo:[:selector :method|
                    (method isJavaMethod and:[method analyzer methodsInvoked includesAny: matching]) ifTrue:[
                        block value: method
                    ]
                ]
            ]
        ]
    ]

    "Created: / 01-09-2013 / 03:11:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-09-2013 / 10:16:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaToolbox class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/tools/JavaToolbox.st,v 1.4 2015-03-20 13:29:52 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

