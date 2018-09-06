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





"{ NameSpace: Demos }"

ObjectView subclass:#HostView
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'demos-ObjectView'
!

!HostView class methodsFor:'documentation'!

copyright
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




!

documentation
"
    a simple demonstration of an ObjectView use.

    This does not redefine any objectView methods;
    therefore, no fancy drag&drop or object interaction
    features are provided.
    (i.e. objects are only displayed)

    This class and HostIcon are provided as a starting
    point for your own ObjectView-based applications.
    (maybe someone combines thos with the snmp interface,
     to send out queries to other hosts ...)

    See examples.


    [author:]
        Claus Gittinger

    [see also:]
        DrawView DrawObject DrawTool
        ObjectView
        LogicTool WindowTreeView
"

!

examples
"
  open a view, displaying two hostIcons:
                                                                [exBegin]
    |top v host1 host2|

    top := StandardSystemView new.
    v := HostView origin:0.0@0.0 corner:1.0@1.0 in:top.

    host1 := HostIcon forHost:'foo'.
    host1 origin:(10 @ 10).

    host2 := HostIcon forHost:'bar'.
    host2 origin:(100 @ 10).

    v add:host1.
    v add:host2.

    top extent:300@300.
    top open.
                                                                [exEnd]
"
! !

!HostView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/HostView.st,v 1.5 1997-01-24 17:10:43 cg Exp $'
! !
