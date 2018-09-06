"
 COPYRIGHT (c) 1995 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

UninterpretedBytes variableByteSubclass:#SocketAddress
	instanceVariableNames:''
	classVariableNames:'DomainToClassMapping Verbose LastName LastPort LastType LastAddr
		LastTime'
	poolDictionaries:''
	category:'OS-Sockets'
!

!SocketAddress primitiveDefinitions!
%{
#include "stxOSDefs.h"
%}
! !

!SocketAddress class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
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
    Abstract superclass for subclasses implementing various IPC addressing schemes.
    See concrete examples IPSocketAddress and UDSocketAddress.

    ST-80 compatibility class.
    This may be required when existing code has to be ported to ST/X;
    however, it may not be complete and more protocol may be added in the future.
    The code here was created when public domain code (Manchester) had to
    be ported to ST/X and missing classes/methods were encountered, and code added
    by reasoning 'what the original class could probably do there'.

    This is an additional goody class; therefore:

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
! !

!SocketAddress class methodsFor:'instance creation'!

allForHostName:name
    "get a collection of new instances given a hostname"

    ^ self allForHostName:name serviceName:nil type:nil
!

allForHostName:name port:portNr
    "get a collection of new instances given a hostname and port"

    ^ self allForHostName:name serviceName:portNr type:nil
!

allForHostName:name serviceName:portNrOrName type:socketTypeSymbol
    "get a collection of new instances given a hostname, port or service and type.
     Multi-homed hosts return more than one entry"

    |addressInfo|

    addressInfo := self 
                    getAddressInfo:name 
                    serviceName:portNrOrName 
                    domain:self domain 
                    type:socketTypeSymbol
                    protocol:nil 
                    flags:0.
    addressInfo isNil ifTrue:[
        ^ nil
    ].
    ^ addressInfo collect:[:eachAddressInfo| eachAddressInfo socketAddress].
        

    "
     SocketAddress allForHostName:'localhost' serviceName:10 type:#stream
     SocketAddress allForHostName:'localhost' serviceName:'10' type:#stream
     IPSocketAddress allForHostName:'localhost' serviceName:'echo' type:#datagram 
     IPSocketAddress allForHostName:'localhost' serviceName:'echo' type:nil
     IPSocketAddress allForHostName:'google.com' serviceName:'http' type:nil
    "
!

anyHost
    "get a new instance representing the ANY-host address"

    ^ self hostAddress:self anyAddress
!

fromBytes:bytesArg
    "create a socket address from bytes (ByteArray), 
     returned by the primitive syscalls.
     Raises an error, if the domainType is not supported by this Smalltalk
     (i.e. if libbasic was compiled without support for the corresponding AF_xxx support)"

    |domainNr domainSymbol bytes|

    bytes := bytesArg asByteArray.

    "/ cg: code used to be:
    "/      domainNr := bytes unsignedShortAt:1.
    "/ however, some systems use a different structure, which includes the struct length
    "/ in byte 1 (APPLE).
    "/ so better let the C-compiler figure out how things are layed out...
%{
    if (__isByteArrayLike(bytes)) {
        struct sockaddr *s = (struct sockaddr *)(__ByteArrayInstPtr(bytes)->ba_element);

        domainNr = __mkSmallInteger(s->sa_family);
    }
%}.
    domainSymbol := OperatingSystem domainSymbolOf:domainNr.
    domainSymbol isNil ifTrue:[
       self error:('unsupported domain (type=%1)' bindWith:domainNr)
    ].
    ^ (SocketAddress newDomain:domainSymbol) fromBytes:bytes.
!

hostAddress:addr
    "get a new instance given addr-bytes"

    ^ self new hostAddress:addr
!

hostAddress:addr port:portNr
    "get a new instance given addr-bytes and a portNr"

    ^ self new hostAddress:addr; port:portNr
!

hostName:name
    "get a new instance given a hostname"

    ^ self hostName:name serviceName:nil type:nil.

    "Modified: / 17-06-2009 / 15:25:42 / sr"
!

hostName:name port:portNr
    "get a new instance given a hostname and port"

    "Solaris 9 has a problem with some service names if type is missing!!"
    ^ self hostName:name serviceName:portNr type:#SOCK_STREAM
!

