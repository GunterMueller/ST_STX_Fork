"{ Package: 'stx:libdb/nosql/minneStore' }"

"{ NameSpace: Minnestore }"

Object subclass:#FlavorCompatibility
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-MinneStore-GG-Patch'
!

FlavorCompatibility comment:'    This class generalizes messages for Dolphin Smalltalk.
    PATCHED BY GIOVANNI GIORGI
	to work with VW3.0 and 2.5.x'
!


!FlavorCompatibility class methodsFor:'Giorgi Giovanni Patch 2 Gen99'!

Comment
"   
    This class generalizes messages for Dolphin Smalltalk.
    PATCHED BY GIOVANNI GIORGI
	to work with VW3.0 and 2.5.x
"
!

FlavorCompatibility
    "This is a dummy method for file-out purposes."
!

MinneStore
	"Used to just have a symbol #MinneStore in dangling methods, but VAST doesn't like it.
	Keep this method in order to be portable."
!

MinneStoreCompatibility
	"Dummy method for file-out purposes"
!

aNewBinaryStreamableCollection: anInteger
	"Answer something that can be streamed over with a ReadWriteStream."

	"Original: ^String new: anInteger"
	"Una ByteString non va bene, per cui cerco qualcosa d' altro:"
	^ByteArray new: anInteger
!

aNewByteArray: size
	"Answer something that can be streamed over with a ReadWriteStream.
	This is usually a byte array, but is sometimes a string."

	^String new: size
!

aNewWeakDictionary
	"Answer a weak 'dictionary' where the values can be garbage collected.
GG:
The VW offers IdentityDictionary and I am trying to use it
"

	^IdentityDictionary new.
	"^PseudoWeakValueIdentityDictionary cleanupThreshold: 100."
!

assert: aBoolean
	"GG"
	super assert: aBoolean.
	"super ASSERT: aBoolean"
!

atPropertyNamed: aSymbol for: object1 put: object2
	"Put the property and answer object1"
	"Patched in object by GG"

	object1
		propertyAt: aSymbol
		put: object2.
	^object1
!

clearMemory     
	Object initPropertyEngine.
!

clone: anObject
	"Make a thoroughly deep copy by filing anObject out to a stream and reading it back in"
	"Edited by GG"
                
	| stream |
	stream := ReadWriteStream on: (ByteArray new: 100).
	self dumpObject: anObject on: stream.
	^self loadObjectFrom: stream.
!

createDirectoryNamed: aString
	"Answer true if successful.  False if not."
	"Correzione di GG Error al posto di File ERROR e modifche rimuovendo Directory..."
	[ (aString asFilename) makeDirectory]
		on: Error
		do: [:e | ^false].
	^true.
!

createFileNamed: aString
	"Answer an open, empty file whether it exists already or not.
	Il problema e' che devo resituire uno stream in aalcuni casi, un file in altri!!!!!!
	Questo funziona per il test di compatibilita' ma non funziona per createLockFile:ifExists: cosi' quest' ultimo metodo e' stato cambiato"

	| file |
	[file := File createFileNamed: aString]
		on: Error "Era FileAlreadyExists"
		do: [].
        
	^file.
	"era 
	^File fromPath: aString
	ma non cosi' dovrebbe essere ok"
!

createLockFile: aString ifExists: aBlock 
	"Answer an empty and closed file if it doesn't exist, or the value of a block if it does."

	"Fixed by GG"

	| f |
	f := aString asFilename.
	f exists 
		ifTrue: [^aBlock value]
		ifFalse: 
			[ 
			 (f readWriteStream) close.
			^f]
!

doesDirectoryExist: aString
	"Answer a boolean."
   "Correzione di GG"
  " ^Directory exists: aString."
 ^(aString asFilename) exists.
!

doesFileExist: aString

	^File exists: aString
!

dumpObject: anObject on: aStream
    "Answer anObject"
	"Write an object into a Stream
	But What is returned???
 by G.G. "
	| bos |
	aStream reset.
	bos := BinaryObjectStorage onNew: aStream.      "Basic Step 2"

[bos nextPut: anObject]                         "Basic Step 3"
	valueNowOrOnUnwindDo: [bos close].
"It close the bos steam, I hope this is right 
GG"
	^anObject       
	"Originale:"
	"^ObjectFiler dump: anObject on: aStream"
!

