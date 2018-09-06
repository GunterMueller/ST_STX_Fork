Object subclass:#NewsHandler
	instanceVariableNames:'listOfNewsGroups subscriptionKnown cachedSubjects
		firstInCurrentGroup lastInCurrentGroup'
	classVariableNames:'SpoolDirPath ActiveFilePath'
	poolDictionaries:''
	category:'demos-NewsTool'
!

!NewsHandler class methodsFor:'documentation'!

documentation
"
    NewsHandlers know about the format of .newsrc files.
    I have put all interface to the news-system into this class,
    so that this code is not spread around;
    should be enhanced to allow for much more functionality.

    Subclasses (currently only NNTPHandler) may redefine some methods
    for remote access.

    written summer 90 by claus

    [see also:]
        NNTPHandler NewsView NumberSet

    [author:]
        Claus Gittinger

    [start with:]
        NewsView open
"
! !

!NewsHandler class methodsFor:'instance creation'!

new
    "answer a new newshandler for news"

    ^ self basicNew initialize
! !

!NewsHandler class methodsFor:'defaults'!

activeFilePath
    "on most machines this is usr/lib/news/active; on some,
     its in usr/local/lib/news. Check for local first; this should
     work ...
     rubbish - should come from a configuration file ..."

    (ActiveFilePath notNil
    and:[OperatingSystem isReadable:ActiveFilePath]) ifTrue:[
	^ ActiveFilePath
    ].
    #('/usr/local/lib/news/active'
      '/usr/lib/news/active'
      '/usr/local/news/active'
     ) do:[:aPossiblePath |
	(OperatingSystem isReadable:aPossiblePath) ifTrue:[
	    ^ aPossiblePath
	].
    ].
    ^ nil

    "Created: 30.10.1995 / 13:54:10 / cg"
!

activeFilePath:aPath
    "set the path of your active file.
     rubbish - should come from a configuration file ..."

    ActiveFilePath := aPath

    "
     NewsHandler activeFilePath:'/phys/clam/claus/usr/local/lib/active'
    "
!

oldSpoolDirPath
    (OperatingSystem isReadable:'/usr/spool/oldnews') ifTrue:[
	^ '/usr/spool/oldnews'
    ].
    (OperatingSystem isReadable:'/phys/clam/usr/spool/oldnews') ifTrue:[
	^ '/phys/clam/usr/spool/oldnews'
    ].
    ^ nil
!

spoolDirPath
    "return the path of your spool directory.
     rubbish - should come from a configuration file ..."

    (SpoolDirPath notNil
    and:[OperatingSystem isReadable:SpoolDirPath]) ifTrue:[
	^ SpoolDirPath
    ].
    (OperatingSystem isReadable:'/usr/spool/news') ifTrue:[
	^ '/usr/spool/news'
    ].
    ^ nil
!

spoolDirPath:aPath
    "set the path of your spool directory.
     rubbish - should come from a configuration file ..."

    SpoolDirPath := aPath

    "
     NewsHandler spoolDirPath:'/phys/clam/claus/usr/spool/news'
    "
! !

!NewsHandler methodsFor:'active file processing'!

newsGroups
    "return a list of all newsgroups, from reading the active file"

    |dir topDir activeName stream|

    listOfNewsGroups isNil ifTrue:[
        topDir := self class spoolDirPath.
        topDir notNil ifTrue:[
            dir := FileDirectory directoryNamed:topDir.
        ].
        dir isNil ifTrue:[
            ^ nil
        ].
        dir := nil.

        listOfNewsGroups := Dictionary new.

        activeName := self class activeFilePath.
        activeName notNil ifTrue:[
            stream := FileStream readonlyFileNamed:activeName.
        ].
        stream isNil ifTrue:[
"/            self notify:'no active file'.
            ^ nil
        ].
        self readActiveFileFrom:stream
    ].

    ^ listOfNewsGroups

    "
     NewsHandler new newsGroups
    "

    "Modified: 9.5.1996 / 18:51:17 / cg"
!

