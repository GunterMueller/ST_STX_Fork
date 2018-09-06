"
 Copyright (C) 2015 Claus Gittinger

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

RBBlockLintRule subclass:#RBCodeDuplicationRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Block Rules'
!

!RBCodeDuplicationRule class methodsFor:'documentation'!

copyright
"
 Copyright (C) 2015 Claus Gittinger

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

!RBCodeDuplicationRule class methodsFor:'running'!

hasMethod:method1 sameSemanticAs:method2
    "used to check if a change in a changeList is a real change (not jsut formatting).
     Ignores the selector in the check, so it can also be used to compare
     two totally different methods (i.e. if sth. is already implemented elsewhere)"

    |tree1 tree2 variableMapping ret|

    tree1 := RBParser
                    parseMethod:method1 source ? ''
                    onError: [:aString :position | ^ false "ignore any error"].
    tree1 isNil ifTrue:[^ false].

    tree2 := RBParser
                    parseMethod:method2 source ? ''
                    onError: [:aString :position | ^ false "ignore any error"].
    tree2 isNil ifTrue:[^ false].

    variableMapping := Dictionary new.
    ret := tree1 semanticallyEqualTo: tree2 withMapping:variableMapping ignoringSelector:true.
    ret ifTrue:[
        variableMapping notEmpty ifTrue:[
            |args1 args2 locals1 locals2|

            "/ for nw, only allow argument renames...
            args1 := tree1 allArgumentVariables.
            args2 := tree2 allArgumentVariables.
            variableMapping keysAndValuesDo:[:name1 :name2 |
                name1 ~= name2 ifTrue:[
                    ((args1 includes:name1) and:[(args2 includes:name2)
                    and:[ (args1 indexOf:name1) = (args2 indexOf:name2) ]]) ifTrue:[
                        "/ same
                    ] ifFalse:[
                        ^ false
                    ].    
                ].    
            ].
        ].    
    ].    
    ^ ret

    "
     |m1 m2|

     m1 := RBMethod for:(RBClass named:'foo') source:'retFoo ^ foo' selector: #retFoo.
     m2 := RBMethod for:(RBClass named:'foo') source:'retFoo ^ bar' selector: #retFoo.
     self hasMethod:m1 sameSemanticAs:m2
    "
    "
     |m1 m2|

     m1 := RBMethod for:(RBClass named:'foo') source:'retFoo:foo ^ foo' selector: #retFoo.
     m2 := RBMethod for:(RBClass named:'foo') source:'retFoo:bar ^ bar' selector: #retFoo.
     self hasMethod:m1 sameSemanticAs:m2
    "
    "
     |m1 m2|

     m1 := RBMethod for:(RBClass named:'foo') source:'retFoo:foo ^ inst1' selector: #retFoo.
     m2 := RBMethod for:(RBClass named:'foo') source:'retFoo:bar ^ inst2' selector: #retFoo.
     self hasMethod:m1 sameSemanticAs:m2
    "
    "
     |m1 m2|

     m1 := RBMethod for:(RBClass named:'foo') source:'retFoo:foo ^ inst1' selector: #retFoo.
     m2 := RBMethod for:(RBClass named:'foo') source:'retFoo:foo ^ inst2' selector: #retFoo.
     self hasMethod:m1 sameSemanticAs:m2
    "
    "
     |m1 m2|

     m1 := RBMethod for:(RBClass named:'foo') source:'retFoo:a _:b ^ a' selector: #retFoo.
     m2 := RBMethod for:(RBClass named:'foo') source:'retFoo:a _:c ^ a' selector: #retFoo.
     self hasMethod:m1 sameSemanticAs:m2
    "
    "
     |m1 m2|

     m1 := RBMethod for:(RBClass named:'foo') source:'retFoo:a _:b ^ a' selector: #retFoo.
     m2 := RBMethod for:(RBClass named:'foo') source:'retFoo:b _:a ^ a' selector: #retFoo.
     self hasMethod:m1 sameSemanticAs:m2
    "
    "
     |m1 m2|

     m1 := RBMethod for:(RBClass named:'foo') source:'retFoo:a _:b ^ a' selector: #retFoo.
     m2 := RBMethod for:(RBClass named:'foo') source:'retFoo:b _:a ^ b' selector: #retFoo.
     self hasMethod:m1 sameSemanticAs:m2
    "
    "
     |m1 m2|

     m1 := RBMethod for:(RBClass named:'foo') source:'retFoo ^ foo' selector: #retFoo.
     m2 := RBMethod for:(RBClass named:'foo') source:'retBar ^ foo' selector: #retBar.
     self hasMethod:m1 sameSemanticAs:m2
    "
    "
     |m1 m2|

     m1 := RBMethod for:(RBClass named:'foo') source:'retFoo ^ [:foo | foo + 1]' selector: #retFoo.
     m2 := RBMethod for:(RBClass named:'foo') source:'retFoo ^ [:bar | bar + 1]' selector: #retBar.
     self hasMethod:m1 sameSemanticAs:m2
    "

    "Created: / 04-02-2017 / 23:40:27 / cg"
    "Modified: / 05-02-2017 / 02:48:57 / cg"
!

