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

LogTransport subclass:#CustomBlockTransport
	instanceVariableNames:'block blockSource'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Loggia-Transports'
!

!CustomBlockTransport class methodsFor:'documentation'!

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

!CustomBlockTransport methodsFor:'accessing'!

block
    ^ block
!

block: aBlock

    block := aBlock
!

blockSource
    ^ blockSource
!

blockSource: aString

    blockSource := aString
!

configurationUI

    ^CustomBlockTransportUI on: self
! !

!CustomBlockTransport methodsFor:'processing'!

process: aLogMessage

    block ifNotNil: [
	mutex critical: [block valueWithOptionalArgument: aLogMessage]
    ]

    "Modified: / 23-06-2005 / 09:26:30 / masca"
! !

!CustomBlockTransport methodsFor:'testing'!

isCustomBlockTransport
    ^ true

    "Modified: / 20-05-2005 / 11:46:14 / masca"
!

isSetUp

    ^block notNil
! !

!CustomBlockTransport methodsFor:'utilities'!

compileString: aString

    | compiledBlock |
    compiledBlock := Compiler evaluate: aString "notifying: self".

    (compiledBlock isKindOf: Block)
	ifTrue: [
	    self block: compiledBlock.
	    self blockSource: aString]
!

defaultCode

    ^'[:aLogMessage | "any code" ]'
!

storeConfigurationOf: aString on: aStream

    super storeConfigurationOf: aString on: aStream.
    self to: aString send: 'compileString:' with: blockSource storeString on: aStream

    "Created: / 05-05-2005 / 16:49:47 / masca"
! !

!CustomBlockTransport class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__CustomBlockTransport.st,v 1.3 2014-07-01 10:21:10 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__CustomBlockTransport.st,v 1.3 2014-07-01 10:21:10 cg Exp $'
!

version_SVN
    ^ '§Id: Loggia__CustomBlockTransport.st 20 2011-09-01 15:04:29Z vranyj1 §'
! !
