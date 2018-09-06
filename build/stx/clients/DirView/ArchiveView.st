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


"{ NameSpace: Demos }"

DirectoryView subclass:#ArchiveView
	instanceVariableNames:'archiveName'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-DirectoryView'
!

!ArchiveView class methodsFor:'documentation'!

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
    to show archives (tar ...)

    [author:]
        Claus Gittinger (fall 93)
"

! !

!ArchiveView class methodsFor:'defaults'!

icon
    ^ (Image fromFile:'bitmaps/ArchiveObj.xbm' resolution:100)

    "Modified: 24.1.1997 / 16:57:13 / cg"
! !

!ArchiveView methodsFor:'accessing'!

showContentsOf:pathName
    pathName asFilename exists ifTrue:[
	archiveName := pathName.
	self updateContents
    ]
! !

!ArchiveView methodsFor:'drag & drop'!

canDrop:anObject
    ^ false
!

drop:something at:aPoint from:aView with:aBlock ifFail:failBlock
    ^ failBlock value
!

dropObject:anObject at:aPoint
    ^ false
!

move:something to:aPoint in:aView
    "move something into another view"

    |newObject|

    "have to extract the file, then do the move"

    newObject := self extractFile:something name.
    newObject notNil ifTrue:[
	super move:newObject to:aPoint in:aView
    ]
! !

!ArchiveView methodsFor:'extracting'!

extractFile:aFileName
    (archiveName endsWith:'.tar') ifTrue:[
	^ self extractTarFile:aFileName
    ].
    (archiveName endsWith:'.tar.Z') ifTrue:[
	^ self extractTarZFile:aFileName
    ].
    (archiveName endsWith:'.tz') ifTrue:[
	^ self extractTarZFile:aFileName
    ].
    (archiveName endsWith:'.tar.gz') ifTrue:[
	^ self extractTarGZFile:aFileName
    ].
    (archiveName endsWith:'.zip') ifTrue:[
	^ self extractZipFile:aFileName
    ].
    ^ nil
!

extractTarFile:aFileName
    |ok isAbsolute absPath obj|

    (aFileName startsWith:'/') ifTrue:[
	ok := self confirm:'file has absolute pathname - extract ?'.
	ok ifFalse:[^ false].
	isAbsolute := true.
    ] ifFalse:[
	isAbsolute := false
    ].

    isAbsolute ifTrue:[
	"can extract it anywhere"

	ok := OperatingSystem executeCommand:'tar xf ' , archiveName , 
					     ' ', aFileName
    ] ifFalse:[
	"change to usr/tmp - extract there"

	(archiveName startsWith:'/') ifTrue:[
	    absPath := archiveName
	] ifFalse:[
	   absPath := (FileStream oldFileNamed:archiveName
					     in:FileDirectory currentDirectory) pathName.
	].
	ok := OperatingSystem executeCommand:'cd /tmp;tar xf ',
					     absPath , ' ', aFileName.
	ok ifTrue:[
	    obj := self objectForFile:aFileName.
	    obj font:font.
	    obj pathName:('/tmp/' , aFileName).
	].
    ].
    ^ obj
!

extractTarGZFile:aFileName
    |ok isAbsolute absPath obj|

    (aFileName startsWith:'/') ifTrue:[
	ok := self confirm:'file has absolute pathname - extract ?'.
	ok ifFalse:[^ false].
	isAbsolute := true.
    ] ifFalse:[
	isAbsolute := false
    ].

    isAbsolute ifTrue:[
	"can extract it anywhere"

	ok := OperatingSystem executeCommand:'gunzip ', archiveName , 
					     '| tar xf - ', aFileName
    ] ifFalse:[
	"change to usr/tmp - extract there"

	(archiveName startsWith:'/') ifTrue:[
	    absPath := archiveName
	] ifFalse:[
	   absPath := (FileStream oldFileNamed:archiveName
					     in:FileDirectory currentDirectory) pathName.
	].
	ok := OperatingSystem executeCommand:'cd /tmp;gunzip <',
					     absPath , '|tar xf - ', aFileName.
	ok ifTrue:[
	    obj := self objectForFile:aFileName.
	    obj font:font.
	    obj pathName:('/tmp/' , aFileName).
	].
    ].
    ^ obj