dumpObject: anObject toNewFile: aString
    "Answer anObject.  If the file already exists, replace its contents.  Make sure file gets closed."
	|s|
	s:=(aString asFilename) newReadWriteStream.
	self dumpObject: anObject on: s.
        
	"Originale: ^ObjectFiler dump: anObject newFile: aString"
!

exceptionDetails: exception
	"Answer the objects that the exception was signaled with"

    ^exception messageText
!

exceptionReceiver: exception
	"Answer the receiver of a MessageNotUnderstood exception."

	^exception message receiver
!

fileNameLike: aString
    "Answer a string.  Windows95/NT allows long file names with spaces."
	"Si prevede l' uso solo sotto Windows95/Unix"
	^aString.
"       ^(OperatingSystem isWindows95 or: [OperatingSystem isWindowsNT])
		ifTrue: [aString]
		ifFalse: [File fileName: aString extension: '']."
!

filedSizeOf: anObject
	"Answer the number of bytes this object would take on disk.
	This method not required."

	| stream |
	stream := WriteStream on: (String new: 100).
	self dumpObject: anObject on: stream.
	^stream size.
!

indexOfCollection: collection2 in: collection1
	"This will probably work in any flavor of Smalltalk."

    | index1 index2 limit1 limit2 |
    limit2 := collection2 size.
    limit1 := collection1 size - limit2 + 1.
    index1 := 1.
    [index1 <= limit1]
	whileTrue: [
	    (collection1 at: index1) = (collection2 at: 1)
		ifTrue: [
		    index2 := 2.
		    [index2 <= limit2
			and: [ (collection1 at: index1 + index2 - 1) =
			    ( collection2 at: index2 ) ] ]
			whileTrue: [index2 := index2 + 1].
		    index2 > limit2
			ifTrue: [ ^index1] ].
	    index1 := index1 + 1].
    ^0
!

isCollection: anObject
	"Answer a boolean"

	^anObject isCollection
!

isDictionary: anObject
	"Answer a boolean"
	"Modifcato da GG"
	anObject isNil ifTrue: [^false] ifFalse:[
	^ (anObject asFilename) isDictionary].
!

isStream: anObject
	"Answer a boolean"

	^anObject isStream
!

isString: anObject
	"Answer a boolean"

	^anObject isString
!

isSymbol: anObject
	"Answer a boolean"

	^anObject isSymbol
!

issue
	"Used to just have a symbol #issue in the code, but VAST doesn't like it.
	This method is needed for all 'flavors'"
!

loadObjectFrom: aStream 
	"Answer the first object loaded from aStream."
	"GG"

	| bos array |
	aStream reset.
	bos := BinaryObjectStorage onOldNoScan: aStream.
	[array := bos contents]
		valueNowOrOnUnwindDo: [bos close].      "^ObjectFiler loadFrom: aStream"
	^(array at:1)
!

loadObjectFromFileNamed: aString
	"Answer the object loaded from file named aString.
	___If the file doesn't exist__, answer nil.
	Make sure file gets closed properly."
	"GG"
	|f|
f:=(aString asFilename).
f exists ifFalse:[^nil] ifTrue:[
	^(self loadObjectFrom: (f readStream)).].

	"^ObjectFiler loadFromPathName: aString"
!

lockNameForFile: aString

	^aString, '.lock'
!

needsWork
	"Used to just have a symbol #needsWork in the code, but VAST doesn't like it."
!

nextWordOf: aReadStream
        "Answer the next word in aReadStream, delimited by whitespace and punctuation.
        Answer nil if there are no more words in the receiver."

        | first last |
        aReadStream skipSeparatorsAndPunctuation ifFalse: [^nil].
        first := aReadStream position.
        Smalltalk isSmalltalkX ifTrue:[
            first := first - 1.      "/ 1-based indexing
        ].
        aReadStream skipWhile: [:c | c isLetter or: [c isDigit]].
        last := aReadStream position.
        Smalltalk isSmalltalkX ifTrue:[
            last := last - 1.        "/ 1-based indexing
        ].
        ^aReadStream contents copyFrom: first+1 to: last
!

propertyNamed: aSymbol for: anObject
    "if property is absent answer nil."
        
	^anObject propertyAt: aSymbol
!

propertyNamed: aSymbol for: anObject ifAbsent: aBlock
    "if property is absent answer the value of aBlock"

	^anObject propertyAt: aSymbol ifAbsent: aBlock
