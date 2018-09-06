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

CompletionEngine subclass:#AbstractJavaCompletionEngine
	instanceVariableNames:'class method'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Java'
!

!AbstractJavaCompletionEngine class methodsFor:'documentation'!

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

!AbstractJavaCompletionEngine class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned here for myself only; false for subclasses.
     Abstract subclasses must redefine again."

    ^ self == SmallSense::AbstractJavaCompletionEngine.
! !

!AbstractJavaCompletionEngine methodsFor:'completion-individual'!

addClassesStartingWith: prefix
    ^ self addClassesStartingWith:prefix matchFullName:false

    "Created: / 03-10-2013 / 11:16:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-05-2014 / 07:25:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addClassesStartingWith:prefixArg filter: filter
    ^ self addClassesStartingWith:prefixArg matchFullName:false filter: filter

    "Created: / 07-08-2014 / 15:04:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addClassesStartingWith:prefixArg matchFullName:matchFullName 
    ^ self addClassesStartingWith:prefixArg matchFullName:matchFullName filter: nil

    "Created: / 15-05-2014 / 07:24:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-08-2014 / 15:03:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addClassesStartingWith:prefixArg matchFullName:matchFullName filter: filter 
    | prefix |

    prefix := prefixArg.
    matchFullName ifTrue:[
        prefix := prefix copyReplaceAll:$. with:$/.
    ].
    context environment 
        allClassesDo:[:cls | 
            (cls isJavaClass and:[ cls isAnonymous not and:[filter isNil or:[filter value: cls]]]) ifTrue:[
                | name  i |

                matchFullName ifTrue:[
                    (prefix isEmpty or:[cls binaryName startsWith:prefix]) ifTrue:[
                        result add:((PO forClass:cls)
                                    showPrefix:true;
                                    yourself).
                    ].
                ] ifFalse:[
                    name := cls lastName.
                    i := name lastIndexOf:$/.
                    prefix isEmptyOrNil ifTrue:[ 
                        result add:(PO forClass:cls).
                    ] ifFalse:[
                        ((name size >= (i + prefix size)) 
                            and:[
                                (name at:i + 1) == prefix first 
                                    and:[
                                        (name at:i + prefix size) == prefix last 
                                            and:[
                                                (2 to:prefix size - 1) 
                                                    allSatisfy:[:o | (name at:i + o) == (prefix at:o) ]
                                            ]
                                    ]
                            ]) 
                                ifTrue:[ result add:(PO forClass:cls). ].
                    ]
                ].
            ].
        ].

    "Created: / 07-08-2014 / 15:03:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-08-2014 / 16:05:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addConstructorsForClass: aJavaClass fullName: showFullName
    aJavaClass selectorsAndMethodsDo:[:selector :method |
        (selector first == $< and:[ selector startsWith: '<init>' ]) ifTrue:[
            result add: ((JavaConstructorPO new initializeWithClass: aJavaClass selector: selector) showPrefix: showFullName)
        ].
    ].

    "Created: / 15-05-2014 / 12:05:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addExceptionsStartingWith: prefix
    "raise an error: this method should be implemented (TODO)"

    ^ self addExceptionsStartingWith: prefix matchFullName: false

    "Created: / 07-08-2014 / 14:59:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addExceptionsStartingWith: prefix matchFullName: matchFullName
    ^ self addClassesStartingWith: prefix matchFullName: matchFullName filter: [ :cls | cls isThrowable ].

    "Created: / 07-08-2014 / 15:04:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addFieldsForType: type
    | seen |

    type isUnknownType ifTrue:[ 
        ^ self.
    ].
    seen := Set new.
    type classesDo:[:initialCls |
        (seen includes: initialCls) ifFalse:[
            | cls |

            cls := initialCls.
            cls staticFields do:[:each | result add: (VariablePO classVariable: each name in: cls) ].
            [ cls ~~ JavaObject and:[ (seen includes: cls) not ] ] whileTrue:[
                seen add: cls.
                cls fields do:[:each | result add: (VariablePO instanceVariable: each name in: cls) ].
                cls := cls superclass.
            ].
        ]
    ].

    "Created: / 17-05-2014 / 20:37:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-05-2014 / 17:36:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addImportsStartingWith: prefix
    | packages |

    packages := Set new.

    "/ Class imports...
    context environment allClassesDo: [:cls |
        cls isJavaClass ifTrue:[
            | name |

            name := cls javaName.
            (cls isPublic and:[name startsWith: prefix]) ifTrue:[
                result add: (JavaImportPO new import: name; klass: cls; yourself).
                packages add: cls javaPackage.
            ].
        ]
    ].
    "/ Package imports...
    packages do:[:each |
        result add: (JavaImportPO new import: (each , '.*'))
    ].

    "Created: / 19-10-2013 / 17:54:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 14-05-2014 / 12:48:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addMethodsStartingWith: prefix
    ^ self addMethodsStartingWith: prefix stripOff: nil filter: [:m | m isJavaMethod ]

    "Created: / 03-10-2013 / 18:01:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-04-2014 / 21:37:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractJavaCompletionEngine class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

