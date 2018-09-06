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

Regex::RxMatcher subclass:#TokenPatternMatcher
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Utils-Matcher'
!

!TokenPatternMatcher class methodsFor:'documentation'!

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
!

documentation
"
    A custom regex-like matcher to match token streams.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!TokenPatternMatcher methodsFor:'accessing'!

subexpression: subIndex
    "returns the matches for a parenthized subexpression.
     notice that non-matching subexpressions deliver an empty matchString;
     also be careful with nested parnethesis.
     With index==1, you get the whole matchString"

    | originalPosition start end reply |

    originalPosition := self position.
    start := self subBeginning: subIndex.
    end := self subEnd: subIndex.
    (start isNil or: [end isNil]) ifTrue: [^''].
    reply := (Array new: end first - start first) writeStream.
    self position: start.
    start first to: end first - 1 do: [:ignored | reply nextPut: stream next].
    self position: originalPosition.
    ^reply contents

    "
     |matcher|

     matcher := Regex::RxMatcher new 
                    initializeFromString:'(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[ ]+(:isDigit::isDigit:?)[ ]*,[ ]*19(:isDigit::isDigit:)'
                    ignoreCase:false.
     (matcher matches:'Aug 6, 1996') ifTrue:[
        matcher subexpression:2
     ] ifFalse:[
        self error.
     ].                       
    "

    "Created: / 06-05-2014 / 15:46:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-06-2014 / 17:33:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TokenPatternMatcher methodsFor:'double dispatch'!

syntaxToken: tokenNode
    | type value |

    type := tokenNode type.
    value := tokenNode value.

    ^ Regex::RxmPredicate new predicate:
        [:token |
            (token isSymbol or:[token isCharacter]) ifTrue:[ 
                (type == token) and:[ value isNil or:[value == token ] ]
            ] ifFalse:[ 
                (type == token type) and:[ value isNil or:[value = token value]  ]
            ].
        ].

    "Created: / 06-05-2014 / 14:38:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-05-2014 / 15:59:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

syntaxTokenSet: tokenSetNode
    | tokens|

    tokens := tokenSetNode tokens.

    ^ Regex::RxmPredicate new predicate:
        [:token |
            | matches |
            matches := tokens anySatisfy:[:tokenNode |
                | type value |

                type := tokenNode type.
                value := tokenNode value.
                (token isSymbol or:[token isCharacter]) ifTrue:[ 
                    (type = token) and:[ value isNil or:[value == token ] ]
                ] ifFalse:[ 
                    (type = token type) and:[ value isNil or:[value = token value]  ]
                ].
            ].
            tokenSetNode negated ifTrue:[ 
                matches := matches not.
            ].
            matches.
        ].

    "Created: / 09-05-2014 / 16:22:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TokenPatternMatcher methodsFor:'initialize-release'!

initialize: syntaxTreeRoot ignoreCase: aBoolean
        "Compile myself for the regex with the specified syntax tree.
        See comment and `building' protocol in this class and 
        #dispatchTo: methods in syntax tree components for details 
        on double-dispatch building. 
        The argument is supposedly a RxsRegex."

        ignoreCase := aBoolean.
        self buildFrom: syntaxTreeRoot.
"/        startOptimizer := RxMatchOptimizer new initialize: syntaxTreeRoot ignoreCase: aBoolean

    "Created: / 06-05-2014 / 14:39:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TokenPatternMatcher methodsFor:'streaming'!

position
    ^ Array with: stream position with: stream sourceStream position

    "Created: / 13-06-2014 / 16:52:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

position: positionsPair 
    [
        stream position:positionsPair first.
    ] on: Stream positionErrorSignal do:[
        "/ No that much tokens in backlog, reset backlog
        "/ and set source stream's position
        stream position: positionsPair first sourcePosition: positionsPair second.
    ]

    "Created: / 13-06-2014 / 16:53:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

