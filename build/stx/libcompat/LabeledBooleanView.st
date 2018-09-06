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

Button subclass:#LabeledBooleanView
	instanceVariableNames:'controlBlock'
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-ST80'
!

!LabeledBooleanView class methodsFor:'documentation'!

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
    This is a dummy ST-80 compatibility class.

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

!LabeledBooleanView methodsFor:'accessing-behavior'!

beRadioButton
    controller beRadioButton

    "Created: 27.1.1997 / 13:40:10 / cg"
! !

!LabeledBooleanView methodsFor:'accessing-look'!

beVisual:aDisplayObject
    self label: aDisplayObject

    "Created: 27.1.1997 / 13:29:35 / cg"
! !

!LabeledBooleanView methodsFor:'defaults'!

defaultControllerClass
    ^ LabeledBooleanViewController

    "Created: 27.1.1997 / 13:36:24 / cg"
! !

!LabeledBooleanView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/LabeledBooleanView.st,v 1.4 2011-10-01 11:11:44 vrany Exp $'
! !
