"{ Package: 'stx:goodies/communication/dolphinHTTP/tests' }"

TestCase subclass:#SptHTTPProxyTestExept
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Dolphin-Spt-HTTP-Tests'
!

!SptHTTPProxyTestExept class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
        cg

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!SptHTTPProxyTestExept methodsFor:'tests'!

test01_exept_directly
    | request |

    SptHTTPConnection beLoggingWireToTranscript.    "Note: this is a global setting that remains until turned off"
    (request := SptHTTPRequest new)
            openGetTo: 'http://www.exept.de/';
            addHeader: 'Accept' value: '*/*'.
    request send.
    request waitOnReady.

    "Clean up"
    SptHTTPConnection beNotLoggingWire.

    request okBodyStream upToEnd inspect.
    request inspect.

    "Created: / 04-10-2011 / 17:19:37 / cg"
!

test01_exept_via_proxy
    | request proxySettings |

    proxySettings := SptHTTPProxySettings new.
    proxySettings useHost:'sixtyfour' port:3128.

    SptHTTPConnection beLoggingWireToTranscript.    "Note: this is a global setting that remains until turned off"
    (request := SptHTTPRequest new)
            openGetTo: 'http://www.exept.de/';
            addHeader: 'Accept' value: '*/*';
            proxySettings: proxySettings.
    request send.
    request waitOnReady.

    "Clean up"
    SptHTTPConnection beNotLoggingWire.

    request inspect.

    "Created: / 04-10-2011 / 17:15:46 / cg"
! !

!SptHTTPProxyTestExept class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/tests/SptHTTPProxyTestExept.st,v 1.2 2011-10-05 16:16:35 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/tests/SptHTTPProxyTestExept.st,v 1.2 2011-10-05 16:16:35 cg Exp $'
! !
