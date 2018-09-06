"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

CodeTool subclass:#ClassNavigatorTool
	instanceVariableNames:'currentSubcanvas subcanvas'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Code Tools'
!

ClassNavigatorTool comment:'ClassNavigatorTool is a code tool that is used to browse classes. It has radio buttons to switch between different aspects of class properties (definition, comment, etc.). When a radio button is pressed, it switches its subcanvas to the tool specified by the radio button.

Instance Variables:
	currentSubcanvas        <ValueHolder on: Symbol>        which radio button is selected
	subcanvas       <CodeTool>      the specific tool for the selected radio button'
!


!ClassNavigatorTool class methodsFor:'accessing'!

classCommentToolClass
	^ClassCommentTool
!

classDefinitionToolClass
	^BrowserClassTool
!

organizationToolClass
	^OrganizationEditor
! !

!ClassNavigatorTool class methodsFor:'interface specs'!

windowSpec
        "UIPainter new openOnClass: self andSelector: #windowSpec"

        RBParser isSmalltalkX ifTrue:[
            ^ self windowSpecSTX
        ].
        ^ self windowSpecVW
!

windowSpecSTX
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ClassNavigatorTool andSelector:#windowSpecSTX
     ClassNavigatorTool new openInterface:#windowSpecSTX
    "

    <resource: #canvas>

    ^ 
     #(#FullSpec
        #name: #windowSpecSTX
        #window: 
       #(#WindowSpec
          #label: 'Class Tool'
          #name: 'Class Tool'
          #bounds: #(#Rectangle 218 175 776 634)
        )
        #component: 
       #(#SpecCollection
          #collection: #(
           #(#RadioButtonSpec
              #label: 'definition'
              #name: 'RadioButton1'
              #layout: #(#LayoutFrame 0 0 0 0 0 0.25 21 0)
              #model: #currentSubcanvas
              #select: #definition
              #callbacksSpec: 
             #(#UIEventCallbackSubSpec
                #valueChangeSelector: #definitionSubcanvas
                #requestValueChangeSelector: #updateRequest
              )
            )
           #(#RadioButtonSpec
              #label: 'comment'
              #name: 'RadioButton2'
              #layout: #(#LayoutFrame 0 0.25 0 0 0 0.5 21 0)
              #model: #currentSubcanvas
              #select: #comment
              #callbacksSpec: 
             #(#UIEventCallbackSubSpec
                #valueChangeSelector: #commentSubcanvas
                #requestValueChangeSelector: #updateRequest
              )
            )
           #(#RadioButtonSpec
              #label: 'hierarchy'
              #name: 'RadioButton3'
              #layout: #(#LayoutFrame 0 0.5 0 0 0 0.75 21 0)
              #model: #currentSubcanvas
              #select: #hierarchy
              #callbacksSpec: 
             #(#UIEventCallbackSubSpec
                #valueChangeSelector: #hierarchySubcanvas
                #requestValueChangeSelector: #updateRequest
              )
            )
           #(#RadioButtonSpec
              #label: 'organization'
              #name: #organization
              #layout: #(#LayoutFrame 0 0.75 0 0 0 1 21 0)
              #model: #currentSubcanvas
              #select: #organization
              #callbacksSpec: 
             #(#UIEventCallbackSubSpec
                #valueChangeSelector: #organizationSubcanvas
                #requestValueChangeSelector: #updateRequest
              )
            )
           #(#SubCanvasSpec
              #name: #subcanvas
              #layout: #(#LayoutFrame 0 0 23 0 0 1 0 1)
              #majorKey: #classTool
              #minorKey: #windowSpec
              #clientKey: #subcanvas
            )
           )
         
        )
      )
!

