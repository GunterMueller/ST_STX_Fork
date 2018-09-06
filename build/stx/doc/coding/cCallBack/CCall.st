"
 COPYRIGHT (c) 1996 by Claus Gittinger
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

"{ NameSpace: CodingExamples }"

Object subclass:#CCallBackDemo
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'examples-C-CallBack'
!

!CCallBackDemo primitiveFunctions!
%{

static timeoutID = -1;

/*
 * this C-function is called by Smalltalk
 */
static void
callBackFunction(arg) {
	reinstallCallBack(arg+1);
	printf("callBack called with %d\n", arg);
}

/*
 * reinstall the callback (prepare for triggering again)
 */
static
reinstallCallBack(arg) {
	timeoutID = __STX_AddTimeout(callBackFunction, 1000, arg);
}

/*
 * install the callback (prepare for triggering)
 */
static
startCCalling() {
	timeoutID = __STX_AddTimeout(callBackFunction, 1000, 1);
}

/*
 * deinstall the callback (stop triggering)
 */
static
stopCCalling() {
	__STX_RemoveTimeout(timeoutID);
}

%}
! !

!CCallBackDemo class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996 by Claus Gittinger
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
    this example demonstrates, how primitive (or alien) C-Code can
    use the smalltalk timer to install a timeout. Notice, that external C-Code
    which uses the alarm timer directly will probably stop the smalltalk scheduler.
    Therefore, use of the __STX_AddTimeout() utility function is recommended if 
    the C-Code needs timer functionality.

    This class only works if stc-compiled (due to the primitiveFunctions);
    if loaded from source, it will not work.
    i.e.:
        make CCall.o
        (on ELF-based systems:
            make CCall.o; make CCall.so)
    then fileIn the binary class.

    Notice: watch the xterm window for the output
            (C-code cannot easily send messages to the Transcript)
"
! !

!CCallBackDemo class methodsFor:'testing'!

startCCalling
    "install a timer, to call a C-function after some time"

%{
    startCCalling();        
%}
    "
     CCallBackDemo startCCalling
    "
!

stopCCalling
    "deinstall the C-call timer"

%{
    stopCCalling();        
%}
    "
     CCallBackDemo stopCCalling
    "
! !

!CCallBackDemo class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/cCallBack/CCall.st,v 1.8 1997-01-08 16:49:57 cg Exp $'
! !
