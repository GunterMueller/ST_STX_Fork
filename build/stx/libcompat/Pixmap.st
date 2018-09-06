"
 COPYRIGHT (c) 2001 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libcompat' }"

"{ NameSpace: Smalltalk }"

Form subclass:#Pixmap
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-ST80'
!

!Pixmap class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2001 by eXept Software AG
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
    ST-80 compatibility class.
    This may be required when existing code has to be ported to ST/X;
    however, it may not be complete and more protocol may be added in the future.
    The code here was created when public domain code (Manchester) had to
    be ported to ST/X and missing classes/methods were encountered, and code added
    by reasoning 'what the original class could probably do there'.

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

!Pixmap class methodsFor:'instance creation'!

width:w height:h
    "create a new form on the default device"

    ^ self width:w height:h depth:(Screen current depth) onDevice:Screen current

    "Modified: / 04-06-1996 / 22:16:33 / cg"
    "Created: / 06-03-1997 / 15:48:25 / cg"
    "Modified: / 31-03-2017 / 17:52:18 / stefan"
!

width:w height:h fromArray:anArray
    "create a new form on the default device"

    |form|

    form := self width:w height:h depth:Screen current depth onDevice:Screen current.
    form bits:anArray .
    ^ form

    "Created: / 06-03-1997 / 15:48:27 / cg"
    "Modified: / 31-03-2017 / 17:52:25 / stefan"
!

width:w height:h on:aDevice
    "create a new form on the default device"

    ^ self width:w height:h depth:(aDevice depth) onDevice:aDevice

    "Modified: / 04-06-1996 / 22:16:33 / cg"
    "Created: / 06-03-1997 / 15:48:30 / cg"
    "Modified: / 31-03-2017 / 17:52:33 / stefan"
! !

!Pixmap methodsFor:'ST-80 compatibility'!

palette
    ^ self colorMap

    "Created: 1.3.1997 / 15:41:36 / cg"
!

palette:aColormap
    self colorMap:aColormap

    "Created: 1.3.1997 / 15:41:04 / cg"
! !

!Pixmap class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/Pixmap.st,v 1.7 2017-03-31 15:52:56 stefan Exp $'
! !

