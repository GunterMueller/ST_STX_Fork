"{ Package: 'stx:goodies/communication/webdriverService' }"

"{ NameSpace: Smalltalk }"

HTTPSimpleJSONRestService subclass:#SmalltalkWebDriverElement
	instanceVariableNames:'interface session'
	classVariableNames:''
	poolDictionaries:''
	category:'WebDriver-Service'
!

!SmalltalkWebDriverElement class methodsFor:'documentation'!

documentation
"
    I represent a single element inside a webDriver.
"
! !

!SmalltalkWebDriverElement methodsFor:'service entries'!

screenshot:aRequest argument:arg     
    "get a screenshot of this element"

    <Rest: (GET name: 'screenshot' 
                 argument: 'Dictionary' 
                 return: 'Dictionary' 
                 comment: 'return a screenshot.') >

    |img pngBytes|

    Logger info:'GET element/screenshot'.
    img := Image fromScreen.
    pngBytes := ByteArray streamContents:[:byteStream |
        PNGReader save:img onStream:byteStream
    ].
    ^ { 'value' -> (Base64Coder encode:pngBytes) }

    "Created: / 21-07-2018 / 19:10:47 / Claus Gittinger"
! !

!SmalltalkWebDriverElement class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/webdriverService/SmalltalkWebDriverElement.st,v 1.1 2018-07-22 09:54:59 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/webdriverService/SmalltalkWebDriverElement.st,v 1.1 2018-07-22 09:54:59 cg Exp $'
! !

