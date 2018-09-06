"
 COPYRIGHT (c) 1990 by Claus Gittinger
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



"{ Package: 'stx:clients/LogicTool' }"

"{ NameSpace: Demos }"

LogicObject subclass:#Output
	instanceVariableNames:'prevInputValue'
	classVariableNames:'OffIcon OnIcon'
	poolDictionaries:''
	category:'demos-LogicTool-Objects'
!

!Output class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1990 by Claus Gittinger
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


!

documentation
"
    output/lamp

    [author:]
        Claus Gittinger (spring 90)
"





! !

!Output class methodsFor:'specification'!

genericName
    ^ 'out'
!

icon
    ^ self offIcon
!

iconFileName
    ^ 'OutputOff.64.xbm'
!

numberOfInputs
    ^ 1
!

numberOfOutputs
    ^ 0
!

offIcon
    OffIcon isNil ifTrue:[
        OffIcon := self iconForFilename:'OutputOff.64.xbm'
    ].
    ^ OffIcon
!

onIcon
    OnIcon isNil ifTrue:[
        OnIcon := self iconForFilename:'OutputOn.64.xbm'
    ].
    ^ OnIcon

    "Modified: / 9.2.1998 / 17:35:38 / cg"
! !

!Output methodsFor:'initialization'!

initialize
    super initialize
! !

!Output methodsFor:'simulation'!

evaluate
    ((inputValues at:1) ~~ prevInputValue) ifTrue:[
	changedPicture := true
    ].
    prevInputValue := inputValues at:1.
    ^ self
!

value
    ^ inputValues at:1
! !

!Output methodsFor:'specification'!

icon
    (inputValues at:1) ifTrue:[
	^ self class onIcon
    ].
    ^ self class offIcon
! !

!Output class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/LogicTool/Output.st,v 1.12 2000-12-28 14:54:18 cg Exp $'
! !
