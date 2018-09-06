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

Object subclass:#CTimerDemo
	instanceVariableNames:'sema'
	classVariableNames:''
	poolDictionaries:''
	category:'examples-C-CallBack'
!

!CTimerDemo primitiveFunctions!
%{

static OBJ semaRef = nil;

/*
 * the C timeout function ...
 */
static void
doTrigger(dummyArg)
{
    printf("CTimeout doTrigger called ..\n");

    /*
     * signal the semaphore
     */
    __STX_SignalSemaphore(semaRef);

    /*
     * remove the cell-Ref from the system
     * (i.e. the garbage collector no longer
     *  needs to care for it)
     */
    semaRef = nil;
    printf("removeCell ..\n");
    __REMOVE_REFCELL( &semaRef );
}

/*
 * install a timeout for a C function ...
 */
static void
triggerSemaAfter(theSema, delta)
    OBJ theSema;
    int delta;
{
    /*
     * remember the semaphore
     */
    semaRef = theSema;
    printf("addCellRef ..\n");
    __ADD_REFCELL( &semaRef );

    /*
     * install a timeout
     */
    printf("add CTimeout ..\n");
    __STX_AddTimeout(doTrigger, delta, 0);
}

%}
! !

!CTimerDemo class methodsFor:'documentation'!

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
    use the smalltalk timer to install a timeout, and also signal
    a smalltalk semaphore from there.

    This is useful, if some C-code has to signal an event up to
    smalltalk, but return values cannot easily be used.

    This class only works if stc-compiled (due to the primitiveFunctions);
    if loaded from source, it will not work.
    i.e.:
        make CTimer.o
        (on ELF-based systems:
            make CTimer.o; make CTimer.so)
    then fileIn the binary class.

    Notice: watch the xterm window for the output
            (C-code cannot easily send messages to the Transcript)
"
! !

!CTimerDemo class methodsFor:'testing'!

timerDemo1
    |mySema|

    mySema := Semaphore new.
    Transcript showCR:'installing timer ...'.
%{
    triggerSemaAfter(mySema, 1000);        
%}.
    Transcript showCR:'waiting ...'.
    mySema wait.
    Transcript showCR:'done ...'.

    "
     CTimerDemo timerDemo1
    "
! !

!CTimerDemo methodsFor:'testing'!

startTimer
%{
    triggerSemaAfter(__INST(sema), 1000);        
%}
!

timerDemo2
    sema := Semaphore new.
    Transcript showCR:'installing timer ...'.
    self startTimer.
    Transcript showCR:'waiting ...'.
    sema wait.
    Transcript showCR:'done ...'.

    "
     CTimerDemo new timerDemo2
    "
! !

!CTimerDemo class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/cCallBack/CTimer.st,v 1.6 1997-01-08 16:47:31 cg Exp $'
! !
