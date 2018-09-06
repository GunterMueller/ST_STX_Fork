"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1997 by eXept Software AG 
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libhtml' }"

"{ NameSpace: Smalltalk }"

Object subclass:#URL
	instanceVariableNames:'method host path port anchor rest otherPart flag authority'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-Support'
!

!URL class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG 
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
    (for now) only a holder for the parse URL info.
    Will takeover more functionality in the near future.

    Please Notice: 
        this class is more or less obsoleted by URI, which provides better support
        for multiple transports, passwords etc. 
        However, a lot of old code still uses URL, and also Squeak has an URL as well. 
        So this remains here, although this has a slight duplicate-code odeur.
        Please use URI if possible.

    [author:]
        Claus Gittinger

    [see also:]
            URI FtpURI HttpURI FileURI
"
! !

!URL class methodsFor:'instance creation'!

classForScheme:  schemeString   
    |httpsClass|

    schemeString = 'https' ifTrue:[

        (httpsClass := Smalltalk at:#'SSL::HttpsUrl') notNil ifTrue:[
            ^ httpsClass 
       ].
    ].
    ^ self.
!

fromString: aString
    | otherPart otherPartKind index urlString url |

    otherPart := nil.
    otherPartKind := 0.
    "check fragment and search part"
    (index := aString indexOf: $#) ~= 0
            ifTrue: [otherPartKind := 1]
            ifFalse: [(index := aString indexOf: $?) ~= 0
                    ifTrue: [otherPartKind := 2]
                    ifFalse: [urlString := aString]].
    otherPartKind > 0
            ifTrue:
                    [urlString := aString copyFrom: 1 to: index - 1.
                    index < aString size
                            ifTrue: [otherPart := aString copyFrom: index + 1 to: aString size]].
    url := self fromURLString: urlString.
    otherPart notNil
            ifTrue:
                    [otherPartKind = 1
                            ifTrue: [url fragmentPart: otherPart]
                            ifFalse:[url searchPart: otherPart]].
    ^url

    "
     URL fromString: 'http://www'.
     URL fromString: 'http://www/dir/file.html'.
     URL fromString: 'http://www:10080/dir/file.html'.
     URL fromString: 'http://www:10080/dir/file.html?x=100'.
     URL fromString: 'http://www:10080/dir/file.html?a=1&b=2&c=3'.
     URL fromString: 'http://www:10080/dir/file.html#section'.
     URL fromString: 'ftp://ftp/pub/smalltalk'.
     URL fromString: 'ftp://ftp:21/pub/smalltalk'.
     URL fromString: 'ftp://user@ftp:21/pub/smalltalk'.
     URL fromString: 'ftp://user@ftp/pub/smalltalk'.
     URL fromString: 'ftp://user:passwd@ftp:21/pub/smalltalk'.
     URL fromString: 'news:fj.lang.smalltalk'.
     URL fromString: '/dir/file.html'.
     URL fromString: 'file.html'.
     URL fromString: 'file://D:\foo\bar\baz'.
    "

    "Modified (comment): / 12-07-2018 / 08:06:59 / Claus Gittinger"
!

fromURLString:aStringIn
    |aString defPath read write ch scheme host port path pos try|

    aString := aStringIn.

    "/ hack for MSDOS-type files, with a volume
    "/ done even under unix, in case a windows fiel url is passed in
    aString size > 1 ifTrue:[
        ((aString at:2) = $:) ifTrue:[
            ^ self scheme:nil host:nil port:nil path:aString
        ].
        (aString startsWith:'file://') ifTrue:[
            
            ((aString at:'file://' size + 2) = $:) ifTrue:[
                ^ self scheme:nil host:nil port:nil path:(aString asString copyFrom:'file://' size + 1)
            ].
        ].
    ].

    defPath := nil.
    read := aString readStream.
    write := WriteStream on: (String new: aString size).

    "parse scheme"
    [read atEnd or:
    [(ch := read next) isLetterOrDigit not]]
            whileFalse: [write nextPut: ch].


    (write isEmpty or: [ch ~= $:])
            ifTrue: "no scheme"
                    [read reset.
                    scheme := nil.

                    "aString isEmpty
                            ifTrue: [path := defPath]
                            ifFalse:        [path := aString]."
                    "It's may be a file name."
                    "^self scheme: nil path: path"]
            ifFalse:
                    [scheme := write contents].

    write reset.
    pos := read position.
    (read nextAvailable: 2) = '//'
            ifFalse:[ "no host and port"
                ch ~= $: ifTrue:[
                    read position: pos.
                    path := read upToEnd.
                    path isEmpty ifTrue: [path := defPath].
                    ^ self scheme: scheme path: path
                ].
                read position: pos-1.
                host := scheme.
                scheme := nil.
            ].

    "parse host and port (and user and password)."

    try := true.
    [try] whileTrue:
            [[read atEnd or:
            [(ch := read next) = $/ or: [ch == $: or: [ch == $@]]]]
                    whileFalse:
                            [write nextPut: ch].
            write notEmpty
                    ifTrue: [host := write contents].
            write reset.
            ch == $:
                    ifTrue: "parse port or passwd"
                            [[read atEnd or:
                            [(ch := read next) == $/ or: [ch == $@]]]
                                    whileFalse:
                                            [write nextPut: ch].
                            write notEmpty
                                    ifTrue: [port := write contents].
                            write reset].

            ch == $@
                    ifFalse: [try := false]
                    ifTrue: "re-parse host"
                            [host notNil
                                    ifTrue: [write nextPutAll: host. host := nil].
                            port notNil
                                    ifTrue: [write nextPut: $:; nextPutAll: port. port := nil].
                            write nextPut: $@]].

    port notNil
            ifTrue: [port := Number readFrom: port readStream onError:nil].

    read atEnd
            ifTrue: [path := defPath]
            ifFalse:
                    [write nextPut: ch; nextPutAll: (read upToEnd).
                    path := write contents].

    ^ self scheme: scheme host: host port: port path: path

    "URL fromString: 'http://www/dir/file.html'."
    "URL fromString: 'http://www:10080/dir/file.html'."
    "URL fromString: 'ftp://ftp/pub/smalltalk'."
    "URL fromString: 'ftp://ftp:21/pub/smalltalk'."
    "URL fromString: 'ftp://user@ftp:21/pub/smalltalk'."
    "URL fromString: 'ftp://user@ftp/pub/smalltalk'."
    "URL fromString: 'ftp://user:passwd@ftp:21/pub/smalltalk'."
    "URL fromString: 'news:fj.lang.smalltalk'."
    "URL fromString: '/dir/file.html'."
    "URL fromString: '//host/dir/file.html'."
    "URL fromString: 'file.html'."
    "
     self oldFromURLString:'checkout.stt'.   
     self fromURLString:'checkout.stt'.      
    "

    "Modified: / 25.9.1999 / 22:00:43 / cg"
!

method: methodString host: hostString port: portNumber path: pathString
    ^ self new
            method: methodString;
            host: hostString;
            port: portNumber;
            path: pathString

!

method: methodString path: pathString
        ^self
                method: methodString
                host: nil
                port: nil
                path: pathString

!

new
    ^ self basicNew initialize
!

scheme: schemeString host: hostString port: portNumber path: pathString
    ^ (self classForScheme: schemeString) new
            scheme: schemeString;
            host: hostString;
            port: portNumber;
            path: pathString
!

scheme: schemeString path: pathString
        ^self
                scheme: schemeString
                host: nil
                port: nil
                path: pathString

    "
     self scheme:'http' path:'foo/bar/baz'   
     self scheme:'http' host:'www.exept.de' port:80 path:'foo/bar/baz' 
     self fromString:'http://www.exept.de/foo/bar/baz&foo=1&bar=2' 
    "

    "Modified (comment): / 05-10-2011 / 18:07:41 / cg"
! !

!URL class methodsFor:'Compatibility-Squeak'!

schemeNameForString:urlString
    |idx|

    idx := urlString indexOf:$:.
    (idx ~~ 0) ifTrue:[
        ^ (urlString copyTo:(idx - 1)) asLowercase.
    ].
    ^ nil

    "
     self schemeNameForString:'https://www.cacert.org'
    "

    "Modified (comment): / 05-10-2011 / 18:05:42 / cg"
! !

!URL class methodsFor:'utilities'!

constructPath:path1 with:path2 
    |sep dirStack read p write|

    sep := $/.
    dirStack := OrderedCollection new.
    (path2 notEmpty and:[ path2 first = sep ]) ifFalse:[
        read := path1 readStream.
        [ read atEnd ] whileFalse:[
            p := read upTo:sep.
            (p isEmpty or:[ p = '.' ]) ifFalse:[
                p = '..' ifTrue:[
                    dirStack notEmpty ifTrue:[
                        dirStack removeLast
                    ]
                ] ifFalse:[
                    dirStack addLast:p
                ]
            ]
        ].
        (path1 notEmpty and:[ path1 last = sep ]) ifFalse:[
            "trim path tail (file name)."
            dirStack notEmpty ifTrue:[
                dirStack removeLast
            ]
        ]
    ].
    read := path2 readStream.
    [ read atEnd ] whileFalse:[
        p := read upTo:sep.
        (p isEmpty or:[ p = '.' ]) ifFalse:[
            p = '..' ifTrue:[
                dirStack notEmpty ifTrue:[
                    dirStack removeLast
                ]
            ] ifFalse:[
                dirStack addLast:p
            ]
        ]
    ].
    dirStack isEmpty ifTrue:[
        ^ String with:sep
    ].
    write := WriteStream on:(String new:path1 size + path2 size).
    [ dirStack isEmpty ] whileFalse:[
        write
            nextPut:sep;
            nextPutAll:dirStack removeFirst
    ].
    (path2 notEmpty and:[ path2 last = sep ]) ifTrue:[
        write nextPut:sep
    ].
    ^ write contents
! !

!URL methodsFor:'Compatibility-Squeak'!

authority
    ^ authority ? host ? ''.

    "Modified: / 21-09-2010 / 23:52:36 / cg"
!

fullPath
    ^ self path ? '/'
!

retrieveContents
    "squeak compatibility"

    ^ self retrieveContentsArgs: nil
!

retrieveContentsAccept: mimeType
    "squeak compatibility"

    ^ self retrieveContentsArgs: nil accept: mimeType
!

retrieveContentsArgs: args
    "squeak compatibility"

    ^self retrieveContentsArgs: args accept: '*/*; q=1'
!

retrieveContentsArgs: args accept: mimeType
    "squeak compatibility"

    Smalltalk isSmalltalkX ifTrue:[
        ^ (URI fromString:(self printString)) contents
    ].
    self subclassResponsibility
!

withoutFragment
    "what does it do ?"

    ^ self
! !

!URL methodsFor:'accessing'!

anchor
    "return the anchor in the fragment part;  
     that is the name of the local anchor within the document.
     May be nil or empty"

    ^ self fragmentPart

    "Created: / 23-01-1998 / 12:09:03 / cg"
    "Modified (comment): / 05-02-2017 / 19:55:43 / cg"
!

anchor:aString
    "set the anchor in the fragment part;  
     that is the name of the local anchor within the document.
     May be nil or empty"

    self fragmentPart: aString.

    "Created: / 23-01-1998 / 12:09:03 / cg"
    "Modified (format): / 05-02-2017 / 19:58:44 / cg"
!

baseName
    "the basename of the file part"

    ^ self file asFilename baseName
!

file
    "return the file/path part.
     Same as path for compatibility"

    ^ path

    "Created: / 23-01-1998 / 12:05:59 / cg"
    "Modified (comment): / 05-02-2017 / 19:59:01 / cg"
!

file:aString
    "set the file/path part.
     Same as path: for compatibility"

    path := aString.

    "Created: / 23-01-1998 / 12:05:59 / cg"
    "Modified (comment): / 05-02-2017 / 19:59:04 / cg"
!

fragmentPart
    self hasFragmentPart ifTrue: [^ otherPart].
    ^ nil


!

fragmentPart: aString
    otherPart := aString.
    flag := 0.
    self hasFragmentPart:true


!

host
    "return the host"

    ^ host

    "Created: / 23-01-1998 / 12:05:58 / cg"
    "Modified (comment): / 05-02-2017 / 19:58:11 / cg"
!

host:aString
    "set the host"

    host := aString.

    "Created: / 23-01-1998 / 12:05:58 / cg"
    "Modified (format): / 05-02-2017 / 19:58:15 / cg"
!

method
    "return the access scheme (http, https, ftp, etc.).
     Same as scheme for compatibility"

    ^ method

    "Created: / 23-01-1998 / 12:05:58 / cg"
    "Modified (comment): / 05-02-2017 / 19:59:54 / cg"
!

method:aString
    "set the access scheme (http, https, ftp, etc.).
     Same as scheme: for compatibility"

    method := aString.

    "Created: / 23-01-1998 / 12:05:58 / cg"
    "Modified (comment): / 05-02-2017 / 19:59:46 / cg"
!

otherPart
        ^otherPart


!

parameters
    "extract parameters from the otherpart;
     parses the '?foo=fooVal&bar=barval...' part of the URL (after the plain href),
     and returns an orderedDictionary containing the key-value pairs"

    |dict params|
    
    dict := OrderedDictionary new.
    (params := self otherPart) isEmptyOrNil ifTrue:[
        ^ dict.
    ].
    params := params asCollectionOfSubstringsSeparatedBy:$&.
    params do:[:entry |
        |kv key value|

        kv := entry asCollectionOfSubstringsSeparatedBy:$=.
        key := kv first.
        value := kv second.
        dict at:key put:value
    ].

    ^ dict.

"<<END
     |url|

     url := URL fromString:'https://www.exept.de/foo?p1=bla&p2=bla bla'.
     url otherPart.
     url parameters.
END"

    "Created: / 29-06-2018 / 12:35:42 / Claus Gittinger"
!

path
    "return the file/path part.
     Same as file for compatibility"

    ^ path

    "Created: / 23-01-1998 / 12:05:59 / cg"
    "Modified (comment): / 05-02-2017 / 19:59:22 / cg"
!

path:aString
    "set the file/path part.
     Same as file: for compatibility"

    path := aString.

    "Created: / 23-01-1998 / 12:05:59 / cg"
    "Modified (comment): / 05-02-2017 / 19:59:14 / cg"
!

port
    "return the port; may be nil"

    ^ port

    "Created: / 23-01-1998 / 12:05:59 / cg"
    "Modified (comment): / 05-02-2017 / 19:56:39 / cg"
!

port:anInteger
    "set the port; may be nil"

    port := anInteger.

    "Created: / 23-01-1998 / 12:05:59 / cg"
    "Modified (format): / 05-02-2017 / 19:56:57 / cg"
!

rest
    "return the value of the instance variable 'rest' (automatically generated)"

    ^ '' "/ self fragmentPart

    "Created: / 23.1.1998 / 12:09:03 / cg"
!

rest:aString
    "set the value of the instance variable 'rest' (automatically generated)"

    self fragmentPart:aString.

    "Created: / 23-01-1998 / 12:09:03 / cg"
    "Modified (format): / 05-02-2017 / 19:58:22 / cg"
!

scheme
    "return the access scheme (http, https, ftp, etc.).
     Same as method for compatibility"

    ^ method

    "Modified (comment): / 05-02-2017 / 19:59:30 / cg"
!

scheme:aString
    "set the access scheme (http, https, ftp, etc.).
     Same as method: for compatibility"

    method := aString

    "Modified (comment): / 05-02-2017 / 19:59:38 / cg"
! !

!URL methodsFor:'comparing'!

= anURL
    ^ self species = anURL species
        and:[method = anURL method
        and:[host = anURL host
        and:[port = anURL port
        and:[path = anURL path
        and:[otherPart = anURL otherPart
        and:[flag = anURL flag]]]]]]

    "Modified (format): / 29-06-2018 / 12:40:45 / Claus Gittinger"
!

copyWithoutFragmentPart
    ^ self copy clearFragmentPart.

!

copyWithoutOtherPart
    ^ self copy clearOtherPart.

!

hash
    ^ ((((path hash bitShift: 2)
            bitXor: host hash) bitShift: 1)
            bitXor: method hash + port hash + otherPart hash + flag hash)

!

postCopy
    "/ super postCopy.
    method := method copy.
    host := host copy.
    port := port copy. 
    path := path copy.
    otherPart := otherPart copy.
    flag := flag copy.

    "Modified: / 08-02-2017 / 00:15:16 / cg"
! !

!URL methodsFor:'conversion'!

asURI
    "return an URI-object from myself"

    ^ (URI fromString:(self printString))

    "
     'http://www.exept.de/index.html' asURL asURI    
     'https://www.exept.de/index.html' asURL asURI    
     'http://www.exept.de:80/index.html' asURL asURI    
     'ftp://www.exept.de/index.html' asURL asURI    
    "

    "Created: / 28-08-2018 / 09:09:12 / Claus Gittinger"
!

asURL
    "return an URL-object from myself - that's me."

    ^ self

    "
     'http://www.exept.de:80/index.html' asURL host    
     'http://www.exept.de:80/index.html' asURL port    
     'http://www.exept.de:80/index.html' asURL method    
     'http://www.exept.de:80/index.html' asURL path    
    "
! !

!URL methodsFor:'parsing'!

parseFromString:urlString
    "parse URL contained in a string and set my inst vars"

    |i idx found|

    method := 'file'.
    method := nil.

    rest := urlString.
    idx := urlString indexOf:$:.
    (idx ~~ 0) ifTrue:[
        i := urlString indexOf:$#.
        ((i == 0) or:[i > idx]) ifTrue:[
            method := (urlString copyTo:(idx - 1)) asLowercase.
            rest := urlString copyFrom:(idx + 1).

            "/ special for VMS & MSDOS
            OperatingSystem isUNIXlike ifFalse:[
                (self isValidMethod:method) ifFalse:[
                    "/ method := 'file'.
                    method := nil.
                    rest := urlString copy.
                ]
            ].
        ] ifFalse:[
            idx := 0.
        ]
    ].

    "/
    "/ rest is everything after initial <method>:
    "/ search for #
    "/
    idx := rest indexOf:$# startingAt:idx + 1.
    found := false.
    [found or:[idx == 0]] whileFalse:[
        idx < (rest size) ifTrue:[
            (rest at:idx+1) ~~ $# ifTrue:[
                found := true.
            ] ifFalse:[
                idx := rest indexOf:$# startingAt:idx+2
            ]
        ] ifFalse:[
            idx := 0.
            (rest endsWith:$#) ifTrue:[
                rest := rest copyButLast
            ]
        ]
    ].

    idx ~~ 0 ifTrue:[
        path := (rest copyTo:(idx - 1)) asNilIfEmpty.
        anchor := (rest copyFrom:(idx + 1)) asNilIfEmpty.  
    ] ifFalse:[
        path := rest
    ].

    path notNil ifTrue:[
        "/ msdos support

        (path startsWith:'\\') ifTrue:[
            "/ network drive ...
            path asFilename exists ifTrue:[
                ^ self
            ]
        ].

        path := path asUnixFilenameString.

        (path startsWith:'//') ifTrue:[
            idx := path indexOf:$/ startingAt:3.

            idx ~~ 0 ifTrue:[
                host := path copyFrom:3 to:idx-1.
                path := path copyFrom:idx
            ] ifFalse:[
                "/ hostname only
                host := path copyFrom:3.
                path := '/'
            ].

            idx := host indexOf:$:.
            (idx ~~ 0) ifTrue:[
                port := Number readFromString:(host copyFrom:idx+1) onError:nil.
                host := host copyTo:idx-1.
            ].
        ]
    ].

    "Created: / 23.1.1998 / 12:11:52 / cg"
    "Modified: / 9.9.1998 / 20:50:37 / cg"
