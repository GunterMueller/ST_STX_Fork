"
 Copyright (C) 2016 Claus Gittinger

 Permission is hereby granted, free of charge, to any 
 person obtaining a copy of this software and associated 
 documentation files (the 'Software'), to deal in the 
 Software without restriction, including without limitation 
 the rights to use, copy, modify, merge, publish, distribute, 
 sublicense, and/or sell copies of the Software, and to 
 permit persons to whom the Software is furnished to do so, 
 subject to the following conditions:

 The above copyright notice and this permission notice shall 
 be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, 
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:goodies/refactoryBrowser/lint' }"

"{ NameSpace: Smalltalk }"

RBParseTreeLintRule subclass:#RBDoubleTranslationsRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Smalltalk/X'
!

!RBDoubleTranslationsRule class methodsFor:'documentation'!

copyright
"
 Copyright (C) 2016 Claus Gittinger

 Permission is hereby granted, free of charge, to any 
 person obtaining a copy of this software and associated 
 documentation files (the 'Software'), to deal in the 
 Software without restriction, including without limitation 
 the rights to use, copy, modify, merge, publish, distribute, 
 sublicense, and/or sell copies of the Software, and to 
 permit persons to whom the Software is furnished to do so, 
 subject to the following conditions:

 The above copyright notice and this permission notice shall 
 be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, 
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"
! !

!RBDoubleTranslationsRule methodsFor:'accessing'!

group
    ^ 'Possible Bugs - Smalltalk/X'
!

name
        ^ 'Duplicate translations in dialogs'
!

rationale
        ^ 'Searches for strings which are translated again via the resource translation mechanism.
<BR>
This happens if a utility method is called with a translated string,
and the utility method itself translates it again.
<BR>
Common situations are:
<code><pre>    self information:(resources string:''Some Message'')</pre></code>
or:
<code><pre>    self warn:(resources string:''Some Message'')</pre></code>
where the "information:"/"warn:" method again translates the incoming message.
<BR>
This is normally not a problem except for a tiny little bit of runtime overhead, and added code size.
<P>
For now, this rule only checks subclasses of ApplicationModel, 
knowing that those methods do the translation.
'.
! !

!RBDoubleTranslationsRule methodsFor:'initialization'!

initialize
        super initialize.
        self matcher
            matchesAnyOf: #(
                    'self information:(resources string: `@stuff)'
                    'self warn:(resources string: `@stuff)'
            )
            do: [ :node :oldAnswer :owner |
                |myAnswer rcvr selector stringExpr|

                (myAnswer := oldAnswer) isNil ifTrue:[
                    |class implClass|

                    rcvr := node receiver.
                    selector := node selector.
                    stringExpr := node arg1.
                    "/ check where the information: message is implemented.
                    (owner currentSearchContext notNil
                    and:[(class := owner currentSearchContext selectedClass) notNil
                    and:[(class := class isBehavior ifTrue:[class] ifFalse:[class realClass]) notNil]]) ifTrue:[
                        implClass := class whichClassIncludesSelector:selector.
                        "/ hard coding the knowledge that AppModel does xlation.
                        "/ probably too much work to figure it out myself, if the implMethod
                        "/ does it.
                        implClass == ApplicationModel ifTrue:[
                            myAnswer := node
                        ].    
                    ].    
"/                        (selector = #'information:') ifTrue:[
"/                            nil
"/                        ] ifFalse:[
"/                            ((selector copyFrom: 1 to: (selector size min: 2)) ~= 'as' 
"/                                and: [
"/                                    | receiver |
"/                                    receiver := rcvr receiver.
"/                                    receiver isVariable not 
"/                                            or: [ ((#('self' 'super') includes: receiver name) 
"/                                            or: [ Smalltalk includesKey: receiver name asSymbol ]) not ] ]) 
"/                                    ifTrue: [ node ]
"/                                    ifFalse: [ nil ] 
"/                        ]
                ].
                myAnswer
            ]

    "Modified: / 01-03-2012 / 17:03:00 / cg"
! !

!RBDoubleTranslationsRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

