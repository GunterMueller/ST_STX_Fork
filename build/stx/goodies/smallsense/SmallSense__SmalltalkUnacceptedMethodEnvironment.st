"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany

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

BrowserEnvironment subclass:#SmalltalkUnacceptedMethodEnvironment
	instanceVariableNames:'class method'
	classVariableNames:'UnacceptedSelector'
	poolDictionaries:''
	category:'SmallSense-Smalltalk-Lint'
!

!SmalltalkUnacceptedMethodEnvironment class methodsFor:'documentation'!

copyright
"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany

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

!SmalltalkUnacceptedMethodEnvironment class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    "/ please change as required (and remove this comment)

    UnacceptedSelector := #'* * UnacceptedSelector * *'

    "Modified: / 27-01-2012 / 16:23:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkUnacceptedMethodEnvironment class methodsFor:'instance creation'!

onClass: realClass methodSource: source

    ^self new setupForClass: realClass source: source

    "Created: / 27-01-2012 / 15:38:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkUnacceptedMethodEnvironment methodsFor:'accessing'!

methodsInto:arg
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self shouldImplement
!

selectorsForClass: aClass do: aBlock

    self assert: aClass == class.
    aBlock value: (method selector) ? UnacceptedSelector

    "Created: / 27-01-2012 / 15:50:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkUnacceptedMethodEnvironment methodsFor:'accessing-classes'!

classesDo: aBlock 

    ^aBlock value: class.

    "Created: / 27-01-2012 / 15:48:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkUnacceptedMethodEnvironment methodsFor:'initialization'!

setupForClass: realClass source: source

    | ns |

    ns := RBNamespace onEnvironment: BrowserEnvironment new.
    class := realClass isMetaclass 
                ifTrue:[RBMetaclass existingNamed: realClass theNonMetaclass name]
                ifFalse:[RBClass existingNamed: realClass name].
    class model: ns.
    method := RBMethod for: class source: source selector: nil.
    class addMethod: method.

    "Created: / 27-01-2012 / 15:42:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkUnacceptedMethodEnvironment methodsFor:'testing'!

includesSelector: aSelector in: aClass

    ^aClass == method mclass 
        and:[aSelector == #'  fake selector  '].

    "Created: / 27-01-2012 / 15:51:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkUnacceptedMethodEnvironment class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !


SmalltalkUnacceptedMethodEnvironment initialize!
