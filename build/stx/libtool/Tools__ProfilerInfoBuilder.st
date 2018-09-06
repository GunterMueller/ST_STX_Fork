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

Object subclass:#ProfilerInfoBuilder
	instanceVariableNames:'packages percentageCutOff'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Browsers-New-Profiler'
!

ProfilerInfoBuilder subclass:#MethodList
	instanceVariableNames:'methodsToInfoItems'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ProfilerInfoBuilder
!

!ProfilerInfoBuilder class methodsFor:'documentation'!

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

!ProfilerInfoBuilder class methodsFor:'instance creation'!

new
    ^ self basicNew initialize.

    "Created: / 01-12-2007 / 22:46:19 / janfrog"
! !

!ProfilerInfoBuilder methodsFor:'accessing'!

items

    ^self subclassResponsibility

    "Created: / 01-12-2007 / 23:40:07 / janfrog"
!

packages
    ^ packages

    "Created: / 01-12-2007 / 22:45:27 / janfrog"
!

packages:something
    packages := something.

    "Created: / 01-12-2007 / 22:45:27 / janfrog"
!

percentageCutOff
    ^ percentageCutOff ? 0

    "Created: / 01-12-2007 / 22:45:27 / janfrog"
!

percentageCutOff:something
    percentageCutOff := something.

    "Created: / 01-12-2007 / 22:45:27 / janfrog"
! !

!ProfilerInfoBuilder methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    "/ please change as required (and remove this comment)
    "/ packages := nil.
    "/ percentageCutOff := nil.

    "/ super initialize.   -- commented since inherited method does nothing

    "Created: / 01-12-2007 / 22:46:19 / janfrog"
! !

!ProfilerInfoBuilder methodsFor:'testing'!

isFiltered: profileTree

    profileTree totalTally < self percentageCutOff ifTrue:[^true].
    packages ifNil:[^false].
    ^(packages includes: profileTree package) not

    "Created: / 01-12-2007 / 22:56:49 / janfrog"
! !

!ProfilerInfoBuilder::MethodList class methodsFor:'documentation'!

version
    ^'$Id: Tools__ProfilerInfoBuilder.st 7854 2012-01-30 17:49:41Z vranyj1 $'
! !

!ProfilerInfoBuilder::MethodList methodsFor:'accessing'!

items

    ^methodsToInfoItems values asSortedCollection:
        [:a :b|a tally > b tally]

    "Created: / 01-12-2007 / 23:40:34 / janfrog"
! !

!ProfilerInfoBuilder::MethodList methodsFor:'building'!

build: profileTree

    (self isFiltered: profileTree) ifFalse:
        [(self itemForMethod: profileTree method) tallyAdd: profileTree leafTally].
    profileTree called ifNotNil:
        [profileTree called do:[:e|self build:e]]

    "Created: / 01-12-2007 / 22:49:55 / janfrog"
! !

!ProfilerInfoBuilder::MethodList methodsFor:'initialization'!

initialize

    super initialize.
    methodsToInfoItems := Dictionary new

    "Modified: / 01-12-2007 / 22:48:43 / janfrog"
! !

!ProfilerInfoBuilder::MethodList methodsFor:'private'!

itemForMethod: method

    ^methodsToInfoItems 
        at: method 
        ifAbsentPut:[ProfilerInfoItem new method: method]

    "Created: / 01-12-2007 / 22:52:35 / janfrog"
! !

!ProfilerInfoBuilder class methodsFor:'documentation'!

version_CVS
    ^ '§Header: /cvs/stx/stx/libtool/Tools__ProfilerInfoBuilder.st,v 1.2 2011/07/03 17:46:45 cg Exp §'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: Tools__ProfilerInfoBuilder.st 7854 2012-01-30 17:49:41Z vranyj1 $'
! !