processActiveLine:line
    |index start groupName group nArticles nextLocalArticle mode moderated available|

 Transcript showCR:line.

    index := line indexOfSeparatorStartingAt:1.
    (index == 0) ifTrue:[
        self notify:('corrupted active file: ' , line).
        ^ self.
    ].

    groupName := line copyFrom:1 to:(index - 1).

    start := index + 1.
    index := line indexOfSeparatorStartingAt:start.
    (index == 0) ifTrue:[
        self notify:('corrupted active file: ' , line).
        ^ self
    ].

    nArticles := Number readFromString:(line copyFrom:start to:(index - 1)).

    start := index + 1.
    index := line indexOfSeparatorStartingAt:start.
    (index == 0) ifTrue:[
        self notify:('corrupted active file: ' , line).
        ^ self
    ].

    nextLocalArticle := Number readFromString:(line copyFrom:start to:(index - 1)).

    start := index + 1.
    mode := line copyFrom:start.

    (mode = 'm') ifTrue:[
        moderated := true.
        available := true
    ] ifFalse:[
        moderated := false.
        (mode = 'y') ifTrue:[
            available := true
        ] ifFalse:[
            available := false
        ]
    ].
    available ifTrue:[
        group := NewsGroup new.
        group name:groupName.
        group articleCount:nArticles.
        group articleRange:nil.
        group moderated:moderated.

        listOfNewsGroups at:groupName put:group.
    ]

    "Modified: 10.5.1996 / 10:10:37 / cg"
!

readActiveFileFrom:aStream
    |line index start group nArticles nextLocalArticle mode moderated available|

    self activityNotification:'reading active ...'.

    [aStream atEnd] whileFalse:[
        line := aStream nextLine.
        line notNil ifTrue:[
            self processActiveLine:line
        ]
    ].

    self activityNotification:'done (' , listOfNewsGroups size printString , ' groups)'

    "Modified: 9.5.1996 / 18:52:40 / cg"
! !

!NewsHandler methodsFor:'article contents'!

article:aNumber in:aNewsGroupName
    "return the article in a newsgroup"

    |text articleStream|

    articleStream := self streamForArticle:aNumber inGroup:aNewsGroupName.
    articleStream isNil ifTrue:[
        ^ '-- article not available --'
    ].
    text := articleStream upToEnd asCollectionOfLines.
    articleStream close.
    ^ text

    "Modified: 9.5.1996 / 18:59:17 / cg"
!

articleArchiveNameOf:aNumber in:aNewsGroupName
    "return the articles archive file name of an article in a newsgroup"

    |archive|

    archive := nil.
    self withArticleHeaderOf:aNumber in:aNewsGroupName do:[:line |
	((line startsWith:'Archive-Name: ') or:[line startsWith:'Archive-name: ']) ifTrue:[
	    archive := line copyFrom:15
	]
    ].

    ^ archive
!

articleAuthorOf:aNumber in:aNewsGroupName
    "return the article author of an article in a newsgroup"

    |line from index|

    from := '(?)'.
    self withArticleHeaderOf:aNumber in:aNewsGroupName do:[:line |
	(line startsWith:'From: ') ifTrue:[
	    from := line copyFrom:7
	]
    ].

    "look for better from ..."
    index := from indexOf:$(.
    (index ~~ 0) ifTrue:[
	from := from copyFrom:index to:(from indexOf:$) startingAt:index)
    ].
    ^ from
!

articleHeaderSummaryOf:aNumber in:aNewsGroupName
    "return the article header of an article in a newsgroup"

    |line index subject from numberString path stream maxNumber
     digits range index2 sz|

    stream := self streamForArticle:aNumber inGroup:aNewsGroupName.
    stream isNil ifTrue:[
        ^ nil "'-- article not readable --'  "
    ].
    subject := '<no subject>'.
    from := '(?)'.

    index := stream peekForLineStartingWithAny:#('Subject: ' 'From: ').
    index notNil ifTrue:[
        line := stream nextLine.
        (index == 1) ifTrue:[
            subject := line copyFrom:10.
            line := stream peekForLineStartingWith:'From:'.
            line notNil ifTrue:[
                from := line copyFrom:7
            ]
        ] ifFalse:[
            from := line copyFrom:7.
            line := stream peekForLineStartingWith:'Subject:'.
            line notNil ifTrue:[
                subject := line copyFrom:10
            ]
        ]
    ].

    stream close.

    range := self articleRangeOf:aNewsGroupName.
    firstInCurrentGroup := range first.
    lastInCurrentGroup := range last.
    self cacheSubject:subject of:aNumber.

    "look for better from ..."
    index := from indexOf:$(.
    (index ~~ 0) ifTrue:[
        index2 := from indexOf:$) startingAt:(index + 1).
        (index2 ~~ 0) ifTrue:[
            from := from copyFrom:index to:index2
        ]
    ].
    maxNumber := (self articleRangeOf:aNewsGroupName) last.
    digits := maxNumber printString size.
    numberString := '   ' , (aNumber printString).
