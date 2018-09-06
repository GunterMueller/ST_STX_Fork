"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

ApplicationModel subclass:#BrowserApplicationModel
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Browser'
!

BrowserApplicationModel comment:'BrowserApplicationModel is an abstact class that extends the standard ApplicationModel. It adds functions to easily change subcanvases and change the properties of the widgets.

Subclasses with subcanvases should override the #subcanvases method so that the new subcanvas is also return in the list of subcanvas open in this application. The subcanvas information is used so that #updateRequest''s can be made of the whole application without the need to write a specific updateRequest in each subclass that defines uses a subcanvas. Also, when installing the same application model several different times, the builder must be nil''ed and the #subcanvases method is also used to nil the builder.'
!


!BrowserApplicationModel class methodsFor:'interface specs'!

emptySpec
	"UIPainter new openOnClass: self andSelector: #emptySpec"

	<resource: #canvas>
	^#(#FullSpec
		#window:
		#(#WindowSpec
			#label: 'Unlabeled Canvas'
			#bounds: #(#Rectangle 369 270 569 470 ) )
		#component:
		#(#SpecCollection
			#collection: #() ) )
! !

!BrowserApplicationModel methodsFor:'accessing'!

performChange: aRefactoringChange 
	RefactoryChangeManager instance performChange: aRefactoringChange
!

performChange: aRefactoringChange withMessage: aString 
	RefactoryChangeManager instance performChange: aRefactoringChange
		withMessage: aString
!

preferredSpec
	^#windowSpec
! !

!BrowserApplicationModel methodsFor:'error handling'!

handleError: aBlock 
        ^[self showWaitCursorWhile: aBlock] on: Refactoring preconditionSignal
                do: 
                        [:ex | |msgText|

                        msgText := ex messageText.
                        ex isResumable 
                                ifTrue: 
                                        [(Dialog confirm: (msgText last == $? 
                                                                ifTrue: [msgText]
                                                                ifFalse: [msgText , '\Do you want to proceed?' withCRs])) 
                                                ifTrue: [ex resume]]
                                ifFalse: 
                                        [ex parameter notNil 
                                                ifTrue: [(Dialog confirm: msgText) ifTrue: [ex parameter value]]
                                                ifFalse: [Dialog warn: msgText]].
                        ex return: nil]
! !

!BrowserApplicationModel methodsFor:'interface opening'!

