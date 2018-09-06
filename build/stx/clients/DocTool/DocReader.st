"
 COPYRIGHT (c) 1991 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 This is a demo example:

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

Object subclass:#DocumentReader
	 instanceVariableNames:'inStream master currentFont currentFamily currentFace
		currentStyle currentSize underline fontChange 
		tabPositions pageWidth pageHeight marginLeft
		marginRight marginTop marginBottom lineSpacing
		leftIndent rightIndent firstIndent nCols
		needBreak centered'
	 classVariableNames:''
	 poolDictionaries:''
	 category:'Views-Document'
!

!DocumentReader class methodsFor:'instance creation'!

new
    ^ super new
! !

!DocumentReader methodsFor:'private'!

getFont
    fontChange := false.
    currentFont := (Font family:currentFamily
			   face:currentFace
			  style:currentStyle
			   size:currentSize).
    currentFont isNil ifTrue:[
	(currentFamily = 'Palatino') ifTrue:[
	    currentFamily := 'Helvetica'.
	    currentFont := (Font family:currentFamily
				   face:currentFace
				  style:currentStyle
				   size:currentSize)
	]
    ].

    currentFont isNil ifTrue:[
	currentFamily errorPrint. '-' errorPrint.
	currentFace errorPrint. '-' errorPrint.
	currentStyle errorPrint. '-' errorPrint.
	currentSize errorPrint. ' not available' errorPrintNewline.

	"try normal instead of italic font"
	(currentStyle = 'oblique') ifTrue:[
	    currentFont := Font family:currentFamily
				  face:currentFace
				 style:'roman'
				  size:currentSize
	].
	currentFont isNil ifTrue:[
	    "try normal instead of bold font"
	    (currentFace = 'bold') ifTrue:[
		currentFont := Font family:currentFamily
				      face:'medium'
				     style:'roman'
				      size:currentSize
	    ]
	]
    ].
    currentFont := currentFont on:Display
!

nextTabAfter:pos
    tabPositions notNil ifTrue:[
	tabPositions do:[:tab |
	    (tab > pos) ifTrue:[^ tab]
	]
    ].
    ^ pos
!

setupDefaults
    currentFamily := 'courier'.
    currentFace := 'medium'.
    currentStyle := 'roman'.
    currentSize := 12.
    lineSpacing := 12.

    leftIndent := 0.
    firstIndent := 0.
    rightIndent := 0.

    underline := false.
    centered := false.
    fontChange := true.

    pageWidth := 12240.

    marginLeft := 1800.
    marginRight := 1800.
    marginTop := 1440.
    marginBottom := 1440.

    needBreak := false.
    nCols := 1.
!

paragraphStart
    needBreak ifTrue:[
	master addLineBreak.
	needBreak := true
    ].
    (firstIndent ~~ 0) ifTrue:[
	master firstIndent:firstIndent
    ]
! !

!DocumentReader methodsFor:'setup'!

on:aStream
    inStream := aStream
! !
