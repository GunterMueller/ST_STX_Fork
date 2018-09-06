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

Object subclass:#GDBObject
	instanceVariableNames:'properties'
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Core'
!

!GDBObject class methodsFor:'documentation'!

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

!GDBObject class methodsFor:'accessing-magritte'!

descriptionContainer
    ^ GDBMAContainer forClass: self.

    "Created: / 23-09-2014 / 23:26:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBObject class methodsFor:'utilities - properties'!

getPropertiesOf: object

    | names index properties |

    names := object class allInstVarNames.
    index := names indexOf: #properties.
    index ~~ 0 ifTrue:[ 
        properties := object instVarAt: index.
        properties isNil ifTrue:[ 
            properties := Dictionary new.
            object instVarAt: index put: properties.
            ^ properties
        ].
    ].
    ^ nil

    "Created: / 20-06-2014 / 09:03:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getProperty: nm of: object

    | nmXlated names index properties |

    nmXlated := (nm includes: $-) ifTrue:[ nm copyReplaceAll: $- with: $_] ifFalse:[ nm ].
    index := (names := object class allInstVarNames) indexOf: nmXlated.
    index ~~ 0 ifTrue:[ 
        ^ object instVarAt: index.
    ].
    index := names indexOf: #properties.
    index ~~ 0 ifTrue:[ 
        properties := object instVarAt: index.
        properties notNil ifTrue:[ 
            ^ properties at: nm ifAbsent:[ nil ]
        ].
    ].
    ^ nil

    "Created: / 20-06-2014 / 08:59:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-09-2014 / 02:05:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setProperty: nm of: object to: value

    | nmXlated names index properties setter |

    nmXlated := (nm includes: $-) ifTrue:[ nm copyReplaceAll: $- with: $_] ifFalse:[ nm ].
    setter := ('_', nmXlated , ':') asSymbolIfInterned.
    setter notNil and:[ 
        (object respondsTo: setter) ifTrue:[ 
            object perform: setter with: value.
            ^ self
        ].
    ].
    setter := (nmXlated , ':') asSymbolIfInterned.
    setter notNil and:[ 
        (object respondsTo: setter) ifTrue:[ 
            object perform: setter with: value.
            ^ self
        ].
    ].
    index := (names := object class allInstVarNames) indexOf: nmXlated.
    index ~~ 0 ifTrue:[ 
        object instVarAt: index put: value.
    ] ifFalse:[
        index := names indexOf: #properties.
        index ~~ 0 ifTrue:[ 
            properties := object instVarAt: index.
            properties isNil ifTrue:[ 
                properties := Dictionary new.
                object instVarAt: index put: properties.
            ].
            properties at: nm put: value.
        ].
    ].

    "Created: / 20-06-2014 / 09:01:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-03-2015 / 08:34:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBObject methodsFor:'accessing-properties'!

properties
    ^ self class getPropertiesOf: self.

    "Modified: / 06-09-2014 / 01:49:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

propertyAt: name
    ^ self class getProperty: name of: self

    "Created: / 31-05-2014 / 00:00:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-09-2014 / 01:49:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

propertyAt: name put: value
    ^ self class setProperty: name of: self to: value

    "Created: / 31-05-2014 / 00:01:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-09-2014 / 01:49:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBObject methodsFor:'attributes access'!

objectAttributes
    ^ properties

    "Created: / 18-06-2014 / 07:56:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

objectAttributes: aDictionary
    properties := aDictionary

    "Created: / 18-06-2014 / 07:57:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBObject methodsFor:'inspecting'!

inspectorExtraAttributes
    | attrs |

    attrs := super inspectorExtraAttributes.
    properties notEmptyOrNil ifTrue:[ 
        properties keysAndValuesDo:[ :name :value |
            attrs at: '-' , name put: value.
        ]
    ].
    ^ attrs

    "Created: / 13-06-2017 / 16:13:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBObject class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

