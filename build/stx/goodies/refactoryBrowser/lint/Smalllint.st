"
 Copyright (C) Original SmallLint Authors
 Copyright (C) The Squeak Team
 Copyright (C) The Pharo Team
 Copyright (C) 2011-2013 Jan Vrany (porting, Smalltalk/X rules & tweaks)
 Copyright (C) 2011-2013 Claus Gittinger (porting, Smalltalk/X rules & tweaks)

 Permission is hereby granted, free of charge, to any 
 person obtaining a copy of this software and associated 
 documentation files (the 'Software'), to deal in the 
 Software without restriction, including without limitation 
 the rights to use, copy, modify, merge, publish, distribute, 
 sublicense, and/or sell copies of the Software, and to 
 permit persons to whom the Software is furnished to do so, 
 subject to the following conditions:

 The above copyright notice and this permission notice shall 
 be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, 
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:goodies/refactoryBrowser/lint' }"

"{ NameSpace: Smalltalk }"

BrowserApplicationModel subclass:#Smalllint
	instanceVariableNames:'checker percentDone checkerProcess environmentEditor menuHolder
		ruleHolder context'
	classVariableNames:'RuleSelectionBlock'
	poolDictionaries:''
	category:'Refactory-Lint'
!

!Smalllint class methodsFor:'documentation'!

copyright
"
 Copyright (C) Original SmallLint Authors
 Copyright (C) The Squeak Team
 Copyright (C) The Pharo Team
 Copyright (C) 2011-2013 Jan Vrany (porting, Smalltalk/X rules & tweaks)
 Copyright (C) 2011-2013 Claus Gittinger (porting, Smalltalk/X rules & tweaks)

 Permission is hereby granted, free of charge, to any 
 person obtaining a copy of this software and associated 
 documentation files (the 'Software'), to deal in the 
 Software without restriction, including without limitation 
 the rights to use, copy, modify, merge, publish, distribute, 
 sublicense, and/or sell copies of the Software, and to 
 permit persons to whom the Software is furnished to do so, 
 subject to the following conditions:

 The above copyright notice and this permission notice shall 
 be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, 
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"
! !

!Smalllint class methodsFor:'accessing'!

runAllChecks
        "self runAllChecks"

        self runRule: RBCompositeLintRule allRules
!

runRule: aRule 
	| dialog |
	dialog := ClassSelectionDialog new.
	dialog open ifFalse: [^self].
	self runRule: aRule onEnvironment: dialog selectedEnvironment
!

runRule: rule onEnvironment: environment 
	| lint |
	lint := self new.
	lint openInterface: #abortWindowSpec.
	lint environmentEditor environment: environment.
	lint checker value: rule.
	lint runNoInterface
! !

!Smalllint class methodsFor:'interface specs'!

abortWindowSpec
	"UIPainter new openOnClass: self andSelector: #abortWindowSpec"

	<resource: #canvas>
	^#(#FullSpec 
		#window: 
		#(#WindowSpec 
			#label: 'Smalllint' 
			#min: #(#Point 40 20 ) 
			#bounds: #(#Rectangle 517 401 799 504 ) ) 
		#component: 
		#(#SpecCollection 
			#collection: #(
				#(#ProgressWidgetSpec 
					#layout: #(#LayoutFrame 5 0 30 0 -5 1 -35 1 ) 
					#isOpaque: true 
					#colors: 
					#(#LookPreferences 
						#setForegroundColor: #(#ColorValue #blue ) ) 
					#model: #percentDone 
					#direction: #horizontal 
					#position: #topLeft 
					#area: true 
					#reverse: false ) 
				#(#ActionButtonSpec 
					#layout: #(#LayoutFrame -30 0.5 -30 1 30 0.5 -2 1 ) 
					#name: #abort 
					#flags: 40 
					#model: #abort 
					#label: 'Abort' ) 
				#(#LabelSpec 
					#layout: #(#AlignmentOrigin 0 0.5 5 0 0.5 0 ) 
					#label: 'Running rule...' ) ) ) )
