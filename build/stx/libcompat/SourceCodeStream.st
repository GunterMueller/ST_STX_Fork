"
 COPYRIGHT (c) 1997 by eXept Software AG / Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libcompat' }"

Stream subclass:#SourceCodeStream
	instanceVariableNames:'files'
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-ST80'
!

!SourceCodeStream class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG / Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"


!

documentation
"
    Enough to support the SourceCodeSaver PD goody ....


    ST-80 compatibility class.
    This may be required when existing code has to be ported to ST/X;
    however, it may not be complete and more protocol may be added in the future.
    The code here was created when public domain code (Manchester) had to
    be ported to ST/X and missing classes/methods were encountered, and code added
    by reasoning 'what the original class could probably do there'.

    This is currently not used by ST/X itself.

    This is an additional goody class; therefore:

    THIS SOFTWARE IS PROVIDED BY THE CONTRIBUTOR ``AS IS'' AND
    ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
    IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
    ARE DISCLAIMED.  IN NO EVENT SHALL THE CONTRIBUTOR BE LIABLE
    FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
    DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
    OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
    HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
    LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
    OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
    SUCH DAMAGE.
"

! !

!SourceCodeStream class methodsFor:'instance creation'!

on:aStream
    ^ self basicNew files:(Array with:aStream)

    "Modified: 20.6.1997 / 17:09:44 / cg"
! !

!SourceCodeStream methodsFor:'accessing'!

files
    "return the value of the instance variable 'files' (automatically generated)"

    ^ files

    "Created: 20.6.1997 / 17:09:24 / cg"
!

files:something
    "set the value of the instance variable 'files' (automatically generated)"

    files := something.

    "Created: 20.6.1997 / 17:09:24 / cg"
!

targetFile
    ^ files first

    "Created: 20.6.1997 / 17:10:00 / cg"
    "Modified: 20.6.1997 / 17:17:36 / cg"
! !

!SourceCodeStream methodsFor:'fileOut'!

fileOutMessages:collectionOfMessageSelectors for:aClass
    |methods|

    methods := collectionOfMessageSelectors collect:[:sel | aClass compiledMethodAt:sel].
    aClass fileOutMethods:methods on:self.

    "Modified: / 29.1.1999 / 19:25:54 / cg"
! !

!SourceCodeStream methodsFor:'misc'!

timeStamp
    self nextPutAll:(Smalltalk timeStamp).
    self cr; cr.

    "Created: / 29.1.1999 / 19:12:43 / cg"
    "Modified: / 29.1.1999 / 19:29:27 / cg"
! !

!SourceCodeStream methodsFor:'stream messages'!

cr
    self targetFile cr

    "Created: 20.6.1997 / 17:19:32 / cg"
!

nextChunkPut:someString
    self targetFile nextChunkPut:someString

    "Created: 20.6.1997 / 17:20:51 / cg"
!

nextPut:aCharacter
    self targetFile nextPut:aCharacter

    "Created: 20.6.1997 / 17:19:54 / cg"
!

nextPutAll:aCollection
    self targetFile nextPutAll:aCollection

    "Created: 20.6.1997 / 17:19:24 / cg"
!

nextPutAllAsChunk:someString
    self targetFile nextPutAllAsChunk:someString

    "Created: 20.6.1997 / 17:20:40 / cg"
!

nextPutChunkSeparator
    self targetFile nextPutChunkSeparator

    "Created: 20.6.1997 / 17:20:09 / cg"
!

space
    self targetFile space

    "Created: 20.6.1997 / 17:19:39 / cg"
! !

!SourceCodeStream class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/SourceCodeStream.st,v 1.5 2011-10-01 11:06:25 vrany Exp $'
! !
