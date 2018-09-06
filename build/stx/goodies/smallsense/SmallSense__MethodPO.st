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

PO subclass:#MethodPO
	instanceVariableNames:'selector classes'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Core-Interface-PO'
!

!MethodPO class methodsFor:'documentation'!

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

!MethodPO methodsFor:'accessing'!

classes
    ^ classes
!

cursorColumnAfterComplete

    | idx |
    idx := self label indexOf: $:.
    ^idx == 0 ifTrue:[self label size + 1] ifFalse:[idx + 1].

    "Created: / 05-04-2011 / 17:08:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-05-2014 / 11:43:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cursorColumnAfterCompleteForLanguage: language
    | stringToComplete idx |

    stringToComplete := self stringToCompleteForLanguage: language.
    language  isSmalltalk  ifTrue:[
        idx := stringToComplete indexOf: $:.
        ^idx == 0 ifTrue:[stringToComplete size] ifFalse:[idx].
    ].
    ((language askFor: #isJava) or:[language askFor: #isGroovy]) ifTrue:[
        ^ (stringToComplete at: stringToComplete size - 1) isSeparator
            ifTrue:[stringToComplete size- 2]
            ifFalse:[stringToComplete size]
    ].

    ^ stringToComplete size + 1.

    "Created: / 03-10-2013 / 16:50:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-10-2013 / 12:30:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hint
    classes size == 1 ifTrue:[ 
        ^ classes anElement nameWithoutNameSpacePrefix.
    ].
    classes size < 3 ifTrue:[ 
        ^ (classes collect:[:each | each nameWithoutPrefix ]) asArray asStringWith:' , '.
    ].
    ^ '%1 implementors' bindWith: classes size.

    "Created: / 20-05-2014 / 12:27:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-01-2015 / 19:15:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label

    label isNil ifTrue:[
        | someClass |

        someClass := classes anElement.
        label := selector.
        someClass programmingLanguage isSmalltalk ifFalse:[
            label := (someClass compiledMethodAt: selector) printStringForBrowserWithSelector: selector.
        ]
    ].
    ^ label

    "Created: / 07-04-2011 / 09:56:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-05-2014 / 10:28:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selector
    ^ selector
!

stringToCompleteForLanguage: language
    | someClass |

    someClass := classes anElement.
    someClass isJavaClass ifTrue:[
        | method |

        method := someClass compiledMethodAt: selector.
        language isSmalltalk  ifTrue:[          
            ^ selector upTo: $(
        ].
        ((language askFor: #isJava) or:[language askFor: #isGroovy]) ifTrue:[
            | selector |

            selector := (method selector upTo: $().
            selector = '<init>' ifTrue:[ 
                selector := someClass lastName.
            ].
            selector := selector , (method numArgs == 0 ifTrue:['()'] ifFalse:['(  )']).
            ^ selector
        ].
    ].
    ^selector isKeyword ifTrue:[
        String streamContents: [:s | selector keywords do:[:kw | s nextPutAll: kw; space; space ] ]
    ] ifFalse:[ 
        selector
    ].

    "Created: / 02-10-2013 / 02:33:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-03-2015 / 10:43:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MethodPO methodsFor:'accessing-private'!

subject
    "Return the real object for which the receiver
     is a presentor.
     
     For internal usage only."

    classes size ~~ 1 ifTrue:[ 
        ^ classes collect:[ :cls | cls compiledMethodAt: selector ]
    ].
    ^ classes anElement compiledMethodAt: selector

    "Created: / 20-06-2014 / 11:11:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-01-2015 / 16:20:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MethodPO methodsFor:'initialization'!

initializeWithClass: aClass selector: aSymbol
    ^ self initializeWithClasses: (Array with: aClass) selector: aSymbol

    "Created: / 20-05-2014 / 10:32:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeWithClasses: anArray"Of Classes" selector: aSymbol 
    selector := aSymbol.
    classes := anArray

    "Created: / 20-05-2014 / 10:32:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-05-2014 / 11:34:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MethodPO methodsFor:'testing'!

isSmallSenseMethodPO
    ^ true
! !

!MethodPO class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