hostName:name serviceName:portNrOrName type:socketTypeSymbol
    "get a new instance given a hostname, port or service and type.
     Do not use this, since it does not work for multi-homed hosts"

    |addressList sa|

    LastName = name ifTrue:[
        LastPort = portNrOrName ifTrue:[
            LastType = socketTypeSymbol ifTrue:[
                (Timestamp now secondDeltaFrom: LastTime) <= 30 ifTrue:[
                    ^ LastAddr 
                ]
            ]
        ]
    ].

    addressList := self allForHostName:name serviceName:portNrOrName type:socketTypeSymbol.
    addressList isNil ifTrue:[^ nil].

    sa := addressList last.
    addressList size > 1 ifTrue:[
        (addressList contains:[:entry| entry  ~= sa]) ifTrue:[
            Verbose == true ifTrue:[
                ('SocketAddress [warning]: multiple hostAddresses for host: ', name) infoPrintCR.
                addressList do:[:entry| '  ' infoPrint. entry infoPrintCR].
                (addressList detect:[:entry| entry ~= sa] ifNone:nil) infoPrintCR.
            ].
        ].
    ].
    LastTime := Timestamp now.
    LastName := name.
    LastPort := portNrOrName.
    LastType := socketTypeSymbol.
    LastAddr := sa.
    ^ sa.

    "
     SocketAddress hostName:'localhost' serviceName:10 type:#stream  
     IPSocketAddress hostName:'localhost' serviceName:'echo' type:#datagram 
     IPSocketAddress hostName:'localhost' serviceName:'echo' type:nil
     IPSocketAddress hostName:'www.google.com' serviceName:'http' type:nil
     SocketAddress allForHostName:'localhost' serviceName:10 type:#stream.
     SocketAddress allForHostName:'www.google.com' serviceName:10 type:#stream.
    "

    "Modified: / 17-06-2009 / 15:25:35 / sr"
!

new
    |numBytes|

    self == SocketAddress ifTrue:[
        self abstractClassInstantiationError.
    ].

    numBytes := self socketAddressSize.
    numBytes isNil ifTrue:[
        self error:'unsupported domain'.
        ^ nil
    ].
    ^ (self new:numBytes) domainCode:(self domainCode)

    "
     IPSocketAddress new            
     IPv6SocketAddress new          
     UDSocketAddress new            
     AppletalkSocketAddress new
   "
!

newDomain:domain
   "answer an new socket address for a given domain"

   ^ (self knownClassFromCode:domain) new

   "
    self newDomain:#afUnix    
    self newDomain:#afInet    

    self newDomain:#'AF_UNIX' 
    self newDomain:#'AF_INET' 

    self newDomain:#unix
    self newDomain:#inet
   "
! !

!SocketAddress class methodsFor:'addressing'!

anyAddress
    self subclassResponsibility
! !

!SocketAddress class methodsFor:'queries'!

domain
    "Answer the domain symbol. Subclasses redefine this"

    self == SocketAddress ifTrue:[
        ^ nil
    ] ifFalse:[
        self subclassResponsibility
    ]
!

domainCode
    "answer the numerical domain code used in socket addresses"

    ^ OperatingSystem domainCodeOf:self domain
!

