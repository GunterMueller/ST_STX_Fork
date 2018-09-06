"
 COPYRIGHT (c) 1989 by Claus Gittinger
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

StandardSystemView subclass:#Calendar
	instanceVariableNames:'calendarView list year'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-Goodies'
!

Calendar comment:'
 shows a calendar, like motif example in oReilly 

 start with:
	Calendar start
'!

!Calendar class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
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
    shows a calendar, like the motif example in oReilly. 

    This example shows how to read the output of some
    Unix command via a PipeStream and put it into a textview.
    Also, it includes a simple popupmenu to choose the year.
    It does not run under WIN32 (no cal command).

    [see also:]
        PipeStream 

    [start with:]
        Calendar open
"
! !

!Calendar class methodsFor:'startup'!

isVisualStartable
    "returns whether this application class can be started via #open
     (i.e. via a double click on the class in the browser)"

    ^ true

    "Created: / 7.7.1998 / 17:40:57 / cg"
!

open
    "open blocked, if not running under unix"

    OperatingSystem isUNIXlike ifFalse:[
        self warn:'This demo only runs under Unix'.
        ^ self.
    ].
    ^ super open

    "Created: / 5.8.1999 / 12:50:23 / cg"
! !

!Calendar methodsFor:'initialization'!

initialize
    "setup the view, fonts and a static menu.
     Select the current month initially."

    |v cView|

    super initialize.

    year := Date today year.

    "
     the label, which will hold the output of the unix cal command
    "
    calendarView := Label in:self. 
    calendarView adjust:#left.
    calendarView font:(Font family:'courier'
                              face:'bold'
                             style:'roman'
                              size:14).

    "adjust my size, to make 8 lines fit into label"
    calendarView label:#(' '
                         ' '
                         ' '
                         ' '
                         ' '
                         ' '
                         ' '
                         ' ') asStringCollection.
    StyleSheet name == #st80 ifTrue:[
        calendarView level:1
    ].
    calendarView sizeFixed:true.

    self extent:500 @ (calendarView height + 
                      (device verticalPixelPerMillimeter * 10)) rounded.
    calendarView origin:0.0@0.0 corner:0.66@1.0.

    v := ScrollableView for:SelectionInListView in:self.
    v origin:0.66@0.0 corner:1.0@1.0.
    list := v scrolledView.
    list list:#('January' 'February' 'March'
                'April' 'May' 'June' 'July'
                'August' 'September' 'October'
                'November' 'December').

    list action:[:line | self monthSelection:line].
    list middleButtonMenu:(PopUpMenu
                         labels:(Array with:(year - 2) printString
                                       with:(year - 1) printString
                                       with:(year    ) printString
                                       with:(year + 1) printString
                                       with:'other ...')
                      selectors:#(changeYear:
                                  changeYear:
                                  changeYear:
                                  changeYear:
                                  otherYear)
                           args:(Array with:(year - 2)
                                       with:(year - 1)
                                       with:(year    )
                                       with:(year + 1)
                                       with:nil)
                       receiver:self).

    self label:'Calendar'.
    list selection:(Date today month).
    self monthSelection:(Date today month).

    "Modified: 23.4.1996 / 21:19:17 / cg"
! !

!Calendar methodsFor:'user interaction'!

changeYear:aYear
    "change year action (from popup menu)"

    year := aYear.
    list selection notNil ifTrue:[
        self monthSelection:list selection
    ]

    "Modified: 23.4.1996 / 21:20:38 / cg"
!

monthSelection:aMonthNumber
    "month selected (either initially or via menu).
     Read the calendar from a pipe opened to the unix `cal'
     command and forward the text to my caledarView"

    |command p text|

    command := 'cal ' , aMonthNumber printString , ' ' 
                      , year printString.

    p := PipeStream readingFrom:command.
    p atEnd ifTrue:[
        "/ bug workaround for windows - Pipetream should return nil here
        text := #( 'No cal command.' ) asStringCollection.
    ] ifFalse:[ 
        text := p contents.

        "remove blank line at end"
        (text at:(text size)) isEmpty ifTrue:[
            text grow:(text size - 1)
        ].
    ].
    p close.
    calendarView label:text

    "Modified: / 5.9.1998 / 13:53:04 / cg"
!

otherYear
    "other year selected from menu.
     Let user enter some year in a box"

    |box|

    box := EnterBox new title:'year ?'.
    box action:[:s |
        |n|

        n := Integer readFromString:s.
        (n notNil and:[n ~~ 0]) ifTrue:[
            self changeYear:n
        ]
    ].
    box showAtPointer

    "Modified: 23.4.1996 / 21:20:26 / cg"
! !

!Calendar class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/Calendar.st,v 1.13 1999-08-05 11:23:27 cg Exp $'
! !
