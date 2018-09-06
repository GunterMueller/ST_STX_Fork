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

RBTransformationRule subclass:#RBAllAnyNoneSatisfyRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Transformation Rules'
!

!RBAllAnyNoneSatisfyRule class methodsFor:'documentation'!

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

!RBAllAnyNoneSatisfyRule methodsFor:'accessing'!

group
	^ 'Transformations'
!

name
        ^ 'Replace do-loops with #allSatisfy:, #anySatisfy: or #noneSatisfy:'

    "Modified: / 19-11-2016 / 11:53:34 / cg"
!

rationale
        ^ 'Can replace programmed do-loops with equivalent calls to 
<CODE>#allSatisfy:</CODE>, <CODE>#anySatisfy:</CODE> or <CODE>#noneSatisfy:</CODE>'

    "Modified: / 19-11-2016 / 11:53:18 / cg"
!

severity
        ^ SeverityInformation
! !

!RBAllAnyNoneSatisfyRule methodsFor:'initialization'!

initialize
        super initialize.
        self rewriteRule
                " allSatisfy: "
                replaceMethod: '`@method: `@args
                        | `@temps |
                        `@.statements.
                        `@collection do: [ :`each |
                            | `@blocktemps |
                            `@.blockstatements.
                            `@condition ifFalse: [ ^ false ] 
                        ].
                        ^ true'
                with: '`@method: `@args
                        | `@temps |
                        `@.statements. 
                        ^ `@collection allSatisfy: [ :`each |
                            | `@blocktemps |
                            `@.blockstatements.
                            `@condition 
                        ]';

                " anySatisfy: "
                replaceMethod: '`@method: `@args
                        | `@temps |
                        `@.statements.
                        `@collection do: [ :`each |
                            | `@blocktemps |
                            `@.blockstatements.
                            `@condition ifTrue: [ ^ true ] 
                        ].
                        ^ false'
                with: '`@method: `@args
                        | `@temps |
                        `@.statements.
                        ^ `@collection anySatisfy: [ :`each | 
                            | `@blocktemps |
                            `@.blockstatements.
                            `@condition 
                        ]';

                " noneSatisfy: "
                replaceMethod: '`@method: `@args
                        | `@temps |
                        `@.statements.
                        `@collection do: [ :`each |
                            | `@blocktemps |
                            `@.blockstatements.
                            `@condition ifTrue: [ ^ false ] 
                        ].
                        ^ true'
                with: '`@method: `@args
                        | `@temps |
                        `@.statements.
                        ^ `@collection noneSatisfy: [ :`each | 
                            | `@blocktemps |
                            `@.blockstatements.                             
                            `@condition 
                        ]'

    "Modified (format): / 19-11-2016 / 11:51:17 / cg"
! !

!RBAllAnyNoneSatisfyRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