domainCodeFromName:aNameSymbol
    "this is a compatibility method;
     VW returns the internal unix codes here - however, in ST/X,
     symbols are returned, which are translated later"

    aNameSymbol isInteger ifTrue:[ ^ aNameSymbol ].

    "here, all possible variants are translated to AF_* symbols,
     which are handled by the primitives"

    aNameSymbol == #afUnix      ifTrue:[^ #'AF_UNIX'].
    aNameSymbol == #AF_UNIX     ifTrue:[^ #'AF_UNIX'].
    aNameSymbol == #unix        ifTrue:[^ #'AF_UNIX'].

    aNameSymbol == #afInet      ifTrue:[^ #'AF_INET'].    
    aNameSymbol == #'AF_INET'   ifTrue:[^ #'AF_INET'].    
    aNameSymbol == #inet        ifTrue:[^ #'AF_INET'].    

    aNameSymbol == #afIpV6      ifTrue:[^ #'AF_INET6'].    
    aNameSymbol == #'AF_INET6'  ifTrue:[^ #'AF_INET6'].    
    aNameSymbol == #inet6       ifTrue:[^ #'AF_INET6'].    
    aNameSymbol == #afInet6     ifTrue:[^ #'AF_INET6'].    

    aNameSymbol == #afAppletalk    ifTrue:[^ #'AF_APPLETALK'].    
    aNameSymbol == #'AF_APPLETALK' ifTrue:[^ #'AF_APPLETALK'].    
    aNameSymbol == #appletalk      ifTrue:[^ #'AF_APPLETALK'].    

    aNameSymbol == #afDecnet    ifTrue:[^ #'AF_DECnet'].    
    aNameSymbol == #'AF_DECnet' ifTrue:[^ #'AF_DECnet'].    
    aNameSymbol == #'AF_DECNET' ifTrue:[^ #'AF_DECnet'].    
    aNameSymbol == #decnet      ifTrue:[^ #'AF_DECnet'].    
    aNameSymbol == #decNet      ifTrue:[^ #'AF_DECnet'].    
    aNameSymbol == #DECnet      ifTrue:[^ #'AF_DECnet'].    

    aNameSymbol == #afSna       ifTrue:[^ #'AF_SNA'].    
    aNameSymbol == #'AF_SNA'    ifTrue:[^ #'AF_SNA'].    
    aNameSymbol == #sna         ifTrue:[^ #'AF_SNA'].    

    aNameSymbol == #afNs        ifTrue:[^ #'AF_NS'].    
    aNameSymbol == #'AF_NS'     ifTrue:[^ #'AF_NS'].    
    aNameSymbol == #ns          ifTrue:[^ #'AF_NS'].    
    aNameSymbol == #xns         ifTrue:[^ #'AF_NS'].    

    aNameSymbol == #afCcitt     ifTrue:[^ #'AF_CCITT'].    
    aNameSymbol == #'AF_CCITT'  ifTrue:[^ #'AF_CCITT'].    
    aNameSymbol == #ccitt       ifTrue:[^ #'AF_CCITT'].    

    aNameSymbol == #afImplink    ifTrue:[^ #'AF_IMPLINK'].    
    aNameSymbol == #'AF_IMPLINK' ifTrue:[^ #'AF_IMPLINK'].    
    aNameSymbol == #implink      ifTrue:[^ #'AF_IMPLINK'].    

    aNameSymbol == #afPup       ifTrue:[^ #'AF_PUP'].    
    aNameSymbol == #'AF_PUP'    ifTrue:[^ #'AF_PUP'].    
    aNameSymbol == #pup         ifTrue:[^ #'AF_PUP'].    

    aNameSymbol == #afChaos    ifTrue:[^ #'AF_CHAOS'].    
    aNameSymbol == #'AF_CHAOS' ifTrue:[^ #'AF_CHAOS'].    
    aNameSymbol == #chaos      ifTrue:[^ #'AF_CHAOS'].    

    aNameSymbol == #afEcma      ifTrue:[^ #'AF_ECMA'].    
    aNameSymbol == #'AF_ECMA'   ifTrue:[^ #'AF_ECMA'].    
    aNameSymbol == #ecma        ifTrue:[^ #'AF_ECMA'].    

    aNameSymbol == #afDatakit    ifTrue:[^ #'AF_DATAKIT'].    
    aNameSymbol == #'AF_DATAKIT' ifTrue:[^ #'AF_DATAKIT'].    
    aNameSymbol == #datakit      ifTrue:[^ #'AF_DATAKIT'].    

    aNameSymbol == #afDli     ifTrue:[^ #'AF_DLI'].    
    aNameSymbol == #'AF_DLI'  ifTrue:[^ #'AF_DLI'].    
    aNameSymbol == #dli       ifTrue:[^ #'AF_DLI'].    

    aNameSymbol == #afLat     ifTrue:[^ #'AF_LAT'].    
    aNameSymbol == #'AF_LAT'  ifTrue:[^ #'AF_LAT'].    
    aNameSymbol == #lat       ifTrue:[^ #'AF_LAT'].    

    aNameSymbol == #afHylink    ifTrue:[^ #'AF_HYLINK'].    
    aNameSymbol == #'AF_HYLINK' ifTrue:[^ #'AF_HYLINK'].    
    aNameSymbol == #hylink      ifTrue:[^ #'AF_HYLINK'].    

    aNameSymbol == #afUnspec    ifTrue:[^ #'AF_UNSPEC'].    
    aNameSymbol == #'AF_UNSPEC' ifTrue:[^ #'AF_UNSPEC'].    
    aNameSymbol == #unspec      ifTrue:[^ #'AF_UNSPEC'].    

    aNameSymbol == #afRaw    ifTrue:[^ #'AF_RAW'].    
    aNameSymbol == #'AF_RAW' ifTrue:[^ #'AF_RAW'].    
    aNameSymbol == #raw      ifTrue:[^ #'AF_RAW'].    

    "/
    "/ could someone tell me which symbols are used in ST-80's SocketAddress class ?
    "/
    self error:'no more mimicri implemented yet ...'

    "Modified: / 9.1.1998 / 10:03:56 / stefan"
