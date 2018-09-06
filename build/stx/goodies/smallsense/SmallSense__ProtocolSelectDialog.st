"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2014 Jan Vrany
Copyright (C) 2015-2016 Jan Vrany

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

CetegoryOrProtocolSelectDialog subclass:#ProtocolSelectDialog
	instanceVariableNames:'protocolsToHighlight'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Core-Interface-Search'
!

!ProtocolSelectDialog class methodsFor:'documentation'!

copyright
"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2014 Jan Vrany
Copyright (C) 2015-2016 Jan Vrany

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

!ProtocolSelectDialog methodsFor:'accessing'!

protocolsToHighlight
    ^ protocolsToHighlight
!

protocolsToHighlight:aCollection
    protocolsToHighlight := aCollection.
! !

!ProtocolSelectDialog methodsFor:'accessing-defaults'!

defaultTitle
    ^ (resources string: 'Select Protocol...')

    "Created: / 13-12-2014 / 12:57:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProtocolSelectDialog methodsFor:'searching'!

matchingObjectPOsForPattern:pattern relax: level
    | environment protocols |

    environment := self environment.
    protocols := Set new.
    "/ Convert highlighted protocols to a Set because
    "/ (i)  Set>>includes: is faster O(1)
    "/ (ii) the collection passed in by client might be an iterator so
    "/      doing so actually caches the value. We want this for
    "/      performance reasons.
    protocolsToHighlight notNil ifTrue:[
        protocolsToHighlight := protocolsToHighlight asSet.
    ].

    environment allMethodsDo:[ :mth | 
        | protocol |

        protocol := mth category.
        (protocol notNil 
            and: [ (filter isNil or:[filter value: protocol]) 
            and: [ pattern isNil or:[pattern match: protocol relax: level] ] ]) ifTrue:[
                protocols add: mth category 
            ] 
    ].
    protocols := protocols asArray.
    protocols sort: [ :a :b | a < b ].
    ^ protocols collect:[ :each | 
        | label |

        label := each.
        (protocolsToHighlight notNil and:[protocolsToHighlight includes: each]) ifTrue:[  
            label := label asText allBold.
        ].
        PluggablePO new label: label; subject: each 
    ].

    "Created: / 13-12-2014 / 08:42:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-08-2016 / 15:56:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

