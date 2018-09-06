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

Object subclass:#TextAttributes
	instanceVariableNames:'alignment baseline characterAttributes firstIndent restIndent
		lineGrid rightIndent equalTabs tabsArray'
	classVariableNames:'TextStyles'
	poolDictionaries:''
	category:'Compatibility-ST80'
!

!TextAttributes class methodsFor:'documentation'!

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

!TextAttributes class methodsFor:'initialization'!

initializeDefault
    | style |

    style := self new.
    style characterAttributes:(CharacterAttributes styleNamed:#default).
    self styleNamed:#default put:style.
    "/ VW uses #pixelDefault instead of #default
    self styleNamed:#pixelDefault put:style.

    "Created: 25.1.1997 / 03:07:51 / cg"
    "Modified: 27.1.1997 / 12:36:34 / cg"
!

initializeDefaultItalic
    | style |

    style := self new.
    style characterAttributes:(CharacterAttributes styleNamed:#defaultItalic).
    self styleNamed:#defaultItalic put:style.
    "/ VW uses #pixelDefaultItalic instead of #defaultItalic
    self styleNamed:#pixelDefaultItalic put:style.

    "Created: 25.1.1997 / 03:06:55 / cg"
    "Modified: 27.1.1997 / 12:36:40 / cg"
!

initializeFixed
    | style |

    style := self new.
    style characterAttributes:(CharacterAttributes styleNamed:#fixed).
    self styleNamed:#fixed put:style.
    "/ VW uses #pixelFixed instead of #fixed
    self styleNamed:#pixelFixed put:style.

    "Created: 25.1.1997 / 03:07:41 / cg"
    "Modified: 27.1.1997 / 12:36:44 / cg"
!

initializeLarge
    | style |

    style := self new.
    style characterAttributes:(CharacterAttributes styleNamed:#large).
    self styleNamed:#large put:style.
    "/ VW uses #pixelLarge instead of #large
    self styleNamed:#pixelLarge put:style.

    "Created: 25.1.1997 / 03:07:13 / cg"
    "Modified: 27.1.1997 / 12:36:47 / cg"
!

initializeSmall
    | style |

    style := self new.
    style characterAttributes:(CharacterAttributes styleNamed:#small).
    self styleNamed:#small put:style.
    "/ VW uses #pixelSmall instead of #small
    self styleNamed:#pixelSmall put:style.

    "Created: / 25.1.1997 / 03:07:28 / cg"
    "Modified: / 27.1.1997 / 12:36:50 / cg"
    "Modified: / 6.3.1998 / 15:52:58 / stefan"
!

initializeStyles
    TextStyles isNil ifTrue:[
        TextStyles := IdentityDictionary new
    ].
    self initializeLarge.
    self initializeSmall.
    self initializeFixed.
    self initializeSystemDefault.
    self initializeDefault.
    self initializeDefaultItalic.

    "
     TextAttributes initialize
    "

    "Modified: / 27-01-1997 / 12:35:38 / cg"
    "Created: / 07-08-2011 / 13:23:38 / cg"
!

initializeSystemDefault
    | style |

    style := self new.
    style characterAttributes:(CharacterAttributes styleNamed:#systemDefault).
    self styleNamed:#systemDefault put:style

    "Created: 25.1.1997 / 03:07:51 / cg"
    "Modified: 27.1.1997 / 12:36:34 / cg"
! !

!TextAttributes class methodsFor:'instance creation'!

characterAttributes:attributes
    ^ self new characterAttributes:attributes

    "Created: 25.1.1997 / 02:36:35 / cg"
!

default
    ^ self styleNamed:#default
!

styleNamed:aStyleSymbol
    ^ self textStyles at:aStyleSymbol

    "Created: / 25-01-1997 / 02:25:25 / cg"
    "Modified: / 07-08-2011 / 13:25:09 / cg"
!

styleNamed:aStyleSymbol ifAbsent:defaultValue
    ^ self textStyles at:aStyleSymbol ifAbsent:defaultValue

    "Modified: / 07-08-2011 / 13:25:15 / cg"
!

styleNamed:aStyleSymbol put:aStyle
    self textStyles at:aStyleSymbol put:aStyle

    "Created: / 25-01-1997 / 02:25:25 / cg"
    "Modified: / 07-08-2011 / 13:25:21 / cg"
! !

!TextAttributes class methodsFor:'others'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libcompat/TextAttributes.st,v 1.14 2011-08-07 11:25:41 cg Exp $'
! !

!TextAttributes class methodsFor:'queries'!

styles
    ^ self textStyles keys

    "Created: / 27-01-1997 / 17:54:38 / cg"
    "Modified: / 07-08-2011 / 13:24:49 / cg"
!

textStyles
    TextStyles isNil ifTrue:[
        self initializeStyles
    ].
    ^ TextStyles

    "Created: / 07-08-2011 / 13:24:31 / cg"
! !

!TextAttributes methodsFor:'accessing'!

alignment
    "return alignment"

    ^ alignment

    "Created: 14.2.1997 / 17:13:29 / cg"
!

alignment:something
    "set alignment"

    alignment := something.

    "Created: 14.2.1997 / 17:13:29 / cg"
!

baseline
    "return baseline"

    ^ baseline

    "Created: 14.2.1997 / 17:13:45 / cg"
!

baseline:something
    "set baseline"

    baseline := something.

    "Created: 14.2.1997 / 17:13:45 / cg"
!

characterAttributes
    "return characterAttributes"

    ^ characterAttributes

    "Created: 14.2.1997 / 17:13:52 / cg"
!

characterAttributes:something
    "set the characterAttributes"

    characterAttributes := something.

    "Created: 14.2.1997 / 17:13:52 / cg"
    "Modified: 20.6.1997 / 15:03:42 / cg"
!

equalTabs
    "return equalTabs"

    ^ equalTabs

    "Created: 14.2.1997 / 17:13:59 / cg"
!

equalTabs:something
    "set equalTabs"

    equalTabs := something.

    "Created: 14.2.1997 / 17:13:59 / cg"
!

firstIndent
    "return firstIndent"

    ^ firstIndent

    "Created: 14.2.1997 / 17:13:58 / cg"
!

firstIndent:something
    "set firstIndent"

    firstIndent := something.

    "Created: 14.2.1997 / 17:13:58 / cg"
!

lineGrid
    "return lineGrid"

    ^ lineGrid

    "Created: 14.2.1997 / 17:13:58 / cg"
!

lineGrid:something
    "set lineGrid"

    lineGrid := something.

    "Created: 14.2.1997 / 17:13:59 / cg"
!

restIndent
    "return restIndent"

    ^ restIndent

    "Created: 14.2.1997 / 17:13:58 / cg"
!

restIndent:something
    "set restIndent"

    restIndent := something.

    "Created: 14.2.1997 / 17:13:58 / cg"
!

rightIndent
    "return rightIndent"

    ^ rightIndent

    "Created: 14.2.1997 / 17:13:59 / cg"
!

rightIndent:something
    "set rightIndent"

    rightIndent := something.

    "Created: 14.2.1997 / 17:13:59 / cg"
!

setCharacterAttributes:something
    "set the characterAttributes"

    characterAttributes := something.

    "Created: 20.6.1997 / 15:03:39 / cg"
!

tabsArray
    "return tabsArray"

    ^ tabsArray

    "Created: 14.2.1997 / 17:14:00 / cg"
!

tabsArray:something
    "set tabsArray"

    tabsArray := something.

    "Created: 14.2.1997 / 17:14:00 / cg"
!

useTabs:aCollection
    "set tabsArray"

    self tabsArray:aCollection

    "Created: / 19.5.1998 / 16:53:45 / cg"
! !

!TextAttributes methodsFor:'queries'!

defaultFont
    ^ characterAttributes defaultFontFor:#normal

    "Created: 25.1.1997 / 02:42:20 / cg"
    "Modified: 25.1.1997 / 02:44:16 / cg"
! !

!TextAttributes class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/TextAttributes.st,v 1.14 2011-08-07 11:25:41 cg Exp $'
! !
