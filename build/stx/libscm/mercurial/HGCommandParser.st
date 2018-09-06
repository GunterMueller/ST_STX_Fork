"
stx:libscm - a new source code management library for Smalltalk/X
Copyright (C) 2012-2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
"{ Package: 'stx:libscm/mercurial' }"

"{ NameSpace: Smalltalk }"

Object subclass:#HGCommandParser
	instanceVariableNames:'stream command'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Mercurial-Internal'
!

!HGCommandParser class methodsFor:'documentation'!

copyright
"
stx:libscm - a new source code management library for Smalltalk/X
Copyright (C) 2012-2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
! !

!HGCommandParser class methodsFor:'instance creation'!

for: anHGCommand on: aStringOrStream
    | stream |

    stream := aStringOrStream isStream 
                ifTrue:[aStringOrStream]
                ifFalse:[aStringOrStream readStream].

    ^self new
        command: anHGCommand;
        stream: stream;
        yourself

    "Created: / 04-02-2013 / 13:54:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

on: aStringOrStream
    ^self for: nil on: aStringOrStream

    "Created: / 23-10-2012 / 11:07:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-02-2013 / 13:55:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommandParser class methodsFor:'templates'!

templateHeads
    ^'{rev}:{node}\n'

    "Created: / 27-11-2012 / 21:25:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

templateLog
    ^ '{rev}:{node}\n{branch}\n{p1rev}:{p1node} {p2rev}:{p2node} \n\n{file_adds}\n{file_copies}\n{file_dels}\n{file_mods}\n{author}\n{date|isodate}\n{desc}\n**EOE**\n'

    "Created: / 12-11-2012 / 23:06:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-11-2014 / 00:22:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

templateLogChildren
    ^ '{rev}:{node}\n{children}\n'

    "Created: / 05-12-2012 / 23:40:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

templateLogForVersionLessThan2_4
    ^ '{rev}:{node}\n{branch}\n{parents}\n\n{file_adds}\n{file_copies}\n{file_dels}\n{file_mods}\n{author}\n{date|isodate}\n{desc}\n**EOE**\n'

    "Created: / 27-11-2014 / 23:20:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

templateLogIdsOnly
    ^ '{rev}:{node}\n'

    "Created: / 05-12-2012 / 19:10:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommandParser methodsFor:'accessing'!

command
    ^ command
!

command:anHGCommand
    command := anHGCommand.
!

stream
    ^ stream
!

stream:something
    stream := something.
! !

!HGCommandParser methodsFor:'error reporting'!

error: aString
    <context: #return>
    <resource: #skipInDebuggersWalkBack>

    self propagate: HGCommandParseError message: aString

    "Created: / 14-11-2012 / 19:59:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-02-2013 / 21:50:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

notify: aString
    <context: #return>
    <resource: #skipInDebuggersWalkBack>

    self propagate: HGNotification message: aString

    "Created: / 04-02-2013 / 13:56:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-02-2013 / 21:50:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

propagate: anException
    "Propagates given exception to the caller og HGCommand>>execute
     (but only if command is set)"

    command notNil ifTrue:[
        command propagate: anException.
        anException isError ifTrue:[
            Processor activeProcess terminate
        ].
    ] ifFalse:[
        anException raiseSignal
    ].

    "Created: / 04-02-2013 / 21:38:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-03-2014 / 23:30:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

propagate: class message: message
    "Propagates an exception of given class with given message to
     the caller of HGCommand>>execute"

    ^self propagate: (class newException messageText: message)

    "Created: / 04-02-2013 / 21:50:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

warn: aString
    <context: #return>
    <resource: #skipInDebuggersWalkBack>

    self propagate: HGWarning message: aString

    "Created: / 04-02-2013 / 13:56:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-02-2013 / 21:50:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommandParser methodsFor:'parsing'!