!

propertyNamed: aSymbol for: anObject ifAbsentPut: niladicBlock
    "if property is absent, insert and return the value of niladicBlock"

	| temp |
	^anObject 
		propertyAt: aSymbol 
		ifAbsent:
			[anObject propertyAt: aSymbol put: (temp := niladicBlock value).
			temp].
!

removeDirectoryNamed: aString
        "Remove a directory along with all its' files and subdirectories. 
        This is a powerful command, use with care. 
        Answer true if successful, false if not."
        "Riscritto da Zero da GG e ricorsiva!!!! 
        Il problema e' che le directory vanno prima svuotate !!!!!! 
        self removeDirectoryNamed: 'C:\MSTest' ifAbsent: []. 
        "

        ^ self removeDirectoryNamed: aString ifAbsent: true
!

removeDirectoryNamed: aString ifAbsent: aBlock 
	"Remove a directory along with all its' files and       subdirectories. 
	This is a powerful command, use with care. 
	Answer true if successful, false if not."
	"Riscritto da Zero da GG e ricorsiva!!!! 
	Il problema e' che le directory vanno prima svuotate !!!!!! 
	self removeDirectoryNamed: 'C:\MSTest' ifAbsent: []. 
	"

	| dir |
	dir := aString asFilename.
	dir exists ifFalse: [^aBlock value]
		ifTrue: 
			[(dir filenamesMatching: '*')
				do: [:each | each isDirectory
						ifTrue: [self removeDirectoryNamed: each asString ifAbsent: aBlock]
						ifFalse: [each delete]].
			dir delete.
			^True]
!

removeFileNamed: aString

	File remove: aString
!

removeFileNamed: aString ifAbsent: aBlock

	File remove: aString ifAbsent: aBlock
!

replaceAll: string1 in: aString with: string2

	| i str |
	(i := FlavorCompatibility indexOfCollection: string1 in: aString) > 0
		ifFalse: [^self copy].
	str :=
		i < 2
			ifTrue: ['']
			ifFalse: [aString copyFrom: 1 to: i - 1].
	^str, string2, (aString copyFrom: i + string1 size to: aString size)
!

testing
	"Used to just have a symbol #testing in the code, but VAST doesn't like it.
	Keep this method in order to be compatible"
!

triggerEvent: aSymbol for: anObject

	^anObject triggerEvent: aSymbol
!

triggerEvent: aSymbol for: anObject with: anArgument

	^anObject triggerEvent: aSymbol with: anArgument
!

triggerEvent: aSymbol for: anObject with: anArgument1 with: anArgument2

	^anObject triggerEvent: aSymbol with: anArgument1 with: anArgument2
!

wait
	"Wait for about 1 second.
	This is pretty primitive because it ties up the machine, but it works for 
	now since it is only used when a file is locked."

	| endTime |
	endTime := Time now asSeconds + 1.
	[Time now asSeconds < endTime]
		whileTrue: [].
!

waitFor: anInteger
	"Wait for anInteger number of milliseconds.
	This is hardly exact, but it will work for now."

	| seconds |
	seconds := (anInteger / 1000) asInteger.
	seconds == 0 
		ifTrue: [seconds := 1].
	1 to: seconds do: [self wait].
! !

!FlavorCompatibility class methodsFor:'Giorgi Giovanni Patch Mar99'!

directoryDelimiter
        "GG Porting!!
        Answer the *character* used for delimiting directories.
        For DOS, Windows, and OS/2 this is a backward slash.
        For Unix this is a forward slash.
        For information on HOW it works, please see directoryDelimiterString method
        "
        Smalltalk isSmalltalkX ifTrue:[^ Filename separator].

        ^(LogicalFilename separator).
        
!

directoryDelimiterString
        "Answer the character used for delimiting directories.
        For DOS, Windows, and OS/2 this is a backward slash.
        For Unix this is a forward slash.
        GG Porting:
        On VW  I use a special class, which should be able to carry a Filename across different filesystem. It works only in sometimes!!!!
"
        Smalltalk isSmalltalkX ifTrue:[ ^String with:(Filename separator). ].

^String with:(LogicalFilename separator).
! !

!FlavorCompatibility class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/minneStore/FlavorCompatibility.st,v 1.3 2014-02-17 21:19:29 cg Exp $'
! !