! !

!URL methodsFor:'printing & storing'!

displayOn:aGCOrStream
    "return a string to display the receiver - for display in Inspector"

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ old ST80 means: draw-yourself on a GC.
    (aGCOrStream isStream) ifFalse:[
        ^ super displayOn:aGCOrStream
    ].

    aGCOrStream 
        nextPutAll:self class name;
        nextPutAll:'(method='.
    method displayOn:aGCOrStream.
    aGCOrStream nextPutAll:' host='. 
    host displayOn:aGCOrStream.
    aGCOrStream nextPutAll:' port='. 
    port displayOn:aGCOrStream.
    aGCOrStream nextPutAll:' file='. 
    path displayOn:aGCOrStream.                                       
    otherPart notNil ifTrue:[
        aGCOrStream nextPutAll:' otherPart='. 
        otherPart displayOn:aGCOrStream.
    ].
    aGCOrStream nextPut:$).

    "Created: / 23-01-1998 / 12:14:59 / cg"
    "Modified (comment): / 22-02-2017 / 16:48:25 / cg"
!

printOn: aStream
    "take care, used by #fullRequestString and #urlPrintString"

    method notNil ifTrue: [
        aStream nextPutAll:method; nextPut:$:
    ].
    host notNil ifTrue: [
        aStream nextPutAll:'//'; nextPutAll:host
    ].
    port notNil ifTrue: [
        aStream nextPut:$:; nextPutAll: port printString
    ].
    path isEmptyOrNil ifTrue: [
        aStream nextPut:$/.
    ] ifFalse:[
        aStream nextPutAll:path.
    ].
    (otherPart notNil "and:[self hasPostData not]") ifTrue:[
        self hasFragmentPart ifTrue: [
            aStream nextPut:$#
        ] ifFalse:[
            aStream nextPut:$?
        ].
        aStream nextPutAll:otherPart
    ].