parseBookmarks
    "Parse output of 'hg bookmarks' command. Return collection
     of orphaned HGBookmark"

    | bookmarks |

    bookmarks := OrderedCollection new.
    [ stream atEnd ] whileFalse:[
        bookmarks add: self parseBookmarksEntry
    ].
    ^bookmarks

    "Created: / 20-03-2014 / 01:51:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseBookmarksEntry
    | bookmark |

    "Example:
       issue37-update-to-revision 399:858944cebec4
     * master                    403:5cc256ed28a1 
    "

    bookmark := HGBookmark new.


    stream skipSeparators.
    stream peek == $* ifTrue:[
        stream next.
        stream skipSeparators.
    ].
    bookmark setName: self parseName.
    stream skipSeparators.
    bookmark setChangesetId: self parseNodeId.
    self expectLineEnd.
    ^bookmark

    "Created: / 20-03-2014 / 01:52:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-03-2014 / 17:12:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseBranches
    "Parse output of 'hg branches' command. Return collection
     of orphaned HGBranch"

    | branches branch |

    branches := OrderedCollection new.
    stream atEnd ifFalse:[ 
        branch := self parseBranchesEntryAllowForInvalidBranchheadsMessage: true.
        branch notNil ifTrue:[ 
            branches add: branch.
        ].
    ].
    [ stream atEnd ] whileFalse:[
        branch := self parseBranchesEntryAllowForInvalidBranchheadsMessage: false.  
        branches add:  branch.
    ].
    ^branches

    "Created: / 27-11-2012 / 20:20:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-10-2014 / 20:56:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseBranchesEntryAllowForInvalidBranchheadsMessage: allowForInvalidBrancheadsMessage
    | name branch |

    name := self parseName.
    stream skipSeparators.
    allowForInvalidBrancheadsMessage ifTrue:[ 
        stream peek isDigit ifFalse:[ 
            | message |

            message := name , ' ', stream nextLine.
            self notify: message.  
            name := self parseName.
            stream skipSeparators.   
        ].
    ].                
    branch := HGBranch new.
    branch setName: name.
 
    self parseNodeId.
    stream peek == Character space ifTrue:[
        stream next.
        stream peek == $( ifFalse:[self error:'''('' expected but ''' , stream peek , ''' found'].
        stream next.
        stream peek == $i ifTrue:[
            self expect:'inactive)'.
            branch setActive: false.
        ] ifFalse:[
            stream peek == $c ifTrue:[
                self expect:'closed)'.
                branch setClosed: true.
            ] ifFalse:[
                self error:'Unexpected branch attribute (only ''closed'' and ''inactive'' supported)'''
            ]
        ].
    ].
    self expectLineEnd.
    ^branch

    "Created: / 08-10-2014 / 20:54:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseConfig
    "Parse output of 'hg showconfig' command, assuming the template given
     was HGCommandParser templateLog. Return a list of HGChangeset."

    | root |

    root := HGConfig::Section new setName: '<root>'.
    [ stream atEnd ] whileFalse:[
        self parseConfigEntryInto: root.
    ].
    ^root

    "Created: / 06-12-2012 / 16:00:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-12-2012 / 19:59:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseConfigEntryInto: root
    | entry out |

    entry := root.
    out := String new writeStream.
    [ stream atEnd or:[stream peek == $=] ] whileFalse:[
        stream peek == $. ifTrue:[
            entry := entry at: out contents ifAbsentPut: [
                HGConfig::Section new setName: out contents.
            ].
            out reset.
            stream next.
        ] ifFalse:[
            out nextPut: stream next.
        ].
    ].
    stream next.
    entry at: out contents put:
        (HGConfig::Entry new setName: out contents value:stream nextLine)

    "Created: / 06-12-2012 / 19:41:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseDate
    | ts c |
    ts := Timestamp readIso8601FormatFrom:stream.
    c := stream peek.
    c == Character space ifTrue:[ 
        stream next.
        c := stream peek.
    ].
    (c == $+ or:[c == $-]) ifFalse:[
        self error:'Cannot read timezone: ''+'' or ''-'' expected, ''' , c , ''' found'
    ].
    stream next.
    4 timesRepeat:[
        ('0123456789' includes: (c := stream peek)) ifFalse:[
            self error:'Cannot read timezone: digit expected, ''' , c , ''' found'
        ].
        stream next.
    ].
    ^ts

    "Created: / 13-11-2012 / 10:22:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-11-2014 / 10:44:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseInteger
    "Parses integer from stream and returns it"

    ^Integer readFrom: stream onError:[self error: 'integer value expected']

    "
    (HGCommandParser on: '12 34' readStream) parseInteger; skipSeparators; parseInteger
    "

    "Created: / 19-11-2012 / 20:05:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseLog
    "Parse output of 'hg log' command, assuming the template given
     was HGCommandParser templateLog. Return a list of HGRevision."

    | revs |

    revs := OrderedCollection new.
    [ stream atEnd ] whileFalse:[
        | rev |

        rev := self parseLogEntry.
        revs add: rev.
    ].

    ^revs.

    "Created: / 13-11-2012 / 09:46:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseLogEntry
    "Parse single revision entry, assuming the template given
     was HGCommandParser templateLog. Return a HGRevision."

    | rev branches line message adds copies deletions modifications |

    rev := HGChangeset new.
    rev setId: self parseNodeId. self expectLineEnd.
    branches := self parseNameList. self expectLineEnd.
    rev setBranches: branches.
    rev setParent1Id: self parseNodeId. self expectSpace.
    rev setParent2Id: self parseNodeId. self expectSpace. self expectLineEnd.
    "rev setChildren: self parseNodeIdList." self expectLineEnd.

    adds := self parsePathList. self expectLineEnd.
    copies := self parsePathCopyList. self expectLineEnd.
    deletions := self parsePathList. self expectLineEnd.
    modifications := self parsePathList. self expectLineEnd.

    copies pairsDo:[:dst :src|
        adds remove: dst ifAbsent:[].
        deletions remove: src ifAbsent:[].
    ].

    adds := adds collect:[:e|HGChange newAdded setChangeset: rev path: e].
    copies := copies collect:[:e|HGChange newCopied setChangeset: rev path: e first; setSource: e second].
    deletions := deletions collect:[:e|HGChange newRemoved setChangeset: rev path: e].
    modifications := modifications collect:[:e|HGChange newModified setChangeset: rev path: e].

    rev setChanges: modifications , adds , deletions , copies.
    rev setAuthor: self nextLine.
    rev setTimestamp: self parseDate. self expectLineEnd.
    message := String streamContents:[:s|
        line := self nextLine.
        s nextPutAll: line.
        [ line := self nextLine . line = '**EOE**' ] whileFalse:[
            s cr.
            s nextPutAll: line
        ].
    ].
    rev setMessage: message.
    rev setNonLazy.

    ^rev

    "Created: / 13-11-2012 / 09:45:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-03-2014 / 23:23:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseMergeLocalChanged: info
    "Parses

    local changed lcmake.bat which remote deleted
    use (c)hanged version or (d)elete? c

    " 

    self expect: 'local changed'.
    stream nextLine.
    self expect: 'use'.
    stream nextLine.

    "Created: / 22-03-2013 / 08:59:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseMergePath: info
    "Parses 'merging Make.proto' line" 

    self expect: 'merging '.
    self parsePath.
    self expectLineEnd.

    "Created: / 14-01-2013 / 15:56:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseMergeRemoteChanged: info
    "Parses

    remote changed CharacterEncoderImplementations__SJIS.st which local deleted
    use (c)hanged version or leave (d)eleted? c

    " 

    self expect: 'remote changed'.
    stream nextLine.
    self expect: 'use'.
    stream nextLine.

    "Created: / 15-01-2013 / 09:59:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseMergeSummary
    ^self parseMergeSummary: HGMergeInfo new

    "Created: / 14-01-2013 / 15:48:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseMergeSummary: info
    "Example:

        '9 files updated, 0 files merged, 1 files removed, 0 files unresolved'
    "

    info setNumUpdated: self parseInteger.
    self expect: ' files updated, '.
    info setNumMerged: self parseInteger.
    self expect: ' files merged, '.
    info setNumRemoved: self parseInteger.
    self expect: ' files removed, '.
    info setNumUnresolved: self parseInteger.
    self expect: ' files unresolved'.
    self expectLineEnd.
    ^info

    "Created: / 14-01-2013 / 15:52:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseName
    ^String streamContents:[:out|
        [ stream peek isSeparator ] whileFalse:[
            out nextPut:stream next
        ]
    ].

    "Created: / 27-11-2012 / 20:21:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseNameList
    | list |

    stream atEnd ifTrue:[ ^#() ].
    stream peek isSeparator ifTrue:[ ^#() ].
    list := OrderedCollection new.
    list add: self parseName.
    [ stream atEnd not and:[stream peek == Character space]] whileTrue:[
        stream next. "/eat space.
        list add: self parseName.
    ].
    ^list.

    "Created: / 27-11-2012 / 20:30:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseNodeId
    "Parses node id from stream and returns it. Support both,
     short and full node ids"

    ^HGChangesetId readFrom: stream onError:[:msg|self error: msg]



    "
        (HGCommandParser on: '4:6f88e1f44d9eb86e0b56ca15e30e5d786acd83c7' readStream) parseNodeId

        Bad ones:

        (HGCommandParser on: '4:6f88e1f44d9eb86e0b56ca15e30e5d786acd' readStream) parseNodeId
        (HGCommandParser on: '4:6f88Z1f44d9eb86e0b56ca15e30e5d786acd83c7' readStream) parseNodeId

    "

    "Created: / 13-11-2012 / 10:22:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-11-2012 / 16:52:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseNodeIdList
    "Parses node id list from stream and returns it. Support both,
     short and full node ids."

    | ids |

    stream atEnd ifTrue:[ ^ #() ].
    stream peek == Character cr ifTrue:[ ^ #() ].
    ids := OrderedCollection new.
    [ stream peek ~~ Character cr ] whileTrue:[
        ids add: self parseNodeId.
        stream peek == Character space ifTrue:[stream next].
    ].
    ^ids

    "Created: / 05-12-2012 / 17:24:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parsePath
    "Parse single path entry from repository"

    ^self parseName

    "Created: / 05-12-2012 / 18:27:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parsePathCopy
    "Parse single path entry from repository"

    | dst src |

    dst := self parseName.
    self expectSpace.
    self expect:$(.
    src := String streamContents:[:out|
        [ stream peek == $) ] whileFalse:[
            out nextPut:stream next
        ].
        stream next.
    ].

    ^Array with: dst with: src

    "Created: / 05-12-2012 / 18:38:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parsePathCopyList
    | list |

    stream atEnd ifTrue:[ ^#() ].
    stream peek isSeparator ifTrue:[ ^#() ].
    list := OrderedCollection new.
    list add: self parsePathCopy.
    [ stream atEnd not and:[stream peek ~= Character cr]] whileTrue:[
        "/stream next. "/eat space.
        list add: self parsePathCopy.
    ].
    ^list.

    "Created: / 05-12-2012 / 18:39:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-01-2013 / 23:25:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parsePathList
    | list |

    stream atEnd ifTrue:[ ^#() ].
    stream peek isSeparator ifTrue:[ ^#() ].
    list := OrderedCollection new.
    list add: self parsePath.
    [ stream atEnd not and:[stream peek == Character space]] whileTrue:[
        stream next. "/eat space.
        list add: self parsePath.
    ].
    ^list.

    "Created: / 05-12-2012 / 18:27:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parsePushPull
    | info |
    info := HGPushPullInfo new.
    [ stream atEnd ] whileFalse:[
        | ln |
        ln := stream nextLine.
        (ln startsWith:'(run ''hg') ifFalse:[
            (ln startsWith:'remote: ') ifTrue:[
                ln := ln copyFrom: 9
            ].
            self notify: ln.
            (ln startsWith:'added ') ifTrue:[
                self parsePushPullSummaryInto: info from: ln readStream.  
            ]
        ]
    ].
    ^info.
    

"/    #(
"/        'adding changesets'
"/        'adding manifests'
"/        'adding file changes'
"/    ) do:[:info|
"/        stream peek == $r ifTrue:[
"/            self expect: 'remote: '.
"/        ].
"/        self expect:info; expectLineEnd.
"/        self notify:info.
"/    ].
"/    ^self parsePushPullSummary

    "Created: / 04-02-2013 / 15:01:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-12-2017 / 08:46:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parsePushPullSummary
    ^self parsePushPullSummaryInto:HGPushPullInfo new

    "Created: / 04-02-2013 / 15:02:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parsePushPullSummaryInto:info 
    "Example:

        'added 1 changesets with 1 changes to 1 files (+1 heads)'"
    
    | c |

    stream peek == $r ifTrue:[
        self expect:'remote: '.
    ].
    self expect:'added '.
    info setNumChangesets:self parseInteger.
    self expect:' changesets with '.
    info setNumChanges:self parseInteger.
    self expect:' changes to '.
    info setNumFiles:self parseInteger.
    self expect:' files'.
    c := stream next.
    c == Character space ifTrue:[
        self expect:$(.
        c := stream next.
        ('+-' includes:c) ifFalse:[
            self error:('got ''%1'', ''+'' or ''-'' expected' bindWith:c).
        ].
        info 
            setNumHeads:(self parseInteger * ((c == $-) ifTrue:[ -1 ] ifFalse:[ 1 ])).
        ^ info
    ].
    (stream atEnd or:[c == Character cr]) ifTrue:[
        ^ info
    ].
    self error:('got ''%1'', new line or space expected' bindWith:c).

    "Created: / 04-02-2013 / 15:26:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-07-2013 / 11:55:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parsePushPullSummaryInto: info from: auxStream

    | oldStream |

    oldStream := stream.
    [
        stream := auxStream.
        self parsePushPullSummaryInto: info
    ] ensure:[
        stream := oldStream.
    ].
    ^info

    "Created: / 13-07-2013 / 11:43:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommandParser methodsFor:'parsing - commands'!

parseCommandBookmarks
    "Parse output of 'hg bookmarks' command. Return collection
     of orphaned HGBookmark"

    ^self parseBookmarks

    "Created: / 20-03-2014 / 01:51:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseCommandBranches
    "Parse output of 'hg branches' command. Return collection
     of orphaned HGBranch"

    ^self parseBranches

    "Created: / 27-11-2012 / 19:16:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-11-2012 / 20:21:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseCommandHeads
    "Parse output of 'hg heads' command, assuming the template given
     was HGCommandParser templateHeads. Return a list of HGChangesetId."

    | ids |

    ids := OrderedCollection new.
    [ stream atEnd ] whileFalse:[
        ids add: self parseNodeId. self expectLineEnd.
    ].
    ^ids

    "Created: / 27-11-2012 / 21:24:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseCommandHelp 
    "Parse output of 'hg help topic'"

    ^ String streamContents:[ :out |
        [ stream atEnd ] whileFalse:[ 
            out nextPutLine: stream nextLine              
        ].
    ]

    "Created: / 07-02-2014 / 10:17:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseCommandLocate
    "Filenames are 0-byte separated. Yeah, Mercurial is easy
     to parse"

    | filenames |
    filenames := OrderedCollection new.
    [ stream atEnd ] whileFalse:[
        | filename |

        filename := stream nextLine.
        "/ Workaround for Mercurial 2.3.x which includes trailing new line
        (filename size ~~ 1 or:[filename first ~~ Character cr]) ifTrue:[
            filenames add:  filename
        ]
    ].
    ^filenames.

    "Created: / 16-11-2012 / 22:35:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-12-2012 / 00:09:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseCommandLog
    "Parse output of 'hg log' command, assuming the template given
     was HGCommandParser templateLog. Return a list of HGChangeset."

    "/ As of mercurial 3.1.1, a message like
    "/ 'invalid branchheads cache (visible): tip differs
    "/ may be written to the stdout. Following code test for it
    stream peek == $i ifTrue:[ 
        self notify: stream nextLine.  
    ].
    ^self parseLog

    "Created: / 13-11-2012 / 09:09:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-10-2014 / 21:22:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseCommandLogChildren
    "Parse output of 'hg log <path>' command, assuming the template given
     was HGCommandParser templateLogChildren. Return a list of pairs (HGChangesetId, list of HGChangesetId)"

    | revsAndChildren |

    revsAndChildren := OrderedCollection new.
    [ stream atEnd ] whileFalse:[
        | rev children |
        rev := self parseNodeId. self expectLineEnd.
        stream atEnd ifFalse:[
            children := self parseNodeIdList. self expectLineEnd.
        ] ifTrue: [
            children := #().
        ].
        revsAndChildren add: (Array with: rev with: children).
    ].
    ^revsAndChildren

    "Created: / 05-12-2012 / 23:44:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseCommandLogIdsOnly
    "Parse output of 'hg log <path>' command, assuming the template given
     was HGCommandParser templateLogFile. Return a list of HGChangesetId."
    
    | ids |

    ids := OrderedCollection new.
    [ stream atEnd ] whileFalse:[
        ids add:self parseNodeId.
        self expectLineEnd.
    ].
    ^ ids

    "Created: / 05-12-2012 / 19:15:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseCommandMerge
    "Parse output of 'hg update' command. "

    | info c |

    info := HGMergeInfo new.
    [ stream peek isDigit ] whileFalse:[
        [ c := stream peek. c isSeparator ] whileTrue:[ stream next ].
        c == $m ifTrue:[
            self parseMergePath: info.
        ] ifFalse:[
            c == $r ifTrue:[
                self parseMergeRemoteChanged: info
            ] ifFalse:[
                c == $l ifTrue:[
                    self parseMergeLocalChanged: info
                ] ifFalse:[
                    self error:'Unexpected merge line'
                ]
            ]
        ]
    ].
    self parseMergeSummary: info.
    c := stream next.
    c == $( ifTrue:[
        self expect: 'branch merge, don''t forget to commit)'.
        self expectLineEnd.
        ^info
    ].
    c == $u ifTrue:[
        "/ Mercurial 4.6 and newer prints
        "/ 
        "/     use 'hg resolve' to retry unresolved file merges or 'hg merge --abort' to abandon
        "/ 
        "/ while older versions print
        "/ 
        "/      use 'hg resolve' to retry unresolved file merges or 'hg update -C .' to abandon
        "/ 
        "/ We have to support both...

        self expect: 'se ''hg resolve'' to retry unresolved file merges or ''hg '.
        self nextLine. "/ eat the rest of the line
        ^info
    ].
    self error:('Unexpected character ''%1'' expecting ''('' or ''u''' bindWith: c)

    "Created: / 14-01-2013 / 15:57:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-08-2018 / 10:28:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseCommandPull
    "Parse output of 'hg pull' command."

    "
    Ex:

    pulling from ssh://dialin.exept.de/repositories/hg/exept.workflow
    searching for changes
    adding changesets
    adding manifests
    adding file changes
    added 16 changesets with 16 changes to 14 files (+1 heads)
    (run ''hg heads'' to see heads)       

    "
    | c |

    stream atEnd ifTrue:[
        ^ nil
    ].
    
    self expect:'pulling from'. stream nextLine.
    c := stream peek.
    c == $s ifTrue:[
        self expect: 'searching for changes'. stream nextLine.
        self notify: 'searching for changes'.
        c := stream peek.
    ].
    c == $r ifTrue:[
        self expect: 'requesting all changes'. stream nextLine.
        self notify: 'requesting all changes'.
        ^self parsePushPull
    ].
    c == $n ifTrue:[
        self expect: 'no changes found'. stream nextLine.
        self notify: 'no changes found'.
        ^HGPushPullInfo new
    ].

    [ c == $a ] whileTrue:[
        self expect: 'add'.
        c := stream peek.
        c == $i ifTrue:[
            "/ adding ...
            self expect: 'ing '.
            c := stream peek.
            c == $c ifTrue:[
                self expect: 'changesets'. stream nextLine.
                self notify: 'adding changesets'.
            ] ifFalse:[
            c == $m ifTrue:[
                self expect: 'manifests'. stream nextLine.
                self notify: 'adding manifests'.
            ] ifFalse:[
            c == $f ifTrue:[
                self expect: 'file changes'. stream nextLine.
                self notify: 'adding file changes'.  
            ]]]
        ] ifFalse:[
        c == $e ifTrue:[
            "/ added ... ('add' already eaten...)
            | line |

            line := 'add' , stream nextLine.
            ^ self parsePushPullSummaryInto: HGPushPullInfo new from: line readStream.
        ]].
        c := stream peek.
    ].

    self error:('Unexpected character ''%1'' expecting ''r'' or ''n''' bindWith: c)

    "Created: / 04-02-2013 / 15:35:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-11-2013 / 13:25:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseCommandPush
    "Parse output of 'hg push' command. "
    "
     Ex:

     pushing to /tmp/stx_tmp/stxtmp_7733_20/upstream
     searching for changes
    "
    | c |

    stream atEnd ifTrue:[
        ^ nil
    ].

    
    self expect:'pushing to'.stream nextLine.
    stream atEnd ifTrue:[ ^ nil ].
    c := stream peek.
    c == $s ifTrue:[
        self expect: 'searching for changes'. stream nextLine.
        self notify: 'searching for changes'.
        c := stream peek.
    ].
    c == $n ifTrue:[
        self expect:'no changes found'. stream nextLine.
        self notify: 'no changes found'.
        ^ HGPushPullInfo new
    ] ifFalse:[
        ^ self parsePushPull
    ].
    self error:('Unexpected character ''%1'' expecting ''s'' or ''n''' bindWith: c)

    "Created: / 10-12-2012 / 02:15:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-02-2013 / 23:49:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseCommandResolveList
    "Parse output of 'hg resolve --list' command. Return dictionary <path,status>"

    | statuses |

    statuses := Dictionary new.

    [ stream atEnd ] whileFalse:[
        | status path |

        status := stream next.
        (status == $U or:[status == $R]) ifFalse:[
            self error:'Unknown resolution status: ', status.
        ].
        self expectSpace.
        path := self parsePath.
        statuses at: path put: status.
        self expectLineEnd.
    ].
    ^statuses

    "Created: / 14-01-2013 / 16:45:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseCommandShowConfig
    "Parse output of 'hg showconfig' command, assuming the template given
     was HGCommandParser templateLog. Return a list of HGChangeset."

    ^self parseConfig

    "Created: / 06-12-2012 / 16:00:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseCommandStatus
    | statusesAndPaths |
    statusesAndPaths := OrderedCollection new.
    [ stream atEnd ] whileFalse:[
        | status path |

        stream peek == Character space ifTrue:[
            statusesAndPaths last first"status" isAdded ifTrue:[
                stream next.
                self expectSpace.
                path := self nextLine.
                statusesAndPaths last at:1 put: (HGStatus copied source: path)
            ] ifFalse:[
                self error:'Malformed status output, status code expected, got space'
            ]
        ] ifFalse:[
            status := HGStatus forCode: self next.
            self expectSpace.
            path := self nextLine.
            statusesAndPaths add: { status . path }
        ].
    ].
    ^ statusesAndPaths

    "Created: / 23-10-2012 / 10:57:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-11-2012 / 01:09:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseCommandUpdate
    "Parse output of 'hg update' command. "

    ^self parseMergeSummary

    "Created: / 14-01-2013 / 15:48:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseCommandVersion
    "Parse output of 'hg --version'"

    "
    Mercurial Distributed SCM (version 2.3.2)
    (see http://mercurial.selenic.com for more information)
    
    Copyright (C) 2005-2012 Matt Mackall and others
    This is free software; see the source for copying conditions. There is NO
    warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
    "

    | major minor revision |

    self 
        expect:'Mercurial'; skipSeparators;
        expect:'Distributed'; skipSeparators;
        expect:'SCM'; skipSeparators;
        expect:$(; skipSeparators;
        expect:'version'.

    major := self parseInteger.
    self expect:$..
    minor := self parseInteger.
    stream peek == $. ifTrue:[
        stream next.
        revision := self parseInteger.
    ].

    (stream peek ~~ $) and:[ stream peek ~~ $+]) ifTrue:[ 
        self error: ('Expected ''$)'' or ''+'' got ''%2''.' bindWith: stream peek).
    ].

    ^(Array with: major with: minor with: revision)

    "Created: / 19-11-2012 / 20:19:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-12-2014 / 20:25:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommandParser methodsFor:'parsing - errors'!

parseError
    ^self parseErrorClass: HGCommandError

    "Created: / 04-02-2013 / 12:21:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseError: parseBlock
    [ stream atEnd ] whileFalse:[
        self parseError1: parseBlock.  
    ].
    ^nil

    "Created: / 04-02-2013 / 12:21:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-11-2014 / 00:29:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseErrorBookmark
    ^self parseErrorClass: HGBookmarkError

    "Created: / 20-03-2014 / 17:28:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseErrorBranches
    [ stream atEnd ] whileFalse:[
        | c word |

        c := stream peek.
        c == $i ifTrue:[
            "/ Mercurial <  2.7 uses 'invalidating branch cache (tip differs)'.
            "/ Mercurial >= 2.7 uses 'invalid branchheads cache (served): tip differs'
            "/                    or 'invalid branchheads cache (visible): tip differs'
            "/ Sigh...
            self expect: 'invalid'.
            c := stream peek.
            c == $a ifTrue:[
                self expect: 'ating branch cache'.
                stream nextLine. "/ eat reast of the line
            ] ifFalse:[c == Character space ifTrue:[
                self expect: ' branchheads cache'.
                stream nextLine. "/ eat reast of the line
            ]].


        ] ifFalse:[
            self parseError1: [ :msg | self error: msg ]  
        ]
    ].
    ^nil

    "Created: / 06-02-2013 / 19:18:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-11-2014 / 00:43:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseErrorClass: errorClass
    "Generic error output parse. Returns an initialized
     error (instance of errorClass) if an error occures,
     nil if not.

     An error is indicated by 'abort: ' prefix."

    self parseError:[:msg|
        self propagate: errorClass message: msg
    ].

    "Created: / 04-02-2013 / 12:50:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-02-2013 / 21:58:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseErrorCommit
    ^self parseErrorClass: HGCommitError

    "Created: / 04-02-2013 / 12:21:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseErrorPush
    ^self parseError: [:msg |
        (msg startsWith: 'push creates new remote head ') ifTrue:[
            | newHeadId err |

            newHeadId := HGChangesetId fromString: (msg copyFrom: 30 to: msg size -1).
            err := HGPushWouldCreateNewHeadError newException
                        parameter: newHeadId;
                        messageText: msg;
                        yourself.
            self propagate: err.                          
        ] ifFalse:[
            self propagate: HGError message: msg
        ].

    ].

    "Created: / 04-02-2013 / 12:49:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-03-2014 / 15:39:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommandParser methodsFor:'parsing - errors - private'!

parseError1: parseBlock
    "/ Parse at most one error from stream and returs.

    | c word line |

    c := stream peek.
    c isNil ifTrue:[ ^ self ]. "/ stream closed / already at end

    "/ Care for "*** failed to import extension" messages...
    c == $* ifTrue:[ 
        stream next.
        c := stream peek.
        c == $* ifTrue:[ 
            stream next.
            c := stream peek.
            c == $* ifTrue:[ 
                stream next.
                self notify: stream nextLine.
                ^ self.
            ].
        ].
        self notify: stream nextLine.
        ^ self.
    ].
    "/ parse `abort: some error messsage` error format
    c == $a ifTrue:[
        word := stream upTo: $:.
        stream next. "/eat space
        word = 'abort' ifTrue:[
            self parseError1: parseBlock message: stream nextLine.              
            ^ self.
        ].
    ].
    "/ parse `hg: parse error: some error messsage` error format introduced in Mercurial 4.3
    c == $h ifTrue:[
        word := stream upTo: $:.
        word = 'hg' ifTrue:[
            stream next. "/eat space
            c := stream peek.
            c == $p ifTrue:[
                self expect: 'parse error: '.
                self parseError1: parseBlock message: stream nextLine.                
                ^ self.
            ].
        ].
    ].


    "/ Special hack for mercurial_keyring extension, sigh...
    line := stream nextLine.
    "/ If c == $a we may have already read some data. In that case,
    "/ word is not nil and we have to preprend it to line read just above...
    word notNil ifTrue:[ 
        line := word , (line ? '')
    ].

    (line includesSubString: 'mercurial_keyring.py') ifTrue:[
        (line endsWith: 'UserWarning: Basic Auth Realm was unquoted') ifTrue:[
            stream nextLine.
        ].
        ^ self.
    ].
    self notify: 'Unexpected error output: ', line.
    ^ self.

    "Created: / 06-11-2014 / 00:28:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-10-2017 / 09:55:50 / jv"
    "Modified: / 08-02-2018 / 08:51:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseError1: parseBlock message: errorMessage
    "Parse given `errorMmessage` using `parseBlock`. Handle common errors here,
     pass the rest to the parseBlock to handle."

    (errorMessage startsWith: 'unknown revision ''') ifTrue:[
        | rev err |

        rev := HGChangesetId readFrom: (errorMessage readStream skip: 'unknown revision ''' size) onError:[ nil ].
        err := HGUnknownRevisionError newException
                    parameter: rev;
                    messageText: errorMessage; yourself.
        self propagate: err.
        ^ self.
    ].
    (errorMessage startsWith: 'hidden revision ''') ifTrue:[
        | rev err |

        rev := HGChangesetId readFrom: (errorMessage readStream skip: 'hidden revision ''' size) onError:[ self error: 'Cannot parse changeset ID from error message!!' ].
        err := HGObsoleteRevisionError newException
                    parameter: rev;
                    messageText: errorMessage; yourself.
        self propagate: err.
        ^ self.
    ].
    parseBlock value: errorMessage

    "Created: / 08-02-2018 / 08:51:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommandParser methodsFor:'parsing - files'!

parseDotHgBookmarks
    "Parse contents of .hg/bookmarks, return a collection
     of orphaned HGBookmark"

    | bookmarks |

    bookmarks := OrderedCollection new.
    [ stream atEnd ] whileFalse:[ 
        | bookmark |

        bookmark := HGBookmark new.
        bookmark setChangesetId: self parseNodeId.
        stream skipSeparators.
        bookmark setName: stream nextLine.
        bookmarks add: bookmark
    ].
    ^ bookmarks

    "Created: / 20-03-2014 / 02:10:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-03-2014 / 18:53:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommandParser methodsFor:'parsing - shell'!

parseShellCommand
    "Parses input stream as a shell command. Returns
     an array of arguments (main's argv[], actually)"

    OperatingSystem isMSWINDOWSNTlike ifTrue:[ 
        ^ self parseShellCommandAsForCmd
    ] ifFalse:[
        ^ self parseShellCommandAsForSh
    ]

    "Created: / 17-07-2014 / 12:25:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseShellCommandAsForCmd
    ^ Array streamContents:[ :argv | 
        stream skipSeparators.
        [ stream atEnd ] whileFalse:[
            argv nextPut: self parseShellCommandTokenAsForCmd.
            stream skipSeparators.   
        ].
    ].

    "Created: / 17-07-2014 / 12:53:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseShellCommandAsForSh
    ^ Array streamContents:[ :argv | 
        stream skipSeparators.
        [ stream atEnd ] whileFalse:[
            argv nextPut: self parseShellCommandTokenAsForSh.
            stream skipSeparators.   
        ].
    ].

    "Created: / 17-07-2014 / 12:53:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseShellCommandTokenAsForCmd
    | buffer char done1 done2 |

    buffer := (String new: 10) writeStream.
    done1 := false.
    char := stream next.
    [ done1 ] whileFalse:[
        char == $" ifTrue:[ 
            done2 := false.
            [ done2 ] whileFalse:[
                stream atEnd ifTrue:[ self error:'Unterminated string token'. ^ nil ].
                char := stream next.
                char == $" ifTrue:[
                    done2 := true.
                ] ifFalse:[ 
                    buffer nextPut: char      
                ].
            ]
        ] ifFalse:[ 
            char == $^ ifTrue:[ 
                stream atEnd ifTrue:[ self error:'Unterminated string token'. ^ nil ].
                char := stream next.                    
                char == Character space ifTrue:[ 
                    buffer nextPut: $^ 
                ].
            ].
            buffer nextPut: char.   
        ].
        char := stream atEnd ifTrue:[ nil ] ifFalse:[ stream next ].  
        done1 := char isNil or:[ char isSeparator ].
    ].
    ^ buffer contents

    "Created: / 17-07-2014 / 12:32:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-07-2014 / 14:31:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parseShellCommandTokenAsForSh
    | buffer char done1 done2 |

    buffer := (String new: 10) writeStream.
    done1 := false.
    char := stream next.
    [ done1 ] whileFalse:[
        char == $" ifTrue:[ 
            done2 := false.
            [ done2 ] whileFalse:[
                stream atEnd ifTrue:[ self error:'Unterminated string token'. ^ nil ].
                char := stream next.
                char == $\ ifTrue:[ 
                    stream atEnd ifTrue:[ self error:'Unterminated string token'. ^ nil ].
                    char := stream next.
                    char == $" ifTrue:[ 
                        buffer nextPut: $"  
                    ] ifFalse:[ 
                        buffer nextPut: $\; nextPut: char  
                    ].
                ] ifFalse:[ char == $" ifTrue:[
                    done2 := true.
                ] ifFalse:[ 
                    buffer nextPut: char      
                ]].
            ]
        ] ifFalse:[ char == $' ifTrue:[ 
            done2 := false.
            [ done2 ] whileFalse:[
                stream atEnd ifTrue:[ self error:'Unterminated string token'. ^ nil ].
                char := stream next.
                char == $' ifTrue:[
                    done2 := true.
                ] ifFalse:[ 
                    buffer nextPut: char      
                ].                       
            ]
        ] ifFalse:[ 
            char == $\ ifTrue:[ 
                stream atEnd ifTrue:[ self error:'Unterminated string token'. ^ nil ].
                char := stream next.                    
            ].
            buffer nextPut: char.   
        ]].
        char := stream atEnd ifTrue:[ nil ] ifFalse:[ stream next ].  
        done1 := char isNil or:[ char isSeparator ].
    ].
    ^ buffer contents

    "Created: / 17-07-2014 / 12:32:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-07-2014 / 14:11:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommandParser methodsFor:'parsing - utils'!

expect: aStringOrChar

    | c |
    aStringOrChar isCharacter ifTrue:[
        (stream atEnd or:[(c := stream next) ~= aStringOrChar]) ifTrue:[
            self error:('Expected ''%1'' got ''%2''.' bindWith: aStringOrChar with: c).
        ].
        ^self.
    ].
    aStringOrChar isString ifTrue:[
        aStringOrChar do:[:expected|
            (stream atEnd or:[(c := stream next) ~= expected]) ifTrue:[
                self error:('Expected ''%1''.' bindWith: aStringOrChar).
            ].
        ].
        ^self.
    ].

    self error:'Invalid expected value'.

    "Created: / 19-11-2012 / 20:08:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

expectLineEnd
    self expect: Character cr.

    "Created: / 19-11-2012 / 20:06:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

expectSpace
    self expect: Character space.

    "Created: / 19-11-2012 / 20:06:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

next
    ^stream next.

    "Created: / 23-10-2012 / 10:57:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nextLine
    ^stream nextLine

    "Created: / 23-10-2012 / 11:05:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-11-2012 / 12:02:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

skipSeparators
    stream skipSeparators

    "Created: / 19-11-2012 / 20:05:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCommandParser class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