!

windowSpec
    ((Smalltalk respondsTo:#isSmalltalkX) and:[Smalltalk isSmalltalkX]) ifTrue:[
        ^ self windowSpecForSTX
    ].
    ^ self windowSpecForVisualWorks
!

windowSpecForSTX
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Smalllint andSelector:#windowSpecForSTX
     Smalllint new openInterface:#windowSpecForSTX
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpecForSTX
        #window: 
       #(#WindowSpec
          #label: 'Smalllint'
          #name: 'Smalllint'
          #min: #(#Point 40 20)
          #bounds: #(#Rectangle 12 22 554 409)
          #menu: #menu
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#MenuButtonSpec
              #name: #checker
              #layout: #(#LayoutFrame 2 0 2 0 -1 0.666666 30 0)
              #model: #checker
              #menu: #checkerMenu
              #useIndex: false
            )
           #(#ProgressIndicatorSpec
              #name: 'ProgressIndicator1'
              #layout: #(#LayoutFrame 2 0.666666 2 0 -1 1 30 0)
              #isOpaque: true
              #colors: 
             #(#LookPreferences
                #foregroundColor: #(#ColorValue 0 0 100)
              )
              #model: #percentDone
              #direction: #horizontal
              #reverse: false
              #area: true
              #position: #topLeft
            )
           #(#SubCanvasSpec
              #name: #environmentEditor
              #layout: #(#LayoutFrame 0 0 62 0 0 1 0 1)
              #majorKey: #EnvironmentEditor
              #minorKey: #classWindowSpec
              #clientKey: #environmentEditor
            )
           #(#ActionButtonSpec
              #label: 'Run'
              #name: #run
              #layout: #(#LayoutFrame -45 0.2 32 0 45 0.2 60 0)
              #flags: 40
              #model: #run
            )
           #(#ActionButtonSpec
              #label: 'Abort'
              #name: #abort
              #layout: #(#LayoutFrame -45 0.4 32 0 45 0.4 60 0)
              #flags: 40
              #model: #abort
            )
           #(#ActionButtonSpec
              #label: 'Empty cache'
              #name: #emptyCache
              #layout: #(#LayoutFrame -45 0.8 32 0 45 0.8 60 0)
              #model: #emptyCache
            )
           #(#ActionButtonSpec
              #label: 'Results'
              #name: #results
              #layout: #(#LayoutFrame -45 0.6 32 0 45 0.6 60 0)
              #flags: 40
              #model: #viewResults
            )
           )
         
        )
      )
!