!

urlPrintString
    "the printString of the full url (incl. method, host and port)"

    ^ self printString.

"/    |s|
"/
"/    s := (method ? 'file') , '://'  
"/      , (host ? OperatingSystem getHostName).
"/
"/    port notNil ifTrue:[
"/        s := s , ':' , port printString
"/    ].
"/    s := s , (path ? '/').
"/    ^ s.
! !

!URL methodsFor:'private'!

clearFragmentPart
        self hasFragmentPart ifFalse: [^self].
        self clearOtherPart.


!

clearOtherPart
        flag := 0.
        otherPart := nil.


!

flag
        ^flag


!

hasFragmentPartBitMask
        ^1


!

hasPostDataBitMask
        ^4


!

hasSearchPartBitMask
        ^2


!

initialize
        self clearOtherPart.


!

setOtherPart: aString flag: anInteger
        otherPart := aString.
        flag := anInteger.


! !

!URL methodsFor:'queries'!

canCache
    ^ self isFileScheme not and:[flag = 0 and: [otherPart isNil]]


!

fullRequestString
    ^ self printString
!

hasFragmentPart
    ^ flag allMask: self hasFragmentPartBitMask


!

hasFragmentPart: aBoolean
    flag := flag mask:(self hasFragmentPartBitMask) set:aBoolean.
