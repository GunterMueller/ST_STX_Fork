"{ Encoding: utf8 }"

"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany
Copyright (C) 2014 Claus Gittinger
Copyright (C) 2015 Claus Gittinger

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

Object subclass:#SmalltalkQuickFixer
	instanceVariableNames:'view rule fixes'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Smalltalk-Lint'
!

Object subclass:#QuickFix
	instanceVariableNames:'rule label action'
	classVariableNames:''
	poolDictionaries:''
	privateIn:SmalltalkQuickFixer
!

!SmalltalkQuickFixer class methodsFor:'documentation'!

copyright
"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany
Copyright (C) 2014 Claus Gittinger
Copyright (C) 2015 Claus Gittinger

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

!SmalltalkQuickFixer class methodsFor:'instance creation'!

forView: view

    ^self new initializeForView: view

    "Created: / 15-12-2014 / 16:45:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkQuickFixer methodsFor:'accessing'!

fixesForRule: rule
    ^ fixes select:[:fix | fix rule == rule ]

    "Created: / 15-12-2014 / 16:47:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkQuickFixer methodsFor:'adding'!

fix
    "Create and return new quick fix. Caller MUST set its 
     rule, label and action"

    | fix |

    fix := QuickFix new.
    fixes add: fix.
    ^fix

    "Created: / 01-02-2012 / 10:51:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 15-12-2014 / 16:48:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkQuickFixer methodsFor:'initialization'!

initializeForView: aCodeView2
    view := aCodeView2.
    fixes := OrderedCollection new: 3.

    "Created: / 15-12-2014 / 16:46:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkQuickFixer methodsFor:'performing fixes'!

performFix: index

    index <= fixes size ifTrue:[
        (fixes at: index) performFix.
    ] ifFalse:[
        ^ Dialog warn: ('No such fix (%1)' bindWith: index).
    ]

    "Created: / 16-02-2012 / 14:48:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkQuickFixer methodsFor:'utilities'!

apply: changes 
    changes isEmptyOrNil ifTrue: [
        ^ self
    ].
    (changes size == 1 and: [ changes anElement isMethodCodeChange ]) ifTrue: [
        "/ Only one change, modify the code directly in the editor

        | oldSource newSource |

        oldSource := view contents asString string.
        newSource := changes anElement source asString.
        oldSource ~= newSource ifTrue: [
            | line |

            view 
                undoableDo:[
                    line := view firstLineShown.
                    view replaceContentsWith:newSource asStringCollection.
"/                    view contents: newSource asStringCollection clear: false.
                    view modified: true.
                    view isCodeView2 ifTrue: [
                        view reallyModifiedChannel value: true.
                    ].
                    view scrollToLine:line.     
                ]
                info:'Rewrite the code'.
        ].
    ] ifFalse: [
        | browser |

        browser := view application topApplication.
        (browser respondsTo: #performRefactoring:) ifTrue: [
            browser performRefactoring: changes.
        ] ifFalse: [
            self breakPoint: #jv.
            Dialog warn:'Sorry, this application does not support quick fixes'
        ]
    ]

    "Created: / 16-02-2012 / 14:46:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-10-2014 / 03:05:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkQuickFixer::QuickFix methodsFor:'accessing'!

action
    ^ action
!

action:aBlock
    action := aBlock.
!

label
    ^ label
!

label:aString
    label := aString.
!

performFix

    ^action value

    "Created: / 16-02-2012 / 14:48:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

rule
    ^ rule
!

rule:anRBLintRule
    rule := anRBLintRule.
! !

!SmalltalkQuickFixer class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

