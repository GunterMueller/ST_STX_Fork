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

Object subclass:#CharacterAttributes
	instanceVariableNames:'attributes defaultQuery'
	classVariableNames:'CharacterStyles'
	poolDictionaries:''
	category:'Compatibility-ST80'
!

!CharacterAttributes class methodsFor:'documentation'!

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

!CharacterAttributes class methodsFor:'initialization'!

initializeDefault
    | style |

    style := self newWithDefaultAttributes.

    style setDefaultQuery: 
                (FontDescription new
                        family: #('helv*' 'arial' '*');
                        manufacturer: #('adobe' '*');
                        fixedWidth: false;
                        serif: false;
                        italic: false;
                        boldness: 0.5;
                        color: Color black;
                        pixelSize: 12).
    self styleNamed: #default put: style

    "Created: 25.1.1997 / 03:09:42 / cg"
!

initializeDefaultItalic
    | style |

    style := self newWithDefaultAttributes.

    style setDefaultQuery: 
                (FontDescription new
                        family:#('helv*' 'arial' '*');
                        manufacturer:#('adobe' '*');
                        fixedWidth:false;
                        serif:false;
                        italic:true;
                        boldness:0.5;
                        color:(Color black);
                        pixelSize:12).
    self styleNamed:#defaultItalic put:style

    "Created: 25.1.1997 / 03:08:57 / cg"
    "Modified: 25.1.1997 / 03:10:17 / cg"
!

initializeFixed
    | style |

    style := self newWithDefaultAttributes.

    style setDefaultQuery: 
                (FontDescription new
                        family: #('courier*' 'fixed' '*');
                        manufacturer: #('adobe' '*');
                        fixedWidth: true;
                        serif: false;
                        italic: false;
                        boldness: 0.5;
                        color: Color black;
                        pixelSize: 12).
    self styleNamed: #fixed put: style

    "Created: 25.1.1997 / 03:24:11 / cg"
!

initializeLarge
    | style |

    style := self newWithDefaultAttributes.

    style setDefaultQuery: 
                (FontDescription new
                        family: #('helv*' 'arial' '*');
                        manufacturer: #('adobe' '*');
                        fixedWidth: false;
                        serif: false;
                        italic: false;
                        boldness: 0.5;
                        color: Color black;
                        pixelSize: 16).
    self styleNamed: #large put: style

    "Created: 25.1.1997 / 03:11:00 / cg"
!

initializeSmall
    | style |

    style := self newWithDefaultAttributes.

    style setDefaultQuery: 
                (FontDescription new
                        family: #('helv*' 'arial' '*');
                        manufacturer: #('adobe' '*');
                        fixedWidth: false;
                        serif: false;
                        italic: false;
                        boldness: 0.5;
                        color: Color black;
                        pixelSize: 8).
    self styleNamed: #small put: style

    "Created: 25.1.1997 / 03:11:10 / cg"
!

initializeStyles
    CharacterStyles := IdentityDictionary new.

    self initializeLarge.
    self initializeSmall.
    self initializeFixed.
    self initializeSystemDefault.
    self initializeDefault.
    self initializeDefaultItalic.

    "
     self initializeStyles
    "

    "Created: / 07-08-2011 / 13:20:49 / cg"
!

initializeSystemDefault
    | style |

    style := self newWithDefaultAttributes.

    style setDefaultQuery: 
                (FontDescription new
                        family: #('helv*' 'arial' '*');
                        manufacturer: #('adobe' '*');
                        fixedWidth: false;
                        serif: false;
                        italic: false;
                        boldness: 0.5;
                        color: Color black;
                        pixelSize: 12).
    self styleNamed: #systemDefault put: style

    "Created: 25.1.1997 / 03:09:42 / cg"
! !

!CharacterAttributes class methodsFor:'instance creation'!

newWithDefaultAttributes
    ^ self new
        at:#bold put:[:aFontDescription | aFontDescription boldness:1];
        at:#italic put:[:aFontDescription | aFontDescription italic];
        yourself

    "Modified: 25.1.1997 / 02:40:01 / cg"
! !

!CharacterAttributes class methodsFor:'accessing'!

characterStyles
    CharacterStyles isNil ifTrue:[
        self initializeStyles
    ].

    ^ CharacterStyles

    "Created: / 07-08-2011 / 13:26:16 / cg"
!

default
    ^ self styleNamed:#default

    "Created: 27.1.1997 / 13:43:04 / cg"
!

styleNamed:aPolicySymbol
    ^ self characterStyles at:aPolicySymbol ifAbsent:nil

    "Created: / 27-01-1997 / 12:36:00 / cg"
!

styleNamed:aPolicySymbol put:aStyle
    self characterStyles at:aPolicySymbol put:aStyle

    "Created: / 25-01-1997 / 03:23:30 / cg"
! !

!CharacterAttributes class methodsFor:'others'!

version_CVS
    ^ '$Id: CharacterAttributes.st,v 1.11 2011-10-01 11:05:31 vrany Exp $'
! !

!CharacterAttributes methodsFor:'accessing'!

at:policySymbol
    ^ attributes at:policySymbol

    "Modified: 25.1.1997 / 02:41:18 / cg"
    "Created: 25.1.1997 / 02:43:32 / cg"
!

at:policySymbol put:aBlock
    attributes isNil ifTrue:[
        attributes := IdentityDictionary new
    ].
    attributes at:policySymbol put:aBlock

    "Modified: 25.1.1997 / 02:41:18 / cg"
!

defaultFont
"/    ^ (attributes at:#normal) ...
    ^ View defaultFont.

    "Created: 27.1.1997 / 13:43:40 / cg"
    "Modified: 27.1.1997 / 13:44:11 / cg"
!

defaultFontFor:policySymbol
"/    ^ (attributes at:policySymbol) at:#normal
    ^ View defaultFont.

    "Created: 25.1.1997 / 02:44:45 / cg"
    "Modified: 25.1.1997 / 02:54:05 / cg"
!

setDefaultQuery:aBlock
    defaultQuery := aBlock

    "Created: 25.1.1997 / 03:22:30 / cg"
! !

!CharacterAttributes class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/CharacterAttributes.st,v 1.11 2011-10-01 11:05:31 vrany Exp $'
!

version_SVN
    ^ '§Id: CharacterAttributes.st,v 1.8 2011/07/05 18:08:47 cg Exp §'
! !