"/    aBoolean
"/        ifTrue: [flag := flag maskSet: self hasFragmentPartBitMask]
"/        ifFalse: [flag := flag maskClear: self hasFragmentPartBitMask]

    "
     self new hasFragmentPart 
     (self new hasFragmentPart:true) hasFragmentPart 
    "
!

hasPostData
    ^ flag allMask: self hasPostDataBitMask


!

hasPostData: aBoolean
    flag := flag mask:(self hasPostDataBitMask) set:aBoolean.
"/    aBoolean
"/        ifTrue: [flag := flag maskSet: self hasPostDataBitMask]
"/        ifFalse: [flag := flag maskClear: self hasPostDataBitMask]
!

hasSearchPart
    ^flag allMask: self hasSearchPartBitMask


!

hasSearchPart: aBoolean
    flag := flag mask:(self hasSearchPartBitMask) set:aBoolean.
"/    aBoolean
"/        ifTrue: [flag := flag maskSet: self hasSearchPartBitMask]
"/        ifFalse: [flag := flag maskClear: self hasSearchPartBitMask]
!

isFileScheme
    ^ method isNil or:[method = 'file']
!

isFragmentOnly
    ^  method isNil 
        and: [host isNil 
        and: [port isNil 
        and: [path isNil 
        and: [self fragmentPart notNil]]]]
