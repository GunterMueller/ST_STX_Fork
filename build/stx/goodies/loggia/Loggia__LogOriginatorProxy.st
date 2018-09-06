"
 COPYRIGHT (c) 2005-2011 by Jan Vrany & Martin Dvorak

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
"{ Package: 'stx:goodies/loggia' }"

"{ NameSpace: Loggia }"

Object subclass:#LogOriginatorProxy
	instanceVariableNames:'name facility print'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Loggia'
!

!LogOriginatorProxy class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2005-2011 by Jan Vrany & Martin Dvorak

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

!LogOriginatorProxy class methodsFor:'instance creation'!

for: originatorObject

    ^originatorObject class == self
	ifTrue: [originatorObject]
	ifFalse: [self new forOriginator: originatorObject]
! !

!LogOriginatorProxy methodsFor:'accessing'!

logFacility

    ^facility
!

nameForLog

    ^name

    "Modified: / 10-05-2005 / 16:25:47 / masca"
! !

!LogOriginatorProxy methodsFor:'initialization'!

forOriginator: originatorObject

    self
	name: (originatorObject perform: #nameForLog ifNotUnderstood: [originatorObject class name])
	printString: originatorObject printString
	facility: (originatorObject perform: #logFacility ifNotUnderstood: [Logger systemFacilityName])
!

name: originatorNameForLog printString: originatorPrintString facility: facilitySymbol

    name := originatorNameForLog.
    print := originatorPrintString.
    facility := facilitySymbol
! !

!LogOriginatorProxy methodsFor:'printing'!

printOn: aStream

    (name isNil or: [print isNil])
	ifTrue: [aStream nextPutAll: '[invalid log originator proxy]']
	ifFalse: [aStream
	    nextPutAll: '[unavailable:';
	    nextPutAll: name;
	    nextPutAll: '] ';
	    nextPutAll: print]
! !

!LogOriginatorProxy class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__LogOriginatorProxy.st,v 1.4 2014-09-23 10:59:32 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__LogOriginatorProxy.st,v 1.4 2014-09-23 10:59:32 vrany Exp $'
!

version_SVN
    ^ '$Id: Loggia__LogOriginatorProxy.st,v 1.4 2014-09-23 10:59:32 vrany Exp $'
! !

