"{ Package: 'stx:clients/NewsTool' }"

NewsHandler subclass:#NNTPHandler
	instanceVariableNames:'lastGroup nntpConnection currentFirst currentLast sema'
	classVariableNames:'OKCANPOST OKNOPOST ERRACCESS OKGROUP OKHEADER OKARTICLE OKSUBJECT
		OKLIST'
	poolDictionaries:''
	category:'demos-NewsTool'
!

!NNTPHandler class methodsFor:'documentation'!

documentation
"
    instances of NNTPHandler provide a newsHandler interface
    via an NNTP tcp/ip connection.
    The NewsView uses NNTP if it either finds the NNTPSERVER shell
    variable or a smalltalk global with that name.
    (i.e. setenv NNTPSERVER nntpHost
     or:  Smalltalk at:#NNTPSERVER put:'nntphost')

    [see also:]
        NewsHandler NewsView

    [author:]
        Claus Gittinger

    [start with:]
        NewsView open
"
!

forMyself
"
    nntp-commands
	article <number>
	body <number>
	group <name>
	head <number>
	help
	last ???
	list
	newgroups ???
	newnews ???
	next
	post ???
	slave ???
	stat ???
	xhdr <number> <field> ???
"
! !

!NNTPHandler class methodsFor:'initialization'!

initialize
    super initialize.

    OKCANPOST := 200.
    OKNOPOST :=  0.  "XXX fill in"

    OKGROUP := 211.
    OKARTICLE := 220.
    OKHEADER := 221.
    OKLIST := 215.

    ERRACCESS := 0.  "XXX fill in"

    "NNTPHandler initialize"
! !

!NNTPHandler methodsFor:'initialization'!

connect
    "setup connection to nntp-server on default host.
     The nntp hostname can come from either the shell environment ($NNTPSERVER)
     or be found in the global NNTPSERVER"

    |host|

    ('NNTPSERVER' knownAsSymbol and:[Smalltalk includesKey:'NNTPSERVER' asSymbol]) ifTrue:[
	host := Smalltalk at:'NNTPSERVER' asSymbol
    ] ifFalse:[
	host := OperatingSystem getEnvironment:'NNTPSERVER'.
    ].
    host isNil ifTrue:[
	host := self query:'Host where NNTP server is running:'.
	host isNil ifTrue:[
	    ^false
	]
    ].
    ^ self connectTo:host

    "Smalltalk at:#NNTPSERVER put:'slsv6bt'"
!

connectTo:aHost
    "setup connection to nntp-server at aHost"

    |code r|

    nntpConnection := Socket newTCPclientToHost:aHost port:'nntp' withTimeout:10.
    nntpConnection isNil ifTrue:[
        self warn:'could not connect to NNTP server on ' , aHost.
        ^ false
    ].
    nntpConnection buffered:false. 
    nntpConnection useCRLF:true.

    r := self getResponseCode.
    code := r at:1.
    code == OKNOPOST ifTrue:[
        self warn:'no posting allowed by nntpserver on ' , aHost
    ].
    code == ERRACCESS ifTrue:[
        self warn:'no access permitted by nntpserver on ', aHost.
        ^ false
    ].
    sema := RecursionLock new.
    code := self sendRequestForCode:'MODE READER'.

    (code ~= OKCANPOST  and:[code ~= OKNOPOST]) ifTrue:[
        self sendRequest:'XMODE READER'.
    ].
    ^ true

    "Socket connectTo:'nntp' on:'josef'"
    "Socket connectTo:'nntp' on:'slsv6bt'"

    "|n r|
     n := NNTPHandler new.
     n connect.
     r := n articleRangeOf:'comp.lang.smalltalk'. 
     n article:r first in:'comp.lang.smalltalk'.  
    "

    "Modified: 26.9.1995 / 09:16:43 / stefan"
    "Modified: 10.5.1996 / 09:15:28 / cg"
!

release
    nntpConnection notNil ifTrue:[
	nntpConnection close.
    ].
    lastGroup := nil.
    sema := nil.
    super release
! !

!NNTPHandler methodsFor:'misc'!

XXarticleFromOf:aNumber in:aGroup
    "return the articles sender of an article in a newsgroup.
     this does not work and I dont have any documentation on the
     XHDR request at the moment ..."

    ^ self getTextResponseFor:'XHDR ' , aNumber printString , ' From' inGroup:aGroup expecting:OKHEADER
!

XXarticleSubjectOf:aNumber in:aGroup
    "return the article subject of an article in a newsgroup.
     this does not work and I dont have any documentation on the
     XHDR request at the moment ..."

    ^ self getTextResponseFor:'XHDR ' , aNumber printString , ' Subject' inGroup:aGroup expecting:OKHEADER
!

article:aNumber in:aGroup
    "return an article in a newsgroup"

    ^ self getTextResponseFor:'ARTICLE ' , aNumber printString inGroup:aGroup expecting:OKARTICLE
!

articleArchiveNameOf:aNumber in:aNewsGroupName
    "return the articles archive file name of an article in a newsgroup"

    |archive|

    archive := nil.
    self withArticle:aNumber in:aNewsGroupName do:[:line |
	((line startsWith:'Archive-Name: ') or:[line startsWith:'Archive-name: ']) ifTrue:[
	    archive := line copyFrom:15
	]
    ].

    ^ archive
!

articleFromOf:aNumber in:aGroupName
    |from  response|


    self withArticleHeaderOf:aNumber in:aGroupName do:[:line |
	(line startsWith:'From: ') ifTrue:[
	    from := line copyFrom:7 
	].
	(line startsWith:'Subject:') ifTrue:[
	    self cacheSubject:(line copyFrom:10) of:aNumber.
	].
    ].

    ^ from
!

articleHeaderSummaryOf:aNumber in:aNewsGroupName
    "return the article header of an article in a newsgroup"

    |line index subject from numberString maxNumber
     digits range index2|

    from := self articleFromOf:aNumber in:aNewsGroupName.
    from isNil ifTrue:[^ nil].

    subject := self articleSubjectOf:aNumber in:aNewsGroupName.
    subject isNil ifTrue:[
	subject := '<no subject>'
    ].

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
    numberString := numberString copyFrom:(numberString size - digits).
    ^ numberString , ' ' , subject,  ' ' , from
!

articleRangeOf:aNewsGroupName
    "return the range of article numbers in the given newsgroup,
     nil if there is no such group."

    |dir dirName range article group|

    group := self getGroup:aNewsGroupName.
    group isNil ifTrue:[^ nil].

    group articleCount == 0 ifTrue:[
        range := NumberSet new.
        group articleRange:range
    ] ifFalse:[
        range := group articleRange.
        range isNil ifTrue:[
            (self selectGroup:aNewsGroupName) ifFalse:[^ NumberSet new].
            currentLast == 0 ifTrue:[
                range := NumberSet new
            ] ifFalse:[
                range := NumberSet with:(currentFirst to:currentLast)
            ].
            group articleRange:range
        ].
    ].

    "been here before .. range already known"
    ^ range

    "Modified: 10.5.1996 / 08:51:01 / cg"
!

articleSubjectOf:aNumber in:aGroup
    |subject response|

    subject := self cachedSubjectOf:aNumber.
    subject notNil ifTrue:[^ subject].

    sema critical:[
        (self selectGroup:aGroup) ifTrue:[
            response := self sendRequestForCode:('HEAD ' , aNumber printString).
            response == OKHEADER ifTrue:[
                subject := '<no subject>'.
                self withTextResponseDo:[:line |
                    (line startsWith:'Subject: ') ifTrue:[
                        subject := line copyFrom:10
                    ].
                ].
                self cacheSubject:subject of:aNumber.
            ].
        ].
    ].
    ^ subject

    "Modified: 10.5.1996 / 09:15:20 / cg"
!

articlesIn:aNewsGroupName do:aBlock
    "evaluate aBlock for each article number in given newsgroup"

    (self articleRangeOf:aNewsGroupName) do:aBlock
!

critical:aBlock
    sema critical:aBlock

    "Created: 12.4.1996 / 12:04:50 / stefan"
    "Modified: 12.4.1996 / 13:23:12 / stefan"
!

getResponseCode
    |code response|

    nntpConnection readWait.
    response := nntpConnection nextLine.
    response notNil ifTrue:[
"        response printNewline.     "
        code := Number readFromString:response       
    ].
    ^ Array with:code with:response

    "Modified: 10.5.1996 / 09:07:23 / cg"
!

getTextResponseFor:request expecting:expectedReply
    "send a request, expect a reply and return the received text"

    |text response|

    response := self sendRequestForCode:request.
    expectedReply notNil ifTrue:[
        response == expectedReply ifFalse:[
            ^ nil
        ]
    ].

    text := OrderedCollection new:100.
    self withTextResponseDo:[:line |
        text add:line
    ].
    ^ text

    "Modified: 10.5.1996 / 09:15:39 / cg"
!

getTextResponseFor:request inGroup:group expecting:expectedReply
    |text|

    sema critical:[
	(group isNil or:[self selectGroup:group]) ifTrue:[
	    text := self getTextResponseFor:request expecting:expectedReply 
	].
    ].
    ^ text
!

helpInfo
    "return helptext from server"

    ^ self getTextResponseFor:'HELP' inGroup:nil expecting:nil
!

list
    "return list from server"

    ^ self getTextResponseFor:'LIST' inGroup:nil expecting:nil
!

newsGroups
    "return a list of all newsgroups"

    |response|

    listOfNewsGroups isNil ifTrue:[
        nntpConnection isNil ifTrue:[
            ^ nil
        ].

        listOfNewsGroups := Dictionary new.

        sema critical:[
            response := self sendRequestForCode:('LIST').
            response == OKLIST ifTrue:[
                Transcript showCR:'reading active ...'.
                self withTextResponseDo:[:line |
                    self processActiveLine:line
                ]
            ]
        ].
        Transcript showCR:'done.'
    ].
    ^ listOfNewsGroups

    "Modified: 10.5.1996 / 09:15:43 / cg"
!

query:titleString
    |inp|

    [
	inp := DialogView request:titleString.
	inp = ''
    ] whileTrue:[            
	    self warn:'Empty input is not allowed.
    Use ABORT instead.'
    ].
    ^inp

    "NNTPHandler new query:'foo ?'"
!

quickEmptyGroupCheck:aNewsGroupName
    "return true, if the group is empty - quick check only"

    |group|

    group := self getGroup:aNewsGroupName.
    group isNil ifTrue:[^ true].

    group articleCount == 0 ifTrue:[^ true].
    ^ false "/ dont know

    "Modified: 10.5.1996 / 10:09:29 / cg"
!

selectGroup:aGroupName
    |r code response s|

    aGroupName = lastGroup ifTrue:[
        ^ true
    ].
    nntpConnection isNil ifTrue:[
        ^ false
    ].
    self flushSubjectCache.

    currentFirst := 0.
    currentLast := 0.    

    sema critical:[
        r := self sendRequest:('GROUP ' , aGroupName).
    ].
    code := r at:1.
    code == OKGROUP ifFalse:[
        ^ false
    ].
    response := r at:2.

    s := ReadStream on:response.
    Number readFrom:s.      "skip"
    Number readFrom:s.      "skip"
    currentFirst := Number readFrom:s.    
    currentLast:= Number readFrom:s.    
    lastInCurrentGroup := currentLast.
    firstInCurrentGroup := currentFirst.
    lastGroup := aGroupName.
    ^ true

    "Modified: 10.5.1996 / 09:10:40 / cg"
!

sendRequest:what
    |try r|

    try := 0.
    Socket writeErrorSignal handle:[:ex |
        try == 0 ifTrue:[
            "
             connect again
            "
            self connect.
            try := try + 1.
            ex restart
        ].
        "
         abort request
        "
        ex returnWith:-1
    ] do:[
        nntpConnection nextPutLine:what; flush.
        ^ self getResponseCode.
    ].
    ^ Array with:-1 with:nil

    "Modified: 27.1.1997 / 20:51:43 / cg"
!

sendRequestForCode:what
    |r|

    r := self sendRequest:what.
    ^ r at:1

    "Created: 10.5.1996 / 09:15:01 / cg"
!

withArticle:aNumber in:aGroup do:aBlock
    "helper for extraction methods"

    |response|

    sema critical:[
        (self selectGroup:aGroup) ifTrue:[
            response := self sendRequestForCode:('ARTICLE ' , aNumber printString).
            response == OKARTICLE ifTrue:[
                self withTextResponseDo:aBlock
            ]
        ]
    ]

    "Modified: 10.5.1996 / 09:15:54 / cg"
!

withArticleHeaderOf:aNumber in:aGroup do:aBlock
    "helper for extraction methods"

    |response|

    sema critical:[
        (self selectGroup:aGroup) ifTrue:[
            response := self sendRequestForCode:('HEAD ' , aNumber printString).
            response == OKHEADER ifTrue:[
                self withTextResponseDo:aBlock
            ]
        ]
    ]

    "Modified: 10.5.1996 / 09:15:56 / cg"
!

withTextResponseDo:aBlock
    |line|

    nntpConnection readWait.
    line := nntpConnection nextLine.
    [line notNil and:[line ~= '.']] whileTrue:[
	aBlock value:line.
	nntpConnection readWait.
	line := nntpConnection nextLine
    ]
! !

!NNTPHandler class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/NewsTool/NNTPHndlr.st,v 1.17 2003-03-17 16:38:08 cg Exp $'
! !

NNTPHandler initialize!