!

domainNameFromCode:code
    "this is a compatibility method;
     VW expects the internal unix codes here - however, in ST/X,
     symbols are expected - keeping the numeric values secret (in Socket)"

    code == #unix           ifTrue:[^ #afUnix].
    code == #'AF_UNIX'      ifTrue:[^ #afUnix].
    code == #'afUnix'       ifTrue:[^ #afUnix].

    code == #inet           ifTrue:[^ #afInet].
    code == #'AF_INET'      ifTrue:[^ #afInet].
    code == #'afInet'       ifTrue:[^ #afInet].

    code == #inet6          ifTrue:[^ #afIpV6].
    code == #'AF_INET6'     ifTrue:[^ #afIpV6].
    code == #'afIpV6'       ifTrue:[^ #afIpV6].

    code == #appletalk      ifTrue:[^ #afAppletalk].
    code == #'AF_APPLETALK' ifTrue:[^ #afAppletalk].
    code == #'afAppletalk'  ifTrue:[^ #afAppletalk].

    code == #decnet         ifTrue:[^ #afDecnet].
    code == #DECnet         ifTrue:[^ #afDecnet].
    code == #decNet         ifTrue:[^ #afDecnet].
    code == #'AF_DECNET'    ifTrue:[^ #afDecnet].
    code == #'AF_DECnet'    ifTrue:[^ #afDecnet].
    code == #'afDecnet'     ifTrue:[^ #afDecnet].

    code == #sna            ifTrue:[^ #afSna].
    code == #'AF_SNA'       ifTrue:[^ #afSna].
    code == #'afSna'        ifTrue:[^ #afSna].

    code == #xns            ifTrue:[^ #afNs].
    code == #ns             ifTrue:[^ #afNs].
    code == #'AF_NS'        ifTrue:[^ #afNs].
    code == #'afNs'         ifTrue:[^ #afNs].

    code == #ccitt          ifTrue:[^ #afCcitt].
    code == #'AF_CCITT'     ifTrue:[^ #afCcitt].
    code == #'afCcitt'      ifTrue:[^ #afCcitt].

    code == #implink      ifTrue:[^ #afImplink].    
    code == #'AF_IMPLINK' ifTrue:[^ #afImplink].    
    code == #afImplink    ifTrue:[^ #afImplink].    

    code == #pup         ifTrue:[^ #afPup].    
    code == #'AF_PUP'    ifTrue:[^ #afPup].    
    code == #afPup       ifTrue:[^ #afPup].    

    code == #chaos      ifTrue:[^ #afChaos].    
    code == #'AF_CHAOS' ifTrue:[^ #afChaos].    
    code == #afChaos    ifTrue:[^ #afChaos].    

    code == #ecma        ifTrue:[^ #afEcma].    
    code == #'AF_ECMA'   ifTrue:[^ #afEcma].    
    code == #afEcma      ifTrue:[^ #afEcma].    

    code == #datakit      ifTrue:[^ #afDatakit].    
    code == #'AF_DATAKIT' ifTrue:[^ #afDatakit].    
    code == #afDatakit    ifTrue:[^ #afDatakit].    

    code == #dli       ifTrue:[^ #afDli].    
    code == #'AF_DLI'  ifTrue:[^ #afDli].    
    code == #afDli     ifTrue:[^ #afDli].    

    code == #lat       ifTrue:[^ #afLat].    
    code == #'AF_LAT'  ifTrue:[^ #afLat].    
    code == #afLat     ifTrue:[^ #afLat].    

    code == #hylink      ifTrue:[^ #afHylink].    
    code == #'AF_HYLINK' ifTrue:[^ #afHylink].    
    code == #afHylink    ifTrue:[^ #afHylink].    

    code == #unspec      ifTrue:[^ #afUnspec].    
    code == #'AF_UNSPEC' ifTrue:[^ #afUnspec].    
    code == #afUnspec    ifTrue:[^ #afUnspec].    

    code == #raw      ifTrue:[^ #afRaw].    
    code == #'AF_RAW' ifTrue:[^ #afRaw].    
    code == #afRaw    ifTrue:[^ #afRaw].    

    "/
    "/ could someone tell me which symbols are used in ST-80's SocketAddress class ?
    "/
    self error:'no more mimicri implemented yet ...'
