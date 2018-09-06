StandardSystemView subclass:#MailView
	instanceVariableNames:'buttonPanel textPanel mailHeaderView mailDocuView mailTextView
		mailImageView infoView faceView mailText printButton saveButton
		deleteButton replyButton fullHeaderTextToggle rescanButton
		mailLabel replyView replyButtonPanel replyEditView
		replySendButton replyAbortButton replyAddressLabel
		replyAddressField replySubjectField replyCCField replyAliasButton
		aliasBox checkBlock mailHandler editViewActive selectedLine
		showFullHeaderText waitCursor numberOfLetters checkInterval'
	classVariableNames:'MailIcon NoMailIcon LetterIcon'
	poolDictionaries:''
	category:'demos-MailTool'
!

MailView comment:'
This mail interface is just a demo - there are many features missing.

To use a POP mailer, set the global MAILSERVER (either ST-global or shell variable)
'!


!MailView class methodsFor:'instance creation'!

new
    MailIcon isNil ifTrue:[
        MailIcon := Image fromFile:'bitmaps/Mail.xbm' resolution:100.
        NoMailIcon := Image fromFile:'bitmaps/NoMail.xbm' resolution:100.
        LetterIcon := Image fromFile:'bitmaps/Letter.xbm' resolution:100
    ].

    ^ super
        label:'Mail'
        icon:NoMailIcon
        minExtent:(100 @ 100)
! !

!MailView class methodsFor:'behavior'!

autoSelectNext
    "returning true here makes the delete function automatically
     select the next entry"

    ^ true
! !

!MailView class methodsFor:'identification'!

versionString
    ^ '0.4'
! !

!MailView class methodsFor:'startup'!

open
    OperatingSystem isUNIXlike ifFalse:[
        Dialog warn:'This demo only works under UNIX.'.
    ].
    ^ super open

    "Modified: / 16.2.2000 / 09:20:27 / cg"
! !

!MailView methodsFor:'initialization'!

initialize
    |panelHeight myWidth myHeight headerHeight textHeight protoButton
     replySubjectLabel replyCCLabel activeReplyField
     enterGroup mm helper mailHost mailFileName|

    super initialize.

    checkInterval := (resources at:'CHECK_INTERVAL' default:'30') asNumber.

    mm := self verticalIntegerPixelPerMillimeter.

    showFullHeaderText := false.
    waitCursor := Cursor wait.

    mailFileName := Smalltalk at:#MAILFILE ifAbsent:nil.
    mailFileName isNil ifTrue:[
        (mailHost := Smalltalk at:#MAILHOST ifAbsent:nil) isNil ifTrue:[
            (mailHost := Smalltalk at:#MAILSERVER ifAbsent:nil) isNil ifTrue:[
                (mailHost := OperatingSystem getEnvironment:'MAILHOST') isNil ifTrue:[
                    mailHost := OperatingSystem getEnvironment:'MAILSERVER'
                ]
            ]
        ].
    ].

    mailHost notNil ifTrue:[
        mailHandler := POPMailHandler forHost:mailHost
    ] ifFalse:[
        mailHandler := MailHandler new.
    ].

    mailHandler isNil ifTrue:[
        self warn:'no mailHandler available'.
    ].

"/    mailHandler := MailHandler new.

"/    numberOfLetters := mailHandler numberOfLetters.
"
    (numberOfLetters == 0) ifTrue:[
        mailLabel := Label form:NoMailIcon
    ] ifFalse:[
        mailLabel := Label form:MailIcon
    ].
"

    protoButton := (Button label:'dummy') action:[self doPrint].
    "
     this horizontalPanel contains the buttons ...
    "
    buttonPanel := HorizontalPanelView in:self.
    buttonPanel horizontalLayout:#leftSpace.   "left adjusted is nicer ...     "
    panelHeight := ((protoButton height) "max:(mailLabel height)" ) + 10.
    buttonPanel origin:(0.0 @ 0.0) extent:(1.0 @ panelHeight).

"
    buttonPanel addSubView:mailLabel.
"

    "
     here are the buttons ...
    "
    printButton := (Button label:(resources string:'print')
                          action:[self doPrint]
                              in:buttonPanel) disable.

"
    saveButton := (Button label:(resources string:'save')
                         action:[self doSave]
                             in:buttonPanel).
