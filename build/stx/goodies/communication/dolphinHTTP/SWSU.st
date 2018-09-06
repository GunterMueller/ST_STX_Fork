"{ Package: 'stx:goodies/communication/dolphinHTTP' }"

Object subclass:#SWSU
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Dolphin-Spt-HTTP-Support'
!

SWSU comment:'Loose method pain avoidence class'
!


!SWSU class methodsFor:'public'!

addPathSlash: aPath
	(aPath isNil or: [aPath isEmpty]) ifTrue: [^aPath].
	^aPath last = $\ ifTrue: [aPath] ifFalse: [aPath , '\']
!

addUrlSlash: aUrlString
	(aUrlString isNil or: [aUrlString isEmpty]) ifTrue: [^aUrlString].
	^aUrlString last = $/ ifTrue: [aUrlString] ifFalse: [aUrlString , '/']
!

extractHTMLFormatFragment: anHTMLFormatString
	| stream |
	stream := anHTMLFormatString readStream.
	(stream skipToAll: '<!!--StartFragment-->') 
		ifFalse: [self error: 'Could not find the StartFragment comment'].
	^stream upToAll: '<!!--EndFragment-->'
!

extractHTMLFormatSourceURL: anHTMLFormatString
	| stream |
	stream := anHTMLFormatString readStream.
	(stream skipToAll: 'SourceURL:') 
		ifFalse: [self error: 'Could not find the SourceURL header'].
	^(stream swUpToWhile: [:c | (c = Character lf | (c = Character cr)) not]) trimBlanks
!

makePathUnique: aPathAndFilename
        "Note: Windows functions for this only seem to be win2k+"

        | split newFilename fnSplit num |
        (File exists: aPathAndFilename) ifFalse: [^aPathAndFilename].
        split := File splitPath: aPathAndFilename.
        ('*(*)' match: split third ignoreCase: true) 
                ifTrue: 
                        [fnSplit := self split: split third atLast: $(.
                        num := [Integer fromString: (fnSplit second copyFrom: 1 to: fnSplit second size - 1)] 
                                                on: Error
                                                do: [:e | 0].
                        num := num + 1.
                        newFilename := fnSplit first , '(' , num displayString , ')']
                ifFalse: [newFilename := split third , ' (1)'].
        ^self makePathUnique: (File 
                                composePath: split first , split second
                                stem: newFilename
                                extension: split fourth)

    "Modified: / 23-09-2011 / 21:08:23 / cg"
!

numFilesIn: aPath
	| count |
	count := 0.
	File 
		for: '*.*'
		in: aPath
		do: [:each | each isDirectory ifFalse: [count := count + 1]].
	^count
!

rootPathOf: path
	^(File splitPath: path) first asUppercase copyWith: File pathDelimiter
! !

!SWSU class methodsFor:'strings'!

byteSizeStringFor: bytes
	bytes < 1024 ifTrue: [^bytes displayString , ' bytes'].
	bytes <= 1000000 ifTrue: [^(bytes / 1024 roundTo: 0.1) displayString , 'KB'].
	bytes <= (1024 * 1024 * 1023) 
		ifTrue: [^(bytes / 1024 / 1024 roundTo: 1.0e-002) displayString , 'MB'].
	^(bytes / 1024 / 1024 / 1024 roundTo: 1.0e-002) displayString , 'GB'
!

copy: aString expanding: aTable
	"Answer a copy of the receiver with the chartacters in aTable expanded to their value strings.
	-aTable must be a table keying characters to strings"

	| keys stream |
	keys := aTable keys asArray.
	stream := WriteStream on: (String new: aString size).
	aString do: 
			[:each | 
			(keys includes: each) 
				ifTrue: [stream nextPutAll: (aTable at: each)]
				ifFalse: [stream nextPut: each]].
	^stream contents
!

copyCombiningSeparators: aString
	| inStream outStream isLastSeparator |
	inStream := aString readStream.
	outStream := (String new: aString size) writeStream.
	isLastSeparator := false.
	[inStream atEnd] whileFalse: 
			[| next |
			next := inStream next.
			next isSeparator 
				ifTrue: 
					[isLastSeparator 
						ifFalse: 
							[outStream space.
							isLastSeparator := true]]
				ifFalse: 
					[isLastSeparator := false.
					outStream nextPut: next]].
	^outStream contents
!

copyReplacingLineDelimiters: aString
	^aString 
		collect: [:each | each isLinefeed | (each = Character cr) ifTrue: [Character space] ifFalse: [each]]
!

does: aString1 endWith: aString2
	aString2 size > aString1 size ifTrue: [^false].
	^(aString1 last: aString2 size) = aString2
!

pad: aString with: aChar to: aNumber
	| newString |
	newString := (String new: aNumber) atAllPut: aChar.
	^aString 
		replaceBytesOf: newString
		from: 1
		to: (aString size min: aNumber - 2)
		startingAt: 1
!

padLeft: aString with: aChar to: aNumber
	aString size >= aNumber ifTrue: [^aString].
	^(String new: aNumber - aString size withAll: aChar) , aString
!

split: aString atLast: aCharacter
	| charIndex |
	charIndex := aString findLast: [:c | c = aCharacter].
	^charIndex = 0 
		ifTrue: [Array with: aString with: nil]
		ifFalse: 
			[Array with: (aString copyFrom: 1 to: charIndex - 1)
				with: (aString copyFrom: charIndex + 1 to: aString size)]
!

truncate: aString to: anInteger
	"truncate to anInteger chars if needed.
	Note it puts a space between the truncation and elipses"

	^aString size > anInteger 
		ifTrue: [(aString leftString: anInteger - 4) , ' ...']
		ifFalse: [aString]
!

truncateStart: aString to: anInteger
	"truncate to anInteger chars if needed ... anInteger could be 4, but really??"

	anInteger < 5 ifTrue: [self error: 'Invalid truncatation argument'].
	^aString size > anInteger 
		ifTrue: ['...' , (aString rightString: anInteger - 3)]
		ifFalse: [aString]
! !

!SWSU class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SWSU.st,v 1.2 2011-09-23 20:22:25 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SWSU.st,v 1.2 2011-09-23 20:22:25 cg Exp $'
! !
