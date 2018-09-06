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

MessageTally subclass:#Profiler
	instanceVariableNames:'startTimestamp notes retVal'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Browsers-New-Profiler'
!

!Profiler class methodsFor:'documentation'!

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
!

documentation
"
    a visual profiler;
    provides the same interface as a MessageTally, but does not show the
    sample data on a stream, instead a browser is opened, allowing easy
    navigation through the sampled code.
"
!

examples
"
                                                                    [exBegin]
    | profiler |

    profiler := Tools::Profiler profileOn:[1 to: 1000 do:[:i|i factorial]] interval: 10.
    Tools::NewSystemBrowser browseProfilerStatistics: profiler
                                                                    [exEnd]

                                                                    [exBegin]
    Tools::Profiler spyOn:[1 to: 1000 do:[:i|i factorial]] interval: 10.
                                                                    [exEnd]

"
! !

!Profiler class methodsFor:'instance creation'!

readStatisticsFrom: stream

    ^BinaryInputManager readFrom: stream

    "Created: / 24-11-2007 / 09:24:12 / janfrog"
! !

!Profiler class methodsFor:'messageTally compatible interface'!

spyDetailedOn: aBlock
    "execute a Block; then open a visual profiler.
     Return the value from aBlock"

    ^ self spyOn:aBlock interval:(self detailedSamplingIntervalMS)
!

spyOn: aBlock
    "execute a Block; then open a visual profiler.
     Return the value from aBlock"

    ^ self spyOn:aBlock interval:(self normalSamplingIntervalMS)
!

spyOn: aBlock interval: interval
    "execute a Block; then open a visual profiler.
     Return the value from aBlock"

    | profiler |

    profiler := self new.
    profiler profileOn:aBlock interval: interval.
    Tools::NewSystemBrowser browseProfilerStatistics: profiler.
    ^ profiler retVal
! !

!Profiler class methodsFor:'profiling'!

profile: aBlock
    "run aBlock, return profile information"

    ^self profileOn: aBlock

    "Created: / 18-02-2008 / 20:24:08 / janfrog"
!

profileAndOpenBrowser: aBlock
    "run aBlock, open a browser on the profile information; sample tick is 10ms"

    Tools::NewSystemBrowser browseProfilerStatistics: (self profile: aBlock)

    "
        Tools::Profiler profileAndOpenBrowser:[ 10000 timesRepeat:[100 factorial] ] 
    "

    "Created: / 18-02-2008 / 20:24:56 / janfrog"
    "Modified: / 18-02-2008 / 22:16:29 / janfrog"
!

profileDetailedOn: aBlock
    "run aBlock, return profile information; sample tick is 1ms"

    ^self profileOn: aBlock interval:(self detailedSamplingIntervalMS)

    "Created: / 24-11-2007 / 08:31:22 / janfrog"
    "Modified: / 25-12-2008 / 20:39:33 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

profileOn: aBlock
    "run aBlock, return profile information; sample tick is 10ms"

    ^self profileOn: aBlock interval:(self normalSamplingIntervalMS)

    "Created: / 24-11-2007 / 08:31:22 / janfrog"
    "Modified: / 25-12-2008 / 20:39:33 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

profileOn: aBlock interval: interval
    "run aBlock, return profile information; sample tick is interval (ms)"

    ^self new profileOn: aBlock interval: interval

    "Created: / 24-11-2007 / 08:25:37 / janfrog"
! !

!Profiler methodsFor:'I/O'!

storeStatisticsOn: stream

    ^BinaryOutputManager store: self on: stream

    "Created: / 24-11-2007 / 09:23:11 / janfrog"
! !

!Profiler methodsFor:'accessing'!

computationTime
    ^ endTime - startTime

    "Created: / 24-11-2007 / 08:41:33 / janfrog"
!

notes
    ^ notes

    "Created: / 24-11-2007 / 09:24:50 / janfrog"
!

notes:something
    notes := something.

    "Created: / 24-11-2007 / 09:24:50 / janfrog"
!

retVal
    ^ retVal
!

startTimestamp
    ^ startTimestamp

    "Created: / 24-11-2007 / 09:01:12 / janfrog"
! !

!Profiler methodsFor:'profiling'!

profileOn: aBlock interval: interval
    startTimestamp := Timestamp now.
    retVal := super spyOn: aBlock interval: interval.
    self nTally isZero ifFalse:[self tree computePercentage: self nTally].
    ^ self

    "Created: / 24-11-2007 / 08:21:28 / janfrog"
! !

!Profiler class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libtool/Tools__Profiler.st,v 1.5 2012-11-04 21:42:25 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libtool/Tools__Profiler.st,v 1.5 2012-11-04 21:42:25 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '§Id: Tools__Profiler.st 7486 2009-10-26 22:06:24Z vranyj1 §'
! !

