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

LogicObject subclass:#ExorGate2
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'demos-LogicTool-Objects'
!

!ExorGate2 class methodsFor:'documentation'!

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
    2 input exor-gate

    [author:]
        Claus Gittinger (sprint 90)
"





! !

!ExorGate2 class methodsFor:'specification'!

genericName
    ^ 'xor'
!

iconFileName
    (Smalltalk language == #german) ifTrue:[
        ^ self nameWithoutPrefix , '_g.64.xbm'
    ].
    ^ self nameWithoutPrefix , '.64.xbm'

    "Modified: 24.1.1997 / 17:57:22 / cg"
!

numberOfInputs
    ^ 2
!

numberOfOutputs
    ^ 1
! !

!ExorGate2 methodsFor:'simulation'!

evaluate
    |oldOut|

    oldOut := outputValues at:1.
    outputValues at:1 put:((inputValues at:1) xor: (inputValues at:2)).
    (outputValues at:1) ~~ oldOut ifTrue:[
        changed := true
    ].
    ^ outputValues at:1
! !

!ExorGate2 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/LogicTool/ExorGate2.st,v 1.10 2000-12-28 14:54:21 cg Exp $'
! !
