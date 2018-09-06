"{ Package: 'stx:goodies/communication' }"

Query subclass:#HTTPProxyQuery
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-HTTP-Client'
!

!HTTPProxyQuery class methodsFor:'documentation'!

documentation
"
    query for a proxy (raised by HTTPInterface to ask any caller for a proxySettings info)

    [author:]
        cg

    [instance variables:]

    [class variables:]

    [example:]
        |p|

        p := HTTPProxySettings new.
        p proxyHost:'foo'.
        p proxyPort:1234.
        p useProxy:true.
        HTTPProxyQuery 
            answer:p
            do:[
                HTTPInterface get:'www.exept.de'
            ].
"
!

examples
"
                                                            [exBegin]
    |reply p|

    p := HTTPProxySettings useHost:'sixtyfour' port:3128.

    HTTPProxyQuery 
        answer:p
        do:[
            reply := HTTPInterface get:'www.exept.de'
        ].
                                                            [exEnd]

                                                            [exBegin]
    |reply|

    HTTPInterface
        withProxy:(HTTPProxySettings useHost:'sixtyfour' port:3128)
        do:[
            reply := HTTPInterface get:'http://www.exept.de'
        ].
                                                            [exEnd]
"
! !

!HTTPProxyQuery class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/HTTPProxyQuery.st,v 1.1 2011-10-05 16:13:31 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/HTTPProxyQuery.st,v 1.1 2011-10-05 16:13:31 cg Exp $'
! !