"
    deleteButton := (Button label:(resources string:'delete')
                           action:[self doDelete]
                             in:buttonPanel) disable.

    replyButton := (Button label:(resources string:'send/reply')
                          action:[self doReply]
                             in:buttonPanel).

    fullHeaderTextToggle := Toggle label:(resources string:'full-header').
    fullHeaderTextToggle pressAction:[self fullHeaderText].
    fullHeaderTextToggle releaseAction:[self partialHeaderText].
    buttonPanel addSubView:fullHeaderTextToggle.

    rescanButton := (Button label:(resources string:'rescan mail')
                           action:[self doRescan]
                               in:buttonPanel).

    infoView := Label origin:0.0@1.0 corner:1.0@1.0 in:self.
    infoView topInset:(infoView preferredExtent y negated - ViewSpacing).
    infoView bottomInset:ViewSpacing//2.
    infoView horizontalInset:ViewSpacing//2.
    infoView adjust:#left; level:-1.

    "
     a variable panel  for the other subviews ...
    "
    textPanel := VariableVerticalPanel in:self.
    textPanel origin:0.0 @ panelHeight corner:1.0@1.0.
    textPanel bottomInset:(infoView preferredExtent y + ViewSpacing).

    "
     top third contains a list of subject-lines ...
     this list is provided by the mailhandler
     (notice the floats in the origin/extent)
    "
    mailHeaderView := ScrollableView for:SelectionInListView in:textPanel.
    mailHeaderView origin:(0.0 @ 0.0) corner:(1.0 @ 0.25).
"/    mailHeaderView contents:(mailHandler headerLines).
    mailHeaderView action:[:lineNr | self showSelection:lineNr].

    faceView := ImageView origin:(1.0 @ 0.0) corner:(1.0 @ 0.0) in:self.
    faceView level:-1.
    faceView leftInset:(64 + faceView widthIncludingBorder + ViewSpacing) negated;
             bottomInset:(64 + faceView heightIncludingBorder + ViewSpacing) negated;
             topInset:ViewSpacing;
             rightInset:ViewSpacing.
    faceView adjust:#center.
    faceView lower.

    "
     bottom 2-thirds will show the selected mail ...
     normal text is shown in a TextView, Multimedia mail (currently
     NeXT-mail) is shown in a DocumentView which is brought up when
     needed.
    "

    "
     because VariablePanel doesnt like adding & removing views,
     we put the two alternatively visible views into a helper, which
     is managed by the VariablePanel
    "
    helper := View origin:(0.0 @ 0.25) corner:(1.0 @ 1.0) in:textPanel.

    mailTextView := HVScrollableView for:TextView miniScrollerH:true in:helper.
    mailTextView origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).

    "
     prepare for multimedia mail, by creating (invisible)
     documentView
    "
    mailDocuView := HVScrollableView for:DocumentView miniScrollerH:true in:helper.
    mailDocuView origin:(0.0 @ 0.0) corner:(1.0@1.0).
    mailDocuView beInvisible.

    "
     and an (invisible) imageView
    "
    mailImageView := HVScrollableView for:ImageEditView miniScrollerH:true in:helper.
    mailImageView origin:(0.0 @ 0.2) corner:(1.0@1.0).
    mailImageView beInvisible.




    editViewActive := false.
    activeReplyField := nil.

    replyView := StandardSystemView
                      extent:(600 @ 400)
                      label:'Send-Mail'
                      icon:LetterIcon
                      minExtent:(100 @ 100).

    "
     the reply view gets its own button panel
    "
    replyButtonPanel := HorizontalPanelView in:replyView.
    replyButtonPanel horizontalLayout:#leftSpace.   "left adjusted is nicer ...     "
    replyButtonPanel origin:(0.0 @ 0.0)
                     extent:(1.0 @ (protoButton height + 10)).

    "
     and some stuff in it ...
    "
    replySendButton := Button label:(resources string:'send')
                             action:[self doSendReply]
                                 in:replyButtonPanel.

    replyAbortButton := Button label:(resources string:'cancel')
                              action:[self doAbortReply]
                                  in:replyButtonPanel.

    replyAliasButton := Button label:(resources string:'addresses')
                              action:[self doAddressesReply]
                                  in:replyButtonPanel.

    replyAddressLabel := Label in:replyView.
    replyAddressLabel origin:(0.0 @ (replyButtonPanel height)).
    replyAddressLabel label:'reply to:'.
    replyAddressLabel borderWidth:0.

    replySubjectLabel := Label in:replyView.
    replySubjectLabel origin:(0.0 @ (replyAddressLabel origin y
                                   + replyAddressLabel height
                                   + mm)).
    replySubjectLabel label:'subject :'.
    replySubjectLabel borderWidth:0.

    replyCCLabel := Label in:replyView.
    replyCCLabel origin:(0.0 @ (replySubjectLabel origin y
                              + replySubjectLabel height
                              + mm)).
    replyCCLabel label:'cc      :'.
    replyCCLabel borderWidth:0.

    enterGroup := EnterFieldGroup new.

    replyAddressField := EditField
                            origin:((replyAddressLabel origin x + replyAddressLabel width) 
                                    @ 
                                    (replyAddressLabel origin y))
                            extent:[(replyView width
                                     - replyAddressLabel width
                                     - mm)
                                    @ 
                                    (replyAddressLabel height)]
                                in:replyView.
    replyAddressField contents:''.
    replyAddressField disable.
    enterGroup add:replyAddressField.

    replySubjectField := EditField
                            origin:((replyAddressField origin x) 
                                    @ 
                                    (replySubjectLabel origin y))
                            extent:[(replyView width
                                     - replySubjectLabel width
                                     - mm)
                                    @ 
                                    (replySubjectLabel height)]
                                in:replyView.
    replySubjectField contents:''.
    replySubjectField disable.
    enterGroup add:replySubjectField.

    replyCCField := EditField
                            origin:((replyAddressField origin x) 
                                    @ 
                                    (replyCCLabel origin y))
                            extent:[(replyView width
                                     - replyCCLabel width
                                     - mm)
                                    @ 
                                    (replyCCLabel height)]
                                in:replyView.
    replyCCField contents:''.
    replyCCField disable.
    enterGroup add:replyCCField.

    replyEditView := ScrollableView for:MailReplyTextView in:replyView.
    replyEditView origin:[0 
                          @ 
                          (replyCCLabel origin y 
                           + replyCCLabel height
                           + mm + mm)]
                  extent:[replyView width
                          @
                          (replyView height
                           - mm - mm
                           - replyCCLabel origin y
                           - replyCCLabel heightIncludingBorder)].

