"
 COPYRIGHT (c) 1997 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libcompat' }"

Object subclass:#MenuBuilder
	instanceVariableNames:'theMenu stack'
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-ST80'
!

!MenuBuilder class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG
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



!

examples
"
    |mb|

    mb := MenuBuilder new.
    mb add:('copy' -> #copy).
    mb add:('cut' -> [ self doCut ]).
    mb add:('paste' -> [:c | self doPaste ]).
    mb line.
    mb add:('foo' -> #doFoo).
    mb menu showAtPointer
"



! !

!MenuBuilder methodsFor:'accessing'!

menu
    ^ theMenu

    "Created: / 27.10.1997 / 19:45:50 / cg"
!

menuHolder
    ^ self menu asValue

    "Created: / 1.11.1997 / 03:05:50 / cg"
! !

!MenuBuilder methodsFor:'constructing'!

add:labelValueAssoc
    |item|

    item := MenuItem 
                label:(labelValueAssoc key)
                itemValue:(labelValueAssoc value).

    theMenu isNil ifTrue:[
        theMenu := Menu new.
    ].
    theMenu addItem:item

    "Created: / 27-10-1997 / 19:45:37 / cg"
!

addDefaultTextMenuWithEvaluation
    self add:('again' -> #again).
    self line.
    self add:('copy' -> #copySelection).
    self add:('cut' -> #cutSelection).
    self add:('paste' -> #pasteSelection).
    self line.
    self add:('doIt' -> #doIt).
    self add:('printIt' -> #printIt).
    self add:('inspectIt' -> #inspectIt).

    "Created: / 1.11.1997 / 03:03:25 / cg"
    "Modified: / 28.3.1998 / 21:33:42 / cg"
!

beginSubMenuLabeled:lbl
    theMenu isNil ifTrue:[
        theMenu := Menu new.
    ].
    stack isNil ifTrue:[
        stack := OrderedCollection new
    ].
    stack addFirst:(theMenu -> lbl).
    theMenu := Menu new.

    "Modified: / 28.3.1998 / 21:36:17 / cg"
!

endSubMenu
    |entry subMenu label item|

    subMenu := theMenu.
    entry := stack removeFirst.
    theMenu := entry key.
    label := entry value.

    item := MenuItem label:label.
    item submenu:subMenu.

    theMenu addItem:item

    "Created: / 28.3.1998 / 21:39:18 / cg"
    "Modified: / 18.6.1998 / 22:42:55 / cg"
!

line
    "add a separating line"

    self add:('-' -> nil).

    "Modified: / 28.3.1998 / 21:33:19 / cg"
! !

!MenuBuilder class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/MenuBuilder.st,v 1.10 2014-07-08 14:38:14 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libcompat/MenuBuilder.st,v 1.10 2014-07-08 14:38:14 cg Exp $'
! !

