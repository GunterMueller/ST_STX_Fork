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

RBParseTreeLintRule subclass:#RBEqualsTrueRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Parse-tree Rules'
!

!RBEqualsTrueRule class methodsFor:'documentation'!

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

!RBEqualsTrueRule methodsFor:'accessing'!

group
        ^ 'Unnecessary Code'
!

name
        ^ 'Possibly unnecessary "= true"'
!

rationale
        ^ 'A =, ==, ~=, or ~~ message is sent to true/false or with true/false as the argument. 
<BR>
Many times these can be eliminated since their receivers are already booleans. 
For example, <code><pre>    anObject isFoo == false</pre></code>
could be replaced with: 
<code><pre>    anObject isFoo not</pre></code>
if isFoo always returns a boolean. 
<P>
Sometimes variables might refer to true, false, and something else, 
but this is usually considered bad style
(but notice that some confirmation dialogs return true, false or nil on cancel).
<P>
Sometimes, variables are lazily initialized, treating nil as either true or false. 
This might be ok, but only if there is exactly one place, which defines the meaning of nil (i.e. in  a getter).
<P>
In seldom cases, a condition is written in this style to emphasize on the fact that a
boolean is returned, although the methods''s name implies something else.
Then, it may be a good idea to instead rename the message.
'

    "Modified: / 07-03-2012 / 21:37:43 / cg"
!

severity
        ^ SeverityInformation
! !

!RBEqualsTrueRule methodsFor:'initialization'!

initialize
    super initialize.
    self matcher 
        matchesAnyOf: #('true' 'false')
        do:[:node :answer |
            |rslt parent|
            
            rslt := answer.
            answer isNil ifTrue:[ "/ non yet found
                parent := node parent.
                (parent isMessage and: [ #(#= #== #~= #~~) includes: parent selector])
                ifTrue: [ 
                    rslt := node 
                ] ifFalse: [ 
                    rslt := nil 
                ] 
            ].
            rslt
        ].

    "/ manually add (#= #== #~= #~~)
    matcher searches do:[:eachSearch |
        eachSearch addQuickStringForOneOfMustBePresent:#(#= #== #~= #~~).
    ].    
! !

!RBEqualsTrueRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