!

isHostRelativePath
    ^ method isNil 
        and:[ host isNil 
        and:[ port isNil 
        and:[ self fragmentPart notNil ]]]
!

isRelativePath
    ^ method isNil 
        and:[ host isNil 
        and:[ port isNil 
        and:[ self fragmentPart notNil
        and:[ ((path ? '') startsWith:'/') not]]]]
!

isValidMethod:aMethod
    "mhmh - is this a good idea (isn't it the task of a url-user to decide, which
     methods it supports). 
     The URL does not really know..."
    
    aMethod = 'http' ifTrue:[^ true].
    aMethod = 'https' ifTrue:[^ true].
    aMethod = 'file' ifTrue:[^ true].
    aMethod = 'ftp' ifTrue:[^ true].
    aMethod = 'gopher' ifTrue:[^ true].
    ^ false

    "Created: / 27.7.1998 / 19:40:14 / cg"
!

newsGroup
    "If the receiver is an nntp url, return the news group; otherwise, return nil."

    (method = 'nntp' and: [path notNil]) 
        ifTrue:[ ^ path copyFrom:2 to:(path nextIndexOf:$/ from:2 to:path size) - 1]
        ifFalse:[ ^ nil ]

    "Modified: / 19-11-2016 / 13:04:08 / cg"