windowSpecForVisualWorks
        "UIPainter new openOnClass: self andSelector: #windowSpec"

        <resource: #canvas>
        ^#(#FullSpec 
                #window: 
                #(#WindowSpec 
                        #label: 'Smalllint' 
                        #min: #(#Point 40 20 ) 
                        #bounds: #(#Rectangle 450 315 992 541 ) 
                        #flags: 4 
                        #menu: #menu ) 
                #component: 
                #(#SpecCollection 
                        #collection: #(
                                #(#MenuButtonSpec 
                                        #layout: #(#LayoutFrame 2 0 2 0 -1 0.666666 30 0 ) 
                                        #name: #checker 
                                        #model: #checker 
                                        #menu: #checkerMenu ) 
                                #(#ProgressWidgetSpec 
                                        #layout: #(#LayoutFrame 2 0.666666 2 0 -1 1 30 0 ) 
                                        #isOpaque: true 
                                        #colors: 
                                        #(#LookPreferences 
                                                #setForegroundColor: #(#ColorValue #blue ) ) 
                                        #model: #percentDone 
                                        #direction: #horizontal 
                                        #position: #topLeft 
                                        #area: true 
                                        #reverse: false ) 
                                #(#SubCanvasSpec 
                                        #layout: #(#LayoutFrame 0 0 62 0 0 1 0 1 ) 
                                        #name: #environmentEditor 
                                        #majorKey: #EnvironmentEditor 
                                        #minorKey: #classWindowSpec 
                                        #clientKey: #environmentEditor ) 
                                #(#ActionButtonSpec 
                                        #layout: #(#LayoutFrame -45 0.2 32 0 45 0.2 60 0 ) 
                                        #name: #run 
                                        #flags: 40 
                                        #model: #run 
                                        #label: 'Run' ) 
                                #(#ActionButtonSpec 
                                        #layout: #(#LayoutFrame -45 0.4 32 0 45 0.4 60 0 ) 
                                        #name: #abort 
                                        #flags: 40 
                                        #model: #abort 
                                        #label: 'Abort' ) 
                                #(#ActionButtonSpec 
                                        #layout: #(#LayoutFrame -45 0.8 32 0 45 0.8 60 0 ) 
                                        #name: #emptyCache 
                                        #model: #emptyCache 
                                        #label: 'Empty cache' ) 
                                #(#ActionButtonSpec 
                                        #layout: #(#LayoutFrame -45 0.6 32 0 45 0.6 60 0 ) 
                                        #name: #results 
                                        #flags: 40 
                                        #model: #viewResults 
                                        #label: 'Results' ) ) ) )
! !

!Smalllint class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!Smalllint methodsFor:'accessing'!

currentRule
	^self checker value
!

environmentEditor
	environmentEditor isNil
		ifTrue: 
			[environmentEditor := EnvironmentEditor new.
			environmentEditor environment: ClassEnvironment new].
	^environmentEditor
!

percentDone: aValue
        RBParser isSmalltalkX ifTrue:[
            "/ smalltalks progresswidget really uses percents ...
            self percentDone value: aValue * 100
        ] ifFalse:[
            self percentDone value: aValue
        ]

    "Modified: / 10.7.1998 / 01:54:18 / cg"
! !

!Smalllint methodsFor:'actions'!

abort
	checkerProcess isNil ifTrue: [^self].
	checkerProcess terminate.
	checkerProcess := nil.
	self resetButtons.
	self percentDone: 0.0
!

emptyCache
	context release.
	context := SmalllintContext new.

	"We must set the current menu choice to nil before setting the menu -- bug in the MenuButtonView 
	update:..."
	self checker value: nil.
	menuHolder value: self computeMenu
!

