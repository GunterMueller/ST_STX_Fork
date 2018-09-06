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

Info subclass:#ClassInfo
	instanceVariableNames:'className methods instvars seqno'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Smalltalk-Types-Info'
!

!ClassInfo class methodsFor:'documentation'!

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

!ClassInfo class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!ClassInfo methodsFor:'accessing'!

className
    ^ className
!

infoForInstvar: ivarName

    ^instvars at: ivarName ifAbsentPut:[
        Type default.
    ]

    "Created: / 27-11-2011 / 16:44:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

infoForInstvarOrNil: ivarName

    ^instvars at: ivarName ifAbsent: nil

    "Created: / 27-11-2011 / 17:15:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

infoForSelector: selector

    ^methods at: selector ifAbsentPut:[
        MethodInfo new setManager: manager classInfo: self selector: selector.

    ]

    "Created: / 27-11-2011 / 16:26:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

infoForSelectorOrNil: selector

    ^methods at: selector ifAbsent:nil

    "Created: / 27-11-2011 / 17:15:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

seqno
    ^ seqno
!

seqno:anInteger
    seqno := anInteger.
!

superclassInfo

    | nm meta cls |

    (className endsWith:' class') ifTrue:[
        nm := (className copyTo: className size - 6) asSymbol.
        meta := true.
    ] ifFalse:[
        nm := className asSymbol.
        meta := false.
    ].
    cls := Smalltalk at: nm.
    cls isNil ifTrue:[ ^ nil ].
    meta ifTrue:[cls := cls theMetaclass].

    ^ manager infoForClass: cls superclass

    "Modified: / 29-11-2011 / 16:02:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ClassInfo methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    "/ please change as required (and remove this comment)
    "/ superclassInfo := nil.
    "/ className := nil.
    methods := Dictionary new.
    instvars := Dictionary new.

    "/ super initialize.   -- commented since inherited method does nothing

    "Modified: / 27-11-2011 / 16:53:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setManager: mgr className: nm

    manager := mgr.
    className := nm

    "Created: / 29-11-2011 / 15:57:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ClassInfo class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

