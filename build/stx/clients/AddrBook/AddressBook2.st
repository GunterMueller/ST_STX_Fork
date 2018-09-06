"
 COPYRIGHT (c) 1993 by Claus Gittinger
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

AddressBook subclass:#AddressBook2
	instanceVariableNames:''
	classVariableNames:'ZipCodes'
	poolDictionaries:''
	category:'demos-AddressBook'
!

!AddressBook2 class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
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
    a little demo application (an AddressBook)
    with nice taps.

    written spring 90 by claus
"
! !

!AddressBook2 methodsFor:'initialization'!

initZipCodes
    ZipCodes := Dictionary new.
    ZipCodes at:'Boennigheim'          put:74357.
    ZipCodes at:'Germering'            put:82110.
!

initialize
    super initialize.
    self minExtent:565@475.
    listView delegate:(KeyboardForwarder to:self).
    ZipCodes isNil ifTrue:[
	self initZipCodes
    ]
!

initializeListViewIn:aRectangle
    |v lv al bwn|

    v := View in:self.
    v origin:aRectangle origin corner:aRectangle corner.

    lv := InitialLabelView in:v.
    lv font:((Font family:'courier'
		    face:'bold'
		   style:'roman'
		    size:10) on:lv device).

    bwn := lv borderWidth negated.

    lv origin:(bwn @ bwn) corner:(1.0 @ lv height).
    lv action:[:char | self listViewSelection:char].

    al := ScrollableView for:SelectionInListView in:v.
    bwn := al borderWidth negated.
    al origin:(bwn @ (lv height + bwn))
       extent:[v width @ (v height - lv height - lv borderWidth "- al borderWidth"
				   )].

    listView := al scrolledView.
    listView action:[:lineNr | self addressSelect:lineNr].
    self initializeListViewMenu
!

initializeSubViewIn:frame
    |av|

    av := AddressView origin:0.0@0.0 corner:1.0@1.0 in:frame.
    fields := av fields.
    av leaveAction:[self updateEntry. (fields at:#company) enable].
!

realize
     super realize.
    (fields at:#title) middleButtonMenu:(
	PopUpMenu labels:#('Herrn'
			   'Frau'
			   'Fraeulein'
			   'Familie'
			   'Firma')
	       selectors:#(setTitle:
			   setTitle:
			   setTitle:
			   setTitle:
			   setTitle:)
		    args:#('Herr'
			   'Frau'
			   'Fraeulein'
			   'Familie'
			   'Firma')
		receiver:self
		     for:(fields at:#title)
    ).
    (fields at:#city) middleButtonMenu:(
	PopUpMenu labels:#('Boennigheim'
			   'Germering'
			   )
	       selectors:#(setZIPandCity:
			   setZIPandCity:)
		    args:#('Boennigheim'
			   'Germering')
		receiver:self
		     for:(fields at:#city)
    )
! !

!AddressBook2 methodsFor:'user actions'!

canHandle:key
   ^ (key isKindOf:Character) and:[key isLetter]
!

keyPress:key x:x y:y
   ((key isKindOf:Character) and:[key isLetter]) ifTrue:[
       self listViewSelection:key
   ]
!

listViewSelection:key
    |line|

    line := listView list indexOfLineStartingWith:(key asUppercase asString).
    line == 0 ifTrue:[
	line := listView list indexOfLineStartingWith:(key asLowercase asString).
    ].
    line == 0 ifFalse:[
	listView makeLineVisible:line.
	listView selection:line.
	self addressSelect:line
    ]
!

setTitle:aString
    (fields at:#title) contents:aString
!

setZIPandCity:aCityName
    (fields at:#city) contents:aCityName.
    (ZipCodes includesKey:aCityName) ifTrue:[
	(fields at:#zip) contents:(ZipCodes at:aCityName) printString
    ]
! !

!AddressBook2 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/AddrBook/AddressBook2.st,v 1.8 1996-05-10 13:32:10 cg Exp $'
! !
