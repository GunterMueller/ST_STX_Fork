StandardSystemView subclass:#NewsView
	instanceVariableNames:'menu newsGroupView newsHeaderView newsTextView replyButton
		replyView replyEditView replyAddressField editViewActive
		selectedGroupLine selectedHeaderLine showFullHeaderText
		newsHandler mailHandler selectedGroup selectedArticle articles
		newsText waitCursor fileBox infoLabel groupsShown articlesShown
		showEmpty fontPanel groupBgTask subjectBgTask initializing
		numArticlesInGroup numUnread searchBox searchPattern
		nntpServerName'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-NewsTool'
!

!NewsView class methodsFor:'documentation'!

documentation
"
    this class implements a news browser.
    It works together with a NewsHandler object, which does all
    the file-I/O to/from the real news-file(s).
    The newsHandler may also be an NNTPHandler, which connects
    to an nntp socket.
    To get NNTP, either set a shell variable NNTPSERVER or
    a smalltalk global #NNTPSERVER to the name of the nntp host.
    (usually, this is done in your .login / .profile or .bashrc)

    written summer 90 by claus

    [see also:]
        NewsHandler NNTPHandler

    [author:]
        Claus Gittinger

    [start with:]
        NewsView open
"
! !

!NewsView class methodsFor:'instance creation'!

new
    ^ super
        label:'News'
        icon:(Image fromFile:'bitmaps/News.xbm' resolution:100)
        minExtent:(100 @ 100)
! !

!NewsView methodsFor:'initialization'!

initMenu
    |labels f family style face size|

    menu labels:(resources array:#('file' 
                                   'edit' 
                                   'find' 
                                   'group' 
                                   'article'))
         selectors:#(
                     file
                     edit
                     find
                     group
                     article
                    ).

    menu at:#file 
            putLabels:(resources array:#(
                        'archivate' 
                        'save as ...' 
                        'filter ...' 
                        '-' 
                        'update' 
                        'reconnect' 
                        '-' 
                        'print'
                        '-' 
                        'update .newsrc'
                        '-' 
                        'quit'
                        'quit without updating .newsrc'
                       ))
            selectors:#(doArchivate
                        doSaveAs 
                        doFilter
                        nil
                        doRescan
                        reconnect
                        nil
                        doPrint
                        nil
                        doUpdateNewsRc
                        nil
                        finish
                        finishNoUpdate)
             receiver:self.

    menu at:#edit 
            putLabels:(resources array:#(
                        'copy' 
                        'cut' 
                        'paste'))
            selectors:#(copySelection deleteSelection pasteBuffer)
             receiver:self.

    menu at:#find 
            putLabels:(resources array:#(
                        'next with subject' 
                        'prev with subject' 
                        'first with subject'
                        '-' 
                        'next from author' 
                        'prev from author' 
                      ))
            selectors:#(showNextWithSubject showPrevWithSubject showFirstWithSubject
                        nil showNextWithAuthor showPrevWithAuthor)
             receiver:self.

    menu at:#group 
            putLabels:(resources array:#(
                        'subscribe ...' 
                        '-' 
                        'mark all read' 
                        'mark all unread' 
                        '-' 
                        'show all groups'
                        'show empty groups'
                        '-' 
                        'goto group ...'
                      ))
            selectors:#(subscribeDialog
                        nil 
                        markAllRead
                        markAllUnread
                        nil 
                        showAllGroups
                        showEmptyGroups
                        nil 
                        gotoGroup
                       )
             receiver:self.

    menu at:#article 
            putLabels:(resources array:#(
                        'mark read' 
                        'mark unread' 
                        '-' 
                        'mark subject read' 
                        'mark subject unread' 
                        '-' 
                        'mark author read' 
                        'mark author unread' 
                        '-' 
                        'show all articles'
                      ))
            selectors:#(markRead 
                        markUnread
                        nil 
                        markSubjectRead
                        markSubjectUnread
                        nil 
                        markAuthorRead
                        markAuthorUnread
                        nil 
                        showAllArticles
                       )
             receiver:self.

"/    family := resources name:'MENU_FONTFAMILY' default:'helvetica'.
"/    face := resources name:'MENU_FONTFACE' default:'bold'.
"/    style := resources name:'MENU_FONTSTYLE' default:'roman'.
"/    size := resources name:'MENU_FONTSIZE' default:12.
"/    f := Font family:family face:face style:style size:size.
"/    f notNil ifTrue:[
"/        menu font:f.
"/        1 to:5 do:[:i |
"/            (menu menuAt:i) font:f
"/        ]
"/    ]

    "Created: 20.10.1995 / 20:16:52 / cg"
    "Modified: 12.4.1996 / 13:35:46 / stefan"
    "Modified: 2.2.1997 / 05:34:07 / cg"
!

