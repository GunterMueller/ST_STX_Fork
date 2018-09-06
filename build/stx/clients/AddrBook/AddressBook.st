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

StandardSystemView subclass:#AddressBook
	instanceVariableNames:'labelView listView addressView queryBox readCursor waitCursor
		data fields changed selectedEntry activeField addressFileName'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-AddressBook'
!

!AddressBook class methodsFor:'documentation'!

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

    written spring 90 by claus
"
! !

!AddressBook methodsFor:'initialization'!

initialize
    |frame org v|

    super initialize.
    addressFileName := OperatingSystem getHomeDirectory , '/.addr'.

    self label:'AddressBook'.
    self icon:(Form fromFile:'AddrBook.xbm' resolution:100).

    changed := false.

    self initializeListViewIn:((0.0 @ 0.0) extent:(1.0 @ 0.25)).

    frame := View origin:(0.0 @ 0.25) extent:(1.0 @ 0.75) in:self.
    self initializeSubViewIn:frame.

    readCursor := Cursor read.
    waitCursor := Cursor wait.

    self getAddresses.
    selectedEntry := nil

    "AddressBook start"
!

initializeBigField:name atX:x y:y in:frame
    |l e h|

    h := font height + font descent.
    l := Label origin:(0 @ y)
	       extent:((font widthOf:name) @ h)
	  borderWidth:0
		   in:frame.
    l label:name.

    e := EditField origin:(x @ y)
		   extent:[(frame width - x - 5) @ (h * 6)]
		       in:frame.

    e level: -1.
    e disable.

    ^e
!

initializeField:name atX:x y:y in:frame
    |l e h|
    h := font height + font descent.
    l := Label origin:(0 @ y)
	       extent:((font widthOf:name) @ h)
	  borderWidth:0
		   in:frame.
    l label:name.

    e := EditField origin:(x @ y)
		   extent:[(frame width - x - 5) @ h]
		       in:frame.

    e level: -1.
    e disable.

    ^e
!

initializeListViewIn:aRectangle
    |v|

    v := ScrollableView for:SelectionInListView in:self.
    v origin:aRectangle origin extent:aRectangle extent.
    listView := v scrolledView.
    listView action:[:lineNr | self addressSelect:lineNr].
    self initializeListViewMenu
!

initializeListViewMenu
    listView 
	middleButtonMenu:(PopUpMenu 
				labels:#('remove entry'
					 '-'
					 'file'
					 'save'
					)
			     selectors:#(removeAddress nil changeFile writeAddresses)
			      receiver:self
				   for:listView).
!

initializeSubViewIn:frame
    |x y h l field bigField fieldGroup fieldNames fieldKeys
     title key|

    fieldNames := #('Firma:'
		    'Anrede:' 
		    'Name:' 
		    'Vorname:' 
		    'Strasse:' 
		    'PLZ:' 
		    'Ort:' 
		    'Tel.:' 
		    'Tel. (Buero):' 
		    'Email:' 
		    'Fax:').
    fieldKeys := #(company
		   title
		   name
		   firstName
		   street
		   zip
		   city
		   telno
		   telno2
		   email
		   fax).

    l := Label new.
    l label:'Tel. (Buero)::'.
    x := l width.
    l := nil.

    fieldGroup := EnterFieldGroup new.

    fields := Dictionary new.

    h := ((font height + font descent) * 1.5) asInteger.
    y := ViewSpacing.
    1 to:fieldNames size do:[:i |
	title := fieldNames at:i.
	key := fieldKeys at:i.
	field := (self initializeField:title atX:x y:y in:frame).
	fields at:key put:field.
	fieldGroup add:field.
	y := y + h
    ].

    bigField := (self initializeBigField:'Text:' atX:x y:y in:frame).
    fields at:#text put:bigField.

    fieldGroup add:bigField.
    fieldGroup leaveAction:[self updateEntry].

    frame delegate:fieldGroup "/ (KeyboardForwarder to:fieldGroup)
! !

!AddressBook methodsFor:'private'!

changeFile
    |box nm|

    nm := Dialog 
	requestFileName:'name of address file:' 
	default:addressFileName.
    (nm notNil and:[nm ~= addressFileName]) ifTrue:[
	addressFileName := nm.
	self getAddresses.
    ]
