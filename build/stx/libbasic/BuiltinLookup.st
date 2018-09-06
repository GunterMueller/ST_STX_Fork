"
 COPYRIGHT (c) 2010 by Jan Vrany, SWING Research Group. CTU in Prague
 COPYRIGHT (c) 2010 Jan Vrany
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
"{ Package: 'stx:libbasic' }"

Lookup subclass:#BuiltinLookup
	instanceVariableNames:''
	classVariableNames:'Instance'
	poolDictionaries:''
	category:'Kernel-Extensions'
!

!BuiltinLookup class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2010 by Jan Vrany, SWING Research Group. CTU in Prague
 COPYRIGHT (c) 2010 Jan Vrany
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
    the standard smalltalk method lookup algorithm
"
! !

!BuiltinLookup class methodsFor:'instance creation'!

new

    ^self instance

    "Created: / 26-04-2010 / 19:25:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BuiltinLookup class methodsFor:'accessing'!

instance
    
    Instance isNil ifTrue: [Instance := self basicNew].
    ^ Instance

    "Created: / 26-04-2010 / 19:25:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-04-2010 / 21:32:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BuiltinLookup class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic/BuiltinLookup.st,v 1.3 2013-12-16 13:40:00 cg Exp $'
!

version_SVN
    ^ '$Id: BuiltinLookup.st,v 1.3 2013-12-16 13:40:00 cg Exp $'
! !

