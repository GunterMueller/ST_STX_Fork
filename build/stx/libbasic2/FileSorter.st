"
 COPYRIGHT (c) 2004 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

Object subclass:#FileSorter
	instanceVariableNames:'directoriesBeforeFiles selector sortCaseless sortReverse'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Tools-File'
!

!FileSorter class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2004 by eXept Software AG
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
    sort files by selector
    care for directoriesBeforeFiles sortCaseless sortReverse

    [author:]
        Christian Penk

    [instance variables:]
    directoriesBeforeFiles: if true all directories and files will be sorted 
                            independently by the selector and the directories 
                            are before files 
    sortCaseless:           if true and the selector is #baseName ignore upper
                            and lowercase in sort
    sortReverse:            if true starts with highest value of the sort

    [class variables:]

    [see also:]

"
! !

!FileSorter class methodsFor:'instance creation'!

directoriesBeforeFiles:arg1 selector:arg2 sortCaseless:arg3 sortReverse:arg4
    ^ self new directoriesBeforeFiles:arg1 selector:arg2 sortCaseless:arg3 sortReverse:arg4
! !

!FileSorter methodsFor:'accessing'!

directoriesBeforeFiles
    ^ directoriesBeforeFiles ? false
!

directoriesBeforeFiles:something
    directoriesBeforeFiles := something.
!

directoriesBeforeFiles:directoriesBeforeFilesArg selector:selectorArg sortCaseless:sortCaselessArg sortReverse:sortReverseArg 
    "set instance variables (automatically generated)"

    directoriesBeforeFiles := directoriesBeforeFilesArg.
    selector := selectorArg.
    sortCaseless := sortCaselessArg.
    sortReverse := sortReverseArg.
!

selector
    ^ selector
!

selector:something
    selector := something.
!

sortCaseless
    sortCaseless isNil ifTrue:[^ Filename isCaseSensitive not ].
    ^ sortCaseless

    "Modified: / 14-10-2010 / 19:11:18 / cg"
!

sortCaseless:something
    sortCaseless := something.
!

sortReverse
    ^ sortReverse ? false
!

sortReverse:something
    sortReverse := something.
! !

!FileSorter methodsFor:'action'!

sortItemList:aList

    |selectorSymbol instanceSortBlock cmpOp sortBlock locSortReverse convertToString caseLessNameString |

    selectorSymbol := selector asSymbol.
    sortReverse ifTrue:[
        cmpOp := #>.
    ] ifFalse:[
        cmpOp := #<.
    ].
    locSortReverse := self sortReverse.
    caseLessNameString := sortCaseless and:[selector = #baseName].

    instanceSortBlock := [:a :b | 
        |entry1 entry2|

        entry1 := a perform:selectorSymbol.
        entry2 := b perform:selectorSymbol.
        (entry1 isNil or:[entry2 isNil]) ifTrue:[
            (entry1 isNil and:[entry2 isNil]) ifTrue:[
                true
            ] ifFalse:[
                (entry1 notNil and:[entry2 isNil]) ifTrue:[
                    locSortReverse
                ] ifFalse:[
                    locSortReverse not
                ]
            ]
        ] ifFalse:[
            convertToString isNil ifTrue:[
                "if we have to convert the first pair of values, convert every pair"
                convertToString := ((entry1 isNumber and:[entry2 isNumber]) 
                                    or:[(entry1 respondsTo:cmpOp) and:[entry2 respondsTo:cmpOp]]) not.
            ].
            convertToString ifTrue:[
                entry1 := entry1 asString.
                entry2 := entry2 asString.
            ].
            caseLessNameString ifTrue:[
                entry1 := entry1 asLowercase.
                entry2 := entry2 asLowercase.
            ].
            entry1 perform:cmpOp with:entry2
        ]
    ].

    directoriesBeforeFiles ifTrue:[
        sortBlock := [:a :b|
            |aIsDir|

            aIsDir := a isDirectory.
            (aIsDir ~~ b isDirectory) ifTrue:[
                "one is a directory, the other is not"
                aIsDir 
            ] ifFalse:[
                instanceSortBlock value:a value:b.
            ].
          ].
    ] ifFalse:[
        sortBlock := instanceSortBlock.
    ].

    aList notEmptyOrNil ifTrue:[aList sort:sortBlock].
    ^ aList
! !

!FileSorter class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/FileSorter.st,v 1.9 2012-11-25 08:53:04 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic2/FileSorter.st,v 1.9 2012-11-25 08:53:04 cg Exp $'
! !