"/    self checkForAnyMail.

    replyView hiddenOnRealize:true.
    replyView open.
    ^ self

    "Created: 16.11.1995 / 20:52:07 / cg"
    "Modified: 18.6.1996 / 15:58:27 / cg"
!

realize
    |mailHost|

    super realize.

    Processor activeProcess withLowerPriorityDo:[
        self showActivity:'reading your mailbox ...'.
        windowGroup withCursor:Cursor wait do:[
            mailHandler notNil ifTrue:[
                mailHeaderView contents:(mailHandler headerLines).
                numberOfLetters := mailHandler numberOfLetters.
                self checkForAnyMail
            ].
        ].
        self showActivity:''.
    ].
    checkBlock := [self checkForNewMail].

    "
     Smalltalk at:#SMTPMAILHOST put:'axept'
     Smalltalk at:#SMTPMAILHOST put:nil
    "

    "Created: 16.11.1995 / 20:51:30 / cg"
    "Modified: 18.6.1996 / 15:42:57 / cg"
! !

!MailView methodsFor:'private'!

checkForAnyMail
    "set the icon according to basket empty-state"

    (numberOfLetters > 0) ifTrue:[
	"mailLabel form:MailIcon. "
	self icon:MailIcon
    ] ifFalse:[
	"mailLabel form:NoMailIcon. "
	self icon:NoMailIcon
    ]
!

checkForNewMail
    "this is sent every checkInterval secs to check for new mail"

    |currentNumberOfLetters|

    currentNumberOfLetters := mailHandler numberOfLetters.
    (currentNumberOfLetters ~~ numberOfLetters) ifTrue:[
        numberOfLetters := currentNumberOfLetters.
        self showActivity:'reading new mail ...'.
        self icon:MailIcon.
        self doRescan.
        self showActivity:''
    ].
    "trigger next check in checkInterval seconds"
    Processor addTimedBlock:checkBlock afterSeconds:checkInterval

    "Modified: 18.6.1996 / 15:42:20 / cg"
!

showActivity:aMessage
    infoView notNil ifTrue:[
        infoView label:aMessage
    ] ifFalse:[
        self label:'Mail: ' , aMessage
    ].
    device flush.

    "Created: 18.6.1996 / 15:43:27 / cg"
    "Modified: 18.6.1996 / 16:51:38 / cg"
! !

!MailView methodsFor:'user interaction'!

destroy
    "window manager wants MailView to vanish"

    self withWaitCursorDo:[
        Processor removeTimedBlock:checkBlock.
        mailHandler notNil ifTrue:[
            mailHandler needToUpdateMailFile ifTrue:[
                self showActivity:'updating your mailbox ...'.
            ].
            mailHandler release.
        ]
    ].
    aliasBox notNil ifTrue:[aliasBox destroy].
    replyView destroy.
    super destroy

    "Created: 16.11.1995 / 20:52:58 / cg"
    "Modified: 18.6.1996 / 15:42:32 / cg"
