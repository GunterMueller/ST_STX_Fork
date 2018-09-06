"
 COPYRIGHT (c) 2010 by Jan Vrany, SWING Research Group. CTU in Prague
              All Rights Reserved

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the 'Software'), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Tools }"

HierarchicalItem subclass:#ProfilerInfoItem
	instanceVariableNames:'method isBlock tally'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Browsers-New-Profiler'
!

!ProfilerInfoItem class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2010 by Jan Vrany, SWING Research Group. CTU in Prague
              All Rights Reserved

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the 'Software'), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
"
! !

!ProfilerInfoItem methodsFor:'accessing'!

isBlock
    ^ isBlock ? false

    "Created: / 01-12-2007 / 20:38:11 / janfrog"
    "Modified: / 01-12-2007 / 23:54:48 / janfrog"
!

isBlock:aBoolean
    isBlock := aBoolean.

    "Created: / 01-12-2007 / 20:38:11 / janfrog"
!

label
    ^self tallyLabel, ' in ',
        self methodLabel, ' ',
            self packageLabel

    "Created: / 01-12-2007 / 20:46:01 / janfrog"
!

method
    ^ method

    "Created: / 01-12-2007 / 20:38:11 / janfrog"
!

method:aCompiledMethod
    method := aCompiledMethod.

    "Created: / 01-12-2007 / 20:38:11 / janfrog"
!

methodClass

    | mthd |
    mthd := self method.
    ^mthd notNil 
        ifTrue:[method mclass]
        ifFalse:[UndefinedObject]

    "Created: / 01-12-2007 / 20:49:57 / janfrog"
    "Modified: / 28-08-2010 / 21:02:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-08-2011 / 09:35:53 / cg"
!

methodLabel

    ^(self isBlock ifTrue:['[] in '] ifFalse:['']), 
        (self selector ? '???') , 
            (' [' , (self methodClass isNil ifTrue:['???'] ifFalse:[self methodClass  nameWithoutPrefix]) , ']') asText allBold

    "Created: / 01-12-2007 / 20:56:29 / janfrog"
    "Modified: / 01-12-2007 / 23:58:35 / janfrog"
    "Modified: / 18-10-2011 / 17:04:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

packageLabel
    |pkg|

    pkg := method isNil ifTrue:['???'] ifFalse:[method package].
    ^('[' , pkg , ']') asText allItalic

    "Created: / 01-12-2007 / 20:58:18 / janfrog"
!

selector

    | mthd |
    mthd := self method.
    ^mthd notNil 
        ifTrue:[method selector]
        ifFalse:['<no method>']

    "Created: / 01-12-2007 / 20:49:13 / janfrog"
    "Modified: / 28-08-2010 / 21:00:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 02-08-2011 / 09:35:32 / cg"
!

tally
    ^ tally ? 0

    "Created: / 01-12-2007 / 20:38:11 / janfrog"
    "Modified: / 01-12-2007 / 23:43:58 / janfrog"
!

tally:anInteger
    tally := anInteger.

    "Created: / 01-12-2007 / 20:38:11 / janfrog"
!

tallyAdd: anInteger

    tally := self tally + anInteger

    "Created: / 01-12-2007 / 22:53:55 / janfrog"
!

tallyLabel

    ^self tally printString , '% '

    "Created: / 01-12-2007 / 20:47:09 / janfrog"
! !

!ProfilerInfoItem methodsFor:'accessing - private'!

setChildren: collection

    children := collection.
    children do:[:e|e parent:e]

    "Created: / 01-12-2007 / 20:43:36 / janfrog"
! !

!ProfilerInfoItem methodsFor:'comparing'!

= anotherMethodInfo

    ^self class == anotherMethodInfo class
        and:[self method = anotherMethodInfo method
            and:[self isBlock = anotherMethodInfo isBlock]]

    "Created: / 01-12-2007 / 21:20:33 / janfrog"
!

hash

    ^self method hash bitXor: [self isBlock hash]

    "Created: / 01-12-2007 / 21:17:01 / janfrog"
! !

!ProfilerInfoItem class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libtool/Tools__ProfilerInfoItem.st,v 1.5 2012-11-04 21:40:34 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '§Id: Tools__ProfilerInfoItem.st 7486 2009-10-26 22:06:24Z vranyj1 §'
! !