"/    sz := numberString size.
    numberString := numberString copyFrom:(numberString size - digits).
    ^ numberString , ' ' , subject,  ' ' , from

    "Modified: 9.5.1996 / 18:57:25 / cg"
!

articleMessageIDOf:aNumber in:aNewsGroupName
    "return the articles messageID of an article in a newsgroup"

    |id|

    id := nil.
    self withArticleHeaderOf:aNumber in:aNewsGroupName do:[:line |
	(line startsWith:'Message-ID: ') ifTrue:[
	    id := line copyFrom:13
	]
    ].

    ^ id
!

articleSubjectOf:aNumber in:aNewsGroupName
    "return the article subject of an article in a newsgroup"

    |line subject path file range|

    subject := self cachedSubjectOf:aNumber.
    subject notNil ifTrue:[^ subject].

    subject := '<no subject>'.

    self withArticleHeaderOf:aNumber in:aNewsGroupName do:[:line |
	(line startsWith:'Subject: ') ifTrue:[
	    subject := line copyFrom:10
	]
    ].

    self cacheSubject:subject of:aNumber.

    ^ subject
!

articleXRefsOf:aNumber in:aNewsGroupName
    "return the cross refs of an article in a newsgroup"

    |refs|

    refs := OrderedCollection new.
    self withArticleHeaderOf:aNumber in:aNewsGroupName do:[:line |
        |r l|

        (line startsWith:'Xref: ') ifTrue:[
            l := line copyFrom:7.
            r := l asCollectionOfWords.
            r := r select:[:ref | ref includes:$:].
            r := r collect:[:ref |
                        |idx g nr|
                        idx := ref indexOf:$:.
                        g := (ref copyTo:(idx - 1)) withoutSpaces.
                        nr := Number readFrom:(ref copyFrom:(idx + 1)) onError:0.
                        (g -> nr)
                 ].
            refs addAll:r.
        ]
    ].
    ^ refs

    "Created: 10.5.1996 / 11:39:00 / cg"
    "Modified: 10.5.1996 / 12:29:35 / cg"
!

streamForArticle:aNumber inGroup:aNewsGroupName
    |path|

    path := self groupNameToPath:aNewsGroupName.
    path isNil ifTrue:[^ nil].
    path := path , '/' , (aNumber printString).
    ^ FileStream readonlyFileNamed:path.
! !

!NewsHandler methodsFor:'articles'!

markArticleRead:articleNumber inGroup:aGroupName
    "add article to read-range of aGroupName"

    |range refs|

    range := self readRangeOf:aGroupName.
    range add:articleNumber.

    refs := self articleXRefsOf:articleNumber in:aGroupName.
    refs notEmpty ifTrue:[
        refs do:[:r |
           |g nr|

           g := r key.
           nr := r value.
           range := self readRangeOf:g.
           range add:nr.
        ].
    ].

    "Modified: 10.5.1996 / 12:17:42 / cg"
!

markArticleUnread:articleNumber inGroup:aGroupName
    "add article to read-range of aGroupName"

    |range|

    range := self readRangeOf:aGroupName.
    range remove:articleNumber

!

markReadAllArticlesInGroup:aGroupName
    "add all articles in aGroupName to read-range"

    |range|

    range := self readRangeOf:aGroupName.
    self unreadArticlesIn:aGroupName do:[:article |
	range add:article
    ]
!

markUnreadAllArticlesInGroup:aGroupName
    "remove all articles in aGroupName to read-range"

    self readRangeOf:aGroupName put:nil

! !

!NewsHandler methodsFor:'group queries'!

anyArticlesIn:aNewsGroupName
    "return true, if there are any articles in given newsgroup"

    ^ (self numberOfArticlesIn:aNewsGroupName) ~~ 0
!

