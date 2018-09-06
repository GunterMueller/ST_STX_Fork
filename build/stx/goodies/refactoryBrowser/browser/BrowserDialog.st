"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

SimpleDialog subclass:#BrowserDialog
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Browser'
!

BrowserDialog comment:''
!


!BrowserDialog class methodsFor:'images'!

downImage
    ^ self downIcon "/ mask:self downIconMask
!

upImage
    ^ self upIcon "/ mask:self upIconMask
! !

!BrowserDialog class methodsFor:'resources'!

downIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self downIcon inspect
     ImageEditor openOnClass:self andSelector:#downIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'BrowserDialog class downIcon'
        ifAbsentPut:[(Depth1Image new) width: 24; height: 13; photometric:(#palette); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[0 0 0]; mask:((ImageMask new) width: 24; height: 13; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'????????_??>O??<G??8C??0A?? @??@@_>@@O<@@G8@@C0@@A @') ; yourself); yourself]
!

upIcon
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self upIcon inspect
     ImageEditor openOnClass:self andSelector:#upIcon
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'BrowserDialog class upIcon'
        ifAbsentPut:[(Depth1Image new) width: 24; height: 13; photometric:(#palette); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@') ; colorMapFromArray:#[0 0 0]; mask:((ImageMask new) width: 24; height: 13; photometric:(#blackIs0); bitsPerSample:(#[1]); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'@A @@C0@@G8@@O<@@_>@@??@A?? C??0G??8O??<_??>????????') ; yourself); yourself]
! !

!BrowserDialog methodsFor:'widget properties'!

disable: aSymbol 
	| component |
	builder isNil ifTrue: [^self].
	component := builder componentAt: aSymbol.
	component notNil ifTrue: [component disable]
!

disableAll: aCollection
	aCollection do: [:each | self disable: each]
!

enable: aSymbol 
	| component |
	builder isNil ifTrue: [^self].
	component := builder componentAt: aSymbol.
	component notNil ifTrue: [component enable]
!

enableAll: aCollection
	aCollection do: [:each | self enable: each]
!

hide: aSymbol 
	| component |
	builder isNil ifTrue: [^self].
	component := builder componentAt: aSymbol.
	component notNil ifTrue: [component beInvisible]
!

hideAll: aCollection
	aCollection do: [:each | self hide: each]
!

show: aSymbol 
	| component |
	builder isNil ifTrue: [^self].
	component := builder componentAt: aSymbol.
	component notNil ifTrue: [component beVisible]
!

showAll: aCollection
	aCollection do: [:each | self show: each]
! !

!BrowserDialog class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/BrowserDialog.st,v 1.14 2014-12-03 20:08:22 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/BrowserDialog.st,v 1.14 2014-12-03 20:08:22 cg Exp $'
!

version_SVN
    ^ '$Id: BrowserDialog.st,v 1.14 2014-12-03 20:08:22 cg Exp $'
! !

