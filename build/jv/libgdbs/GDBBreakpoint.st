"
jv:libgdbs - GNU Debugger Interface Library
Copyright (C) 2015-now Jan Vrany

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
"{ Package: 'jv:libgdbs' }"

"{ NameSpace: Smalltalk }"

GDBDebuggerObject subclass:#GDBBreakpoint
	instanceVariableNames:'number type disp enabled addr func file fullname line times
		condition script locations'
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core'
!

!GDBBreakpoint class methodsFor:'documentation'!

copyright
"
jv:libgdbs - GNU Debugger Interface Library
Copyright (C) 2015-now Jan Vrany

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

!GDBBreakpoint class methodsFor:'accessing - GDB value descriptors'!

description
    ^ (super description)
        define:#number as:String;
        define:#type as:String;
        define:#disp as:String;
        define:#enabled as:Boolean;
        define:#addr as:Integer;
        define:#func as:String;
        define:#file as:String;
        define:#fullname as:String;
        define:#line as:Integer;
        define:#times as:Integer;
        yourself

    "Created: / 06-09-2014 / 01:56:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-05-2018 / 12:38:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBBreakpoint methodsFor:'accessing'!

addr
    ^ addr
!

condition
    ^ condition
!

condition:aString
    self assert: debugger notNil.
    condition ~= aString ifTrue:[ 
        debugger send: (GDBMI_break_condition arguments: (Array with: number with: aString)) andWait: true.    
        condition := aString
    ].

    "Modified: / 17-11-2017 / 20:25:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

disp
    ^ disp
!

enabled
    ^ enabled
!

enabled: aBoolean
    self assert: debugger notNil.
    enabled ~~ aBoolean ifTrue:[
        aBoolean ifTrue:[
            debugger send: (GDBMI_break_enable arguments: (Array with: number)) andWait: true.
        ] ifFalse:[ 
            debugger send: (GDBMI_break_disable arguments: (Array with: number)) andWait: true.
        ].
        enabled := aBoolean.
    ].

    "Created: / 07-07-2017 / 12:33:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-11-2017 / 20:24:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

file
    ^ file
!

fullname
    ^ fullname
!

func
    ^ func
!

line
    ^ line
!

locations
    locations isNil ifTrue:[ ^ Array with: self ].
    ^ locations

    "Modified: / 18-05-2018 / 12:23:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

locations:aCollection
    self assert:  aCollection isCollection.
    self assert: (aCollection allSatisfy:[:e|e isKindOf: GDBBreakpoint]).
    self assert: (aCollection allSatisfy:[:e|e number startsWith: number , '.']).

    locations := aCollection.
    locations do:[:e|e setDebugger: debugger].

    "Modified: / 18-05-2018 / 15:01:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

number
    ^ number
!

script
    ^ script
!

script:aString
    self assert: debugger notNil.
    script ~= aString ifTrue:[ 
        debugger send: (GDBMI_break_commands arguments: (Array with: number) , aString asStringCollection) andWait: true.    
        script := aString
    ].

    "Created: / 11-07-2017 / 14:32:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-11-2017 / 20:24:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

times
    ^ times
!

type
    ^ type
! !

!GDBBreakpoint methodsFor:'accessing-properties'!

propertyAt: name
    name = 'at' ifTrue:[ 
        ^ nil
    ].
    ^super propertyAt: name

    "Created: / 05-06-2017 / 23:22:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-06-2017 / 09:18:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

propertyAt: name put: value
    name = 'at' ifTrue:[ 
        ^ self.
    ].
    ^ super propertyAt: name put: value

    "Created: / 05-06-2017 / 23:22:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-06-2017 / 09:19:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBBreakpoint methodsFor:'initialization & release'!

setDebugger: aGDBDebugger
    super setDebugger: aGDBDebugger.
    locations notEmptyOrNil ifTrue:[ 
        locations do:[:e | e setDebugger: debugger ]
    ].

    "Created: / 18-05-2018 / 15:00:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBBreakpoint methodsFor:'inspecting'!

inspector2TabCondition
    <inspector2Tab>

    | editor |

    editor := (HVScrollableView for:EditTextView).
    editor model: ((AspectAdaptor forAspect: #condition) subject: self).

    ^ Tools::Inspector2Tab new
            priority: 41;
            label:'Condition';  
            view: editor
            yourself.

    "Created: / 11-07-2017 / 14:36:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

inspector2TabScript
    <inspector2Tab>

    | editor |

    editor := (HVScrollableView for:EditTextView).
    editor model: ((AspectAdaptor forAspect: #script) subject: self).

    ^ Tools::Inspector2Tab new
            priority: 40;
            label:'Script';  
            view: editor
            yourself.

    "Created: / 11-07-2017 / 14:41:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBBreakpoint methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation of the receiver to the argument, aStream"

    super printOn:aStream.
    aStream nextPut:$(.
    number printOn:aStream.
    aStream nextPutAll:', '.
    aStream nextPutAll:(enabled ifTrue:[ 'enabled, ' ] ifFalse:[ 'disabled, ' ]).
    func notNil ifTrue:[ 
        aStream nextPutAll:'in '.
        func printOn:aStream.   
        aStream nextPutAll:'(), '. 
    ].
    file notNil ifTrue:[
        file printOn:aStream.
        aStream nextPut:$:.
        line printOn:aStream.
    ] ifFalse:[ 
        aStream nextPutAll:'at '.
        addr printOn: aStream.
    ].

    "Modified: / 10-07-2017 / 12:55:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBBreakpoint methodsFor:'private'!

_cond: aString
    condition := aString

    "Created: / 11-07-2017 / 14:11:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_enabled: aBoolean
    enabled := aBoolean

    "Created: / 07-07-2017 / 12:46:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

_script: anArray
    script := anArray asStringWith: Character cr.

    "Created: / 11-07-2017 / 14:11:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateFrom: aGDBBreakpoint
    | ignored |

    self assert: number = aGDBBreakpoint number.
    ignored := self class instVarIndexFor: #locations.  
    self class superclass instSize + 1 to: self class instSize do:[:i | 
        i ~~ ignored ifTrue:[
            self instVarAt: i put: (aGDBBreakpoint instVarAt: i).
        ].
    ].
    properties := aGDBBreakpoint properties.

    "Created: / 06-07-2017 / 16:30:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-01-2018 / 23:12:02 / jv"
    "Modified: / 18-05-2018 / 21:44:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBBreakpoint methodsFor:'testing'!

isEnabled
    ^ enabled

    "Created: / 07-07-2017 / 12:31:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isValid
    ^ debugger isConnected

    "Created: / 04-02-2018 / 21:29:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBBreakpoint class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

