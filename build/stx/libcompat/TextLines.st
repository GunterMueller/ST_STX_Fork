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

Object subclass:#TextLines
	instanceVariableNames:'textStyle'
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-ST80'
!

!TextLines class methodsFor:'documentation'!

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

!TextLines methodsFor:'accessing'!

lineGrid
    "return the line grid from the textAttributes"

    ^ textStyle lineGrid

    "Created: 14.2.1997 / 17:16:23 / cg"
!

numberOfLines
    "return the number of lines"

    ^ self subclassResponsibility

    "Created: 14.2.1997 / 17:17:04 / cg"
!

textStyle
    "return textStyle"

    ^ textStyle

    "Created: 14.2.1997 / 17:15:59 / cg"
!

textStyle:something
    "set textStyle"

    textStyle := something.

    "Created: 14.2.1997 / 17:15:59 / cg"
! !

!TextLines methodsFor:'accessing-contents'!

lineAt:index
    ^ self subclassResponsibility

    "Created: 14.2.1997 / 17:19:06 / cg"
!

lineIndexOfTop:top
    ^ self subclassResponsibility

    "Created: 14.2.1997 / 17:19:32 / cg"
!

lineRangeFor:aRectangle
    ^ self subclassResponsibility

    "Created: 14.2.1997 / 17:19:42 / cg"
!

textAt:index
    ^ self subclassResponsibility

    "Created: 14.2.1997 / 17:19:53 / cg"
!

topAtLineIndex:index
    ^ self subclassResponsibility

    "Created: 14.2.1997 / 17:20:14 / cg"
!

visibleRectangleFrom:start to:stop
    ^ self subclassResponsibility

    "Created: 14.2.1997 / 17:20:37 / cg"
! !

!TextLines methodsFor:'queries'!

bottom
    ^ self boundes corner y

    "Created: 14.2.1997 / 17:17:34 / cg"
!

extent
    ^ self boundes extent

    "Created: 14.2.1997 / 17:17:43 / cg"
!

height
    ^ self subclassResponsibility

    "Created: 14.2.1997 / 17:17:57 / cg"
!

left
    ^ 0

    "Created: 14.2.1997 / 17:18:12 / cg"
!

right
    ^ self bounds corner x

    "Created: 14.2.1997 / 17:18:21 / cg"
!

top
    ^ 0

    "Created: 14.2.1997 / 17:18:26 / cg"
!

topLeft
    ^ 0 @ 0

    "Created: 14.2.1997 / 17:18:33 / cg"
!

width
    ^ self subclassResponsibility

    "Created: 14.2.1997 / 17:18:39 / cg"
! !

!TextLines class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/TextLines.st,v 1.5 2011-10-01 11:17:35 vrany Exp $'
! !
