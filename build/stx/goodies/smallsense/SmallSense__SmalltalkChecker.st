"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany
Copyright (C) 2016 Jan Vrany

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

SmalllintChecker subclass:#SmalltalkChecker
	instanceVariableNames:''
	classVariableNames:'Errors'
	poolDictionaries:''
	category:'SmallSense-Smalltalk-Lint'
!

!SmalltalkChecker class methodsFor:'documentation'!

copyright
"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany
Copyright (C) 2016 Jan Vrany

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
!

documentation
"
    SmallSenseChecker is customized SmalllintChecker used
    by SmallSense's checking services. Do not use it in your
    code, use SmalllintChecker instead.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]
        SmalllintChecker
        SmallSenseService

"
! !

!SmalltalkChecker class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    "/ please change as required (and remove this comment)

    Errors := Dictionary new.

    "Modified: / 06-09-2012 / 14:18:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkChecker class methodsFor:'accessing'!

forceDisabledRules
    "Return a list of rule class names that
     are never run by SmallSense's checker - they
     are either buggy (i.e.. not ready to be run
     incrementally) or it does not make sense to run them
     Add with care!!!!!!
    "

    ^ #(
        RBLawOfDemeterRule          "/ Too many false positives, hard to fix
        RBImplementedNotSentRule    "/ Uses Context>>#computeLiterals whichs toooo slow.
        RBSentNotImplementedRule    "/ Uses Context>>#computeLiterals whichs toooo slow.
        RBUndeclaredReferenceRule   "/

        RBNilOrEmptyCollectionReplaceRule   "/ only for Squeak - I don't want people to rewrite ST/X code
        RBSTXSpecialCommentsRule            "/ a rewriter to be used only for porting
    )

    "Created: / 17-02-2012 / 13:10:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-09-2014 / 11:59:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkChecker methodsFor:'private'!

checkClass: aClass 

    "Nothing to do, SmallSense checker checks only methods"
    context selectedClass: aClass.

    "Created: / 16-02-2012 / 16:12:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

checkMethodsForClass: aClass

    environment selectorsForClass: aClass do: [:sel|
        | tree |

        context selector: sel.
        (tree := context parseTree) notNil ifTrue:[
            | ignored |

            ignored := tree pragmas 
                            select:[:e|e selector = #ignore:rationale:author:]
                            thenCollect: [:e | e arguments first value ].
            rule flattened do:[:each|
                [
                    (ignored includes: each class name) ifFalse:[
                        each checkMethod: context.
                    ] ifTrue:[ 
                        "/self halt.
                    ].
                ] on: Error do:[:ex|
                    SmalltalkLintService debugging ifTrue:[
                        SmalltalkLintService debugging: false.
                        ex pass.
                    ] ifFalse:[
                        Errors at: each class ifAbsentPut:[  (context selectedClass compiledMethodAt: context selector) source ].
                    ]
                ]
            ].
        ].
    ]

    "Modified: / 24-08-2010 / 21:32:39 / Jan Vrany <enter your email here>"
    "Created: / 17-02-2012 / 00:50:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-04-2016 / 04:47:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmalltalkChecker class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !


SmalltalkChecker initialize!
