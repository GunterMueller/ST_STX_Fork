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

"{ NameSpace: Smalltalk }"

IdentityDictionary subclass:#ColorPreferencesCollection
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-VisualWorks'
!

!ColorPreferencesCollection class methodsFor:'documentation'!

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

!ColorPreferencesCollection class methodsFor:'defaults'!

colorDefault
    "simulate ST-80 colorDefault values, by asking
     ViewStyle."

    |style defaults|

    style := View styleSheet.

    defaults := self new.
    defaults setForegroundColor:(style colorAt:'foregroundColor' default:Color black).
    defaults setBackgroundColor:(style colorAt:'backgroundColor' 
                default:(style colorAt:'viewBackground' default:Color white)).
    defaults setBorderColor:(style colorAt:'borderColor' default:Color black).
    defaults setSelectionForegroundColor:(style colorAt:'selectionForegroundColor' 
                default:(defaults backgroundColor)).
    defaults setSelectionBackgroundColor:(style colorAt:'selectionBackgroundColor' 
                default:(defaults foregroundColor)).
    defaults setHiliteColor:(style colorAt:'lightColor' 
                default:(defaults backgroundColor lightened)).

    ^ defaults

    "Created: 27.1.1997 / 13:14:18 / cg"
! !

!ColorPreferencesCollection methodsFor:'accessing'!

backgroundColor
    ^ self at:#backgroundColor ifAbsent:nil

    "Created: 27.1.1997 / 12:54:26 / cg"
    "Modified: 6.3.1997 / 15:19:39 / cg"
!

backgroundColor:aColor
    self at:#backgroundColor put:aColor

    "Modified: 6.3.1997 / 15:19:44 / cg"
    "Created: 3.4.1997 / 01:14:02 / cg"
!

borderColor
    ^ self at:#borderColor ifAbsent:nil

    "Created: 27.1.1997 / 12:54:47 / cg"
    "Modified: 6.3.1997 / 15:19:41 / cg"
!

borderColor:aColor
    ^ self at:#borderColor put:aColor

    "Created: 27.1.1997 / 12:48:23 / cg"
!

foregroundColor
    ^ self at:#foregroundColor ifAbsent:nil

    "Created: 27.1.1997 / 12:54:31 / cg"
    "Modified: 6.3.1997 / 15:19:44 / cg"
!

foregroundColor:aColor
    self at:#foregroundColor put:aColor

    "Modified: 6.3.1997 / 15:19:44 / cg"
    "Created: 3.4.1997 / 01:13:58 / cg"
!

hiliteColor
    ^ self at:#hiliteColor ifAbsent:nil

    "Created: 27.1.1997 / 12:54:59 / cg"
    "Modified: 6.3.1997 / 15:19:46 / cg"
!

hiliteColor:aColor
    ^ self at:#hiliteColor put:aColor
!

selectionBackgroundColor
    ^ self at:#selectionBackgroundColor ifAbsent:nil

    "Created: 27.1.1997 / 12:54:19 / cg"
    "Modified: 6.3.1997 / 15:19:33 / cg"
!

selectionBackgroundColor:aColor
    ^ self at:#selectionBackgroundColor put:aColor

    "Created: 27.1.1997 / 12:48:45 / cg"
!

selectionForegroundColor
    ^ self at:#selectionForegroundColor ifAbsent:nil

    "Created: 27.1.1997 / 12:49:27 / cg"
    "Modified: 6.3.1997 / 15:19:50 / cg"
!

selectionForegroundColor:aColor
    ^ self at:#selectionForegroundColor put:aColor

    "Created: 27.1.1997 / 12:48:50 / cg"
!

setBackgroundColor:aColor
    ^ self at:#backgroundColor put:aColor

    "Created: 27.1.1997 / 12:47:27 / cg"
    "Modified: 27.1.1997 / 12:48:08 / cg"
!

setBorderColor:aColor
    ^ self borderColor:aColor
!

setForegroundColor:aColor
    ^ self at:#foregroundColor put:aColor

    "Created: 27.1.1997 / 12:48:14 / cg"
!

setHiliteColor:aColor
    ^ self hiliteColor:aColor
!

setSelectionBackgroundColor:aColor
    ^ self selectionBackgroundColor:aColor
!

setSelectionForegroundColor:aColor
    ^ self selectionForegroundColor:aColor
!

setShadowColor:aColor
    ^ self shadowColor:aColor
!

shadowColor
    ^ self at:#shadowColor ifAbsent:nil

    "Created: 27.1.1997 / 12:49:32 / cg"
    "Modified: 6.3.1997 / 15:19:56 / cg"
!

shadowColor:aColor
    ^ self at:#shadowColor put:aColor
! !

!ColorPreferencesCollection class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/ColorPreferencesCollection.st,v 1.8 2015-03-27 13:24:31 cg Exp $'
! !

