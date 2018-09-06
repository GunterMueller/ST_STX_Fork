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

PO subclass:#MethodBindingPO
	instanceVariableNames:'binding'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Java-Interface-PO'
!

!MethodBindingPO class methodsFor:'documentation'!

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

!MethodBindingPO methodsFor:'accessing'!

binding
    ^ binding
!

binding:b
    binding := b.
!

label
    "Return a text to be displayed. The label may be cached
     `label` instvar."

    label isNil ifTrue:[
        | descriptor |

        descriptor := binding signature.
        label := JavaMethod specTextFromSignature:descriptor in: nil withName: binding selector isConstructor: binding isConstructor.   


"/        | parameters |
"/
"/        label := String streamContents: [ :s |
"/            s nextPutAll: binding selector.
"/            s nextPut: $(.
"/            parameters := binding parameters.
"/            parameters notEmptyOrNil ifTrue:[ 
"/                s nextPutAll: parameters first displayString.
"/                parameters size > 1 ifTrue:[ 
"/                    1 to: parameters size do:[:i |  
"/                        s nextPutAll: ', '.
"/                        s nextPutAll: (parameters at: i) displayString.
"/                    ]
"/                ].
"/            ].
"/            s nextPut: $).
"/        ]
    ].
    ^ label

    "Created: / 13-08-2014 / 22:33:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stringToCompleteForLanguage:aProgrammingLanguage
    ^ binding selector , '()'

    "Created: / 13-08-2014 / 22:39:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MethodBindingPO methodsFor:'testing'!

isSmallSenseMethodBindingPO
    ^ true

    "Created: / 13-08-2014 / 22:44:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MethodBindingPO class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

