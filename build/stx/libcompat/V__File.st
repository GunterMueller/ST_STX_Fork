"{ Package: 'stx:libcompat' }"

"{ NameSpace: V }"

Object subclass:#File
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-ST/V'
!


!File class methodsFor:'misc queries'!

composePath:path stem:packageName extension:extension
    ^ ((path asFilename construct:packageName) withSuffix:extension) name
!

exists:pathname
    ^ pathname asFilename exists
!

extensionDelimiter
    ^ Filename suffixSeparator
!

fullPathOf:pathname relativeTo:aBaseName
    |fn|

    "dummy for now ..."
    fn := pathname asFilename.
    fn isAbsolute ifTrue:[
	^ fn pathName
    ].
    ^ fn constructString:aBaseName
!

relativePathOf:pathname to:aBaseName
    "dummy for now ..."
    ^ pathname
!

splitExtensionFrom: aString
	"Splits aPathname string and answers the extension portion.
	Answers the empty string if there is no extension."

	^(self splitPath: aString) at: 4
!

splitFilenameFrom: aPathnameString
"/ not certain.
    ^ aPathnameString asFilename baseName
!

splitPath: aString
	"Splits aPathname string into its path, stem and extension components and answers
	a four element Array of these.
	Note: We use the C-runtime library to implement this, hence either backward or forward
	slashes (i.e. $\ or $/) are acceptable as pathname delimiters."

	| fn drive dir fname ext splits |

	fn := aString asFilename.
	drive := fn volume.
	dir := fn directory localPathName.
	fname := fn withoutSuffix baseName.
	ext := fn suffix.

	^Array
		with: drive withoutSeparators
		with: dir withoutSeparators
		with: fname withoutSeparators
		with: ext withoutSeparators

    "
     File splitPath: '\\exept\cg\home\smalltalk\st_free\pocketSmalltalk\ide1.5\pst.pac'
    "
!

splitPathFrom: aPathnameString
	"Splits aPathname string and answers the path portion (including the drive letter, if any).
	Answers the empty String if there is no path."

	| splits |
	splits := self splitPath: aPathnameString.
	^(splits at: 1), (splits at: 2)
!

splitStemFrom:filename
    ^ filename asFilename withoutSuffix baseName
! !

!File class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/V__File.st,v 1.2 2016-08-22 13:42:38 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libcompat/V__File.st,v 1.2 2016-08-22 13:42:38 cg Exp $'
! !