"/
"/    box := FilenameEnterBox new.
"/    addressFileName := box request:'name of address file:'.
"/    addressFileName notNil ifTrue:[
"/        self getAddresses.
"/    ]
!

getAddresses
    |inStream fileName names s line entry fax title
     company name firstName street zip city telno telno2 email text key|

    names := StringCollection new.
    data := OrderedCollection new.
    fileName := addressFileName.
    inStream := FileStream readonlyFileNamed:fileName.
    inStream notNil ifTrue:[
	[inStream atEnd] whileFalse:[
	    line := inStream nextLine.
	    line notNil ifTrue:[
		(line isBlank or:[line startsWith:'#']) ifFalse:[
		    company := nil. name := nil. firstName := nil.
		    street := nil. zip := nil. title := nil.
		    city := nil. telno := nil. 
		    telno2 := nil. email := nil. fax := nil. text := nil.
		    s := ReadStream on:line.
		    company := s nextChunk.
		    company notNil ifTrue:[
		     title := s nextChunk.
		     title notNil ifTrue:[
		      name := s nextChunk.
		      name notNil ifTrue:[
			firstName := s nextChunk.
			firstName notNil ifTrue:[
			  street := s nextChunk.
			  street notNil ifTrue:[
			    zip := s nextChunk.
			    zip notNil ifTrue:[
			      city := s nextChunk.
			      city notNil ifTrue:[
				telno := s nextChunk.
				telno notNil ifTrue:[
				  telno2 := s nextChunk.
				  telno2 notNil ifTrue:[
				    email := s nextChunk.
				    email notNil ifTrue:[
				      fax := s nextChunk.
				      fax notNil ifTrue:[
					text := s nextChunk withCRs
				      ]
				    ]
				  ]
				]
			      ]
			     ]
			    ]
			  ]
			]
		      ]
		    ].
		    entry := Dictionary new.
		    entry at:#company put:company.
		    entry at:#title put:title.
		    entry at:#name put:name.
		    entry at:#firstName put:firstName.
		    entry at:#street put:street.
		    entry at:#zip put:zip.
		    entry at:#city put:city.
		    entry at:#telno put:telno.
		    entry at:#telno2 put:telno2.
		    entry at:#email put:email.
		    entry at:#fax put:fax.
		    entry at:#text put:text.
		    names add:(self keyFor:entry).
		    data add:entry
		]
	    ]
	].
	inStream close
    ].
    listView contents:(names sortWith:data)
!

keyFor:entry
    |company name firstName key|


    company := entry at:#company.
    (company isNil or:[company isBlank]) ifTrue:[
	name := entry at:#name.
	firstName := entry at:#firstName.
	(firstName isNil or:[firstName isBlank]) ifTrue:[
	    key := name
	] ifFalse:[
	    key := (name , ', ' , firstName)
	]
    ] ifFalse:[
	key := company
    ].
    ^ key
!

removeAddress
    "if any change, ask if user wants to ignore"

    |newList|

    selectedEntry isNil ifTrue:[^ self].

    fields do:[:aField |
	aField modified:true
    ].

    newList := listView list.
    newList removeIndex:selectedEntry.
    data removeIndex:selectedEntry.
    listView list:newList.
    listView makeLineVisible:selectedEntry
!

