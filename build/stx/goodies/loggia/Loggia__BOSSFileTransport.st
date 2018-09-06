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

FileTransport subclass:#BOSSFileTransport
	instanceVariableNames:'writer writerStream autoProxy dropAttachment'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Loggia-Transports'
!

BinaryOutputManager subclass:#BinaryFileWriter
	instanceVariableNames:'currentDepth maxDepth'
	classVariableNames:'CutOffToken UnrepresentableObjectToken'
	poolDictionaries:''
	privateIn:BOSSFileTransport
!

!BOSSFileTransport class methodsFor:'documentation'!

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

!BOSSFileTransport methodsFor:'accessing'!

autoProxy
    ^ autoProxy

    "Created: / 20-05-2005 / 11:13:47 / masca"
!

autoProxy: aBoolean

    autoProxy := aBoolean

    "Created: / 20-05-2005 / 11:13:47 / masca"
!

configurationUI

    ^BOSSFileTransportUI on: self

    "Created: / 20-05-2005 / 11:15:25 / masca"
!

dropAttachment
    ^ dropAttachment

    "Created: / 20-05-2005 / 11:13:47 / masca"
!

dropAttachment:aBoolean

    dropAttachment := aBoolean

    "Created: / 20-05-2005 / 11:13:47 / masca"
! !

!BOSSFileTransport methodsFor:'binary storage'!

readBinaryContentsFromData:representation manager:manager
    1 to: representation size do:[:i | 
        self instVarAt: i put: (representation at: i).
    ].

    "Created: / 29-10-2014 / 12:09:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

representBinaryOn: manager
    | representation |

    representation := Array new: self class instSize.
    1 to: representation size do:[:i | 
        representation at: i put: (self instVarAt: i).
    ].
    representation at: (self class instVarIndexFor: #writer) put: nil.  
    representation at: (self class instVarIndexFor: #writerStream) put: nil.

    ^ representation

    "Created: / 29-10-2014 / 12:06:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BOSSFileTransport methodsFor:'initialization'!

initialize

    super initialize.

    renewal := false.
    autoProxy := false.
    dropAttachment := false

    "Created: / 20-05-2005 / 11:18:18 / masca"
    "Modified: / 29-10-2014 / 12:22:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BOSSFileTransport methodsFor:'private'!

closeFile
    writerStream close.
    writerStream := writer := nil.

    "Created: / 25-12-2008 / 11:59:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 29-10-2014 / 10:32:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BOSSFileTransport methodsFor:'processing'!

process: aLogMessage

    autoProxy ifTrue: [aLogMessage dropOriginator].
    dropAttachment ifTrue: [aLogMessage dropAttachedObject].

    mutex critical: [
        writer isNil ifTrue:[
            writerStream := filename asFilename appendStream.
            writerStream binary.
            writer := BinaryFileWriter new.
        ].
        aLogMessage storeBinaryOn: writerStream manager: writer.
        writerStream flush.
    ]

    "Created: / 20-05-2005 / 11:15:59 / masca"
    "Modified: / 23-06-2005 / 09:25:35 / masca"
    "Modified: / 29-10-2014 / 10:59:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BOSSFileTransport methodsFor:'testing'!

isBOSSFileTransport

    ^true

    "Modified: / 20-05-2005 / 11:46:32 / masca"
!

isSetUp

    ^filename notEmptyOrNil

    "Created: / 20-05-2005 / 11:45:36 / masca"
! !

!BOSSFileTransport methodsFor:'utilities'!

storeConfigurationOf: aString on: aStream

    super storeConfigurationOf: aString on: aStream.

    filename ifNotNil: [
	self to: aString send: 'filename:' with: filename asString storeString on: aStream].
    self to: aString send: 'renewal:' with: renewal on: aStream.

    self to: aString send: 'autoProxy:' with: autoProxy on: aStream.
    self to: aString send: 'dropAttachment:' with: dropAttachment on: aStream

    "Created: / 20-05-2005 / 12:03:18 / masca"
! !

!BOSSFileTransport::BinaryFileWriter class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    "/ please change as required (and remove this comment)

    CutOffToken := #'*cutoff*'.
    UnrepresentableObjectToken := #'*unrepresentable*'

    "Modified: / 29-10-2014 / 12:39:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BOSSFileTransport::BinaryFileWriter class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!BOSSFileTransport::BinaryFileWriter methodsFor:'access-storing'!

putIdOf:anObject on:aStream
    | objectId |

    "/
    "/ we handle these common cases first ...
    "/
    anObject isNil ifTrue:[
        super putIdOf:anObject on:aStream.
        ^ self
    ].
    anObject == true ifTrue:[
        super putIdOf:anObject on:aStream.
        ^ self
    ].
    anObject == false ifTrue:[
        super putIdOf:anObject on:aStream.
        ^ self
    ].

    anObject class == SmallInteger ifTrue:[
        super putIdOf:anObject on:aStream.
        ^ self
    ].

    anObject isInteger ifTrue:[
        super putIdOf:anObject on:aStream.
        ^ self
    ].

    "/
    "/ other specially encoded stuff
    "/
    anObject hasSpecialBinaryRepresentation ifTrue: [
        ^ anObject storeBinaryOn:aStream manager:self
    ].

    objectId := objectToIdMapping findValueOrNil:anObject.
    objectId isNil ifTrue:[
        fixObjectToIdMapping notNil ifTrue:[
            objectId := fixObjectToIdMapping findValueOrNil:anObject.
        ]
    ].
    objectId notNil ifTrue: [
        super putIdOf:anObject on:aStream.
        ^ self.
    ].

    currentDepth < maxDepth ifTrue:[ 
        currentDepth := currentDepth + 1.
        "/ Special hack for some unrepresentable objects...
        anObject isBlock ifTrue:[ 
            super putIdOf: UnrepresentableObjectToken on: aStream 
        ] ifFalse:[ 
            super putIdOf:anObject on:aStream.
        ].
        currentDepth := currentDepth - 1.
    ] ifFalse:[ 
        super putIdOf: CutOffToken on: aStream
    ].

    "Created: / 29-10-2014 / 10:50:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-10-2014 / 12:38:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BOSSFileTransport::BinaryFileWriter methodsFor:'accessing'!

maxDepth
    ^ maxDepth
!

maxDepth:anInteger
    maxDepth := anInteger.
! !

!BOSSFileTransport::BinaryFileWriter methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    self initializeForSize: nil.
    currentDepth := 0.
    maxDepth := 10.

    "Modified: / 29-10-2014 / 10:57:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BOSSFileTransport class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__BOSSFileTransport.st,v 1.3 2014-10-29 12:52:30 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__BOSSFileTransport.st,v 1.3 2014-10-29 12:52:30 vrany Exp $'
!

version_SVN
    ^ '$Id: Loggia__BOSSFileTransport.st,v 1.3 2014-10-29 12:52:30 vrany Exp $'
! !


BOSSFileTransport::BinaryFileWriter initialize!