!

doAbortReply
    "in the reply view - user clicked abort button"

    self hideReplyView
!

doAddressesReply
    "read & show address alias list"

    |s aliases line box c list|

    s := (OperatingSystem getHomeDirectory , '/.mailrc') asFilename readStream.
    aliases := Dictionary new.
    s notNil ifTrue:[
	[s atEnd] whileFalse:[
	    line := s nextLine.
	    line notNil ifTrue:[
		(line startsWith:'alias') ifTrue:[
		    c := line asCollectionOfWords.
		    aliases at:(c at:2) put:(c at:3).
		]
	    ]
	].
	s close
    ].
    list := OrderedCollection new.
    aliases keysAndValuesDo:[:k :v |
	list add:k
    ].
    "
     launch a box with names
    "
    aliasBox isNil ifTrue:[
	aliasBox := ListSelectionBox new.
	aliasBox title:(resources string:'mail aliases').
    ].
    aliasBox list:list.
    aliasBox action:[:name |
	replyAddressField contents:(aliases at:name ifAbsent:[''])
    ].
    aliasBox showAtPointer
!

doDelete
    "user clicked on delete-button
     delete current mail, and autoselect next mail in list
     if we reached the end of list, go back to previous mail"

    |headers sel|

    selectedLine notNil ifTrue:[
        deleteButton notNil ifTrue:[deleteButton disable].
        printButton notNil ifTrue:[printButton disable].
        saveButton notNil ifTrue:[saveButton disable].
        sel := selectedLine.
        mailHeaderView selection:nil.
        mailHandler deleteMail:sel.
        numberOfLetters := mailHandler numberOfLetters.
        (numberOfLetters == 0) ifTrue:[
            "mailLabel form:NoMailIcon. "
            self icon:NoMailIcon
        ].
        headers := mailHandler headerLines.
        mailHeaderView contents:headers.
        self class autoSelectNext ifTrue:[
            sel > (headers size) ifTrue:[
                sel := sel - 1
            ].
            mailHeaderView selection:sel.
            self showSelection:sel
        ] ifFalse:[
            selectedLine := nil.
            mailTextView contents:nil
        ]
    ].
    ^ self

    "Modified: 21.1.1997 / 23:12:55 / stefan"
!

doPrint
    "user clicked on print-button"

    selectedLine notNil ifTrue:[
	self warn:'gotcha - not implemented'
    ].
    ^ self
!

doReply
    "user clicked on reply-button"

    |subjectLineIndex subject initialText destination|

    selectedLine notNil ifTrue:[
	destination := mailHandler originOf:selectedLine.
	subject := mailHandler subjectOf:selectedLine.
	subject notNil ifTrue:[
	    (subject startsWith:'Re:') ifFalse:[
		subject := 'Re: ' , subject
	    ]
	].
    ].

    destination isNil ifTrue:[
	destination := 'name @ host'
    ].

    deleteButton notNil ifTrue:[deleteButton disable].
    replyButton notNil ifTrue:[replyButton disable].                        

    mailHeaderView disable.

    "
     now, make the replyView visible
    "
    replyAbortButton turnOff.


    replyView hiddenOnRealize:false. replyView realize.

    selectedLine notNil ifTrue:[
	replyEditView originalLetter:(mailHandler letter:selectedLine) 
    ].

    "
     put receivers address into info-label
    "
    selectedLine notNil ifTrue:[
	replyAddressLabel label:'reply to:'
    ] ifFalse:[
	replyAddressLabel label:'send to :'
    ].

    replyAddressField contents:destination.
    subject isNil ifTrue:[
	selectedLine notNil ifTrue:[
	    subject := 'Re: '
	]
    ].
    replySubjectField contents:subject.

    "
     create initial text with subject and 
     mailer id - not my idea - but nice
    "
    initialText := OrderedCollection with:
			 ('X-Mailer: Smalltalk/X ('
			  , Smalltalk versionString
			  , ') MailTool ('
			  , self class versionString 
			  , '), of course').

    replyEditView contents:initialText.
    replyEditView cursorLine:3 col:1.

    editViewActive := true
!

doRescan
    "user wants mail-file to be reread for new mail"

    self withWaitCursorDo:[
	|newHeaders oldSelection|

"
	mailHeaderView selection:nil.
	selectedLine := nil.
	mailTextView contents:nil.
"

	mailHandler scanMailFile.
	newHeaders := mailHandler headerLines.

	oldSelection := mailHeaderView selection.
	mailHeaderView setContents:newHeaders.
	mailHeaderView selection:oldSelection.
    ]
