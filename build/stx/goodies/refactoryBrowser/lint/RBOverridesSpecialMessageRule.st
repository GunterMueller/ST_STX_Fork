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

RBBlockLintRule subclass:#RBOverridesSpecialMessageRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Block Rules'
!

!RBOverridesSpecialMessageRule class methodsFor:'documentation'!

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

!RBOverridesSpecialMessageRule methodsFor:'accessing'!

group
	^ 'Bugs'
!

name
	^ 'Overrides a "special" message'
!

rationale
        ^ 'Checks that a class does not override a message that is essential to the base system. 
For example, if you override the "<code>class</code>" method from object, 
you are likely to crash your image, if you override "<code>displayString</code> in a class,
the browser/debugger cannot show its correct name.
<P>
You can see (and change) which selectors are considered "questionable" by editing the 
<A INFO="Click to browse this method"
   ACTION="doit: SystemBrowser default openInClass:%1 selector:#classShouldNotOverride">
<CODE>%1>>classShouldNotOverride</CODE>
</A> and
<A INFO="Click to browse this method"
   ACTION="doit: SystemBrowser default openInClass:%1 selector:#metaclassShouldNotOverride">
<CODE>%1>>metaclassShouldNotOverride</CODE>
</A> methods.'
        bindWith:self class name
!

severity
        ^ SeverityError
! !

!RBOverridesSpecialMessageRule methodsFor:'private'!

classShouldNotOverride
        ^ #( 
            #==             "/ identity must always exactly mean that
            #~~ 
            #class          "/ we shouldalways be able to get an object's class
            #basicAt:       "/ low level accessors
            #basicAt:put: 
            #basicSize 
            #identityHash   "/ req'd for IdentitySets and IdentityDictionaries
        )
!

metaclassShouldNotOverride
        ^ #( 
            #basicNew       "/ because then instance creation is broken;
            #basicNew:      "/ ditto
            #class          "/ actually inlined in jitter, 
            #comment        
            #name           "/ because browser and debugger may look bad then
            #displayString  "/ because browser and debugger may look bad then
        )
! !

!RBOverridesSpecialMessageRule methodsFor:'running'!

checkClass:aContext 
    |cls superCls selectors|

    cls := aContext selectedClass.
    superCls := cls superclass.
    selectors := cls isMeta 
                    ifTrue:[self metaclassShouldNotOverride] 
                    ifFalse:[self classShouldNotOverride].
    selectors do:[:each | 
        (superCls notNil 
         and:[(superCls canUnderstand:each) 
         and:[cls includesSelector:each]]) 
                ifTrue:[
                    self 
                        addClass:cls
                        selector:each
                        to:result
                ]
    ]
! !

!RBOverridesSpecialMessageRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

