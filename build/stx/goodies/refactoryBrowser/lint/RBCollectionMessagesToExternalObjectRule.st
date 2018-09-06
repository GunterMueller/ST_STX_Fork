"
 Copyright (C) Original SmallLint Authors
 Copyright (C) The Squeak Team
 Copyright (C) The Pharo Team
 Copyright (C) 2011-2013 Jan Vrany (porting, Smalltalk/X rules & tweaks)
 Copyright (C) 2011-2013 Claus Gittinger (porting, Smalltalk/X rules & tweaks)

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

RBParseTreeLintRule subclass:#RBCollectionMessagesToExternalObjectRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Parse-tree Rules'
!

!RBCollectionMessagesToExternalObjectRule class methodsFor:'documentation'!

copyright
"
 Copyright (C) Original SmallLint Authors
 Copyright (C) The Squeak Team
 Copyright (C) The Pharo Team
 Copyright (C) 2011-2013 Jan Vrany (porting, Smalltalk/X rules & tweaks)
 Copyright (C) 2011-2013 Claus Gittinger (porting, Smalltalk/X rules & tweaks)

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

!RBCollectionMessagesToExternalObjectRule methodsFor:'accessing'!

group
        ^ 'Intention Revealing'
!

name
        ^ 'Sends "add:/remove:" to external (not-owned) collection'

    "Modified: / 01-03-2012 / 15:04:42 / cg"
!

rationale
        ^ 'Checks for methods that appear to be modifying a collection that is owned by another object. 
Such modifications can cause problems, especially if other variables are to be updated,
when the collection is modified. 
<P>
For example, UI components must set the container of all their parts which is done in the add: method of the
container, but not if you add to the collection directly. 
Thus simply adding a part to the returned component list may not suffice.
<P>
This check sometimes generates false positives, so please verify if there is an add:-like method available,
and if your code actually does direct access an underlying collection.'

    "Modified: / 01-03-2012 / 20:38:56 / cg"
! !

!RBCollectionMessagesToExternalObjectRule methodsFor:'initialization'!

initialize
        | queries |
        super initialize.
        queries := #( add: addLast: addFirst: remove: addAll: removeAll: )
                collect: [ :each | '(`@Object `@message: `@args) %1 `@Arg' bindWith: each ].
        self matcher 
            matchesAnyOf: queries
            do: [ :node :answer |
                |rcvr selector|
                
                answer isNil 
                    ifTrue: 
                        [
                            |ok|
                            
                            ok := false.
                            
                            rcvr := node receiver.
                            selector := rcvr selector.
                            
                            "/ additional exceptions:
                            (selector = #'at:') ifTrue:[
                                (rcvr receiver isSelf 
                                or:[rcvr receiver isVariable
                                    and:[rcvr receiver isLocal not]]
                                ) ifTrue:[
                                    (matcher currentSearchContext selectedClass instanceVariableNames
                                        includes:rcvr receiver name
                                    ) ifTrue:[
                                        ok := true
                                    ].    
                                ].
                            ].
                            ok ifFalse:[
                                (selector = #'at:ifAbsentPut:') ifTrue:[
                                    ok := true
                                ] ifFalse:[
                                    ((selector copyFrom: 1 to: (selector size min: 2)) ~= 'as' 
                                        and: [
                                            | receiver |
                                            receiver := rcvr receiver.
                                            (receiver isVariable not 
                                                or: [ ((#('self' 'super') includes: receiver name) 
                                                or: [ Smalltalk includesKey: receiver name asSymbol ]) not ]) 
                                    ]) ifFalse: [ ok := true ] 
                                ]
                            ].    
                            ok ifTrue: [ nil ]
                               ifFalse: [ node ] 
                        ]
                    ifFalse: [ answer ] ]
! !

!RBCollectionMessagesToExternalObjectRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