createSelectedVisualBlockFrom: aBlock 
        Smalltalk isSmalltalkX ifTrue:[
        ^ [:v :index |
                |l|

                l := aBlock value: v value: index.
                (l isKindOf:LabelAndIcon) ifTrue:[
                    l string:(l string asText emphasizeAllWith:#reverse).
                ] ifFalse:[
                    l := l string asText emphasizeAllWith:#reverse
                ].
                l
          ]
        ].

        ^
        [:v :index | 
        | rw |
        rw := ReversingWrapper on: (aBlock value: v value: index).
        rw reverse setValue: true.
        BoundedWrapper on: rw]
!

createVisualBlockFrom: block 
        Smalltalk isSmalltalkX ifTrue:[
            ^ [:view :index | (block value: view value: index)]
        ].
        ^[:view :index | BoundingWrapper on: (block value: view value: index)]
!

resetBuilder
	self builder: nil.
	self subcanvases do: [:each | each resetBuilder]
!

windowSpecMethod
	^#windowSpec
! !

!BrowserApplicationModel methodsFor:'menu accessing'!

disableMenu: aMenu
	^self disableMenu: aMenu except: #()
!

disableMenu: aMenu except: aCollection 
	aMenu menuItems
		do: 
			[:each | 
			(aCollection includes: each label)
				ifTrue: [each enable]
				ifFalse: [each disable].
			each submenu notNil ifTrue: [self disableMenu: each submenu except: aCollection]].
	^aMenu
!

enableMenu: aMenu
	^self enableMenu: aMenu except: #()
!

enableMenu: aMenu except: aCollection 
	aMenu menuItems
		do: 
			[:each | 
			(aCollection includes: each label)
				ifTrue: [each disable]
				ifFalse: [each enable].
			each submenu notNil ifTrue: [self enableMenu: each submenu except: aCollection]].
	^aMenu
!

initializeMenu: aMenu 
	^self initializeMenu: aMenu using: nil
!

initializeMenu: aMenu using: aController 
	"Hack aMenu so that it can be installed into window, and still send us the messages instead of 
	sending them to the window's model."

	aMenu values: (aMenu values collect: [:each | (aController notNil and: [#(#find #replace #undo #copySelection #cut #paste #doIt #printIt #inspectIt #hardcopy) includes: each])
				ifTrue: [[aController perform: each]]
				ifFalse: [each isSymbol
						ifTrue: [each numArgs == 1
								ifTrue: [[self perform: each with: aController]]
								ifFalse: [each numArgs == 2
										ifTrue: [[self
												perform: each
												with: aController text
												with: aController]]
										ifFalse: [[self perform: each]]]]
						ifFalse: [each]]]).
	aMenu menuItems do: [:each | each submenu notNil ifTrue: [each submenu: (self initializeMenu: each submenu using: aController)]].
	^aMenu
!

maxMenuNameLength
	^50
!

menu
	"Return a default menu for all subclasses. This is used when embedding this object inside another app 
	model."

	^
	[| mb |
	mb := MenuBuilder new.
	mb add: 'No menu' -> #yourself.
	mb menu]
!

menuNameFor: aSelector 
	^aSelector size > self maxMenuNameLength 
		ifTrue: 
			[(aSelector copyFrom: 1 to: (self maxMenuNameLength * 0.75) rounded) 
				, '...' , (aSelector 
							copyFrom: aSelector size - (self maxMenuNameLength * 0.25) rounded + 3
							to: aSelector size)]
		ifFalse: [aSelector]
!

windowMenuItems
	^#()
! !

!BrowserApplicationModel methodsFor:'requests'!

choose: aString from: aCollection
    ^ self
            choose: aString
            fromList: aCollection
            values: aCollection
            lines: 20
            cancel: [nil]
!

choose: aString fromList: aCollection values: valueCollection ignore: ignoreChoices initialSelection: anIndex lines: anInteger cancel: cancelBlock 
        | labels sd spec listW buttons idx |

        labels := SelectionInList new.
        labels list: aCollection asList.
        anIndex notNil ifTrue: [labels selectionIndex: anIndex].

        RBParser isSmalltalkX ifTrue:[
            sd := Dialog new.
        ] ifFalse:[
            sd := SimpleDialog new.
            spec := sd class interfaceSpecFor: #emptySpec.
            sd builder add: spec window.
            sd builder add: spec component.
        ].
        sd setInitialGap.
        sd addMessage: aString centered: false.
        sd addGap: 8.
        listW := sd addList: labels
                                lines: anInteger
                                validation: [labels selectionIndex > 0].
        listW widget setValidTargetIndex: labels selectionIndex.
        sd addGap: 4.
        buttons := sd addOK: [labels selectionIndex ~= 0].
        sd addGap: 6.
        sd bottomAlignLowerEdge: listW.
        sd bottomAlign: (Array with: buttons).
        labels selectionIndexHolder compute: 
                        [:v | 
                        (v > 0 and: [ignoreChoices includes: v]) ifTrue: 
                                        [labels selectionIndex: 0.
                                        listW widget targetIndex: 0]].
        sd preOpen.
        RBParser isSmalltalkX ifTrue:[
            sd open.
        ] ifFalse:[
            sd builder openDialogWithExtent: sd builder window displayBox extent.
        ].
        ^sd accept value
                ifTrue: [|idx|
                         idx := labels selectionIndex.
                         idx == 0 ifTrue:[
                             cancelBlock value
                         ] ifFalse:[
                             valueCollection at: idx]]
                ifFalse: [cancelBlock value]
!

choose: aString fromList: aCollection values: valueCollection lines: anInteger cancel: aBlock 
	^Dialog
		choose: aString
		fromList: aCollection
		values: valueCollection
		lines: anInteger
		cancel: aBlock
		for: self interfaceWindow
!

confirm: aString
	^Dialog confirm: aString
!

request: aString 
	^Dialog request: aString
!

request: aString initialAnswer: anAnswerString
	^Dialog request: aString initialAnswer: anAnswerString
!

showWaitCursorWhile: aBlock 
    RBParser isSmalltalkX ifTrue:[
        ^ self topApplication withWaitCursorDo:aBlock.
    ].
        ^Cursor wait showWhile: aBlock

    "Modified: / 6.2.2000 / 14:40:34 / cg"
!

warn: aString 
	^Dialog warn: aString
! !

!BrowserApplicationModel methodsFor:'subcanvases'!

installSubcanvasIn: aSymbol using: anApplicationModel 
	self 
		installSubcanvasIn: aSymbol
		using: anApplicationModel
		spec: anApplicationModel windowSpecMethod
!

installSubcanvasIn: aSymbol using: anApplicationModel spec: aSpec 
	| component |
	builder isNil ifTrue: [^self].
	component := builder componentAt: aSymbol.
	component notNil ifTrue: [component widget client: anApplicationModel spec: aSpec]
!

saveState
	self subcanvases do: [:each | each saveState]
!

subcanvases
	^#()
!

updateDisplay
	self subcanvases do: [:each | each updateDisplay]
! !

!BrowserApplicationModel methodsFor:'testing'!

isEditing
	^false
! !

!BrowserApplicationModel methodsFor:'updating'!

updateRequest
	^super updateRequest and: [self subcanvases inject: true into: [:bool :each | bool and: [each updateRequest]]]
! !

!BrowserApplicationModel methodsFor:'widget properties'!

controllerFor: aSymbol 
        | wrapper |
        builder isNil ifTrue: [^nil].
        wrapper := builder componentAt: aSymbol.
        wrapper isNil ifTrue: [^nil].
        Smalltalk isSmalltalkX ifTrue:[
            wrapper widget isNil ifTrue: [^nil].
        ].
        ^wrapper widget controller
!

disable: aSymbol 
	| component |
	builder isNil ifTrue: [^self].
	component := builder componentAt: aSymbol.
	component notNil ifTrue: [component disable]
!

disableAll: aCollection
	aCollection do: [:each | self disable: each]
!

enable: aSymbol 
	| component |
	builder isNil ifTrue: [^self].
	component := builder componentAt: aSymbol.
	component notNil ifTrue: [component enable]
!

enableAll: aCollection
	aCollection do: [:each | self enable: each]
!

hide: aSymbol 
	| component |
	builder isNil ifTrue: [^self].
	component := builder componentAt: aSymbol.
	component notNil ifTrue: [component beInvisible]
!

hideAll: aCollection
	aCollection do: [:each | self hide: each]
!

invalidateComponent: aSymbol 
        | component |

        builder isNil ifTrue: [^self].
        component := builder componentAt: aSymbol.
        component notNil ifTrue: [component invalidate]
!

show: aSymbol 
	| component |
	builder isNil ifTrue: [^self].
	component := builder componentAt: aSymbol.
	component notNil ifTrue: [component beVisible]
!

showAll: aCollection
	aCollection do: [:each | self show: each]
! !

!BrowserApplicationModel methodsFor:'window properties'!

bringWindowToTop
	| window |
	builder isNil ifTrue: [^self].
	window := builder window.
	(window notNil and: [window isOpen])
		ifTrue: [window isCollapsed
				ifTrue: [window expand]
				ifFalse: [window raise]]
!

interfaceWindow
	builder notNil ifTrue: [^builder window].
	^nil
!

setLabel: aLabel 
	(builder notNil and: [builder window notNil])
		ifTrue: [builder window label: aLabel]
! !

!BrowserApplicationModel class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/BrowserApplicationModel.st,v 1.18 2003-09-23 10:44:32 cg Exp $'
! !