anyUnreadArticlesIn:aNewsGroupName
    "return true, if there are any unread articles in given newsgroup"

    |range readRange|

    range := self articleRangeOf:aNewsGroupName.
    (range size == 0) ifTrue:[^ false].

    readRange := self readRangeOf:aNewsGroupName.
    range do:[:anEntry |
	(readRange includes:anEntry) ifFalse:[^ true]
    ].
    ^ false
!

articleRangeOf:aNewsGroupName
    "return the range of article numbers in the given newsgroup,
     nil if there is no such group."

    |dir dirName range article group|

    group := self getGroup:aNewsGroupName.
    group isNil ifTrue:[^ nil].

    group articleCount == 0 ifTrue:[^ NumberSet new].

    range := group articleRange.
    range isNil ifTrue:[
        "/
        "/ the very first query for this group;
        "/ read the groupDirectory
        "/
        range := NumberSet new.
        dirName := self groupNameToPath:aNewsGroupName.
        dirName notNil ifTrue:[
            dir := FileDirectory directoryNamed:dirName.
        ].
        dir isNil ifFalse:[
            dir do:[:anEntry |
                (anEntry asString startsWith:'.') ifFalse:[
                    ((dir typeOf:anEntry) == #regular) ifTrue:[
                        article := Number readFromString:anEntry.
                        range add:article
                    ]
                ]
            ].
            group articleRange:range
        ].
    ].

    "been here before .. range already known"

    ^ range

    "Created: 30.10.1995 / 13:57:11 / cg"
    "Modified: 10.5.1996 / 08:35:50 / cg"
!

articlesIn:aNewsGroupName
    "return a list of all article numbers in given newsgroup"

    ^ (self articleRangeOf:aNewsGroupName) asOrderedCollection

    "Modified: 9.5.1996 / 19:23:30 / cg"
!

numberOfArticlesIn:aGroup
    "return the number of articles in given newsgroup"

    ^ (self articleRangeOf:aGroup) size

    "Modified: 9.5.1996 / 19:07:25 / cg"
!

quickEmptyGroupCheck:aNewsGroupName
    "return true, if the group is empty - quick check only"

    |dir dirName range article group|

    group := self getGroup:aNewsGroupName.
    group isNil ifTrue:[^ true].

    group articleCount == 0 ifTrue:[^ true].

    range := group articleRange.
    range isNil ifTrue:[
        "/
        "/ the very first query for this group;
        "/ read the groupDirectory
        "/
        dirName := self groupNameToPath:aNewsGroupName.
        dirName notNil ifTrue:[
            dir := FileDirectory directoryNamed:dirName.
        ].
        dir isNil ifFalse:[
            ^ false
        ].
        ^ true
    ].

    "been here before .. range already known"

    ^ range isEmpty

    "Modified: 10.5.1996 / 08:35:50 / cg"
    "Created: 10.5.1996 / 09:28:55 / cg"
! !

!NewsHandler methodsFor:'initialization'!

initialize
    subscriptionKnown := false.

    "Modified: 10.5.1996 / 10:29:33 / cg"
!

release

    "Modified: 9.5.1996 / 18:58:50 / cg"
! !

!NewsHandler methodsFor:'misc'!

articlesIn:aNewsGroupName do:aBlock
    "evaluate aBlock for each article number in given newsgroup"

    |range|

    range := self articleRangeOf:aNewsGroupName.
    range do:aBlock

    "Created: 30.10.1995 / 14:07:24 / cg"
    "Modified: 9.5.1996 / 19:05:56 / cg"
!

isSubscribed:aNewsGroupName
    "answer true if a given newsgroup is subscribed"

    |group|

    subscriptionKnown ifFalse:[self readNewsrc].

    group := self getGroup:aNewsGroupName.
    group isNil ifTrue:[^ false].

    ^ group subscribed.

    "Modified: 9.5.1996 / 18:35:34 / cg"
!

numberOfUnreadArticlesIn:aNewsGroupName
    "return the number of unread articles in given newsgroup"

    |count|

    (self numberOfArticlesIn:aNewsGroupName) == 0 ifTrue:[^ 0].

    count := 0.
    self unreadArticlesIn:aNewsGroupName do:[:dummy |
        count := count + 1
    ].
    ^ count

    "Modified: 10.5.1996 / 08:39:43 / cg"
!

