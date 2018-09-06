"{ Package: 'stx:goodies/communication/webdriver' }"

"{ NameSpace: Smalltalk }"

WDCapabilities subclass:#WDDesiredCapabilities
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'WebDriver-Core-Base-Model'
!

WDDesiredCapabilities comment:'The desired capabilities See https://code.google.com/p/selenium/wiki/DesiredCapabilities'
!


!WDDesiredCapabilities class methodsFor:'predefined'!

chrome

	^ self new
		setCapability: 'browserName' to: 'chrome';
		yourself
	
!

firefox

	^ self new
		setCapability: 'browserName' to: 'firefox';
		yourself
	
!

htmlUnit

	^ self new
		setCapability: 'browserName' to: 'htmlunit';
		yourself
!

safari

	^ self new
		setCapability: 'browserName' to: 'safari';
		yourself
	
! !

!WDDesiredCapabilities methodsFor:'private - accessing'!

setCapability: capabilityName to: capabilityValue
	
	^mapping at: capabilityName asSymbol put: capabilityValue
! !

!WDDesiredCapabilities methodsFor:'properties - browser selection'!

browserName
	^self getCapability: #'browserName'
!

platform
	^self getCapability: #'platform'
!

version
	^self getCapability: #'version'
! !

!WDDesiredCapabilities methodsFor:'properties - readonly'!

cssSelectorsEnabled
	"Whether the session supports CSS selectors when searching for elements."
	
	^self getCapability: #'cssSelectorsEnabled'
!

handlesAlerts
	"Whether the session can interact with modal popups, such as window.alert and window.confirm."
	
	^self getCapability: #'handlesAlerts'
!

takesScreenshot
	"Whether the session supports taking screenshots of the current page."
	
	^self getCapability: #'takesScreenshot'
! !

!WDDesiredCapabilities class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/webdriver/WDDesiredCapabilities.st,v 1.1 2018-06-17 06:37:05 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/webdriver/WDDesiredCapabilities.st,v 1.1 2018-06-17 06:37:05 cg Exp $'
! !