!

getAddressInfo:hostName serviceName:serviceName domain:domainArg type:typeArg protocol:protoArg flags:flags 
    "answer an Array of socket addresses for serviceName on hostName
     Domain, type, protocol may be nil or specify a hint for the socket 
     addresses to be returned."

    ^ OperatingSystem socketAccessor 
            getAddressInfo:hostName serviceName:serviceName 
            domain:domainArg type:typeArg protocol:protoArg flags:flags 

    "
     self getAddressInfo:'localhost' serviceName:nil 
            domain:nil type:nil protocol:nil flags:nil
     self getAddressInfo:'localhost' serviceName:nil 
            domain:#AF_INET type:#stream protocol:nil flags:nil
     self getAddressInfo:'localhost' serviceName:nil 
            domain:#AF_INET type:#stream protocol:#tcp flags:nil
     self getAddressInfo:'blurb.exept.de' serviceName:nil 
            domain:#AF_INET type:nil protocol:nil flags:nil
     self getAddressInfo:'1.2.3.4' serviceName:'6' 
            domain:#AF_INET type:nil protocol:nil flags:nil
     self getAddressInfo:'localhost' serviceName:'echo' 
            domain:#AF_INET6 type:nil protocol:nil flags:nil
    "
!

getAddressInfo:hostName serviceName:serviceName type:typeArg protocol:protoArg flags:flags 
    "answer an Array of socket addresses for serviceName on hostName
     Domain, type, protocol may be nil or specify a hint for the socket 
     addresses to be returned."

    ^ self  
        getAddressInfo:hostName serviceName:serviceName 
        domain:(self domainCode) type:typeArg protocol:protoArg flags:flags 

    "
     IPSocketAddress getAddressInfo:'localhost' serviceName:nil 
                     type:nil protocol:nil flags:nil
     IPSocketAddress getAddressInfo:'localhost' serviceName:nil 
                     type:#stream protocol:nil flags:nil
     IPSocketAddress getAddressInfo:'localhost' serviceName:nil 
                     type:#stream protocol:#tcp flags:nil
     IPSocketAddress getAddressInfo:'blurb.exept.de' serviceName:nil 
                     type:nil protocol:nil flags:nil
     IPSocketAddress getAddressInfo:'1.2.3.4' serviceName:'6' 
                     type:nil protocol:nil flags:nil
     IPSocketAddress getAddressInfo:'localhost' serviceName:'echo' 
                     type:nil protocol:nil flags:nil
    "
!