readRangeOf:aNewsGroupName
    "return a set of read articles in a given newsgroup"

    |group r|

    subscriptionKnown ifFalse:[self readNewsrc].
    group := self getGroup:aNewsGroupName.
    group notNil ifTrue:[
        r := group readRange
    ].
    r isNil ifTrue:[
        r := NumberSet new.
        group notNil ifTrue:[
            group readRange:r
        ]
    ].
    ^ r

    "Modified: 9.5.1996 / 19:29:29 / cg"
!

readRangeOf:aNewsGroupName put:aRange
    "set the set of read articles in a given newsgroup"

    |group|

    subscriptionKnown ifFalse:[self readNewsrc].
    group := self getGroup:aNewsGroupName.
    group isNil ifTrue:[
        group := NewsGroup new.
        group name:aNewsGroupName.
        listOfNewsGroups at:aNewsGroupName put:group.
    ].    
    group readRange:aRange

    "Modified: 9.5.1996 / 19:10:10 / cg"
!

scanNewsGroups
    "force a rescan ..."

    listOfNewsGroups := nil.
!

subscribe:aBoolean to:aNewsGroupName
    "un/subscribe a newsGroup"

    |group|

    subscriptionKnown ifFalse:[self readNewsrc].
    group := self getGroup:aNewsGroupName.
    group subscribed:aBoolean

    "Modified: 9.5.1996 / 19:11:20 / cg"
!

subscribeTo:aNewsGroupName
    "subscribe a newsGroup"

    self subscribe:true to:aNewsGroupName.

    "Created: 10.5.1996 / 09:43:50 / cg"
!

subscribedGroups
    "answer a list of all subscribed newsgroups"

    subscriptionKnown ifFalse:[self readNewsrc].
    ^ listOfNewsGroups select:[:group | group subscribed].

    "
     (NewsHandler new) subscribedGroups
    "

    "Modified: 9.5.1996 / 19:12:04 / cg"
!

unreadArticlesIn:aNewsGroupName
    "return a list of all unread article file names in given newsgroup"

    |list|

    list := OrderedCollection new.
    self unreadArticlesIn:aNewsGroupName do:[:anEntry |
	list add:anEntry
    ].
    ^ list
!

unreadArticlesIn:aNewsGroupName do:aBlock
    "evaluate aBlock for each unread article file name in given newsgroup"

    |range|

    range := self readRangeOf:aNewsGroupName.
    self articlesIn:aNewsGroupName do:[:anEntry |
	range isNil ifTrue:[
	    aBlock value:anEntry
	] ifFalse:[
	    (range includes:anEntry) ifFalse:[
		aBlock value:anEntry
	    ]
	]
    ]
!

unsubscribeFrom:aNewsGroupName
    "subscribe a newsGroup"

    self subscribe:false to:aNewsGroupName.

    "Created: 10.5.1996 / 09:43:58 / cg"
!

