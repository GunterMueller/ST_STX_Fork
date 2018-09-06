"{ Encoding: utf8 }"

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

ColorPreferencesCollection subclass:#LookPreferences
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-VisualWorks'
!

!LookPreferences class methodsFor:'documentation'!

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

!LookPreferences class methodsFor:'decorations'!

edgeDecorator
    ^ BorderedWrapper

    "Created: 17.1.1997 / 22:43:18 / cg"
    "Modified: 17.1.1997 / 22:44:01 / cg"
! !

!LookPreferences methodsFor:'converting'!

fromLiteralArrayEncoding:aSpecArray
    "initialize my values from a specArray"

    self initializeForCapacity:(aSpecArray size // 2).
    2 to:aSpecArray size by:2 do:[:i | 
        self perform:(aSpecArray at:i) with:(aSpecArray at:i+1) decodeAsLiteralArray
    ].

    "
     #(#LookPreferences #setSelectionBackgroundColor: #(#ColorValue #black ) ) decodeAsLiteralArray
    "
!

literalArrayEncoding
    |coll|

    coll := OrderedCollection new.
    coll add:(self class name).
    self keysAndValuesDo:[:key :val |
        coll add:(key , ':') asSymbol.
        coll add:val literalArrayEncoding.
    ].
    ^ coll asArray

! !

!LookPreferences class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/LookPreferences.st,v 1.9 2015-05-09 11:59:33 cg Exp $'
! !