run
        checkerProcess notNil ifTrue: [^self].
        self disableAll: #(#run #checker #emptyCache #results).
        self enable: #abort.
        checkerProcess := [[self runChecker]
                                ensure: 
                                        [self enableAll: #(#run #checker #emptyCache).
                                        (self checker value isNil or: [self checker value isEmpty])
                                                ifFalse: [self enable: #results].
                                        self disable: #abort.
                                        checkerProcess := nil]] fork
!

runNoInterface
        checkerProcess notNil ifTrue: [^self].
        self disableAll: #(#run #emptyCache #results).
        self enable: #abort.
        checkerProcess := 
                        [[self runChecker] ensure: 
                                        [checkerProcess := nil.
                                        self closeRequest]]
                                        fork
!

viewResults
	self currentRule openEditor
! !

!Smalllint methodsFor:'aspects'!

checker
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^checker isNil
		ifTrue:
			[checker := nil asValue]
		ifFalse:
			[checker]
!

percentDone
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^percentDone isNil
		ifTrue:
			[percentDone := 0 asValue]
		ifFalse:
			[percentDone]
! !

!Smalllint methodsFor:'events'!

noticeOfWindowClose: aWidget 
	self release.
	super noticeOfWindowClose: aWidget
! !

!Smalllint methodsFor:'initialize-release'!

initialize
        super initialize.

        ((Smalltalk respondsTo:#isSmalltalkX) and:[Smalltalk isSmalltalkX]) ifTrue:[
            "/ since Lint searches through methdos to find checks, those classes
            "/ must be loaded in order to find those checks ...
            Smalltalk allClassesInCategory:(self class category) do:[:eachClass |
                eachClass autoload.
            ].
        ].

        self checker onChangeSend: #changedChecker to: self.
        percentDone := 0.0 asValue
!

release
	self abort.
	context release.
	super release
! !

!Smalllint methodsFor:'interface opening'!

postBuildWith: aBuilder 
	super postBuildWith: aBuilder.
	context := (builder componentAt: #checker) isNil
				ifTrue: [SmalllintContext newNoCache]
				ifFalse: [SmalllintContext new]
! !

!Smalllint methodsFor:'menu'!

checkerMenu
	menuHolder isNil ifTrue: [menuHolder := self computeMenu asValue].
	^menuHolder
!

menu
        | menu |

        RBParser isSmalltalkX ifTrue:[
            self environmentEditor
        ].
        menu := Menu new.
        menu
                addItem: ((MenuItem labeled: 'Ca&tegory') submenu: environmentEditor categoryMenu);
                addItem: ((MenuItem labeled: '&Class') submenu: environmentEditor classMenu).
        ^menu

    "Modified: / 4.2.2000 / 09:54:06 / cg"
! !

!Smalllint methodsFor:'private'!

changedChecker
	checker value notNil & checkerProcess isNil
		ifTrue: 
			[checker value isEmpty
				ifTrue: [self disable: #results]
				ifFalse: [self enable: #results].
			self enable: #run]
		ifFalse: [self disableAll: #(#run #results)].
	percentDone value: 0
!

computeMenu
        | mb |
        mb := MenuBuilder new.
        self menuFor: RBCompositeLintRule allRules builder: mb.
        ^mb menu

    "Modified: / 04-09-2011 / 19:54:42 / cg"
!

menuFor: aCompositeLintRule builder: aMenuBuilder 
	aCompositeLintRule hasConflicts
		ifFalse: 
			[aMenuBuilder add: aCompositeLintRule name , ' - Run all' -> aCompositeLintRule.
			aMenuBuilder line].
	aCompositeLintRule rules do: [:each | each isComposite
			ifTrue: 
				[aMenuBuilder beginSubMenuLabeled: each name.
				self menuFor: each builder: aMenuBuilder.
				aMenuBuilder endSubMenu]
			ifFalse: [aMenuBuilder add: each name -> each]]
!

resetButtons
	self enableAll: #(#run #emptyCache).
	(self currentRule isNil or: [self currentRule isEmpty])
		ifTrue: [self disable: #results]
		ifFalse: [self enable: #results].
	self disable: #abort.
	checkerProcess := nil
!

runChecker
        | size currentChecker i environment |
        environment := environmentEditor selectedEnvironment.
        environment isEmpty ifTrue: 
                        [^Dialog
                                warn: 'You haven''t selected any classes.<n>All selected items will have a check by them.'
                                                expandMacros].
        currentChecker := self currentRule.
        currentChecker isNil ifTrue:
                        [^Dialog
                                warn: 'You haven''t selected any checks.'].
        currentChecker resetResult.
        self percentDone: 0.
        i := 0.0.
        size := environment numberSelectors.
        environment classesDo: 
                        [:aClass | 
                        context selectedClass: aClass.
                        (environment definesClass: aClass)
                                ifTrue: [currentChecker checkClass: context].
                        (environment selectorsForClass: aClass) do: 
                                        [:each | 
                                        context selector: each.
                                        currentChecker checkMethod: context.
                                        i := i + 1.
                                        self percentDone: i / size.
                                        "Processor yield"]].
        self percentDone: 1.
        currentChecker isEmpty ifTrue: [Dialog warn: 'Nobody'].
        currentChecker openEditor
! !

!Smalllint class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