!

doSave
    "user clicked on save-button
     much more work to be done here"

    selectedLine notNil ifTrue:[
	self warn:'gotcha - not implemented'
    ].
    ^ self
!

doSendReply
    "in the reply view - user clicked send button"

    mailHandler sendMail:(replyEditView contents)
		 subject:(replySubjectField contents)
		      cc:(replyCCField contents)
		      to:(replyAddressField contents).

    self hideReplyView

!

fullHeaderText
    "user wants to see all header lines
     this includes all fields inserted by relay stations -"

    showFullHeaderText := true.
    selectedLine notNil ifTrue:[
	self showSelection:selectedLine
    ]
!

hideReplyView
    "make the reply view invisible"

    deleteButton notNil ifTrue:[deleteButton enable].
    replyButton notNil ifTrue:[replyButton enable].
    mailHeaderView enable.
    "
     make the replyView invisible
    "
    replyView unmap. replyView hiddenOnRealize:true. 
    editViewActive := false

    "Modified: 5.9.1996 / 11:37:24 / stefan"
!

partialHeaderText
    "user wants to suppress full header lines
     Thats what I prefer - I'm not very interested in all this relay info"

    showFullHeaderText := false.
    selectedLine notNil ifTrue:[
	self showSelection:selectedLine
    ]
!

showLetter:letter
    (letter type == #rtf) ifTrue:[
        "its a NeXT rtf mail; 
         need DocumentView to show contents of rtf stream..."
        mailTextView beInvisible.
        mailImageView beInvisible.

        mailDocuView contents:nil.
        mailDocuView scrollToTop.
        mailDocuView hiddenOnRealize:false; beVisible; raise.
        mailDocuView fromRTFStream:(ReadStream on:letter contents).
        ^ self
    ].

    (letter type == #multipart) ifTrue:[
        "its a normal mail"
        mailDocuView beInvisible.

        mailTextView corner:(1.0@0.2).

        mailTextView contents:nil.
        mailTextView scrollToTop.
        mailTextView beVisible.
        mailTextView contents:letter parts first contents.

        mailImageView image:nil.
        mailImageView scrollToTopLeft.
        mailImageView image:(letter parts at:2) contents.
"/        mailImageView magnification:0.5.

        mailImageView beVisible.
        ^ self
    ].

    (letter type ~~ #text) ifTrue:[
        "not handled - use contents as text"
        Transcript showCR:('unknown letter type: ' , letter type)
    ].
    "its a normal mail"
    mailDocuView beInvisible.
    mailImageView beInvisible.

    mailTextView contents:nil.
    mailTextView scrollToTop.
    mailTextView corner:(1.0@1.1).
    mailTextView beVisible.
    mailTextView contents:letter contents.

    "Created: 18.6.1996 / 15:36:44 / cg"
    "Modified: 18.6.1996 / 17:00:23 / cg"
!

showSelection:lineNr
    "user clicked on a header line - show selected mail in textView"

    |mailText document letter|

    lineNr isNil ifTrue:[
        printButton disable.
        deleteButton notNil ifTrue:[deleteButton disable].
        saveButton notNil ifTrue:[saveButton disable].
        selectedLine := nil.
        mailTextView contents:nil
    ] ifFalse:[
        lineNr == numberOfLetters ifTrue:[
            self icon:NoMailIcon
        ].

        printButton enable.
        deleteButton notNil ifTrue:[deleteButton enable].
        saveButton notNil ifTrue:[saveButton enable].
        selectedLine := lineNr.

        self withWaitCursorDo:[
            |face|

            showFullHeaderText ifTrue:[
                letter := mailHandler fullLetter:lineNr
            ] ifFalse:[
                letter := mailHandler letter:lineNr
            ].
            letter notNil ifTrue:[
                self showLetter:letter
            ].
            (face := mailHandler faceOf:lineNr) notNil ifTrue:[
                face extent = (48@48) ifFalse:[
                    face := face magnifiedTo:(faceView viewRectangle extent).
                ].    
                faceView image:face.
                faceView raise.
            ] ifFalse:[
                faceView lower.
            ]
        ]
    ].

    self activityNotification:''.

    "Created: 17.11.1995 / 12:51:21 / cg"
    "Modified: 18.6.1996 / 15:46:09 / cg"
    "Modified: 21.1.1997 / 23:08:55 / stefan"
!

withWaitCursorDo:aBlock
    "evaluate aBlock while showing wait-cursor"

    self topView withCursor:waitCursor do:aBlock
! !

!MailView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/MailTool/MailView.st,v 1.23 2000-02-16 08:09:21 cg Exp $'
! !