!

extractTarZFile:aFileName
    |ok isAbsolute absPath obj|

    (aFileName startsWith:'/') ifTrue:[
	ok := self confirm:'file has absolute pathname - extract ?'.
	ok ifFalse:[^ false].
	isAbsolute := true.
    ] ifFalse:[
	isAbsolute := false
    ].

    isAbsolute ifTrue:[
	"can extract it anywhere"

	ok := OperatingSystem executeCommand:'uncompress <', archiveName , 
					     '| tar xf - ', aFileName
    ] ifFalse:[
	"change to usr/tmp - extract there"

	(archiveName startsWith:'/') ifTrue:[
	    absPath := archiveName
	] ifFalse:[
	   absPath := (FileStream oldFileNamed:archiveName
					     in:FileDirectory currentDirectory) pathName.
	].
	ok := OperatingSystem executeCommand:'cd /tmp;uncompress < ',
					     absPath , '|tar xf - ', aFileName.
	ok ifTrue:[
	    obj := self objectForFile:aFileName.
	    obj font:font.
	    obj pathName:('/tmp/' , aFileName).
	].
    ].
    ^ obj
!

extractZipFile:aFileName
    |ok isAbsolute absPath obj|

    "change to usr/tmp - extract there"

    (archiveName startsWith:'/') ifTrue:[
	absPath := archiveName
    ] ifFalse:[
       absPath := (FileStream oldFileNamed:archiveName
					in:FileDirectory currentDirectory) pathName.
    ].
    ok := OperatingSystem executeCommand:'cd /tmp;unzip -x ',
					     absPath , ' ', aFileName.
    ok ifTrue:[
	obj := self objectForFile:aFileName.
	obj font:font.
	obj pathName:('/tmp/' , aFileName).
    ].
    ^ obj
! !

!ArchiveView methodsFor:'initialization'!

initialize
    super initialize.
    checkBlock := nil
!

privateRealize
!

setupContentsSpecific 
! !

!ArchiveView methodsFor:'private'!

archiveContents
    "read the archive - return a list of names"

    (archiveName endsWith:'.tar') ifTrue:[
	^ self tarContents
    ].
    (archiveName endsWith:'.tar.Z') ifTrue:[
	^ self tarZContents
    ].
    (archiveName endsWith:'.tz') ifTrue:[
	^ self tarZContents
    ].
    (archiveName endsWith:'.taz') ifTrue:[
	^ self tarZContents
    ].
    (archiveName endsWith:'.tar.gz') ifTrue:[
	^ self tarGZContents
    ].
    (archiveName endsWith:'.zip') ifTrue:[
	^ self zipContents
    ].
    ^ #()
!

