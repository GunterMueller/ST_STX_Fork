"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2014 Jan Vrany

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

AbstractSearchProcessor subclass:#ImplementorSearchProcessor
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Core-Interface-Search'
!

!ImplementorSearchProcessor class methodsFor:'documentation'!

copyright
"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2014 Jan Vrany

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

!ImplementorSearchProcessor methodsFor:'accessing'!

canDoNextStepFor: aPO
    "Return true if navigation can take a next step for given PO
     (i.e., if user can 'dive in'), false otherwise.
     To be overriden by subclasses to avoid excessive processor creation."

    self assert: aPO class == MethodPO.
    ^ aPO classes size > 1

    "Created: / 23-01-2015 / 22:17:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

processorForNextStepFor: aPO
    "Return a processor for next navigation step for given PO.
     If nil is returned, then there's no next step (i.e.,
     a user connot 'dive in')"

    | selector |

    self assert: aPO class == MethodPO.
    aPO classes size == 1 ifTrue:[ ^ nil ].
    selector := aPO selector.
    ^ PluggableSearchProcessor 
            search:
                [ :pattern :filter :env :level | 

                    ((aPO classes 
                        select:[:cls | pattern isNil or:[ pattern match: cls nameWithoutNameSpacePrefix relax: level ] ])  
                        asArray sort:[ :a :b | a nameWithoutNameSpacePrefix < b nameWithoutNameSpacePrefix ])
                        collect:[ :cls | cls compiledMethodAt: selector ]

                ]
            presentation:             
                [ :method | 
                    PluggablePO new
                        label: (method mclass nameWithoutNameSpacePrefix) , ((' >> ', selector) asText colorizeAllWith: Color gray darker);
                        subject: method.                        
                ].

    "Created: / 23-01-2015 / 22:06:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-01-2015 / 00:44:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ImplementorSearchProcessor methodsFor:'accessing - presentation'!

label
    "Return a label for this processor. This one is used as section label
     in Spotter"

    ^ 'Implementors'

    "Created: / 10-01-2015 / 06:41:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ImplementorSearchProcessor methodsFor:'searching'!

matchingObjectPOsFor: objects
    | pos |

    pos := OrderedCollection new: objects size.
    objects keysAndValuesDo: [ :selector :classes |
        pos add: (PO forClasses: classes selector: selector )

    ].
    ^ pos sort:[ :a :b | a label == b label ifTrue:[ a classes anElement name < b classes anElement name] ifFalse:[ a label < b label ] ]

    "Created: / 30-04-2014 / 09:50:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-12-2014 / 23:50:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

matchingObjectsForPattern:pattern filter: filter inEnvironment:environment relax: level 
    | matching |

    matching := Dictionary new.
    pattern notNil ifTrue:[
        environment 
            allMethodsDo:[:mthd |
                | selector name |

                name := selector := mthd selector.
                mthd isJavaMethod ifTrue:[ name := name upTo: $( ].
                ((filter isNil or:[filter value: mthd]) and:[(pattern match:name relax: level)]) ifTrue:[
                    (matching at: selector ifAbsentPut: [ Set new ]) add: mthd mclass
                ].
            ].
    ].

    ^ matching

    "Created: / 12-12-2014 / 21:24:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-12-2014 / 23:51:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