windowSpecVW
        "UIPainter new openOnClass: self andSelector: #windowSpec"

        <resource: #canvas>
        ^#(#FullSpec 
                #window: 
                #(#WindowSpec 
                        #label: 'Class Tool' 
                        #bounds: #(#Rectangle 138 184 696 643 ) ) 
                #component: 
                #(#SpecCollection 
                        #collection: #(
                                #(#RadioButtonSpec 
                                        #layout: #(#Point 5 0 ) 
                                        #model: #currentSubcanvas 
                                        #callbacksSpec: 
                                        #(#UIEventCallbackSubSpec 
                                                #valueChangeSelector: #definitionSubcanvas 
                                                #requestValueChangeSelector: #updateRequest ) 
                                        #label: 'definition' 
                                        #select: #definition ) 
                                #(#RadioButtonSpec 
                                        #layout: #(#AlignmentOrigin 0 0.333333 0 0 0.333333 0 ) 
                                        #model: #currentSubcanvas 
                                        #callbacksSpec: 
                                        #(#UIEventCallbackSubSpec 
                                                #valueChangeSelector: #commentSubcanvas 
                                                #requestValueChangeSelector: #updateRequest ) 
                                        #label: 'comment' 
                                        #select: #comment ) 
                                #(#RadioButtonSpec 
                                        #layout: #(#AlignmentOrigin 0 0.666666 0 0 0.666666 0 ) 
                                        #model: #currentSubcanvas 
                                        #callbacksSpec: 
                                        #(#UIEventCallbackSubSpec 
                                                #valueChangeSelector: #hierarchySubcanvas 
                                                #requestValueChangeSelector: #updateRequest ) 
                                        #label: 'hierarchy' 
                                        #select: #hierarchy ) 
                                #(#SubCanvasSpec 
                                        #layout: #(#LayoutFrame 0 0 23 0 0 1 0 1 ) 
                                        #name: #subcanvas 
                                        #flags: 0 
                                        #majorKey: #classTool 
                                        #minorKey: #windowSpec 
                                        #clientKey: #subcanvas ) 
                                #(#RadioButtonSpec 
                                        #layout: #(#AlignmentOrigin -5 1 0 0 1 0 ) 
                                        #name: #organization 
                                        #model: #currentSubcanvas 
                                        #callbacksSpec: 
                                        #(#UIEventCallbackSubSpec 
                                                #valueChangeSelector: #organizationSubcanvas 
                                                #requestValueChangeSelector: #updateRequest ) 
                                        #label: 'organization' 
                                        #select: #organization ) ) ) )
! !

!ClassNavigatorTool methodsFor:'accessing'!

menu
	| menu |
	menu := Menu new.
	#(#definition #comment #hierarchy #organization)
		do: 
			[:each | 
			| menuItem |
			menuItem := MenuItem labeled: '&' , each asString.
			currentSubcanvas value == each
				ifTrue: [menuItem beOn]
				ifFalse: [menuItem beOff].
			menu addItem: menuItem value: [self updateRequest
					ifTrue: 
						[currentSubcanvas value: each.
						self updateContents]]].
	menu addItemGroup: (Array with: ((MenuItem labeled: 'too&l')
				submenu: subcanvas menu)).
	^menu
! !

!ClassNavigatorTool methodsFor:'aspects'!

currentSubcanvas
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."

	^currentSubcanvas isNil
		ifTrue:
			[currentSubcanvas := nil asValue]
		ifFalse:
			[currentSubcanvas]
! !

!ClassNavigatorTool methodsFor:'initialize-release'!

codeModel: aCodeModel 
	super codeModel: aCodeModel.
	subcanvas := self class classDefinitionToolClass codeModel: codeModel
!

initialize
	super initialize.
	self currentSubcanvas value: #definition
!

release
	subcanvas release.
	super release
! !

!ClassNavigatorTool methodsFor:'interface opening'!

preBuildWith: aBuilder
	aBuilder subCanvasAt: #classTool at: #windowSpec put: (subcanvas class windowSpec).
	^super preBuildWith: aBuilder
! !

!ClassNavigatorTool methodsFor:'private'!

commentSubcanvas
	self createSubcanvasWith: self class classCommentToolClass
!

createSubcanvasWith: aClass 
	(subcanvas isNil or: [subcanvas class ~~ aClass])
		& codeModel notNil & (builder notNil and: [(builder componentAt: #subcanvas) topComponent notNil])
		ifTrue: 
			[subcanvas := aClass on: codeModel.
			self installSubcanvasIn: #subcanvas using: subcanvas].
	subcanvas notNil ifTrue: [subcanvas updateContents]
!

definitionSubcanvas
	self createSubcanvasWith: self class classDefinitionToolClass
!

hierarchySubcanvas
	codeModel notNil & (builder notNil and: [(builder componentAt: #subcanvas) topComponent notNil])
		ifTrue: 
			[subcanvas := OMTClassTool on: codeModel.
			self installSubcanvasIn: #subcanvas using: subcanvas].
	subcanvas notNil ifTrue: [subcanvas updateContents]
!

organizationSubcanvas
	self createSubcanvasWith: self class organizationToolClass
!

subcanvas
	^subcanvas
!

subcanvases
	^(OrderedCollection withAll: super subcanvases)
		add: self subcanvas; yourself
! !

!ClassNavigatorTool methodsFor:'updating'!

updateContents
	| selection |
	selection := self currentSubcanvas value.
	selection == #definition ifTrue: [self definitionSubcanvas].
	selection == #comment ifTrue: [self commentSubcanvas].
	selection == #hierarchy ifTrue: [self hierarchySubcanvas].
	selection == #organization ifTrue: [self organizationSubcanvas]
! !

!ClassNavigatorTool class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/ClassNavigatorTool.st,v 1.10 2003-09-23 10:43:20 cg Exp $'
! !