objectForFile:aFileName
    |type mode index sz fName iconFileName val
     icon mask actionBlock newObject|

    type := #regular.
    mode := nil.

    "get an icon-filename"
    userIconDefs notNil ifTrue:[
	index := 1.
	sz := userIconDefs size.
	[index <= sz] whileTrue:[
	    val := (userIconDefs at:index) value:aFileName
					   value:type
					   value:mode.
	    (val isKindOf:String) ifTrue:[
		fName := val.
		index := sz  "exit loop"
	    ].
	    index := index + 1
	]
    ].
    fName isNil ifTrue:[
	systemIconDefs notNil ifTrue:[
	    index := 1.
	    sz := systemIconDefs size.
	    [index <= sz] whileTrue:[
		val := (systemIconDefs at:index) value:aFileName
						 value:type
						 value:mode.
		(val isKindOf:String) ifTrue:[
		    fName := val.
		    index := sz  "exit loop"
		].
		index := index + 1
	    ]
	]
    ].
    fName isNil ifTrue:[
	fName := 'FileObj'
    ].
    iconFileName := fName.
    icon := self getFormFromFile:(iconFileName , '.xbm').
    mask := self getFormFromFile:(fName , '_m.xbm').

    icon isNil ifTrue:[
	icon := self getFormFromFile:'FileObj.xbm'.
	mask := self getFormFromFile:'FileObj_m.xbm'
    ].
    newObject := (FileObject new) icon:icon mask:mask.

    "get actionblock"
    userActionDefs notNil ifTrue:[
	index := 1.
	sz := userActionDefs size.
	[index <= sz] whileTrue:[
	    val := (userActionDefs at:index) value:aFileName
					     value:type
					     value:mode.
	    (val isKindOf:BlockNode) ifTrue:[
		actionBlock := val.
		index := sz  "exit loop"
	    ].
	    index := index + 1
	]
    ].
    actionBlock isNil ifTrue:[
	systemActionDefs notNil ifTrue:[
	    index := 1.
	    sz := systemActionDefs size.
	    [index <= sz] whileTrue:[
		val := (systemActionDefs at:index) value:aFileName
						   value:type
						   value:mode.
		(val isKindOf:BlockNode) ifTrue:[
		    actionBlock := val.
		    index := sz  "exit loop"
		].
		index := index + 1
	    ]
	]
    ].
    "none specified - set default action"
    actionBlock isNil ifTrue:[
	actionBlock := fileAction
    ].
    newObject action:actionBlock.
    ^ newObject
!

tarContents
    "read the tar file - return a list of names"

    |p list line|

    list := OrderedCollection new.
    p := PipeStream readingFrom:('tar tf ' , archiveName).
    [p atEnd] whileFalse:[
	line := p nextLine.
	line notNil ifTrue:[
	    list add:line
	]
    ].
    p close.
    ^ list
!

tarGZContents
    "read the tar file - return a list of names"

    |p list line|

    list := OrderedCollection new.
    p := PipeStream readingFrom:('gunzip <' , archiveName , '|tar tf -').
    [p atEnd] whileFalse:[
	line := p nextLine.
	line notNil ifTrue:[
	    list add:line
	]
    ].
    p close.
    ^ list
!

tarZContents
    "read the tar file - return a list of names"

    |p list line|

    list := OrderedCollection new.
    p := PipeStream readingFrom:('uncompress <' , archiveName , '|tar tf -').
    [p atEnd] whileFalse:[
	line := p nextLine.
	line notNil ifTrue:[
	    list add:line
	]
    ].
    p close.
    ^ list
!

updateContents
    "read in currentDirectory - show pictures"

    |files|

    contents size == 0 ifTrue:[
	self removeAllWithoutRedraw.
	self topView label:'Archive: ' , archiveName.
	self topView iconName:archiveName.

	files := self archiveContents asStringCollection.
	files do:[:aFileName |
	    |obj|

	    obj := self objectForFile:aFileName.
	    obj font:font.
	    obj name:aFileName.
	    obj origin:0@0.
	    self addWithoutRedraw:obj.
	].
	self showObjects.
    ]
!

zipContents
    "read the tar file - return a list of names"

    |p list line idx|

    list := OrderedCollection new.
    p := PipeStream readingFrom:('unzip -l ' , archiveName).
    p notNil ifTrue:[
	line := p nextLine.
	[line isNil or:[line withoutSpaces startsWith:'Length']] whileFalse:[
	    line := p nextLine
	].
	[p atEnd] whileFalse:[
	    line := p nextLine.
	    line notNil ifTrue:[
		idx := line indexOf:$^.
		idx ~~ 0 ifTrue:[
		    list add:(line copyFrom:idx + 1)
		]
	    ]
	].
    ].
    p close.
    ^ list
! !

!ArchiveView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DirView/ArchiveView.st,v 1.9 1997-01-24 16:05:06 cg Exp $'
! !