!

postData
    self hasPostData ifTrue: [^ otherPart].
    ^ nil


!

postData: aString
    otherPart := aString.
    flag := 0.
    self hasPostData:true


!

requestString
    "everything but the host & scheme (i.e. path+options alone, as in an HTTP requests header line)"

    | stream |

    stream := WriteStream on: (String new: 128).
    path isNil ifTrue: [
        stream nextPut: $/
    ] ifFalse: [
        stream nextPutAll: path
    ].
    (otherPart notNil and: [self hasSearchPart]) ifTrue: [
        stream nextPut: $?; nextPutAll: otherPart
    ].
    ^ stream contents

    "Modified (comment): / 05-10-2011 / 17:43:07 / cg"
!

searchPart
    self hasSearchPart ifTrue: [^otherPart].
    ^nil


!

searchPart: aString
    otherPart := aString.
    flag := 0.
    self hasSearchPart: true


! !

!URL methodsFor:'testing'!

isURL
    ^ true

    "Created: / 17-02-2017 / 10:24:45 / cg"
! !

!URL methodsFor:'utilities'!

/ aString
    "filename compatibility protocol:
     A a new instance with aString concatenated to my path.
     We simply append aString to the end of the path.
     Look at construct for a more enhanced "

    |newPath|

    path isEmptyOrNil ifTrue:[
        newPath := '/', aString.
    ] ifFalse:[    
        path last = $/ ifTrue:[
            newPath := path , aString.
        ] ifFalse:[
            newPath := path , '/', aString.
        ].
    ].
        
    ^ self copy path:newPath.

    "
      'http://www.exept.de/start' asURL / 'bla'
      'http://www.exept.de/start/' asURL / 'bla'
      'http://www.exept.de' asURL / 'bla'
    "

    "Created: / 13-04-2008 / 21:29:15 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