isMethod:methodHere duplicateOfInherited:methodThere
    "used as a check, when accepting a method, for which an implementation
     might be already inherited from the superclass"

    |treeHere treeThere|

    treeHere := RBParser
                    parseMethod:methodHere source ? ''
                    onError: [:aString :position | ^ false "ignore any error"].
    treeHere isNil ifTrue:[^ false].

    treeThere := RBParser
                    parseMethod:methodThere source ? ''
                    onError: [:aString :position | ^ false "ignore any error"].
    treeThere isNil ifTrue:[^ false].

    ^ self 
        isParseTree:treeHere in:methodHere mclass 
        duplicateOfTree:treeThere in:methodThere mclass

    "Modified (comment): / 04-02-2017 / 23:22:33 / cg"
!

isParseTree:treeHere in:mClassHere duplicateOfTree:treeThere
    "obsolete"
    
    ^ self isParseTree:treeHere in:mClassHere duplicateOfTree:treeThere in:nil

    "Modified (comment): / 04-02-2017 / 23:45:53 / cg"
!

isParseTree:treeHere in:mClassHere duplicateOfTree:treeThere in:mClassThere
    "used as a check, when accepting a method, for which an implementation
     might be already inherited from the superclass.
     Needs the two classes to care for variable accesses 
     (a name might refer to something different in the other class)."

    |dictionary remainingRenames|

    dictionary := Dictionary new.
    (treeHere "body" semanticallyEqualTo: treeThere "body" withMapping: dictionary) ifTrue:[
        "/ must try again, but remove mappings to classVariables and classInstanceVariables ...
        mClassHere theNonMetaclass allClassVarNames do:[:each |
            dictionary removeKey:each ifAbsent:nil.
            dictionary removeValue:each ifAbsent:nil.
        ].

        mClassHere allInstVarNames do:[:each |
            "/            dictionary removeKey:each ifAbsent:nil.
            "/            dictionary removeValue:each ifAbsent:nil.
            dictionary at:each put:each
        ].
        mClassHere theNonMetaclass allClassVarNames do:[:each |
            dictionary at:each put:each
        ].

        (treeHere body semanticallyEqualTo: treeThere body withMapping: dictionary) ifTrue:[
            "/ super and here mean something different in a subclass; may not be present.
            (dictionary keys contains:[:key | (key = 'super') or:[key = 'here']]) ifFalse:[
                (dictionary values contains:[:value | value = 'super' or:[value = 'here']]) ifFalse:[
                    "/ look at the mapping dictionary ..
                    "/ remove equivalently mapped ones ..
                    dictionary keys
                        select:[:key | (dictionary at:key) = key]
                        thenDo:[:key | dictionary removeKey:key].

                    "/ now, no upper-case variables are allowed ...
                    (dictionary keys contains:[:key | key isUppercaseFirst]) ifFalse:[
                        "/ ignore (possibly renamed) arguments ...
                        dictionary keys
                            select:[:key | treeHere arguments contains:[:argVar | argVar name = key]]
                            thenDo:[:eachArgHere |
                                |argIndexHere argThere argIndexThere|

                                argIndexHere := treeHere arguments findFirst:[:argVar | argVar name = eachArgHere].
                                argThere := dictionary at:eachArgHere.
                                argIndexThere := treeThere arguments findFirst:[:argVar | argVar name = argThere].
                                argIndexHere == argIndexThere ifTrue:[
                                    dictionary removeKey:eachArgHere
                                ].
                            ].

                        remainingRenames := dictionary keys.
                        (remainingRenames contains:[:key | treeHere arguments contains:[:argVar | argVar name = key]])
                        ifFalse:[
                            (remainingRenames contains:[:key | treeThere arguments contains:[:argVar | argVar name = key]])
                            ifFalse:[
                                ^ true
                            ]
                        ]
                    ].
                ].
            ].
        ].
    ].
    ^ false

    "Modified: / 05-02-2017 / 00:52:25 / cg"
! !

!RBCodeDuplicationRule methodsFor:'accessing'!

group
        ^ 'Unnecessary Code'
!

name
        ^ 'Method duplicates code which is already inherited'
!

rationale
        ^ 'Check for methods which duplicate an already inherited method''s functioality.
These methods can be removed.'
!

severity
        ^ SeverityInformation
! !

!RBCodeDuplicationRule methodsFor:'running'!

checkMethod: aContext
    |cls selector superCls implClass methodHere methodThere|

    cls := aContext selectedClass.
    selector := aContext selector.

    cls isMeta ifTrue:[
        "/ these are meant to be empty and only contain different comments...
        ( #(
            documentation version examples
            copyright history
            initialize "/ because that is not invoked if only inherited
           ) includes:selector) 
        ifTrue:[
            ^ self
        ].
        "/ these implement subPackages etc., which I want to have as documentation
        cls isProjectDefinition ifTrue:[^ self].
    ].

    superCls := cls superclass.
    superCls isNil ifTrue:[^ self].

    implClass := superCls whichClassIncludesSelector:selector.
    implClass isNil ifTrue:[^ self].

    "/ ok, it is redefined
    methodHere := cls compiledMethodAt:selector.
    methodThere := implClass compiledMethodAt:selector.

    (self class isMethod:methodHere duplicateOfInherited:methodThere) ifTrue:[
        result 
            addClass: aContext selectedClass
            selector: aContext selector. 
        ^ self
    ].
! !

!RBCodeDuplicationRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

