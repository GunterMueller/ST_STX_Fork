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

Object subclass:#CompletionEngine
	instanceVariableNames:'textView result context'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Core'
!

!CompletionEngine class methodsFor:'documentation'!

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

!CompletionEngine class methodsFor:'accessing'!

exactMatcher
    "Return a match block returning true, if given selector start with given prefix"

    ^ [ :prefix :selector | selector startsWith: prefix ]

    "Created: / 08-04-2014 / 21:31:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

inexactMatcher
    "Return a match block returning true, if given prefix matches given selector"

    ^ [ :prefix :selector |
        prefix size < 5 ifTrue:[
            selector startsWith: prefix.
        ] ifFalse:[
            | part |

            part := selector copyTo: (prefix size min: selector size).
            (prefix levenshteinTo: part) < 15
        ].
    ].

    "Created: / 08-04-2014 / 21:30:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

matcher
    "Return a match block returning true, if given prefix matches given selector"

    ^ [ :prefix :selector |
        prefix size < 5 ifTrue:[
            selector startsWith: prefix.
        ] ifFalse:[
            | part |

            part := selector copyTo: (prefix size min: selector size).
            (prefix levenshteinTo: part) < 15
        ].
    ].

    "Created: / 02-04-2014 / 23:30:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CompletionEngine class methodsFor:'testing'!

isAbstract
    ^ self == CompletionEngine

    "Created: / 02-10-2013 / 13:11:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CompletionEngine methodsFor:'completion'!

complete: aCompletionContext
    "Compute completion for given completion context, taking all the information
     from it. Returns a CompletionResult with computed completions"

    context := aCompletionContext.
    result := CompletionResult new.
    textView := context textView.
    result context: context.
    ^ self complete.

    "Created: / 21-01-2014 / 23:07:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-02-2015 / 23:52:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CompletionEngine methodsFor:'completion-individual'!

addMethodsStartingWith: prefix
    ^ self addMethodsStartingWith: prefix stripOff: nil filter: nil

    "Created: / 24-07-2013 / 13:10:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-04-2014 / 21:36:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addMethodsStartingWith: prefix stripOff: stripoffPrefix
    ^ self addMethodsStartingWith: prefix stripOff: stripoffPrefix filter: nil

    "Created: / 08-04-2014 / 21:36:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addMethodsStartingWith: prefix stripOff: stripoffPrefix filter: filterOrNil
    | matcher |

    matcher := stripoffPrefix isEmptyOrNil ifTrue:[ CompletionEngine inexactMatcher ] ifFalse:[ CompletionEngine exactMatcher ].
    ^ self addMethodsStartingWith: prefix stripOff: stripoffPrefix filter: filterOrNil matcher: matcher.

    "Created: / 08-04-2014 / 21:35:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addMethodsStartingWith: prefix stripOff: stripoffPrefix filter: filterOrNil matcher: matcher
    | matchPrefix selectors filter |

    selectors := Dictionary new.
    matchPrefix := stripoffPrefix isNil ifTrue:[ prefix ] ifFalse:[ stripoffPrefix , prefix ].
    filter := filterOrNil  isNil ifTrue:[ [:method | true ] ] ifFalse:[ filterOrNil  ].

    context environment allMethodsWithSelectorDo:[:mthd :selector|
        (mthd isSynthetic not and:[(filter value: mthd) and:[ matcher value: matchPrefix value: selector]]) ifTrue:[
                | class overridden |

                class := mthd mclass superclass.
                overridden := false.
                [ overridden not and:[class notNil] ] whileTrue:[
                    (class methodDictionary includesKey: selector) ifTrue:[
                        overridden := true.
                    ].
                    class := class superclass.
                ].
                overridden ifFalse:[
                    | classes |

                    classes := selectors at: selector ifAbsentPut:[ Set new ].
                    (classes includes: mthd mclass) ifFalse:[
                        classes add: mthd mclass.
                    ].
                ].
            ]
    ].


    selectors keysAndValuesDo: [:selector :classes |
        result add:(PO forClasses: classes selector: selector prefix: stripoffPrefix)
    ].
    ^ self

    "Created: / 08-04-2014 / 21:34:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-05-2014 / 11:54:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CompletionEngine methodsFor:'completion-private'!

complete
    "Compute completion for `codeView`, taking all the information
     from it. Returns a CompletionResult with computed completions"

    ^ self subclassResponsibility

    "Modified (comment): / 02-10-2013 / 13:33:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CompletionEngine class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