initialize
    |panelHeight myWidth myHeight headerHeight textHeight protoButton
     panel topPanel nextButton prevButton v bwn
     nextWithSubjectButton buttonPanel replyButtonPanel
     replySendButton replyAbortButton replyAddressLabel|

    super initialize.

    waitCursor := Cursor wait.

    showFullHeaderText := false.

    groupsShown := #subscribed.
    articlesShown := #unread.
    showEmpty := false.

    menu := PullDownMenu in:self.

    self initMenu.

    protoButton := (Button label:'dummy').

    "
     this horizontalPanel contains the buttons ...
    "
    bwn := borderWidth negated.
    buttonPanel := HorizontalPanelView in:self.
    buttonPanel horizontalLayout:#leftSpace.   "left adjusted is nicer ...     "
    buttonPanel origin:(0.0 "bwn" @ (menu height + 2))
                extent:(1.0 @ (protoButton height * 2)).

    nextButton := ArrowButton downIn:buttonPanel.
    nextButton action:[self showNextUnread].
    prevButton := ArrowButton upIn:buttonPanel.
    prevButton action:[self showPrevUnread].
    nextWithSubjectButton := (Button label:(resources string:'next with subject')
                        action:[self showNextWithSubject]
                            in:buttonPanel).

    "
     and the info label ...
    "
    infoLabel := Label in:buttonPanel.
    infoLabel borderWidth:0.

    "
     a frame for the other subviews ...
    "
    panel := VariableVerticalPanel origin:(0.0 "bwn" @ (buttonPanel origin y + buttonPanel height))
                                   extent:[width @ (height - menu height - buttonPanel height)] 
                                       in:self.

    topPanel := VariableHorizontalPanel 
                    origin:(0.0 @ 0.0) corner:(1.0 @ 0.2) in:panel.

    "
     top contains a list of newsgroups ...
    "
    v := HVScrollableView for:SelectionInListView miniScrollerH:true miniScrollerV:false in:topPanel.
    v origin:(0.0 @ 0.0) corner:(0.25 @ 1.0).
    v action:[:lineNr | self groupSelection:lineNr].
    newsGroupView := v scrolledView.

    "
     next comes a list of subjects ...
    "
    v := HVScrollableView for:SelectionInListView miniScrollerH:true miniScrollerV:false in:topPanel.
    v origin:(0.25 @ 0.0) corner:(1.0 @ 1.0).
    v action:[:selection | self messageSelection:selection first].
    newsHeaderView := v scrolledView.
    newsHeaderView multipleSelectOk:true.

    newsHeaderView middleButtonMenu:(PopUpMenu 
                                         labels:(resources array:#('search'))
                                      selectors:#(searchSubject)
                                       receiver:self
                                            for:newsHeaderView).

    "beside, add keyboard commands for searching"
    newsHeaderView addActionForKey:#FindNext action:[self searchFwd:searchPattern].
    newsHeaderView addActionForKey:#FindPrev action:[self searchBwd:searchPattern].
    newsHeaderView addActionForKey:#Find action:[self searchSubject].

    "
     view for the message itself
    "
    v := HVScrollableView for:TextView miniScrollerH:true miniScrollerV:false in:panel.
    v origin:(0.0 @ 0.2) corner:(1.0 @ 1.0).
    newsTextView := v scrolledView.

    "
     the reply view is created here, but made invisible by putting
     its origin below visible region ...
    "
    editViewActive := false.

    replyView := StandardSystemView new.

    "
     the reply view gets its own button panel
    "
    replyButtonPanel := HorizontalPanelView in:replyView.
    replyButtonPanel horizontalLayout:#leftSpace.   "left adjusted is nicer ...     "
    replyButtonPanel origin:(0 @ 0)
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

    replyAddressLabel := Label in:replyView.
    replyAddressLabel origin:(0 @ (replyButtonPanel height)).
    replyAddressLabel label:(resources string:'reply to:').
    replyAddressLabel height:(replyButtonPanel height).
    replyAddressLabel borderWidth:0.

    replyAddressField := EditField
                            origin:(0 @ (replyButtonPanel height))
                            extent:(1.0 @ (replyAddressLabel width))
                                in:replyView.
    replyAddressField contents:''.

    "
     (notice the blocks in the origin/extent - they allow more
      complicated size evaluations)
    "
    replyEditView := ScrollableView for:EditTextView in:replyView.
    replyEditView origin:(0 @ (replyButtonPanel height * 2))
                  extent:[replyView width
                          @
                          (replyView height
                           - replyButtonPanel heightIncludingBorder
                           - replyAddressLabel heightIncludingBorder)]

    "
     NewsView start
     Smalltalk at:#NNTPSERVER put:'nntp-host'. NewsView start
     Smalltalk at:#NNTPSERVER put:'axept'. NewsView start
     Smalltalk at:#NNTPSERVER put:'exept'. NewsView start
    "

    "Modified: 26.9.1995 / 09:56:38 / stefan"
    "Modified: 2.2.1997 / 05:33:40 / cg"
!

realize
    "read newsGroups when realizeing - since it takes so long"

    |useNNTP|

    super realize.
    useNNTP := 'NNTPSERVER' knownAsSymbol 
               and:[Smalltalk includesKey:'NNTPSERVER' asSymbol].
    useNNTP ifTrue:[
        nntpServerName := Smalltalk at:#NNTPSERVER.
    ] ifFalse:[
        useNNTP := (nntpServerName := OperatingSystem getEnvironment:'NNTPSERVER') notNil.
    ].

    useNNTP ifTrue:[
        self label:('News: connecting to ' , nntpServerName , ' ...').
        newsHandler := NNTPHandler new.
        self withWaitCursorDo:[
            newsHandler connectTo:nntpServerName.
        ].
    ] ifFalse:[
        newsHandler := NewsHandler new.
        newsHandler hasNews ifFalse:[
            self information:'news seem not to be setup on this host.
(i.e. no newsDirectory and/or active file found)

If you have an NNTP server in your network, 
set the (smalltalk-) global NNTPSERVER to the name of that host
and open a new newsReader.'
        ]
    ].
    self normalLabel.

    newsHandler notNil ifTrue:[
        newsHandler hasNewsrc ifFalse:[
            (menu menuAt:#group) selectorAt:(resources string:'show all groups') put:#showSubscribedGroups.
            (menu menuAt:#group) labelAt:#showSubscribedGroups "(resources string:'show all groups')" put:(resources string:'show subscribed groups').
            groupsShown := #nonempty.

            self information:'no .newsrc file; I will subscribe to all nonempty groups.

Please unsubscribe from groups as desired,
after I have finished reading groups.'.

        ]
    ].

    self showGroupsInBackground

    "Modified: 10.5.1996 / 11:21:14 / cg"
! !

!NewsView methodsFor:'messages'!

activityNotification:aMessage
    self label:'News: ' , aMessage

    "Created: 26.2.1996 / 14:21:25 / cg"
    "Modified: 26.2.1996 / 14:21:46 / cg"
! !

!NewsView methodsFor:'private'!

anyInterestingArticlesIn:aGroup
    (newsHandler anyArticlesIn:aGroup) ifFalse:[^ false].

    (articlesShown == #unread) ifTrue:[
        ^ newsHandler anyUnreadArticlesIn:aGroup
    ].
    ^ newsHandler anyArticlesIn:aGroup

    "Modified: 10.5.1996 / 10:14:05 / cg"
!

findUnreadArticleBetween:startIndex and:endIndex
    "return the index of an unread article in the current
     subject list; nil if there is none"

    |step readRange|

    selectedGroup isNil ifTrue:[^ nil].
    ((newsHandler numberOfArticlesIn:selectedGroup) == 0) ifTrue:[^ nil].
    ((newsHandler numberOfUnreadArticlesIn:selectedGroup) == 0) ifTrue:[^ nil].
    readRange := newsHandler readRangeOf:selectedGroup.

    startIndex >= endIndex ifTrue:[
	step := -1
    ] ifFalse:[
	step := 1
    ].

    startIndex to:endIndex by:step do:[:thisIndex |
	(readRange includes:(articles at:thisIndex)) ifFalse:[
	    ^ thisIndex
	]
    ].
    ^ nil

    "Modified: 26.9.1995 / 09:40:42 / stefan"
!

findUnreadArticleWithSubject:aSubject between:startIndex and:endIndex
    "return the index of an unread article in the current
     subject list with subject; nil if there is none"

    |readRange s rs thisArticle thisSubject step|

    selectedGroup isNil ifTrue:[^ nil].
    ((newsHandler numberOfArticlesIn:selectedGroup) == 0) ifTrue:[^ nil].
    readRange := newsHandler readRangeOf:selectedGroup.

    (aSubject startsWith:'Re: ') ifTrue:[
	rs := aSubject.
	s := aSubject copyFrom:5
    ] ifFalse:[
	rs := 'Re: ' , aSubject.
	s := aSubject
    ].

    startIndex >= endIndex ifTrue:[
	step := -1
    ] ifFalse:[
	step := 1
    ].

    startIndex to:endIndex by:step do:[:thisIndex |
	thisArticle := articles at:thisIndex.
	(readRange includes:thisArticle) ifFalse:[
	    thisSubject := newsHandler articleSubjectOf:thisArticle in:selectedGroup.
	    ((thisSubject = s) or:[thisSubject = rs]) ifTrue:[
		^ thisIndex
	    ]
	]
    ].
    ^ nil
!

firstUnreadArticleWithSubject:aSubject
    "return the index of the firstunread article in the current
     subject list with subject; nil if there is none"

    ^ self findUnreadArticleWithSubject:aSubject between:1 and:newsHeaderView list size
!

getGroups
    "get groups for group-list"

    |list|

    self withCursor:Cursor wait do:[
        self label:'News - reading groups ...'.
        (groupsShown == #subscribed) ifTrue:[
            list := newsHandler subscribedGroups
        ] ifFalse:[
            (groupsShown == #nonempty) ifTrue:[
                list := newsHandler newsGroups
            ]
        ].
        list := ( (list ? #()) collect:[:group | group name]) asOrderedCollection.
        list sort.
        self normalLabel.
    ].
    ^ list

    "Created: / 26.10.1995 / 14:55:38 / cg"
    "Modified: / 16.2.2000 / 09:22:34 / cg"
!

indexOfLineStartingWith:aPattern in:aCollection
    "answer the index of the first line starting with the argument, aString"

    |index|

    index := 1.
    [index < aCollection size] whileTrue:[
	((aCollection at:index) startsWith:aPattern) ifTrue:[
	    ^ index
	].
	index := index + 1
    ].
    ^ 0
!

nextUnreadArticle
    "return the index of the next unread article in the current
     subject list; nil if there is none"

    |startIndex|

    selectedHeaderLine isNil ifTrue:[
	startIndex := 1
    ] ifFalse:[
	(selectedHeaderLine isKindOf:Collection) ifTrue:[
	    startIndex := selectedHeaderLine at:1
	] ifFalse:[
	    startIndex := selectedHeaderLine
	]
    ].
    ^ self findUnreadArticleBetween:startIndex and:newsHeaderView list size
!

nextUnreadArticleWithSubject:aSubject
    "return the index of the next unread article in the current
     subject list with subject; nil if there is none"

    |startIndex|

    selectedHeaderLine isNil ifTrue:[
	startIndex := 1
    ] ifFalse:[
	(selectedHeaderLine isKindOf:Collection) ifTrue:[
	    startIndex := selectedHeaderLine at:1
	] ifFalse:[
	    startIndex := selectedHeaderLine
	]
    ].

    ^ self findUnreadArticleWithSubject:aSubject between:startIndex and:newsHeaderView list size
!

normalLabel
    selectedGroup notNil ifTrue:[
	self label:('News: ' , selectedGroup).
    ] ifFalse:[
	self label:'News'
    ]

    "Created: 26.10.1995 / 16:03:27 / cg"
!

numberOfInterestingArticlesIn:aGroup
    (articlesShown == #unread) ifTrue:[
	^ newsHandler numberOfUnreadArticlesIn:aGroup
    ].
    ^ newsHandler numberOfArticlesIn:aGroup
!

prevUnreadArticle
    "return the index of the prev unread article in the current
     subject list; or nil, if there is none"

    |startIndex|

    selectedHeaderLine isNil ifTrue:[
	startIndex := newsHeaderView list size
    ] ifFalse:[
	(selectedHeaderLine isKindOf:Collection) ifTrue:[
	    startIndex := selectedHeaderLine at:(selectedHeaderLine size)
	] ifFalse:[
	    startIndex := selectedHeaderLine
	]
    ].
    ^ self findUnreadArticleBetween:startIndex and:1
!

prevUnreadArticleWithSubject:aSubject
    "return the index of the prev unread article in the current
     subject list with subject; nil if there is none"

    |startIndex|

    selectedHeaderLine isNil ifTrue:[
	startIndex := newsHeaderView list size
    ] ifFalse:[
	(selectedHeaderLine isKindOf:Collection) ifTrue:[
	    startIndex := selectedHeaderLine at:1
	] ifFalse:[
	    startIndex := selectedHeaderLine
	]
    ].

    ^ self findUnreadArticleWithSubject:aSubject between:startIndex and:1 
!

selectedArticlesDo:aBlock
    selectedArticle notNil ifTrue:[
	(selectedArticle isKindOf:Collection) ifTrue:[
	    selectedArticle do:[:anArticle |
		aBlock value:anArticle
	    ]
	] ifFalse:[
	    aBlock value:selectedArticle
	]
    ]
!

showArticle:articleNumber
    self withWaitCursorDo:[
	selectedArticle := articleNumber.
	newsText := newsHandler article:selectedArticle in:selectedGroup.
	newsTextView contents:newsText
    ]
!

showGroups
    "show groups in group-list"

    |list newList|

    groupBgTask notNil ifTrue:[
	"scanning in background ..."
	self notify:'Please wait until reading is done.'.
	^ self
    ].

    Processor activeProcess withLowerPriorityDo:[
	list := self getGroups.
    ].

    showEmpty ifFalse:[
	newList := OrderedCollection new.
	list do:[:aGroup |
	    (self anyInterestingArticlesIn:aGroup) ifTrue:[
		newList add:aGroup
	    ]
	].
	list := newList
    ].
    newsGroupView contents:list

    "Created: 26.10.1995 / 14:53:47 / cg"
    "Modified: 26.10.1995 / 15:47:21 / cg"
!

showGroupsInBackground
    "show groups in group-list; this one starts showing all,
     then starts a background action to remove all uninteresting stuff ...
     This makes startup much faster and also allows immediate user interaction "

    |list newList aGroup endIndex index n|

    groupBgTask notNil ifTrue:[
        "scanning in background ..."
        self notify:'Please wait until reading is done.'.
        ^ self
    ].
    initializing := true.

    Processor activeProcess withLowerPriorityDo:[
        list := self getGroups.
    ].

    list := list select:[:group | (newsHandler quickEmptyGroupCheck:group) not].

    newsGroupView contents:list.

    "then start a background-task to remove all empty/fully read groups from the list"

    groupBgTask :=
    [
        endIndex := list size.
        index := 1.
        n := 1.

        [index <= endIndex] whileTrue:[
            aGroup := list at:index.
            self activityNotification:('reading ' , aGroup).
        
            (self anyInterestingArticlesIn:aGroup) ifFalse:[
                newsHandler unsubscribeFrom:aGroup.
                newsGroupView removeIndex:index.
                endIndex := endIndex - 1.
            ] ifTrue:[
                newsHandler subscribeTo:aGroup.
                index := index + 1
            ].
            n := n + 1.
            n >= 5 ifTrue:[
                Processor yield.
                n := 0.
            ].
        ].

        self activityNotification:''.
        groupBgTask := nil.
    ] forkAt:(Processor userBackgroundPriority)

    "Created: 26.10.1995 / 14:52:26 / cg"
    "Modified: 10.5.1996 / 09:45:02 / cg"
!

showSubjects
    |headers range nunread num allArticles unreadArticles
     wantArticle index endIndex article header firstAvail
     firstRead lastRead first last nDeleted prevFirst prevLast idx1 idx2 i visibleChanged|

    selectedGroup isNil ifTrue:[^ nil].

    self normalLabel.

    newsTextView contents:nil.
    newsHeaderView setAttributes:nil.
    numArticlesInGroup := newsHandler numberOfArticlesIn:selectedGroup.

    (numArticlesInGroup == 0) ifTrue:[
        infoLabel label:'0 articles.'.
        numUnread := 0.
        newsHeaderView contents:nil.
        ^ self
    ].

    range := newsHandler readRangeOf:selectedGroup.
    range isNil ifTrue:[
        "/ never read ...
        range := NumberSet with:0
    ].
    allArticles := newsHandler articlesIn:selectedGroup.

    nDeleted := 0.
    allArticles size ~~ numArticlesInGroup ifTrue:[
        nDeleted := numArticlesInGroup - allArticles size.

        infoLabel label:(numArticlesInGroup printString , ' article(s); ',
                         nDeleted printString , ' deleted.').

        (allArticles size == 0) ifTrue:[
            numUnread := 0.
            newsHeaderView contents:nil.
            ^ self
        ].
    ].

    infoLabel label:(numArticlesInGroup printString , ' article(s).').
    device flush.

    "consider all articles before first available as read"
    firstAvail := allArticles at:1.
    firstRead := range first.
    (firstRead isNil or:[firstRead < firstAvail]) ifTrue:[
        (firstRead isNil or:[range lastOfFirstInterval < (firstAvail - 1)]) ifTrue:[
            firstRead isNil ifTrue:[
                first := 1.
                last := firstAvail - 1
            ] ifFalse:[
                first := range lastOfFirstInterval + 1.
                last := firstAvail - 1
            ].
            Transcript showCR:('mark ' , 
                               first printString , '..' , last printString ,
                               ' as read').
            first to:last do:[:nr |
                range add:nr
            ]
        ]
    ].

    "reuse header-list"
    headers := newsHeaderView list.
    headers isNil ifTrue:[
        headers := OrderedCollection new:(articles size)
    ].
    headers grow:0.
    nunread := 0.
    unreadArticles := OrderedCollection new.

    (articlesShown == #all) ifTrue:[
        allArticles do:[:anArticle |
            headers add:('Article ' , anArticle printString)
        ]
    ] ifFalse:[
        allArticles do:[:anArticle |
            (range isNil or:[(range includes:anArticle) not]) ifTrue:[
                nunread := nunread + 1.
                wantArticle := true.
                unreadArticles add:anArticle
            ] ifFalse:[
                wantArticle := false
            ].
            wantArticle ifTrue:[
                headers add:('Article ' , anArticle printString)
            ]
        ]
    ].
    newsHeaderView contents:headers.
    newsHeaderView scrollToBottom.

    (articlesShown == #all) ifTrue:[
        articles := allArticles.
        infoLabel label:(numArticlesInGroup printString , ' article(s).')
    ] ifFalse:[
        infoLabel label:(numArticlesInGroup printString , ' article(s); '
                         , nunread printString , ' unread.').
        articles := unreadArticles
    ].
    numUnread := nunread.
    endIndex := articles size.

    "start a background block to read headers (which can take a while)"

    "stop any old background job"
    self terminateSubjectReader.

    subjectBgTask := 
    [
        |step firstShown lastShown nShown hdr|

        index := 1.
        endIndex := articles size.

        [index <= endIndex] whileTrue:[
            "first consider lines currently visible - if visible range has changed"

            i := nil.
            firstShown := newsHeaderView firstLineShown.
            lastShown := newsHeaderView lastLineShown.

            idx1 := firstShown.      "the visible lines"
            idx2 := lastShown min:endIndex.
            (prevFirst ~~ idx1 or:[prevLast ~~ idx2]) ifTrue:[
                step := 1.
                (idx2 == endIndex or:[prevFirst notNil and:[idx2 <= prevFirst]]) ifTrue:[
                    "last first - looks better"
                    i := idx1.
                    idx1 := idx2.
                    idx2 := i.
                    i := nil.
                    step := -1.
                ].
                idx1 to:idx2 by:step do:[:idx |
                    i isNil ifTrue:[
                        hdr := newsHeaderView at:idx.
                        (hdr notNil and:[hdr startsWith:'Article']) ifTrue:[
                            "found an ungrabbed - take this one first"
                            i := idx
                        ]
                    ]
                ].
                i isNil ifTrue:[
                    prevFirst := idx1.
                    prevLast := idx2.
                ]
            ].

            i isNil ifTrue:[
                "visible lines already grabbed, grab some lines above and below"

                nShown := lastShown - firstShown + 1.

                idx1 := (firstShown - nShown) max:1.
                idx2 := (firstShown - 1) max:1.
                idx2 to:idx1 by:-1 do:[:idx |
                    i isNil ifTrue:[
                        ((newsHeaderView at:idx) startsWith:'Article') ifTrue:[
                            "found an ungrabbed - take this one first"
                            i := idx
                        ]
                    ]
                ].

                i isNil ifTrue:[
                    idx1 := (lastShown + 1) min:endIndex.
                    idx2 := (lastShown + nShown) min:endIndex.
                    idx1 to:idx2 do:[:idx |
                        i isNil ifTrue:[
                            ((newsHeaderView at:idx) startsWith:'Article') ifTrue:[
                                "found an ungrabbed - take this one first"
                                i := idx
                            ]
                        ]
                    ].
                ].
            ].

            i isNil ifTrue:[
                "visible lines already grabbed, continue with where we left off ..."
                i := index
            ].

            article := articles at:i.
            header := newsHandler articleHeaderSummaryOf:article in:selectedGroup.
            header isNil ifTrue:[
                "/
                "/ an article which is gone ...
                "/
'selection before: ' print. selectedHeaderLine printNL.
selectedHeaderLine notNil ifTrue:[
    'article: ' print. (articles at:selectedHeaderLine) printNL.
].
'removing: ' print. i printNL.
                articles removeIndex:i.
                newsHeaderView removeIndex:i.

                "adjust selection if any"
                selectedHeaderLine notNil ifTrue:[
                    selectedHeaderLine := newsHeaderView selection first.
                ].
'selection after: ' print. selectedHeaderLine printNL.
selectedHeaderLine notNil ifTrue:[
    'article: ' print. (articles at:selectedHeaderLine) printNL.
].
                newsHeaderView redraw.

                endIndex := endIndex - 1.
                nDeleted := nDeleted + 1.
                range add:article

            ] ifFalse:[
                newsHeaderView at:i put:header.
                i == index ifTrue:[
                    index := index + 1
                ]
            ].
            Processor yield.
        ].
        nDeleted ~~ 0 ifTrue:[
            infoLabel label:(numArticlesInGroup printString , ' article(s); ',
                             nDeleted printString , ' deleted.').
        ].
        subjectBgTask := nil.
    ] forkAt:(Processor userBackgroundPriority + 1).

    "Modified: 16.4.1996 / 12:42:21 / stefan"
    "Modified: 10.5.1996 / 10:37:12 / cg"
!

terminateSubjectReader
    "stop any old background job"

    subjectBgTask notNil ifTrue:[
        newsHandler critical:[
            subjectBgTask terminate.
            subjectBgTask := nil
        ].
    ].

    "Created: 10.5.1996 / 10:36:04 / cg"
!

updateInfo
    (numArticlesInGroup == 0) ifTrue:[
	infoLabel label:'0 articles.'
    ] ifFalse:[
	infoLabel label:(numArticlesInGroup printString , ' article(s).').
	(articlesShown == #all) ifTrue:[
	    infoLabel label:(numArticlesInGroup printString , ' article(s).')
	] ifFalse:[
	    infoLabel label:(numArticlesInGroup printString , ' article(s); '
			     , numUnread printString , ' unread.')
	]
    ]
! !

!NewsView methodsFor:'release'!

destroy
    "update .newsrc and finish"

    self doUpdateNewsRc.
    self finishNoUpdate
!

finish
    "update .newsrc and finish"

    self destroy
!

finishNoUpdate
    "finish without updating .newsrc"

    groupBgTask notNil ifTrue:[
        newsHandler critical:[
            groupBgTask terminate.
            groupBgTask := nil
        ].
    ].
    self terminateSubjectReader.

    newsHandler notNil ifTrue:[
        newsHandler release.
        newsHandler := nil
    ].
    fontPanel notNil ifTrue:[fontPanel destroy].
    fileBox notNil ifTrue:[fileBox destroy].
    super destroy

    "Modified: 12.4.1996 / 12:09:19 / stefan"
    "Modified: 10.5.1996 / 10:36:31 / cg"
!

terminate
    "exit NewsTool"

    "anyChange ifFalse:[^ self destroy]. "

    (DialogBox
        confirm:(resources string:'update .newsrc and close ?') withCRs
        title:(resources string:'exiting NewsView')
        yesLabel:(resources string:'ok')
        noLabel:(resources string:'cancel')
    ) ifTrue:[
        self destroy
    ].

    "Modified: 9.5.1996 / 17:38:58 / cg"
! !

!NewsView methodsFor:'subject search'!

searchBwd:aPattern
    "search backward for subject in subject list - if found, select it"

    |firstIndex|

    aPattern isNil ifTrue:[^ self searchSubject].

    selectedHeaderLine isNil ifTrue:[
	firstIndex := newsHeaderView list size
    ] ifFalse:[
	(selectedHeaderLine isKindOf:Collection) ifTrue:[
	    firstIndex := selectedHeaderLine last
	] ifFalse:[
	    firstIndex := selectedHeaderLine
	]
    ].
    searchPattern := aPattern.
    newsHeaderView searchBackwardFor:aPattern 
		      startingAtLine:firstIndex col:1
		     ifFound:[:line :col |
				  newsHeaderView selection:line.
				  self messageSelection:line]
		     ifAbsent:[]
!

searchFwd:aPattern
    "search forward for subject in subject list - if found, select it"

    |firstIndex|

    aPattern isNil ifTrue:[^ self searchSubject].

    selectedHeaderLine isNil ifTrue:[
	firstIndex := 1
    ] ifFalse:[
	(selectedHeaderLine isKindOf:Collection) ifTrue:[
	    firstIndex := selectedHeaderLine at:1 + 1
	] ifFalse:[
	    firstIndex := selectedHeaderLine + 1
	]
    ].
    searchPattern := aPattern.
    newsHeaderView searchForwardFor:aPattern 
		     startingAtLine:firstIndex col:1
		     ifFound:[:line :col |
				  newsHeaderView selection:line.
				  self messageSelection:line]
		     ifAbsent:[]
!

searchSubject
    "show a box to enter searchpattern"

    selectedGroup isNil ifTrue:[^ self].
    searchBox isNil ifTrue:[
	searchBox := 
	    EnterBox2
	       title:'search pattern in subjects:'
	     okText1:'prev'
	     okText2:'next'
	   abortText:'abort'
	     action1:[:pattern | self searchBwd:(pattern withoutSeparators)]
	     action2:[:pattern | self searchFwd:(pattern withoutSeparators)]
    ].
    searchPattern notNil ifTrue:[
	searchBox initialText:searchPattern
    ].
    searchBox showAtPointer
! !

!NewsView methodsFor:'user interaction'!

copySelection
    newsTextView copySelection
!

deleteSelection
    ^ self

!

doAbortReply
    "in the reply view - user clicked abort button"

    self hideReplyView
!

doArchivate
    "save the current selected article in the archive;
     if the article does not contain an archive-name, ask for a name."

    |aFileName realArticles archiveName|

    self withWaitCursorDo:[
	self selectedArticlesDo:[:anArticle |
	    aFileName := newsHandler articleArchiveNameOf:anArticle
						       in:selectedGroup.
	    aFileName isNil ifTrue:[
		"kludge"
		realArticles := selectedArticle.
		selectedArticle := anArticle.
		self doSaveAs.
		selectedArticle := realArticles
	    ] ifFalse:[
		archiveName := OperatingSystem getEnvironment:'ARCHIVE'.
		archiveName isNil ifTrue:[
		    archiveName := (OperatingSystem getHomeDirectory) , '/archive'
		].
		self label:('News: ' , selectedGroup, ' - saving ' , aFileName , ' ...').
		aFileName := archiveName , '/' , aFileName.
		self save:anArticle as:aFileName
	    ]
	]
    ].
    self label:('News: ' , selectedGroup).
!

doPrint
    "user clicked on print-button"

    ^ self
!

doReply
    "user clicked on reply-button"

    |subjectLineIndex subject initialText destination|

    subject := 'Subject:'.
    (selectedHeaderLine isKindOf:Number) ifTrue:[
        destination := newsHandler originOf:selectedHeaderLine.
        subjectLineIndex := self indexOfLineStartingWith:'Subject:' in:newsText.
        (subjectLineIndex ~~ 0) ifTrue:[
            subject := newsText at:subjectLineIndex.
            (subject startsWith:'Subject: Re:') ifFalse:[
                subject := 'Subject: Re:'
                           , (subject copyFrom:9 to:(subject size))
            ]
        ]
    ] ifFalse:[
        destination := 'name@host'
    ].

    replyButton disable.

    newsGroupView disable.
    newsHeaderView disable.

    "
     make the text view smaller
    "
    newsTextView extent:(1.0 @ 0.3).

    "
     now, make the replyView visible
    "
    replyView origin:(0.0 @ 0.6) extent:(1.0 @ 0.4).

    "
     put receivers address into info-label
    "
    replyAddressField contents:destination.

    "
     create initial text with subject and 
     mailer id - not my idea - but nice
    "
    initialText := OrderedCollection
                        with:subject
                        with:('X-Newser: Smalltalk/X ('
                              , Smalltalk version
                              , ') NewsTool ('
                              , self class revision
                              , '), of course').

    replyEditView contents:initialText.
    replyEditView cursorLine:4 col:1.

    editViewActive := true

    "Modified: 10.5.1996 / 09:51:04 / cg"
!

doRescan
    "user wants a rescan for new news"

    |groups|

    self withWaitCursorDo:[
	newsGroupView selection:nil.
	newsHeaderView selection:nil.
	selectedGroupLine := nil.
	selectedHeaderLine := nil.
	newsGroupView contents:nil.
	newsHeaderView contents:nil.

	newsHandler scanNewsGroups.
	groups := newsHandler newsGroups.
	newsGroupView contents:groups
    ]
!

doSaveAs
    "user clicked on save-button; ask for file - then save"

    self label:('News: ' , selectedGroup, ' - saving').
    fileBox isNil ifTrue:[
	fileBox := FileSelectionBox
			title:(resources string:'save file:')
			okText:(resources string:'save')
			abortText:(resources string:'abort')
			action:[nil]
    ].
    fileBox title:(resources string:'save file:').
    fileBox action:[:fileName | 
	self label:('News: ' , selectedGroup, ' - saving ' , fileName , ' ...').
	self saveAs:fileName.
	self label:('News: ' , selectedGroup).
    ].
    fileBox okText:(resources string:'save').
    fileBox showAtPointer
!

doSendReply
    "in the reply view - user clicked send button"

    |receiverOfMail|

    mailHandler isNil ifTrue:[
	MailHandler notNil ifTrue:[
	    mailHandler := MailHandler new
	]
    ].
    receiverOfMail := replyAddressField contents.
    mailHandler notNil ifTrue:[
	mailHandler sendMail:(replyEditView contents) to:receiverOfMail
    ].

    self hideReplyView
!

doUpdateNewsRc
    "update newsrc only - needed when two newsreaders
     are running at the same time"

    self label:'News: updating .newsrc ...'.
    Cursor write showWhile:[
	newsHandler updateNewsrc.
    ].
    self normalLabel.

    "Created: 26.10.1995 / 16:04:42 / cg"
    "Modified: 26.10.1995 / 16:05:20 / cg"
!

gotoGroup
    |b|

    b := ListSelectionBox
		    title:(resources string:'Group to switch to:')
		    okText:(resources string:'goto')
		    abortText:(resources string:'abort')
		    action:[:aString | self gotoGroup:aString].
    b list:(newsHandler newsGroups asSortedCollection).
    b showAtPointer
!

gotoGroup:aGroup
    |headers numArticles oldTitle newTitle mSel|

    editViewActive ifFalse:[
	(newsGroupView list includes:aGroup) ifFalse:[
	    newsGroupView list:(newsGroupView list copyWith:aGroup)
	].

	newsGroupView selectElement:aGroup.
	selectedGroupLine := newsGroupView selection.
	selectedHeaderLine := nil.

	self withWaitCursorDo:[
	    selectedGroup := newsGroupView selectionValue.
	    selectedGroup notNil ifTrue:[
		self showSubjects.
	    ]
	]
    ]

    "Created: 20.10.1995 / 20:41:42 / cg"
!

groupSelection:aLineNr
    "user clicked on a group line - show subjects in headerView
     but ignore it, if he's currently editing a reply"

    |headers numArticles oldTitle newTitle mSel|

    (aLineNr == selectedGroupLine) ifTrue:[^ self].

    editViewActive ifFalse:[
        self terminateSubjectReader.

        selectedGroupLine := aLineNr.
        selectedHeaderLine := nil.
        self withWaitCursorDo:[
            selectedGroup := newsGroupView selectionValue.
            selectedGroup notNil ifTrue:[
                self showSubjects.
            ]
        ]
    ]

    "Created: 20.10.1995 / 20:41:32 / cg"
    "Modified: 12.4.1996 / 12:08:26 / stefan"
    "Modified: 10.5.1996 / 10:36:52 / cg"
!

hideEmptyGroups
    "want to see all non empty groups"

    showEmpty ifTrue:[
	self withWaitCursorDo:[
	    |currentGroup subMenu|

	    subMenu := menu menuAt:#group.
	    subMenu labelAt:#hideEmptyGroups put:(resources string:'show empty groups').
	    subMenu selectorAt:#hideEmptyGroups put:#showEmptyGroups.
	    showEmpty := false. 

	    currentGroup := selectedGroup.
	    self showGroups.
	    currentGroup notNil ifTrue:[
		newsGroupView selectElement:currentGroup
	    ]
	]
    ]

    "Created: 20.10.1995 / 20:37:54 / cg"
    "Modified: 26.10.1995 / 15:52:07 / cg"
!

hideReplyView
    "make the reply view invisible"

    replyButton enable.
    newsGroupView enable.
    newsHeaderView enable.
    "
     make the replyView invisible and the mailtextView big again
    "
    newsTextView extent:(1.0 @ 0.7).
    replyView origin:(0.0 @ 1.0).
    editViewActive := false
!

markAllRead
    "mark all articles in current group as read"

    self withWaitCursorDo:[
	newsHandler markReadAllArticlesInGroup:selectedGroup.
	newsHeaderView attributeAt:(newsHeaderView list size) put:#halfIntensity.
	1 to:newsHeaderView list size do:[:index |
	    newsHeaderView attributeAt:index put:#halfIntensity
	].
	numUnread := 0.
	self updateInfo
    ]
!

markAllUnread
    "mark all articles in current group as still unread"

    newsHandler readRangeOf:selectedGroup put:nil.
    newsHeaderView setAttributes:nil.
    numUnread := numArticlesInGroup.
    self updateInfo
!

markAuthorRead
    |author thisAuthor range article|

    self withWaitCursorDo:[
	range := newsHandler readRangeOf:selectedGroup.
	self selectedArticlesDo:[:anArticle |
	    author := newsHandler articleAuthorOf:anArticle in:selectedGroup.
	    author notNil ifTrue:[
		1 to:(articles size) do:[:index |
		    article := articles at:index.
		    thisAuthor := newsHandler articleAuthorOf:article
							   in:selectedGroup.
		    (author = thisAuthor) ifTrue:[
			(range includes:article) ifFalse:[
			    range add:article.
			    newsHeaderView attributeAt:index put:#halfIntensity.
			    numUnread := numUnread - 1
			]
		    ]
		]
	    ]
	].
	newsHandler readRangeOf:selectedGroup put:range.
	self updateInfo
    ]
!

markAuthorUnread
    |author thisAuthor range article|

    self withWaitCursorDo:[
	range := newsHandler readRangeOf:selectedGroup.
	self selectedArticlesDo:[:anArticle |
	    author := newsHandler articleAuthorOf:anArticle in:selectedGroup.
	    author notNil ifTrue:[
		1 to:(articles size) do:[:index |
		    article := articles at:index.
		    thisAuthor := newsHandler articleAuthorOf:article
							   in:selectedGroup.
		    (author = thisAuthor) ifTrue:[
			(range includes:article) ifTrue:[
			    range remove:article.
			    newsHeaderView attributeAt:index put:nil.
			    numUnread := numUnread + 1
			]
		    ]
		]
	    ]
	].
	newsHandler readRangeOf:selectedGroup put:range.
	self updateInfo
    ]
!

markRead
    |range index|

    range := newsHandler readRangeOf:selectedGroup.
    self selectedArticlesDo:[:article |
        (range includes:article) ifFalse:[
            newsHandler markArticleRead:article inGroup:selectedGroup.

"/            range add:article.
            index := articles indexOf:article.
            newsHeaderView attributeAt:index put:#halfIntensity.
            numUnread := numUnread - 1
        ]
    ].
"/    newsHandler readRangeOf:selectedGroup put:range.
    self updateInfo

    "Modified: 10.5.1996 / 11:44:19 / cg"
!

markSubjectRead
    |s list rs thisSubject range article|

    self withWaitCursorDo:[
	range := newsHandler readRangeOf:selectedGroup.
	self selectedArticlesDo:[:anArticle |
	    s := newsHandler articleSubjectOf:anArticle in:selectedGroup.
	    s notNil ifTrue:[
		(s startsWith:'Re: ') ifTrue:[
		    rs := s.
		    s := s copyFrom:5
		] ifFalse:[
		    rs := 'Re: ' , s
		].
		1 to:(articles size) do:[:index |
		    article := articles at:index.
		    thisSubject := newsHandler articleSubjectOf:article
							     in:selectedGroup.
		    ((rs = thisSubject) or:[s = thisSubject]) ifTrue:[
			(range includes:article) ifFalse:[
			    range add:article.
			    newsHeaderView attributeAt:index put:#halfIntensity.
			    numUnread := numUnread - 1
			]
		    ]
		]
	    ]
	].
	newsHandler readRangeOf:selectedGroup put:range.
	self updateInfo
    ]
!

markSubjectUnread
    |s list rs thisSubject range article|

    self withWaitCursorDo:[
	range := newsHandler readRangeOf:selectedGroup.
	self selectedArticlesDo:[:anArticle |
	    s := newsHandler articleSubjectOf:anArticle in:selectedGroup.
	    s notNil ifTrue:[
		(s startsWith:'Re: ') ifTrue:[
		    rs := s.
		    s := s copyFrom:5
		] ifFalse:[
		    rs := 'Re: ' , s
		].
		1 to:(articles size) do:[:index |
		    article := articles at:index.
		    thisSubject := newsHandler articleSubjectOf:article
							     in:selectedGroup.
		    ((rs = thisSubject) or:[s = thisSubject]) ifTrue:[
			(range includes:article) ifTrue:[
			    range remove:article.
			    newsHeaderView attributeAt:index put:nil.
			    numUnread := numUnread + 1
			]
		    ]
		]
	    ]
	].
	newsHandler readRangeOf:selectedGroup put:range.
	self updateInfo
    ]
!

markUnread
    |sel range|

    range := newsHandler readRangeOf:selectedGroup.
    self selectedArticlesDo:[:article |
	(range includes:article) ifTrue:[
	    range remove:article.
	    numUnread := numUnread + 1
	]
    ].
    self updateInfo.
    sel := newsHeaderView selection.
    (sel isKindOf:Collection) ifTrue:[
	newsHeaderView selection do:[:index |
	    newsHeaderView attributeAt:index put:nil
	]
    ] ifFalse:[
	newsHeaderView attributeAt:sel put:nil
    ]
!

messageSelection:selection
    "user clicked on a subject line - show selected article in textView
     but ignore it, if he's currently editing a reply"

    |article range header|

    editViewActive ifFalse: [
        selectedHeaderLine := selection.
        selection notNil ifTrue:[
            (selection isKindOf:Collection) ifFalse:[
                article := articles at:selection.


                self showArticle:article.

                ((newsHeaderView at:selection) startsWith:'Article') ifTrue:[
                    header := newsHandler articleHeaderSummaryOf:article in:selectedGroup.
                    header notNil ifTrue:[
                        newsHeaderView at:selection put:header.
                    ]
                ].

                self markRead.
"/                newsHeaderView attributeAt:selection put:#halfIntensity.
"/                range := newsHandler readRangeOf:selectedGroup.
"/                (range notNil and:[(range includes:article)]) ifFalse:[
"/                    range add:article.
"/                    numUnread := numUnread - 1.
"/                    self updateInfo
"/                ]
            ] ifTrue:[
                selectedArticle := OrderedCollection new.
                selection do:[:sel |
                    article := articles at:sel.
                    selectedArticle add:article
                ].
                newsTextView contents:nil
            ]
        ]
    ]

    "Modified: 10.5.1996 / 11:45:05 / cg"
!

pasteSelection
    ^ self
!

reconnect
    |serverName handler|

    nntpServerName notNil ifTrue:[
        serverName := Dialog request:'connect to (NNTP-server) ?'
                       initialAnswer:nntpServerName.
        serverName isEmpty ifFalse:[
            self label:('News: connecting to ' , serverName , ' ...').
            handler := NNTPHandler new.
            self withWaitCursorDo:[
                self doUpdateNewsRc.
                (handler connectTo:serverName) ifTrue:[
                    newsHandler := handler.
                    nntpServerName := serverName.
                ]
            ].
            self label:('News: connected to ' , nntpServerName).
        ] 
    ]

    "Created: 10.5.1996 / 11:20:03 / cg"
    "Modified: 10.5.1996 / 12:29:11 / cg"
!

save:article as:aFileName
    "save an article in a file"

    |aStream oldStream over text dirName create|

    oldStream := FileStream readonlyFileNamed:aFileName.
    oldStream notNil ifTrue:[
	oldStream close.
	over := self confirm:(aFileName , ' exists. overwrite ?').
	over ifFalse:[
	    ^ self
	]
    ].
    aStream := FileStream newFileNamed:aFileName.
    aStream isNil ifTrue:[
	dirName := OperatingSystem directoryNameOf:aFileName.
	(OperatingSystem isDirectory:dirName) ifFalse:[
	    create := self confirm:(dirName , ' does not exist. create ?').
	    create ifTrue:[
		OperatingSystem recursiveCreateDirectory:dirName
	    ]
	].
	aStream := FileStream newFileNamed:aFileName
    ].
    aStream isNil ifTrue:[
	self notify:('cannot create ' , aFileName).
	^ self
    ].
    text := newsHandler article:article in:selectedGroup.
    text do:[:aLine |
	aLine notNil ifTrue:[
	    aStream nextPutAll:aLine
	].
	aStream cr
    ].
    aStream close
!

saveAs:aFileName
    "save the current selected article in a file"

    self save:selectedArticle as:aFileName
!

showAllArticles
    "want to see all articles"

    |currentArticle|

    self withWaitCursorDo:[
	(menu menuAt:#article) selectorAt:(resources string:'show all articles') put:#showUnreadArticles.
	(menu menuAt:#article) labelAt:(resources string:'show all articles') put:(resources string:'show unread articles').
	articlesShown := #all.
    
	currentArticle := newsHeaderView selectionValue.
	self showSubjects.
	currentArticle notNil ifTrue:[
	    newsHeaderView selectElement:currentArticle
	]
    ]

    "Created: 26.10.1995 / 15:51:42 / cg"
!

showAllGroups
    "want to see all groups"

    |currentGroup|

    self withWaitCursorDo:[
	(menu menuAt:#group) labelAt:#showAllGroups put:(resources string:'show subscribed groups').
	(menu menuAt:#group) selectorAt:#showAllGroups put:#showSubscribedGroups.
	groupsShown := #nonempty.

	currentGroup := selectedGroup.
	self showGroups.
	currentGroup notNil ifTrue:[
	    newsGroupView selectElement:currentGroup
	]
    ]

    "Created: 20.10.1995 / 20:41:03 / cg"
    "Modified: 26.10.1995 / 15:48:50 / cg"
!

showEmptyGroups
    "want to see all groups including empty ones"

    showEmpty ifFalse:[
	self withWaitCursorDo:[
	    |currentGroup subMenu|

	    subMenu := menu menuAt:#group.
	    subMenu labelAt:#showEmptyGroups put:(resources string:'hide empty groups').
	    subMenu selectorAt:#showEmptyGroups put:#hideEmptyGroups.
	    showEmpty := true. 

	    currentGroup := selectedGroup.
	    self showGroups.
	    currentGroup notNil ifTrue:[
		newsGroupView selectElement:currentGroup
	    ]
	]
    ]

    "Created: 20.10.1995 / 20:34:28 / cg"
    "Modified: 26.10.1995 / 15:51:55 / cg"
!

showFirstWithSubject
    "find first article with same subject or reply of it.
     if found, switch to it, otherwise simply return"

    |subject articleIndex|

    selectedGroup isNil ifTrue:[^ self].
    subject isNil ifTrue:[
	(selectedArticle isKindOf:Number) ifFalse:[^ self].
	subject := newsHandler articleSubjectOf:selectedArticle in:selectedGroup
    ].
    subject isNil ifTrue:[^ self].

    self withWaitCursorDo:[
	articleIndex := self firstUnreadArticleWithSubject:subject
    ].
    articleIndex notNil ifTrue:[
	newsHeaderView selection:articleIndex.
	self messageSelection:articleIndex.
	^ articleIndex
    ]
!

showNextUnread
    "find a group with unread articles, switch there and select the first unread
     article; if there is none, simply return"

    |firstGroup groupIndex articleIndex endIndex|

    selectedGroup isNil ifTrue:[
	"start in first group"
	groupIndex := 1.
	selectedHeaderLine := nil
    ] ifFalse:[
	groupIndex := newsGroupView selection
    ].

    firstGroup := groupIndex.  "keep group we started with"
    endIndex := newsGroupView list size.

    newsGroupView list size == 0 ifTrue:[
	^ self
    ].

    [true] whileTrue:[
	newsGroupView selection:groupIndex.
	self groupSelection:groupIndex.
	selectedGroup := newsGroupView selectionValue.
	articleIndex := self nextUnreadArticle.
	articleIndex notNil ifTrue:[
	    newsHeaderView selection:articleIndex.
	    self messageSelection:articleIndex.
	    ^ articleIndex
	].
	(groupIndex == endIndex) ifTrue:[
	    groupIndex := 1
	] ifFalse:[
	    groupIndex := groupIndex + 1
	].
	(groupIndex == firstGroup) ifTrue:[^ nil]
    ]
!

showNextWithAuthor
    self notify:'not yet implemented'
!

showNextWithSubject
    "find next article with same subject or reply of it.
     if found, switch to it, otherwise simply return"

    |subject articleIndex|

    selectedGroup isNil ifTrue:[^ self].
    subject isNil ifTrue:[
	(selectedArticle isKindOf:Number) ifFalse:[^ self].
	subject := newsHandler articleSubjectOf:selectedArticle in:selectedGroup
    ].
    subject isNil ifTrue:[^ self].

    self withWaitCursorDo:[
	articleIndex := self nextUnreadArticleWithSubject:subject
    ].
    articleIndex notNil ifTrue:[
	newsHeaderView selection:articleIndex.
	self messageSelection:articleIndex.
	^ articleIndex
    ]
!

showPrevUnread
    |numArticles sel|


    selectedHeaderLine isNil ifTrue:[
	selectedGroup notNil ifTrue:[
	    numArticles := newsHandler numberOfUnreadArticlesIn:selectedGroup.
	    numArticles == 0 ifFalse:[
		newsHeaderView selectPrevious.
		sel := newsHeaderView selection first.
		sel notNil ifTrue:[self messageSelection:sel].
		^ self
	    ]
	]
    ].
    ((selectedHeaderLine isNil) or:[selectedHeaderLine == 1]) ifTrue:[
	"select prev group"
	newsGroupView selectPrevious.
	self groupSelection:(selectedGroupLine - 1).
	selectedGroup isNil ifTrue:[^ self].

	numArticles := newsHandler numberOfUnreadArticlesIn:selectedGroup.
	[numArticles == 0] whileTrue:[
	    device flush.
	    newsGroupView selectPrevious.

	    self groupSelection:(selectedGroupLine - 1).
	    numArticles := newsHandler numberOfUnreadArticlesIn:selectedGroup
	]
    ].
    newsHeaderView selectPrevious.
    sel := newsHeaderView selection first.
    sel notNil ifTrue:[self messageSelection:sel].
    ^sel.

    "Modified: 26.9.1995 / 09:54:43 / stefan"
!

showPrevWithAuthor
    self notify:'not yet implemented'
!

showPrevWithSubject
    "find prev article with same subject or reply of it.
     if found, switch to it, otherwise simply return"

    |subject articleIndex|

    selectedGroup isNil ifTrue:[^ self].
    subject isNil ifTrue:[
	(selectedArticle isKindOf:Number) ifFalse:[^ self].
	subject := newsHandler articleSubjectOf:selectedArticle in:selectedGroup
    ].
    subject isNil ifTrue:[^ self].

    self withWaitCursorDo:[
	articleIndex := self prevUnreadArticleWithSubject:subject
    ].
    articleIndex notNil ifTrue:[
	newsHeaderView selection:articleIndex.
	self messageSelection:articleIndex.
	^ articleIndex
    ]
!

showSubscribedGroups
    "want to see subscribed groups"

    |currentGroup|

    self withWaitCursorDo:[
	(menu menuAt:#group) labelAt:#showSubscribedGroups put:(resources string:'show all groups').
	(menu menuAt:#group) selectorAt:#showSubscribedGroups put:#showAllGroups.
	groupsShown := #subscribed.
	self showGroups.

	currentGroup := selectedGroup.
	self showGroups.
	currentGroup notNil ifTrue:[
	    newsGroupView selectElement:currentGroup
	]
    ]

    "Created: 20.10.1995 / 20:40:41 / cg"
    "Modified: 26.10.1995 / 15:51:02 / cg"
!

showUnreadArticles
    "want to see unread articles"

    |currentArticle|

    self withWaitCursorDo:[
	(menu menuAt:#article) selectorAt:(resources string:'show unread articles') put:#showAllArticles.
	(menu menuAt:#article) labelAt:(resources string:'show unread articles') put:(resources string:'show all articles').
	articlesShown := #unread.
    
	currentArticle := newsHeaderView selectionValue.
	self showSubjects.
	currentArticle notNil ifTrue:[
	    newsHeaderView selectElement:currentArticle
	]
    ]

    "Created: 26.10.1995 / 15:51:32 / cg"
!

subscribeDialog
    "want to subscribe to group"

    |box l unsubscribed m scr|

    box := ListSelectionBox new.
    box noEnterField.

"/    box := DialogBox new.

    self label:'News - reading groups ...'.
    m := MultiSelectionInList new.
    m list:(newsHandler newsGroups).
    m selection:(newsHandler unsubscribedGroups).
    self normalLabel.

"/    l := SelectionInListView new.
    l := box listView.
    l model:m.
    l strikeOut:true; toggleSelect:true; multipleSelectOk:true.

"/    scr := ScrollableView forView:l.
"/    scr extent:(1.0 @ 300).

"/    box addComponent:scr.
"/    box addAbortButton; addOkButton.
    box openModal.

    box accepted ifTrue:[
	unsubscribed := m selection asSet.
	newsHandler newsGroups do:[:group |
	    newsHandler subscribe:(unsubscribed includes:group) not to:group
	].
	self showGroups
    ]

    "Created: 25.10.1995 / 21:05:41 / cg"
    "Modified: 26.10.1995 / 17:12:16 / cg"
!

subscribeGroup
    "want to subscribe to group"

    |b|

"/    selectedGroup isNil ifTrue:[
	b := ListSelectionBox
		    title:(resources string:'Group to subscribe to:')
		    okText:(resources string:'subscribe')
		    abortText:(resources string:'abort')
		    action:[:aString | newsHandler subscribe:true to:aString].
	self label:'News - reading groups ...'.
	b list:(newsHandler unsubscribedGroups asSortedCollection).
	self normalLabel.
	b showAtPointer
"/    ] ifFalse:[
"/        (newsHandler isSubscribed:selectedGroup) ifFalse:[
"/            newsHandler subscribe:true to:selectedGroup.
"/        ]
"/    ]

    "Created: 25.10.1995 / 21:05:41 / cg"
    "Modified: 26.10.1995 / 16:06:28 / cg"
!

unsubscribeGroup
    "want to subscribe to group"

    |b|

"/    selectedGroup isNil ifTrue:[
	b := ListSelectionBox
		    title:(resources string:'Group to unsubscribe from:')
		    okText:(resources string:'unsubscribe')
		    abortText:(resources string:'abort')
		    action:[:aString | newsHandler subscribe:false to:aString].
	b list:(newsHandler subscribedGroups asSortedCollection).
	b showAtPointer
"/    ] ifFalse:[
"/        (newsHandler isSubscribed:selectedGroup) ifTrue:[
"/            newsHandler subscribe:false to:selectedGroup.
"/        ]
"/    ]

    "Created: 25.10.1995 / 21:05:52 / cg"
    "Modified: 26.10.1995 / 16:06:45 / cg"
! !

!NewsView class methodsFor:'documentation'!

version
"
$Header: /cvs/stx/stx/clients/NewsTool/NewsView.st,v 1.22 2000-02-16 08:11:52 cg Exp $
"
! !