construct:anUrlOrString 
    "filename compatibility protocol:
     return a URL with a path which is the concatenation
     of my path and anUrlOrString.
     If anUrlOrString is a URL and has another method or host than the receiver,
     it is returned plain.
     Also, if anUrlOrString is either an URL representing an absolute path.
     I.e. this method can be used to compute an html document's anchor's target URL"
     
    |newURL anURL|

    anUrlOrString isString ifTrue:[
        anURL := URL fromString:anUrlOrString.
    ] ifFalse:[
        anURL := anUrlOrString.
    ].

    anURL scheme notNil ifTrue:[
        method ~= anURL method ifTrue:[
            ^ anURL
        ].
        anURL host notNil ifTrue:[
            ^ anURL
        ].
         "(anURL host notNil and: [host ~= anURL host]) ifTrue: [^anURL].
         (anURL port notNil and: [port ~= anURL port]) ifTrue: [^anURL]"
    ].
    newURL := self copyWithoutOtherPart.
    anURL path notNil ifTrue:[
        self isFileScheme ifTrue:[
            (path isNil or:[ anURL path notEmpty and:[ anURL path first = $/ ] ]) ifTrue:[
                newURL path:anURL path
            ] ifFalse:[
                (path notEmpty and:[ path first = $/ ]) ifTrue:[
                    newURL path:(self class constructPath:path with:anURL path)
                ] ifFalse:[
                    newURL path:(path asFilename directory constructString:anURL path)
                ]
            ]
        ] ifFalse:[
            path isNil ifTrue:[
                newURL path:(self class constructPath:'/' with:anURL path)
            ] ifFalse:[
                newURL path:(self class constructPath:path with:anURL path)
            ]
        ]
    ].
    newURL setOtherPart:anURL otherPart flag:anURL flag.
    ^ newURL

    "
       (URL fromString: 'http://www/dir/file.html') construct: (URL fromString: 'subdir/image.gif').
       (URL fromString: 'http://www/dir1/file.html') construct: (URL fromString: '/dir2/image.gif').
       (URL fromString: 'http://www/dir1/file.html') construct: (URL fromString: '~kyasu/').
       (URL fromString: 'http://www/dir/file.html') construct: (URL fromString: '#introduction').
       (URL fromString: 'http://www/dir/file.html') construct: (URL fromString: '/cgi-bin/perl.pl&dest=/other').
       (URL fromString: 'http://www/dir/file.html') construct: (URL fromString: 'http:/cgi-bin/perl.pl&dest=/other').
       (URL fromString: 'http://www-s2.rsl.crl.fujixerox.co.jp/~kyasu/') construct: (URL fromString: 'http://arrow').
       (URL fromString: 'gopher://www.com') construct: (URL fromString: '//www.com:70/ParcBenchMain').
       (URL fromString: 'http://www/some.html') construct: (URL fromString: 'http://www/').
       (URL fromString: '../tmp/table.html') construct: (URL fromString: 'kyasu.gif').
    "