saveChangedEntryConfirm:confirm
    "if any change, ask if user wants to ignore"

    |changed newValue entry newEntry save newList l|

    confirm ifTrue:[
	selectedEntry isNil ifTrue:[^ true]
    ].
    changed := false.
    fields do:[:aField |
	aField modified ifTrue:[
	    changed := true
	]
    ].
    changed ifTrue:[
	confirm ifTrue:[
	    save := DialogView confirmWithCancel:'save changes ?'.
	    save == nil ifTrue:[^ false].
	] ifFalse:[
	    save := true
	].
	save ifTrue:[
	    selectedEntry notNil ifTrue:[
		entry := data at:selectedEntry.
		((fields at:#name) contents = (entry at:#name)) ifFalse:[
		    entry := Dictionary new.
		    newEntry := true
		] ifTrue:[
		    newEntry := false
		]
	    ] ifFalse:[
		entry := Dictionary new.
		newEntry := true
	    ].
	    newValue := (fields at:#company) contents.
	    entry at:#company put:newValue.
	    newValue := (fields at:#title) contents.
	    entry at:#title put:newValue.
	    newValue := (fields at:#name) contents.
	    entry at:#name put:newValue.
	    newValue := (fields at:#firstName) contents.
	    entry at:#firstName put:newValue.
	    newValue := (fields at:#street) contents.
	    entry at:#street put:newValue.
	    newValue := (fields at:#zip) contents.
	    entry at:#zip put:newValue.
	    newValue := (fields at:#city) contents.
	    entry at:#city put:newValue.
	    newValue := (fields at:#telno) contents.
	    entry at:#telno put:newValue.
	    newValue := (fields at:#telno2) contents.
	    entry at:#telno2 put:newValue.
	    newValue := (fields at:#email) contents.
	    entry at:#email put:newValue.
	    newValue := (fields at:#fax) contents.
	    entry at:#fax put:newValue.
	    newValue := (fields at:#text) contents.
	    entry at:#text put:newValue.
	    newEntry ifTrue:[
		data add:entry.
		newList := (listView list add:(self keyFor:entry))
	    ] ifFalse:[
		newList := listView list.
		newList at:selectedEntry put:(self keyFor:entry)
	    ].
	    newList sortWith:data.
	    l := listView firstLineShown.
	    listView list:newList.
	    listView makeLineVisible:l. 
	    fields do:[:aField |
		aField modified:false
	    ]
	]
    ].
    ^ true
!

updateEntry
    "update current entry if any change"
    self saveChangedEntryConfirm:false
!

writeAddresses
    |outStream fileName savedListViewCursor|

    fileName := addressFileName.
    outStream := FileStream newFileNamed:fileName.
    outStream isNil ifTrue:[
	self notify:'cannot update address data file'
    ] ifFalse:[
	self cursor:Cursor write.
	savedListViewCursor := listView cursor.
	listView cursor:Cursor write.
	data do:[:entry |
	    self writeEntry:(entry at:#company) on:outStream.
	    self writeEntry:(entry at:#title) on:outStream.
	    self writeEntry:(entry at:#name) on:outStream.
	    self writeEntry:(entry at:#firstName) on:outStream.
	    self writeEntry:(entry at:#street) on:outStream.
	    self writeEntry:(entry at:#zip) on:outStream.
	    self writeEntry:(entry at:#city) on:outStream.
	    self writeEntry:(entry at:#telno) on:outStream.
	    self writeEntry:(entry at:#telno2) on:outStream.
	    self writeEntry:(entry at:#email) on:outStream.
	    self writeEntry:(entry at:#fax) on:outStream.
	    self writeEntry:(entry at:#text) withoutCRs on:outStream.
	    outStream cr
	].
	outStream close.
	self cursor:Cursor normal.
	listView cursor:savedListViewCursor.
    ]
!

writeEntry:entry on:outStream
    (entry isNil or:[entry = '']) ifTrue:[
	outStream nextChunkPut:' '
    ] ifFalse:[
	outStream nextChunkPut:(entry printString)
    ]
! !

!AddressBook methodsFor:'release'!

destroy
    queryBox notNil ifTrue:[
	queryBox destroy
    ].
    super destroy
! !

!AddressBook methodsFor:'user interaction'!

addressSelect:lineNr
    |entry|

    (self saveChangedEntryConfirm:true) ifFalse:[^ self].

    selectedEntry := lineNr.
    entry := data at:selectedEntry.

    #(company title name firstName 
      street zip city telno telno2
      email fax text)
    do:[:key |
	(entry includesKey:key) ifTrue:[
	    (fields at:key) contents:(entry at:key)
	]
    ].
    fields do:[:aField |
	aField modified:false
    ].
    activeField notNil ifTrue:[
	activeField disable.
	activeField := nil
    ].
    listView makeLineVisible:lineNr
! !

!AddressBook class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/AddrBook/AddressBook.st,v 1.9 1996-05-10 13:32:07 cg Exp $'
! !