getNameInfo:socketAddress wantHostName:wantHostName wantServiceName:wantServiceName datagram:useDatagram flags:flags 
    "answer an Array containing the hostName and/or serviceName
     for a given socketAddress."

    ^ OperatingSystem socketAccessor
            getNameInfo:socketAddress wantHostName:wantHostName 
            wantServiceName:wantServiceName datagram:useDatagram flags:flags 
    
    "
     self getNameInfo:
         (self getAddressInfo:'localhost' serviceName:'echo' 
                domain:#inet type:#stream protocol:nil flags:nil) first socketAddress
         wantHostName:true wantServiceName:true datagram:false flags:0     
    "
!

hostAddressLen
    "answer the number of bytes of the host address"

    ^ self subclassResponsibility
!

knownClassFromCode:code
    "this is a compatibility method;
     VW expects the internal unix codes here - however, in ST/X,
     symbols are expected - keeping the numeric values secret (in Socket)"

    |cls|

    DomainToClassMapping isNil ifTrue:[
        DomainToClassMapping := IdentityDictionary new.
        "/ some are always known...
        DomainToClassMapping 
            at:#unix put:UDSocketAddress;
            at:#inet put:IPSocketAddress;
            at:#inet6 put:IPv6SocketAddress;
            at:#appletalk put:AppletalkSocketAddress;
            at:#decnet put:DecNetSocketAddress.
    ].
    cls := DomainToClassMapping at:code ifAbsent:nil.
    cls notNil ifTrue:[^ cls].

    code notNil ifTrue:[
        self allSubclassesDo:[:aSubClass|
            (aSubClass domainCode == code
            or:[aSubClass domain == code
            or:[aSubClass obsoleteDomainSymbol == code
            or:[aSubClass vwDomainSymbol == code]]])
            ifTrue:[
                DomainToClassMapping at:code put:aSubClass.
                ^ aSubClass
            ].
        ].
    ].
    ^ SocketAddress

    "
     DomainToClassMapping := nil.

     self knownClassFromCode:#'AF_UNIX' 
     self knownClassFromCode:#'AF_INET'

     self knownClassFromCode:1
     self knownClassFromCode:2

     self knownClassFromCode:#unix             obsolete ST/X codes
     self knownClassFromCode:#inet

     self knownClassFromCode:#afUnix           visualWorks codes
     self knownClassFromCode:#afInet
    "
!

obsoleteDomainSymbol
    ^ nil
!

peerNameFromPeer:peer
    ^ peer hostName
!

socketAddressSize
    "answer the OS specific size of a socket address.
     Returns nil, if the domain is not supported or invalid."

    ^ OperatingSystem socketAddressSizeOfDomain:self domain

    "
     SocketAddress socketAddressSize  
     UDSocketAddress socketAddressSize  
     IPSocketAddress socketAddressSize  
     IPv6SocketAddress socketAddressSize 
     AppletalkSocketAddress socketAddressSize  
     DecNetSocketAddress socketAddressSize     
    "
!

vwDomainSymbol
    ^ nil
! !

!SocketAddress methodsFor:'accessing'!

domainCode
    "this opaquely returns the first two bytes as a short integer;
     Notice: some systems store the domainCode in those 2 bytes,
     whereas others (IOS) store the size of the addr-struct in byte 1,
     and the actual domain code in byte 2"

    OperatingSystem isOSXlike ifTrue:[
        ^ self at:2
    ].
    ^ self unsignedInt16At:1
!

domainCode:anInteger
    "this opaquely sets the first two bytes as a short integer;
     Notice: some systems store the domainCode in those 2 bytes,
     whereas others (IOS) store the size of the addr-struct in byte 1,
     and the actual domain code in byte 2"

    OperatingSystem isOSXlike ifTrue:[
        self at:1 put:self size.
        self at:2 put:anInteger.
    ] ifFalse:[ 
        self unsignedInt16At:1 put:anInteger
    ].
!

hostAddress:addressBytes
    "generic method, subclasses usually redefine this"

    "/ the first 2-bytes (a short) is the domainCode
    self replaceBytesFrom:1+2 to:addressBytes size+2 with:addressBytes startingAt:1

    "
     IPSocketAddress hostAddress:#[193 141 12 193] port:80
    "
!

hostAddress:addressBytes port:portNr
    self hostAddress:addressBytes.
    self port:portNr

    "
     IPSocketAddress hostAddress:#[193 141 12 193] port:10
    "
!

hostAddressString
    ^ String streamContents:[:s | self printAddressOn:s ].
!

port
    self subclassResponsibility
!

port:portNr
    self subclassResponsibility
! !

!SocketAddress methodsFor:'comparing'!

sameHostAddress:aSocketAddress
    "answer true, if aSocketAddres has the same hostaddress as myself"

    ^ self class = aSocketAddress class 
        and:[self hostAddress = aSocketAddress hostAddress] 

    "
     (IPSocketAddress hostAddress:#[193 141 12 193] port:80)
        sameHostAddress:
     (IPSocketAddress hostAddress:#[193 141 12 193] port:81)
    "
! !

!SocketAddress methodsFor:'converting'!

asIPv4SocketAddressIfPossible
    ^ self
! !

!SocketAddress methodsFor:'hashing'!

hash
    "generate a SmallInteger hash for the socket address - use all the bytes"

    ^ self computeXorHashFrom:1 to:0
! !

!SocketAddress methodsFor:'printing & storing'!

displayOn:aGCOrStream
    "redefine from Collection"

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    (aGCOrStream isStream) ifTrue:[
        self printOn:aGCOrStream.
        ^ self.
    ].

    ^ super displayOn:aGCOrStream
!

printAddressOn:arg 
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

printOn:aStream
    "append a user printed representation of the receiver to aStream.
     The format is suitable for a human - not meant to be read back."

    self printOn:aStream withPort:true
!

printOn:aStream withPort:withPort
    "append a user printed representation of the receiver to aStream.
     The format is suitable for a human - not meant to be read back."

    self printAddressOn:aStream.
    withPort ifTrue:[
        self printPortOn:aStream.
    ].
!

printPortOn:aStream 
    |port|

    (port := self port) ~~ 0 ifTrue:[
        aStream nextPut:$:.
        port printOn:aStream.
    ]
! !

!SocketAddress methodsFor:'private'!

fromBytes:aByteArray
    "Copy the internal representation of a SocketAddress to myself

     This is an internal interface!!"

    self replaceBytesFrom:1 to:(self size) with:aByteArray startingAt:1.


! !

!SocketAddress methodsFor:'queries'!

address
    ^ self subclassResponsibility
!

domain
    "anwer the domain symbol used to creat a socket"

    ^ self class domain
!

hostName
    ^ (self class getNameInfo:self wantHostName:true 
                  wantServiceName:false datagram:false flags:0) first

    "
     (IPSocketAddress hostAddress:#[127 0 0 1]) hostName        
     (IPSocketAddress hostName:'localhost') address        
     (IPSocketAddress hostName:'www.google.com') address        

     (IPSocketAddress hostAddress:#[127 0 0 1] port:7) hostName        
     (IPSocketAddress hostAddress:#[172 23 1 1] port:10) hostName  
     (IPSocketAddress hostAddress:#[172 24 1 244]) hostName 
     (IPv6SocketAddress hostAddress: #[0 0 0 0  0 0 0 0  0 0 0 0  0 0 0 1]) hostName 
     (IPv6SocketAddress hostAddress: #[0 0 0 0  0 0 0 0  0 0 0 0  0 0 0 2]) hostName 
     (IPv6SocketAddress hostAddress: #[0 0 0 0  0 0 0 0  0 0 255 255  127 0 0 1]) hostName 
     (IPv6SocketAddress hostAddress: #[0 0 0 0  0 0 0 0  0 0 255 255  172 23 1 1]) hostName 
    "
!

hostNameOrAddressString
    "answer the host name or the string representation
     of the address"

    ^ [
        self hostName.
    ] on:NameLookupError do:[:ex| |stream|
        stream := '' writeStream.
        self printAddressOn:stream.
        stream contents.
    ].

    "
        (IPSocketAddress hostName:'localhost') hostNameOrAddressString
        (IPSocketAddress hostAddress:#[192 168 8 33]) hostNameOrAddressString
    "
!

portOrName
    ^ self subclassResponsibility
!

serviceName
    ^ (self class getNameInfo:self wantHostName:false 
                  wantServiceName:true datagram:false flags:0) second

    "
     (IPSocketAddress hostAddress:#[127 0 0 1] port:7) serviceName
     (IPSocketAddress hostAddress:#[193 141 12 193] port:10) serviceName
    "
! !

!SocketAddress methodsFor:'testing'!

isIPSocketAddress
    ^ false
!

isIPv4SocketAddress
    ^ false
!

isIPv6SocketAddress
    ^ false
!

isLocal
    "answer true, if this address addresses a peer on the same host"

    ^ self subclassResponsibility
!

isMyAddress
    "answer true, if the address refers to my own host.
     Subclasses may redefine this to check the local configuration, too."

    ^ self isLocal
!

isSocketAddress
    ^ true
! !

!SocketAddress class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

