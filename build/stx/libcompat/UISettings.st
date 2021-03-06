"
 COPYRIGHT (c) 1997 by eXept Software AG 
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

ResourcePack subclass:#UISettings
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-VisualWorks'
!

!UISettings class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG 
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

!UISettings class methodsFor:'accessing'!

preferenceFor:aKey
    ^ self perform:aKey ifNotUnderstood:nil

    "Created: 13.9.1997 / 10:22:13 / cg"
    "Modified: 8.10.1997 / 15:04:56 / cg"
! !

!UISettings class methodsFor:'preferences'!

showInternationalization
    ^ false

    "Created: 13.9.1997 / 10:25:48 / cg"
!

useEnhancedTools
    ^ true

    "Created: 13.9.1997 / 10:22:44 / cg"
! !

!UISettings class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/UISettings.st,v 1.6 2015-03-27 13:24:23 cg Exp $'
! !