!

directory
    "filename compatibility protocol:
     return a URL which represents the receiver's directoy"
    
    ^ self copy path:(UnixFilename named:self path) directoryName.

    "
     'http://www.exept.de:8080/foo/bar/baz.txt' asURL directory
     'file:///foo/bar/baz.txt' asURL directory
    "
!

pathBasename
    "answer the baseName of my path as a string.
     eg. for '/part1/part2/part3.suffix' this is 'part3.suffix'"

    path isNil ifTrue: [^ ''].
    ^ (UnixFilename named:path) baseName

    "
     'http://www.exept.de:8080/foo/bar/baz.txt' asURL pathBasename
     'file:///foo/bar/baz.txt' asURL pathBasename
    "
!

pathSuffix
    "answer the suffix of my path as a string.
     eg. for '/part1/part2/part3.suffix' this is 'suffix'"

    path isNil ifTrue: [^ ''].
    ^ (UnixFilename named:path) suffix

"/    | tail index |
"/
"/    path isNil ifTrue: [^ ''].
"/    tail := path asFilename tail.
"/    index := tail lastIndexOf: $..
"/    index = 0 ifTrue: [^ ''].
"/    ^ tail copyFrom: index + 1 to: tail size

    "
     'http://www.exept.de:8080/foo/bar/baz.txt' asURL pathSuffix
     'file:///foo/bar/baz.txt' asURL pathSuffix
    "
!

pathWithoutSuffix
    "answer the baseName of my path as a string.
     eg. for 'http://host/part1/part2/part3.suffix' this is '/part1/part2/part3'"

    path isNil ifTrue: [^ ''].
    ^ (UnixFilename named:path) withoutSuffix pathName

    "
     'http://www.exept.de:8080/foo/bar/baz.txt' asURL pathWithoutSuffix
     'file:///foo/bar/baz.txt' asURL pathWithoutSuffix
    "
! !

!URL class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libhtml/URL.st,v 1.75 2018-08-28 07:10:04 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libhtml/URL.st,v 1.75 2018-08-28 07:10:04 cg Exp $'
! !

