"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany
Copyright (C) 2014 Claus Gittinger
Copyright (C) 2017 Jan Vrany

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

Tools::CodeViewService subclass:#EditService
	instanceVariableNames:'environment support'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Core-Services'
!

!EditService class methodsFor:'documentation'!

copyright
"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany
Copyright (C) 2014 Claus Gittinger
Copyright (C) 2017 Jan Vrany

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

!EditService class methodsFor:'initialization'!

initialize
    Smalltalk addStartBlock:[
        Screen current notNil ifTrue:[
            | map |
            
            map := Screen current keyboardMap.
            (map bindingForLogical:#CodeCompletion) isNil ifTrue:[
                (map hasMappingFor: #'Ctrl ') ifFalse:[
                    map bindValue:#CodeCompletion to: #'Ctrl '.
                ].
            ].
       ]
    ]

    "Created: / 17-09-2013 / 15:23:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!EditService class methodsFor:'accessing'!

label
    "Answers a short label - for UI"

    ^'SmallSense - Edit Support'

    "Created: / 27-07-2013 / 22:35:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!EditService class methodsFor:'testing'!

isAvailable

    ^false

    "Created: / 28-11-2014 / 15:41:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isAvailableFor: applicationClass

    "Returns true if given service may be used in
     given application class."

    ^false

    "Created: / 28-11-2014 / 15:41:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!EditService methodsFor:'accessing'!

environment
    "Return an system environment for completion."

    ^ environment ? Smalltalk

    "Modified: / 13-05-2014 / 12:02:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

environment:aSystemEnvironment
    "Sets an envirronment for completion. Only classes and/or methods in
     the environment are offered for completion"
    environment := aSystemEnvironment.

    "Modified (comment): / 13-05-2014 / 11:55:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

support
    ^ support
! !

!EditService methodsFor:'accessing-views'!

codeView
    ^ codeView
!

gutterView
    ^ gutterView
!

textView
    ^ textView
! !

!EditService methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    "Invoked when an object that I depend upon sends a change notification."

    changedObject == codeView ifTrue:[
        (#(methodHolder classHolder languageHolder) includes: something) ifTrue:[
            aParameter key removeDependent: self.
            aParameter value addDependent: self.                         
        ].
    ].

    (changedObject == codeView languageHolder 
        or:[changedObject == codeView classHolder
        or:[changedObject == codeView methodHolder]]) ifTrue:[
        self updateSupport.
        ^self.
    ].

    super update:something with:aParameter from:changedObject

    "Modified: / 16-09-2013 / 16:36:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateSupport
    | lang |

    support language ~~ (lang := codeView language) ifTrue:[
        self updateSupport: (EditSupport forLanguage: lang).
    ].

    "Created: / 16-09-2013 / 16:31:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-05-2015 / 21:52:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateSupport: anEditSupport
    support := anEditSupport.
    support initializeForService: self.

    "Created: / 13-05-2014 / 14:49:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!EditService methodsFor:'event handling'!

keyPress: key x:x y:y in: view

    "Handles an event in given view (a subview of codeView).
     If the method returns true, the event will not be processed
     by the view."

    ^ support notNil 
        ifTrue:[support keyPress: key x:x y:y in: view]
        ifFalse:[false]

    "Created: / 07-03-2010 / 09:36:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-05-2015 / 00:00:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!EditService methodsFor:'registering'!

registerIn: aCodeView
    UserPreferences current smallSenseEnabled ifTrue:[
        super registerIn: aCodeView.
        aCodeView languageHolder addDependent: self.
        aCodeView classHolder    addDependent: self.
        aCodeView methodHolder   addDependent: self.
        support := EditSupport forLanguage: aCodeView language.
        support initializeForService: self.
    ] ifFalse:[ 
        "/ If not enabled, remove itself from set of services,
        "/ see Tools::CodeView2>>registerService:
        "/ Bad API, has to be fixed in CodeView2...
        aCodeView services remove: self ifAbsent:[ ]
    ].

    "Created: / 24-07-2013 / 23:13:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-06-2014 / 14:15:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unregister
    "Uninstall myself from my codeView"

    codeView languageHolder removeDependent: self.
    codeView classHolder    removeDependent: self.
    codeView methodHolder   removeDependent: self.
    super unregister

    "Created: / 24-07-2013 / 23:14:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-06-2014 / 14:17:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!EditService class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


EditService initialize!