unsubscribedGroups
    "answer a list of all subscribed newsgroups"

    listOfNewsGroups isNil ifTrue:[self newsGroups].
    listOfNewsGroups isNil ifTrue:[^ #()].

    subscriptionKnown ifFalse:[self readNewsrc].
    ^ listOfNewsGroups select:[:group | group subscribed not].

    "
     (NewsHandler new) unsubscribedGroups
     (NewsHandler new) subscribedGroups
    "

    "Created: 25.10.1995 / 21:09:31 / cg"
    "Modified: 9.5.1996 / 19:13:27 / cg"
!

withArticleHeaderOf:aNumber in:aNewsGroupName do:aBlock
    "helper for extraction methods"

    |line file|

    file := self streamForArticle:aNumber inGroup:aNewsGroupName.
    file isNil ifTrue:[^ nil].

    [file atEnd] whileFalse:[
	line := file nextLine.
	line notNil ifTrue:[
	    aBlock value:line
	]
    ].

    file close
! !

!NewsHandler methodsFor:'newsrc processing'!

readNewsrc
    "read .newsrc, fill in flags of all subscribed newsgroups"

    |inStream newsRC group|

    subscriptionKnown ifTrue:[^ self].

    newsRC := OperatingSystem getHomeDirectory , '/.newsrc'.
    inStream := FileStream readonlyFileNamed:newsRC.
    inStream isNil ifTrue:[
"/        self notify:'no .newsrc in home directory'.

        "/
        "/ no .newsRC file;
        "/ start with all subscribed
        "/
        listOfNewsGroups isNil ifTrue:[self newsGroups].
        listOfNewsGroups isNil ifTrue:[
"/            self notify:'no news'.
            ^ self
        ].

        listOfNewsGroups do:[:group |
            group subscribed:true
        ].
        subscriptionKnown := true.
        ^ self
    ].


    listOfNewsGroups isNil ifTrue:[listOfNewsGroups := Dictionary new].
    self readSubscribedGroupsFrom:inStream.
    inStream close.
    subscriptionKnown := true.


    "
     NewsHandler new readNewsrc
    "

    "Modified: 9.5.1996 / 19:21:59 / cg"
!

readSubscribedGroupsFrom:aStream
    "read .newsrc file"

    |line index group groupName rangeString range subscribed|

    self activityNotification:'reading .newsrc ...'.

    [aStream atEnd] whileFalse:[
        line := aStream nextLine.
        line notNil ifTrue:[

            index := line indexOf:$:.
            (index == 0) ifTrue:[
                index := line indexOf:$!!.
                (index == 0) ifTrue:[
                    Transcript show:'invalid line in .newsrc: '.
                    Transcript showCR:line
                ] ifFalse:[
                    "group!! something - unsubscribed"
                    subscribed := false
                ]
            ] ifFalse:[
                "group: something - subscribed"
                subscribed := true
            ].

            groupName := line copyFrom:1 to:(index - 1).

            group := listOfNewsGroups at:groupName ifAbsent:nil.
            group isNil ifTrue:[
                group := NewsGroup new.
                group name:groupName.
                listOfNewsGroups at:groupName put:group
            ].

            (group subscribed notNil
            and:[group subscribed ~~ subscribed]) ifTrue:[
                "/ already there - double entry in newsrc
                Transcript showCR:('multiple entry for: ' , groupName , ' in .newsrc.').
                subscribed := true.
            ].

            group subscribed:subscribed.
                
            rangeString := line copyFrom:(index + 1).
            ((rangeString size == 0) or:[rangeString isBlank]) ifTrue:[
                rangeString := nil
            ].

            rangeString isNil ifTrue:[
                range := NumberSet new
            ] ifFalse:[
                range := (NumberSet readFrom:rangeString).
            ].
            group readRange:range.
        ]
    ].
"/ Transcript showCR:'done'

    "Modified: 26.9.1995 / 11:07:58 / stefan"
    "Modified: 10.5.1996 / 10:26:24 / cg"
!

updateNewsrc
    "rewrite .newsrc file"

    |stream list name range|

    name := OperatingSystem getHomeDirectory , '/.newsrc'.

    stream := FileStream newFileNamed:(name ,'.new').

    stream isNil ifTrue:[
        self notify:'cannot update .newsrc'.
        ^ self
    ].
    (list := listOfNewsGroups) size == 0 ifTrue:[
        (list := (self subscribedGroups)) size == 0 ifTrue:[
            self notify:'no .newsrc update'.
            ^ self
        ].
    ].

    list := list asSortedCollection:[:a :b | a name < b name].

    list do:[:group|
        stream nextPutAll:group name.
        group subscribed ifTrue:[
            stream nextPut:$:
        ] ifFalse:[
            stream nextPut:$!!
        ].
        stream space.
        range := group readRange.
        range notNil ifTrue:[
            range printOn:stream
        ].
        stream cr
    ].
    stream close.
    OperatingSystem executeCommand:('mv ' , name , ' ' , name , '.old').
    OperatingSystem executeCommand:('mv ' , name , '.new ' , name)

    "Created: 26.10.1995 / 15:44:50 / cg"
    "Modified: 9.5.1996 / 19:15:37 / cg"
! !

!NewsHandler methodsFor:'private'!

cacheSubject:aString of:article
    |sz|

    sz := lastInCurrentGroup - firstInCurrentGroup + 1.
    (cachedSubjects isNil or:[cachedSubjects size ~~ sz]) ifTrue:[
	cachedSubjects := Array new:sz.
    ].
    cachedSubjects at:(article - firstInCurrentGroup + 1) put:aString.
!

cachedSubjectOf:article
    cachedSubjects notNil ifTrue:[
	^ cachedSubjects at:(article - firstInCurrentGroup + 1).
    ].
    ^ nil
!

critical:aBlock
    "do some critical action, which needs exclusive use of the news handler.
     Needed in subclasses"

    ^ aBlock value

    "Created: 12.4.1996 / 12:06:09 / stefan"
    "Modified: 12.4.1996 / 12:10:13 / stefan"
!

findGroupsAndCountsOf:aDir into:groups and:counts
    "recursively traverses news-spool directory; in the way
     count articles and append all subgroup names to groups and 
     corresponding article counts to counts.
     and fill hashList with table index positions.
    -- obsolete ---"

    |articleCount hasSubdirs subGroups subCounts myPath relPath groupName
     hashKey|

    articleCount := 0.
    hasSubdirs := false.

    subGroups := OrderedCollection new.
    subCounts := OrderedCollection new.

    aDir do:[:aName |
	(aName startsWith:'.') ifFalse:[
	    (aDir isDirectory:aName) ifTrue:[
		"a subdirectory"
		hasSubdirs := true.
		self findGroupsAndCountsOf:(FileDirectory directoryNamed:aName in:aDir)
				      into:subGroups and:subCounts
	    ] ifFalse:[
		(aName at:1) isDigit ifTrue:[
		    "an article"
		    articleCount := articleCount + 1
		]
	    ]
	]
    ].
    "if there where any articles, append my name"
    (articleCount == 0) ifFalse:[
	myPath := aDir pathName.
	(myPath = self class spoolDirPath) ifFalse:[
	    relPath := myPath copyFrom:(self class spoolDirPath size + 2).  "start after slash"
	    groupName := self relativePathNameToGroup:relPath.

	    groups add:groupName.
	    counts add:articleCount.

	    self addHash:(groups size) forGroup:groupName
	]
    ].
    hasSubdirs ifTrue:[
	groups addAll:subGroups.
	counts addAll:subCounts
    ]
!

flushSubjectCache
    cachedSubjects := nil

    "Modified: 10.5.1996 / 10:30:24 / cg"
!

getGroup:aGroupName
    listOfNewsGroups isNil ifTrue:[self newsGroups].
    subscriptionKnown ifFalse:[self readNewsrc].
    listOfNewsGroups isNil ifTrue:[^nil].

    ^ listOfNewsGroups at:aGroupName ifAbsent:nil.

    "Created: 9.5.1996 / 18:30:15 / cg"
    "Modified: 9.5.1996 / 19:01:16 / cg"
!

groupNameToPath:aNewsGroupName
    "answer the news - path name for a given newsgroup"

    |relPath dir|

    dir := self class spoolDirPath.
    dir isNil ifTrue:[^ nil].
    relPath := aNewsGroupName copy replaceAll:$. by:$/.
    ^ dir , '/', relPath

!

relativePathNameToGroup:aPathName
    "answer the newsgroup name for a given path (relative to /usr/spool/news)"

    ^ (aPathName copy) replaceAll:$/ by:$. 
! !

!NewsHandler methodsFor:'queries'!

hasNews
    "return true, if news are available on this machine"

    |dir topDir activeName stream|

    listOfNewsGroups notNil ifTrue:[^ true].

    topDir := self class spoolDirPath.
    topDir notNil ifTrue:[
	dir := FileDirectory directoryNamed:topDir.
    ].
    dir isNil ifTrue:[^ false].

    activeName := self class activeFilePath.
    activeName notNil ifTrue:[
	stream := FileStream readonlyFileNamed:activeName.
    ].
    stream isNil ifTrue:[^ false].
    stream close.
    ^ true

    "
     (NewsHandler new) hasNews
    "

    "Created: 29.10.1995 / 18:29:25 / cg"
!

hasNewsrc
    "check for a .newsrc file"

    |inStream newsRC|

    newsRC := OperatingSystem getHomeDirectory , '/.newsrc'.
    inStream := FileStream readonlyFileNamed:newsRC.
    inStream isNil ifTrue:[
        ^ false
    ].
    inStream close.
    ^ true

    "
     (NewsHandler new) hasNewsrc
    "

    "Created: 20.10.1995 / 20:10:55 / cg"
    "Modified: 9.5.1996 / 18:59:44 / cg"
! !

!NewsHandler class methodsFor:'documentation'!

version
"
$Header: /cvs/stx/stx/clients/NewsTool/NewsHndlr.st,v 1.16 1996-05-18 15:59:32 cg Exp $
"
! !
