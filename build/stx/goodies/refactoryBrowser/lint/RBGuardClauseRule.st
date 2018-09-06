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

RBTransformationRule subclass:#RBGuardClauseRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Transformation Rules'
!

!RBGuardClauseRule class methodsFor:'documentation'!

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

!RBGuardClauseRule methodsFor:'accessing'!

group
	^ 'Transformations'
!

name
	^ 'Eliminate guarding clauses'
!

rationale
        ^ 'A guarding clause is often less readable then an early return;
especially if multiple such clauses are nested, it may be better to "strip off" 
cases by returning early. I.e. by changing:
<CODE><PRE>
   guard ifTrue:[
      ...
   ].
</PRE></CODE>
into:
<CODE><PRE>
   guard ifFalse:[^ self].
   ...
</PRE></CODE>
'
!

severity
        ^ SeverityInformation
! !

!RBGuardClauseRule methodsFor:'initialization'!

initialize
        |assignmentMatcher notSimpleAssignments|

        assignmentMatcher := ParseTreeSearcher new.
        assignmentMatcher matches:' `@object := ``@rcv' do:[:aNode :answer | true].

        "/ cg:
        "/ sometimes, you'll have code like
        "/   cond ifTrue:[
        "/      var := expr.
        "/      var2 := expr2.
        "/   ].
        "/
        "/ I don't think, that those should be rewritten; therefore, do not complain,
        "/ if the expressions are simple assignments.
        "/ (the check should probably include a treshold on the expression's complexity, though)
        "/ so some heuristic is asked for here...
        "/ To get the original behavior, simply change the notSimpleAssignments block below to [:node | true].

        notSimpleAssignments :=
            [:node |
                |matchedS1 matchedS2 matchedStatements context notSimple|

                notSimple := false.
                context := rewriteRule context.
                matchedS1 := context at:(RBPatternVariableNode named:'`.Statement1') ifAbsent:nil.
                matchedS1 notNil ifTrue:[
                    matchedS2 := context at:(RBPatternVariableNode named:'`.Statement2') ifAbsent:nil.
                    matchedS2 notNil ifTrue:[
                        matchedStatements := context at:(RBPatternVariableNode named:'`@.Statements1') ifAbsent:nil.
                        matchedStatements notNil ifTrue:[
                            notSimple := (assignmentMatcher executeTree:matchedS1)
                                            and:[ (assignmentMatcher executeTree:matchedS2)
                                            and:[ matchedStatements conform:[:each | (assignmentMatcher executeTree:each)]]].
                        ]
                    ]
                ].
                notSimple
            ].

        super initialize.
        self rewriteRule
                replaceMethod: '`@methodName: `@args 
                                        | `@temps | 
                                        `@.Statements. 
                                        `@condition ifTrue: [
                                            | `@trueTemps | 
                                            `.Statement1.        "/ at least 2 statements
                                            `.Statement2. 
                                            `@.Statements1
                                        ]'
                with: '`@methodName: `@args
                                        | `@temps `@trueTemps |
                                        `@.Statements.
                                        `@condition ifFalse: [^self].
                                        `.Statement1.
                                        `.Statement2.
                                        `@.Statements1'
                when:notSimpleAssignments;

                replaceMethod: '`@methodName: `@args 
                                        | `@temps | 
                                        `@.Statements. 
                                        `@condition ifFalse: [
                                            | `@falseTemps | 
                                            `.Statement1.           "/ at least 2 statements
                                            `.Statement2. 
                                            `@.Statements1
                                        ]'
                with: '`@methodName: `@args
                                        | `@temps `@falseTemps |
                                        `@.Statements.
                                        `@condition ifTrue: [^self].
                                        `.Statement1.
                                        `.Statement2.
                                        `@.Statements1'
                when:notSimpleAssignments
! !

!RBGuardClauseRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

