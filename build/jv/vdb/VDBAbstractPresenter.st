"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
"{ Package: 'jv:vdb' }"

"{ NameSpace: Smalltalk }"

HierarchicalItem subclass:#VDBAbstractPresenter
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'VDB-Presentation'
!

!VDBAbstractPresenter class methodsFor:'documentation'!

copyright
"
jv:vdb - Visual / VM Debugger
Copyright (C) 2015-now Jan Vrany

This software is licensed under 'Creative Commons Attribution-NonCommercial 4.0 International License'

You may find a full license text in LICENSE.txt or at http://creativecommons.org/licenses/by-nc/4.0/
"
! !

!VDBAbstractPresenter class methodsFor:'menu specs'!

contextMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:VDBModelPresenter andSelector:#contextMenu
     (Menu new fromLiteralArrayEncoding:(VDBModelPresenter contextMenu)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        nil nil
        nil
      )
! !

!VDBAbstractPresenter class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned here for myself only; false for subclasses.
     Abstract subclasses must redefine this again."

    ^ self == VDBAbstractPresenter.
! !

!VDBAbstractPresenter methodsFor:'accessing'!

backgroundColor
    | app |

    app := self application.
    app notNil ifTrue:[ 
        ^ app perform: #backgroundColorFor: with: self ifNotUnderstood: [ nil ].
    ].
    ^ nil

    "Created: / 06-06-2017 / 23:38:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

foregroundColor
    | app |

    app := self application.
    app notNil ifTrue:[ 
        ^ app perform: #foregroundColorFor: with: self ifNotUnderstood: [ nil ].
    ].
    ^ nil

    "Created: / 26-06-2018 / 11:46:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

subject
    "Return an instance of GDB object that this presenter displays."

    ^ self subclassResponsibility

    "Created: / 05-02-2018 / 13:07:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tooltip
    "Return tooltip (fly-by-help) text as string or `nil`. 
     If `nil` is returned, list views will show generic 
     toolip for the item"

    ^ nil

    "Created: / 29-07-2018 / 21:32:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBAbstractPresenter methodsFor:'change & update'!

updateChildren
    children notNil ifTrue:[ 
        self children:self fetchChildren  
    ].

    "Created: / 21-09-2014 / 23:43:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBAbstractPresenter methodsFor:'displaying'!

displayString
    ^ self label

    "Created: / 10-06-2017 / 12:24:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBAbstractPresenter methodsFor:'menu'!

contextMenu
    | menu |

    menu := Menu decodeFromLiteralArray: self class contextMenu.
    menu hasItems ifFalse:[ ^ menu ].
    menu findGuiResourcesIn:self.
    menu itemsDo:[:item| item receiver: self ].
    menu addSeparator.
    self contextMenuExtendersFor: #contextMenu do:[:each |
        self perform: each with: menu
    ]. 
    ^ menu

    "Created: / 16-01-2018 / 22:03:53 / jv"
    "Modified: / 07-02-2018 / 09:52:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

contextMenuExtendersFor: key do: block
    "Evaluates a block for each selector that extends particular menu.
     Extender methods have to be annotated by <menuextension: key> annotation
     and must take one argument (an instance of Menu that the menu extension
     extends."

    | cls |

    cls := self class.
    [ cls notNil ] whileTrue:[
        cls selectorsAndMethodsDo:[ :selector :method |
            method annotationsAt: #menuextension: do: [ :annotation |
                annotation arguments first == key ifTrue:[
                    block value: selector
                ].
            ]
        ].
        cls := cls superclass.
    ].

    "Created: / 07-02-2018 / 09:51:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBAbstractPresenter methodsFor:'menu actions'!

doCopy: aString
    <resource: #uiCallback>

    self application window setClipboardText: aString

    "Created: / 16-01-2018 / 22:36:30 / jv"
!

doDoubleClick
    "Invoked when user double-clicks to list item. "

    self subject inspect

    "Created: / 05-02-2018 / 13:03:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBAbstractPresenter methodsFor:'protocol-displaying'!

displayLabel:aLabel h:lH on:aGC x:x y:y h:h isHighlightedAsSelected:isHighlightedAsSelected
    isHighlightedAsSelected ifFalse:[ 
        | bg fg |

        fg := self foregroundColor.
        bg := self backgroundColor.
        (fg notNil or:[ bg notNil ]) ifTrue:[
            | fgSaved |

            fgSaved := aGC paint.
            [ 
                bg notNil ifTrue:[ 
                    aGC paint: bg.
                    aGC fillRectangleX: 0"x" y: y width: aGC width height: h.
                    aGC paint: fg ? fgSaved.
                ] ifFalse:[
                    fg notNil ifTrue:[
                        aGC paint: fg.
                    ].
                ].
                super displayLabel:aLabel h:lH on:aGC x:x y:y h:h isHighlightedAsSelected:isHighlightedAsSelected
            ] ensure:[ 
                aGC paint: fgSaved.
            ].

            ^ self.
        ]
    ].
    super displayLabel:aLabel h:lH on:aGC x:x y:y h:h isHighlightedAsSelected:isHighlightedAsSelected

    "Created: / 22-06-2018 / 15:12:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-06-2018 / 16:11:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBAbstractPresenter methodsFor:'testing'!

isBreakpointPresenter
    ^ false

    "Created: / 11-07-2017 / 11:50:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isFramePresenter
    ^ false

    "Created: / 21-09-2014 / 23:53:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isInstructionPresenter
    ^ false
!

isInstructionsAndSourcePresenter
    ^ false
!

isThreadGroupPresenter
    ^ false

    "Created: / 21-09-2014 / 23:54:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isThreadPresenter
    ^ false

    "Created: / 21-09-2014 / 23:54:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isVariablePresenter
    ^ false

    "Created: / 02-06-2017 / 00:05:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!VDBAbstractPresenter class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

