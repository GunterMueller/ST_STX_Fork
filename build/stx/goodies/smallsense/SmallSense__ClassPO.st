"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany
Copyright (C) 2014 Claus Gittinger

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

PO subclass:#ClassPO
	instanceVariableNames:'showPrefix klass icon'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Core-Interface-PO'
!

!ClassPO class methodsFor:'documentation'!

copyright
"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany
Copyright (C) 2014 Claus Gittinger

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

!ClassPO methodsFor:'accessing'!

hint
    | namespace |

    namespace := nil.
    showPrefix ifFalse:[
        namespace := klass isJavaClass
                        ifTrue:[klass javaPackage]
                        ifFalse:[ | ns | ns := klass nameSpace. [ ns isNameSpace ] whileFalse:[ ns := ns nameSpace ]. ns name].
        (namespace notNil and:[namespace ~~ #Smalltalk]) ifTrue:[
            ^ 'in ', namespace.
        ].
    ].
    ^ nil

    "Created: / 20-05-2014 / 12:21:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-07-2014 / 17:31:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

icon

    icon ifNil:[icon := SystemBrowser iconForClass: klass].
    ^icon

    "Created: / 06-04-2011 / 23:36:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

klass
    ^ klass

    "Created: / 25-08-2013 / 13:07:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

klass: aClass
    ^ klass := aClass

    "Created: / 25-08-2013 / 13:07:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-05-2014 / 10:05:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label
    label isNil ifTrue:[
        showPrefix ifTrue:[
            label := klass name.
            (context notNil and:[klass isJavaClass]) ifTrue:[
                | lang |

                lang := context language.
                (lang notNil and:[lang isJava]) ifTrue:[
                    label := klass javaName
                ] ifFalse:[
                    (lang notNil and:[lang isSmalltalk]) ifTrue:[
                       label := 'JAVA ' , (klass  binaryName copyReplaceAll: $/ with: Character space)
                     ] ifFalse:[ 
                        label := klass nameWithoutNameSpacePrefix.
                     ].
                ]
            ].
        ] ifFalse:[
            label := klass nameWithoutNameSpacePrefix.
        ].
        (ChangeSet current includesChangeForClass: klass) ifTrue:[ 
            label := label asText emphasisAllAdd:(UserPreferences current emphasisForChangedCode)         
        ].
    ].

    ^label

    "Created: / 20-05-2014 / 11:29:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-11-2015 / 07:28:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showPrefix
    ^ showPrefix
!

showPrefix:aBoolean
    showPrefix := aBoolean.
!

stringAlreadyWritten
    "Answers a string already written in the textview"

    klass isJavaClass ifTrue:[
        context language isSmalltalk ifTrue:[
            | rec |

            rec := context node .
            [ rec isUnaryMessage ] whileTrue:[
                rec := rec receiver.
            ].
            (rec isVariableNode and:['JAVA' startsWith: rec name]) ifTrue:[
                ^ context textView contents string copyFrom: rec startPosition to: context node endPosition
            ].
        ] ifFalse:[
        context language isJavaLike ifTrue:[
             ^ context wordBeforeCursorConsisitingOfCharactersMatching:[:c | c isAlphaNumeric or:['$_.' includes: c] ]
        ]].
    ].
    ^ super stringAlreadyWritten

    "Created: / 20-10-2013 / 02:46:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-03-2015 / 17:15:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stringToCompleteForLanguage: language
    ^ (klass isJavaClass and:[language isSmalltalk]) ifTrue:[
	'JAVA ', (klass binaryName copyReplaceAll: $/ with: Character space)
    ] ifFalse:[
	self label
    ].

    "Created: / 03-10-2013 / 16:42:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-05-2014 / 11:41:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ClassPO methodsFor:'accessing-private'!

subject
    "Return the real object for which the receiver
     is a presentor.

     For internal usage only."   

    ^ self klass

    "Created: / 01-10-2014 / 23:48:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ClassPO methodsFor:'converting'!

asString
    ^klass isJavaClass ifTrue:[
	klass javaName
    ] ifFalse:[
	klass name
    ].

    "Created: / 04-04-2012 / 13:00:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-08-2013 / 10:27:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ClassPO methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    "/ please change as required (and remove this comment)
    "/ showPrefix := nil.

    super initialize.
    showPrefix := false.

    "Modified: / 20-10-2013 / 02:38:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeWithClass: aClass

    klass := aClass.
    showPrefix := false.

    "Created: / 20-05-2014 / 09:56:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ClassPO methodsFor:'testing'!

isSmallSenseClassPO
    ^ true
! !

!ClassPO class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

