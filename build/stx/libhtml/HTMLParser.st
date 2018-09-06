"
 COPYRIGHT (c) 1996 by Claus Gittinger
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

Object subclass:#HTMLParser
	instanceVariableNames:'inStream textScannedSoFar bindings additionalInput markupAnchor
		lastMarkup lineNr scriptObject destination outStream
		characterDecoder'
	classVariableNames:'AmpersandEscapes MathAmpersandEscapes CR CRCR CRCRCR SPACE'
	poolDictionaries:''
	category:'System-Documentation'
!

!HTMLParser class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996 by Claus Gittinger
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
    Notice & Warning: 
        this HTML markup framework and the corresponding parser
        started as a quick hack (in the 90's) when replacing a buggy mosaic
        X-widget with a Smalltalk written HTML viewer. 
        Its goals were to be fast enough for typical uses, to be not too memory hungry
        and to provide the functionality required to display simple help documents.
        It was NOT meant to become a full featured web-browser replacement.

        This framework is still in use as the document viewer inside ST/X,
        and supported to the extent that simple online help documents and html tooltips are to be displayed.
        However, there are no plans to further enhance or spend more time on its maintenance.

        If you need more sophisticated html/dom/doc functionality, you may want to use either
        the HTMLTree framework or one of the free frameworks found in the goodies folder.

    instances of this class are used to read HTML documents
    and build a collection of markup elements for simple online help documents.
    This markup-collection can be displayed using the HTMLDocumentViewer
    or printed by the HTMLDocumentPrinter.

    [author:]
        Claus Gittinger

    [see also:]
        HTMLMarkup
        HTMLDocumentView 
        HTMLDocumentPainter HTMLDocumentPrinter
"
!

examples
"
                                                                        [exBegin]
    |p in document|

    p := HTMLParser new.
    in := '../../doc/online/english/TOP.html' asFilename readStream.
    document := p parseText:in.
    in close.
    document inspect
                                                                        [exEnd]


                                                                        [exBegin]
    |v document|

    v := HTMLDocumentView new openAndWait.

    v homeDocument:'../../doc/online/english/TOP.html'.
                                                                        [exEnd]


                                                                        [exBegin]
    |top v document|

    top := StandardSystemView extent:200@500.
    v := HVScrollableView for:HTMLDocumentView miniScrollerH:true in:top.
    v origin:0.0@ 0.0 corner:1.0@1.0.
    top openAndWait.

    v homeDocument:'../../doc/online/english/TOP.html'.
                                                                        [exEnd]


                                                                        [exBegin]
    |v document|

    v := HTMLDocumentView new openAndWait.

    document := (HTMLParser new) 
                        parseText:('../../doc/online/english/programming/viewintro.html' 
                                        asFilename readStream).
    v document:document.

                                                                        [exEnd]
"
! !

!HTMLParser class methodsFor:'initialization'!

initialize
    "/ self initializeAmpersandEscapes.         - now done lazily
    "/ self initializeMathAmpersandEscapes.     - now done lazily 

    "/ save space by reusing common strings (empty lines and single spaces)
    CR := Character cr asString.
    CRCR := CR , CR.
    CRCRCR := CRCR , CR.
    SPACE := Character space asString.

    "
     AmpersandEscapes := nil.
     HTMLParser initialize

     MathAmpersandEscapes := nil.
     HTMLParser initialize
    "

    "Modified: / 19-08-1996 / 15:54:47 / stefan"
    "Modified: / 24-02-1997 / 11:29:48 / cg"
    "Modified: / 06-05-2015 / 17:34:11 / sr"
!

initializeAmpersandEscapes
    "/ TODO:
    "/ fill in all names from http://www.unicode.org/Public/MAPPINGS/VENDORS/MISC/SGML.TXT

    AmpersandEscapes isNil ifTrue:[
        AmpersandEscapes := IdentityDictionary new.

        #(
            #nbsp  160          "/ non-breakable space

            #emspace 160        "/ temporary
            #enspace 160

            #lt    $<
            #gt    $>
            #amp   $&
            #quot  $"

            #copy  169          "/ copyright
            #reg   174          "/ registered

            #cent   162         
            #pound  163
            #yen    165
            #brvbar $|
            #sect   167
            #laquo  171
            #raquo  187
            #plusmn 177
            #micro  181
            #middot 183
            #frac14 188
            #frac12 189
            #frac34 190
            #iquest 191
            #iexcl  16rA1
            #div    247
            #divide 247
            #not    16rAC
            #shy    16rAD
            #para   16rB6

            #deg   16rB0 "/ 176
            #sup1  185
            #sup2  178
            #sup3  179

            #ordm   16rBA
            #ordf   16rAA
            #macr   16rAF

            #cedil  16rB8
            #uml    16rA8
            #acute  16rB4
            #curren 16rA4

            #Oslash 216
            #oslash 248
            #aring  229                         
            #Aring  197

            #ccedil 231
            #Ccedil 199

            #thorn  16rFE
            #THORN  16rDE
            #Thorn  15rDE

            #eth  16rF0
            #ETH  16rD0
            #Eth  16rD0

            #atilde 227
            #Atilde 195
            #ntilde 241
            #Ntilde 209
            #otilde 245
            #Otilde 213

            #auml  228
            #Auml  196
            #uuml  252
            #Uuml  220
            #ouml  246   
            #Ouml  214    
            #euml  235   
            #Euml  203    
            #iuml  239   
            #Iuml  207    
            #yuml  255    

            #acirc  226             
            #Acirc  194
            #icirc  238      
            #Icirc  206
            #ecirc  234
            #Ecirc  202
            #ucirc  251
            #Ucirc  219
            #ocirc  244
            #Ocirc  212

            #agrave 224        
            #Agrave 192
            #egrave 232
            #Egrave 200
            #igrave 236
            #Igrave 204
            #ograve 242
            #Ograve 210
            #ugrave 249
            #Ugrave 217

            #aacute 225
            #Aacute 193
            #eacute 233
            #Eacute 201
            #iacute 237
            #Iacute 205
            #oacute 243
            #Oacute 211
            #uacute 250
            #Uacute 218
            #yacute 16rFD
            #Yacute 16rDD

            #szlig  223
            #aelig  230
            #AElig  198

            "/ unicode

            #OElig   16r0152         "/ 8859-2 (latin2)
            #oelig   16r0153         "/ 8859-2 (latin2)

            #ljlig   16r01C9         "/ 8859-2 (latin2)
            #LJlig   16r01C7         "/ 8859-2 (latin2)
            #Ljlig   16r01C8         "/ 8859-2 (latin2)
            
            #Scaron  16r0160         "/ 8859-2 (latin2)
            #scaron  16r0161         "/ 8859-2 (latin2)
            #Yuml    16r0178         "/ 8859-2 (latin2)

            #lsquo   16r2018         "/ left single quot. mark
            #rsquo   16r2019         "/ right single quot. mark
            #sbquo   16r201A         "/ single low-9 quot. mark
            #ldquo   16r201C         "/ left double quot. mark
            #rdquo   16r201D         "/ right double quot. mark
            #bdquo   16r201E         "/ double low-9 quot. mark
            #dagger  16r2020         
            #Dagger  16r2021         "/ double dagger

            #euro    16r20AC         "/ 8859-16

            #Alpha    16r0391    "/ greek alpha
            #Beta     16r0392    
            #Gamma    16r0393   
            #Delta    16r0394   
            #Epsilon  16r0395    
            #Zeta     16r0396      
            #Eta      16r0397      
            #Theta    16r0398      
            #Iota     16r0399      
            #Kappa    16r039A      
            #Lambda   16r039B      
            #Mu       16r039C      
            #Nu       16r039D      
            #Xi       16r039E      
            #Omicron  16r039F      
            #Pi       16r03A0      
            #Rho      16r03A1      
            #Sigma    16r03A3      
            #Tau      16r03A4      
            #Upsilon  16r03A5      
            #Phi      16r03A6      
            #Chi      16r03A7      
            #Psi      16r03A8      
            #Omega    16r03A9      

            #alpha    16r03B1    "/ greek alpha
            #beta     16r03B2    
            #gamma    16r03B3   
            #delta    16r03B4   
            #epsilon  16r03B5    
            #zeta     16r03B6      
            #eta      16r03B7      
            #theta    16r03B8      
            #iota     16r03B9      
            #kappa    16r03BA      
            #lambda   16r03BB      
            #mu       16r03BC      
            #nu       16r03BD      
            #xi       16r03BE      
            #omicron  16r03BF      
            #pi       16r03C0      
            #rho      16r03C1      
            #sigmaf   16r03C2      
            #sigma    16r03C3      
            #tau      16r03C4      
            #upsilon  16r03C5      
            #phi      16r03C6      
            #chi      16r03C7      
            #psi      16r03C8      
            #omega    16r03C9      
            #thetasym 16r03D1        
            #upsih    16r03D2      
            #piv      16r03D6      

            #bull     16r2022      
            #hellip   16r2026      
            #prime    16r2032      
            #Prime    16r2033      
            #oline    16r203E      
            #frasl    16r2044      
            #weierp   16r2118      
            #image    16r2111     
            #real     16r211C      
            #trade    16r2122      
            #angst    16r212B      
            #alefsym  16r2135      
            #larr     16r2190      
            #uarr     16r2191      
            #rarr     16r2192      
            #darr     16r2193      
            #harr     16r2194      
            #crarr    16r21B5      
            #lArr     16r21D0      
            #uArr     16r21D1      
            #rArr     16r21D2      
            #dArr     16r21D3      
            #hArr     16r21D4      
            #forall   16r2200      
            #part     16r2202      
            #exist    16r2203      
            #empty    16r2205      
            #nabla    16r2207      
            #isin     16r2208      
            #notin    16r2209      
            #ni       16r220B      
            #prod     16r220F      
            #sum      16r2211      
            #minus    16r2212      
            #lowast   16r2217      
            #radic    16r221A      
            #prop     16r221D      
            #infin    16r221E      
            #ang90    16r221F      
            #ang      16r2220      
            #angmsd   16r2221      
            #angsph   16r2222      
            #and      16r2227      
            #or       16r2228      
            #cap      16r2229      
            #cup      16r222A      
            #int      16r222B      
            #there4   16r2234      
            #sim      16r223C      
            #cong     16r2245      
            #asymp    16r2248      
            #ne       16r2260      
"/            #neq   16r2260
            #equiv    16r2261      
            #le       16r2264     
            #ge       16r2265     
            #sub      16r2282     
            #sup      16r2283     
            #nsub     16r2284     
            #sube     16r2286     
            #supe     16r2287     
            #oplus    16r2295     
            #otimes   16r2297     
            #perp     16r22A5     
            #sdot     16r22C5     
            #lceil    16r2308     
            #rceil    16r2309    
            #lfloor   16r230A   
            #rfloor   16r230B     
            #lang     16r2329     
            #rang     16r232A     
            #loz      16r25CA     
            #spades   16r2660    
            #clubs    16r2663     
            #hearts   16r2665    
            #diams    16r2666     

        ) pairWiseDo:[:key :val |
            |v|

            v := val.
            val isInteger ifTrue:[
                v := Character value:v
            ].
            AmpersandEscapes at:key put:v
        ].
    ].

    "
     AmpersandEscapes := nil.
     HTMLParser initializeAmpersandEscapes
    "

    "Created: 24.2.1997 / 11:28:55 / cg"
!

initializeMathAmpersandEscapes
    "these are obsolete now, as HTML4 added the missing stuff in the meantime."

    MathAmpersandEscapes isNil ifTrue:[
        MathAmpersandEscapes := IdentityDictionary new.

        #(
"/            #alpha    16r61      "/ greek alpha
"/            #beta     16r62      "/ greek beta
"/            #chi      16r63      
"/            #delta    16r64     
"/            #epsilon  16r65      "/ symbol characterSet has no epsilon
            #vepsilon 16r65        
"/            #phi      16r66      
"/            #gamma    16r67     
"/            #eta      16r68      
"/            #iota     16r69      
            #varphi   16r6A      
"/            #kappa    16r6B      
"/            #lambda   16r6C      
"/            #mu       16r6D      
"/            #nu       16r6E      
"/            #omicron  16r6F      
"/            #pi       16r70      
"/            #theta    16r71      
            #vtheta   16r71      "/ symbol characterSet has no vtheta  
"/            #rho      16r72      
            #varrho   16r72      "/ symbol characterSet has no varrho  
"/            #sigma    16r73      
            #vsigma   16r56
"/            #tau      16r74      
"/            #upsilon  16r75      
            #varpi    16r76     
"/            #omega    16r77      
"/            #xi       16r78      
"/            #psi      16r79      
"/            #zeta     16r7A      



"/            #Alpha    16r41      "/ greek alpha
"/            #Beta     16r42      "/ greek beta
"/            #Chi      16r43      
"/            #Delta    16r44     
"/            #Epsilon  16r45     
"/            #Phi      16r46      
"/            #Gamma    16r47      
"/            #Eta      16r48      
"/            #Iota     16r49      
"/
"/            #Kappa    16r4B      
"/            #Lambda   16r4C      
"/            #Mu       16r4D      
"/            #Nu       16r4E      
"/            #Omicron  16r4F      
"/            #Pi       16r50      
"/            #Theta    16r51      
"/            #Rho      16r52      
"/            #Sigma    16r53      
"/            #Tau      16r54      
"/            #Upsilon  16rA1      

"/            #Omega    16r57    
"/            #Xi       16r58      
"/            #Psi      16r59      
"/            #Zeta     16r5A      


"/            #forall   16r22
            #exists   16r24
            #aleph    16rC0      "/ no, this is not alf ;-)
            #Re       16rC2      "/ R fraktur
            #Im       16rC1      "/ I fraktur
            #infty    16rA5      

            #leq      16rA3      "/ less-equal
            #geq      16rB3      "/ greater-equal
            #equiv    16rBA      "/ equivalent
            #approx   16rBB      
            #cong     16r40      
"/            #neq      16rB9      

"/            #plusmn   16rB1     
            #times    16rB4   
"/            #div      16rB8    
            #oplus    16rC5   
            #otimes   16rC4   
            #oslash   16rC5   

            #sum      16rE5   
            #prod     16rD5   
        
            #uparrow         16rAD   
            #leftarrow       16rAC   
            #downarrow       16rAF   
            #rightarrow      16rAE   
            #leftrightarrow  16rAB   
            #Uparrow         16rDD   
            #Leftarrow       16rDC   
            #Downarrow       16rDF   
            #Rightarrow      16rDE   
            #Leftrightarrow  16rDB   

            #supset          16rC9  
            #supseteq        16rCA 
            #subset          16rCC   
            #subseteq        16rCD   

            #vee             16rDA   
            #wedge           16rD9   
            #neg             16rD8   

            #ldots           16rBC   

"/            #lfloor          16rEB
"/            #rfloor          16rFB
"/            #lceil           16rE9
"/            #rceil           16rF9

        ) pairWiseDo:[:key :val |
            |v|

            v := val.
            val isInteger ifTrue:[
                v := Character value:v
            ].
            MathAmpersandEscapes at:key put:v
        ].
    ].

    "
     MathAmpersandEscapes := nil.
     HTMLParser initializeMathAmpersandEscapes
    "

    "Modified: 19.8.1996 / 15:54:47 / stefan"
    "Modified: 17.10.1996 / 10:17:59 / cg"
    "Created: 24.2.1997 / 11:29:23 / cg"
! !

!HTMLParser class methodsFor:'accessing'!

ampersandEscapes
    AmpersandEscapes isNil ifTrue:[
        self initializeAmpersandEscapes.
    ].
    ^ AmpersandEscapes

    "Created: / 06-05-2015 / 17:27:43 / sr"
!

mathAmpersandEscapes
    MathAmpersandEscapes isNil ifTrue:[
        self initializeMathAmpersandEscapes.
    ].
    ^ MathAmpersandEscapes

    "Created: / 06-05-2015 / 17:33:29 / sr"
! !

!HTMLParser class methodsFor:'parsing'!

parseText:aStringOrStream
    "parse aStringOrStream.and answer the parsed document"

    ^ self new parseText:(aStringOrStream readStream).

    "
     self parseText:'hello world - this is easy'  
     self parseText:'hello &lt; world > - this is easy'  
     self parseText:'hello <b>world</b> this is easy'  
     self parseText:'hello<br>world<p> this is easy'    
     self parseText:'hello<ul><li>world<li>foo</ul><p> this is easy'    
     self parseText:'<form><input></form><p> this is easy'    

     self
        parseText:('../../doc/online/english/TOP.html' 
                        asFilename contentsOfEntireFile asString)

     self
        parseText:('../../doc/online/english/TOP.html' 
                        asFilename readStream)

     self
        parseText:('../../doc/online/english/TOP.html' 
                        asFilename contentsOfEntireFile asString)
    "
!

parseText:aStringOrStream characterEncoding:anEncodingString
    "parse aStringOrStream. The encoding of the character set is specified by anEncodingString 
     (e.g. #utf8 or 'iso8859-1').

     Answer the parsed document"

    |p|

    p := self new.
    p characterEncoding:anEncodingString.
    ^ p parseText:(aStringOrStream readStream).

    "
     self
        parseText:('../../doc/online/english/TOP.html' 
                        asFilename contentsOfEntireFile asString) characterEncoding:#utf8
    "
! !

!HTMLParser methodsFor:'accessing'!

characterEncoding:aString
    "set the character set / encoding for the following text"

    |charset|

    charset := aString asSymbol.
    destination notNil ifTrue:[
        destination documentEncoding:charset.
    ].

    characterDecoder := CharacterEncoder encoderFor:charset ifAbsent:nil.
    characterDecoder isNil ifTrue:[
        self infoMessage:('No decoder available for ''' , charset, '''').
    ].

    "Modified (comment): / 05-03-2018 / 15:28:58 / stefan"
! !

!HTMLParser methodsFor:'error reporting'!

infoMessage:msg
    |fileInfo|

    fileInfo := (inStream isFileStream) 
                    ifTrue:[ ' in ''' , inStream pathName , '''' ]
                    ifFalse:''.

    ('HTMLParser [info]: %1 [at or near line %2%3]' 
        bindWith:msg 
        with:lineNr
        with:fileInfo
    ) infoPrintCR.

    destination notNil ifTrue:[
        destination infoDisplay:msg
    ]
! !

!HTMLParser methodsFor:'scanning'!

ampersandEscape
    |ampersandEscapeString|

    "parse an ampersand escape; the '&' has already been read."

    ampersandEscapeString := self ampersandEscapeString.
    textScannedSoFar nextPutAll:ampersandEscapeString.

    ^ ampersandEscapeString

    "
     (HTMLParser new) parseText:'hello &lt; world > - this is easy'  
     (HTMLParser new) parseText:'hello &lt world > - this is easy'  
     (HTMLParser new) parseText:'hello &foo world > - this is easy'  
     (HTMLParser new) parseText:'hello & foo world > - this is easy'  
    "

    "Modified: 6.8.1997 / 13:52:47 / cg"
!

ampersandEscape:aString
    "return a new string, containing the ampersand escape character.
     Expects aString to NOT contain the initial ampersand."

    |key val m1 m2 m3|

    aString size > 1 ifTrue:[
        (aString at:1) == $# ifTrue:[
            ((aString at:2) sameAs: $x) ifTrue:[
                ^ Character value:(Integer readFrom:(aString copyFrom:3) radix:16 onError:($? codePoint))
            ].
            ^ Character value:(Integer readFrom:(aString copyFrom:2) onError:($? codePoint))
        ].
    ].
    key := aString asSymbolIfInterned.
    key notNil ifTrue:[
        val := self class ampersandEscapes at:key ifAbsent:nil.
    ].

    val isNil ifTrue:[
        bindings notNil ifTrue:[
            val := bindings at:key ifAbsent:nil.
        ]
    ].
    val notNil ifTrue:[
        ^ val
    ].

    val := self class mathAmpersandEscapes at:key ifAbsent:nil.
    val notNil ifTrue:[
        self finishTextBlock.

        m1 := HTMLMarkup type:#internalMathFont.

        m2 := HTMLMarkupText new.
        m2 text:(val asString).
        m1 next:m2.

        m3 := HTMLMarkup type:#'/internalMathFont'.
        m2 next:m3.

        lastMarkup isNil ifTrue:[
            markupAnchor := m1
        ] ifFalse:[
            lastMarkup next:m1.
        ].
        lastMarkup := m3.

        outStream notNil ifTrue:[
            outStream nextPut:m1; nextPut:m2; nextPut:m3
        ].

        textScannedSoFar isNil ifTrue:[
            self startNewTextBlock.
        ].
        ^ nil
    ].
    self infoMessage:('Unknown character escape: ''' , aString , '''').
    ^ #unknown

    "
     (HTMLParser new) ampersandEscape:'lt'   
     (HTMLParser new) ampersandEscape:'ouml'  
     (HTMLParser new) ampersandEscape:'#32'  

     (HTMLParser new) parseText:'hello &alpha; &beta; &gamma; normal'    
     (HTMLParser new) parseText:'hello<table >world<p> this is easy'    
    "

    "Created: / 16-05-1996 / 14:27:45 / cg"
    "Modified: / 19-08-1996 / 15:49:02 / stefan"
    "Modified: / 23-04-2012 / 21:49:41 / cg"
    "Modified: / 06-05-2015 / 17:33:07 / sr"
!

ampersandEscapeString
    "parse an ampersand escape; the '&' has already been read.
     Return the escape string."

    |next t ch|

    inStream atEnd ifTrue:[
        ^ '&'.
    ].

    (next := inStream peek) isLetter ifFalse:[
        next ~~ $# ifTrue:[
            ^ '&'.
        ]
    ].

    t := ''.

    next == $# ifTrue:[
        t := t copyWith:next.
        inStream next
    ].

    [inStream atEnd not
     and:[ (ch := inStream peek) isSeparator not
     and:[ ch isLetterOrDigit or:[ch == $_ or:[ch == $- or:[ch == $.]]]
    ]]] whileTrue:[
        t := t copyWith:ch.
        inStream next.
    ].

    (inStream atEnd not 
    and:[inStream peek == $;]) ifTrue:[
        inStream next
    ] ifFalse:[
        self infoMessage:('Unterminated &-escape: ', t).
        ^ '&' , t
    ].

    ch := self ampersandEscape:t.
    ch == #unknown ifTrue:[
        ^ '&' , t
    ].
    ch notNil ifTrue:[
        (ch isCharacter and:[ch codePoint > 16rFF]) ifTrue:[
            self finishTextBlock.
            textScannedSoFar := (Unicode16String new:10) writeStream.
        ].
        ^ ch asString.
    ].
    ^ ''

    "Modified: / 23-03-2017 / 12:22:54 / cg"
!

extractMetaInformationFrom:element
    |metaCommand metaArg idx charset|

    metaCommand := element parameterFor:#'HTTP-EQUIV'.
    metaCommand notNil ifTrue:[
        (metaCommand := metaCommand asLowercase) = 'content-type' ifTrue:[
            metaArg := element parameterFor:#'CONTENT'.
            metaArg notNil ifTrue:[
                metaArg := metaArg asLowercase.

                "/ <mime-type> ; charset=
                idx := metaArg findString:'charset='.
                idx ~~ 0 ifTrue:[
                    charset := metaArg copyFrom:(idx + 8).
                    idx := charset indexOf:Character space.
                    idx ~~ 0 ifTrue:[
                        charset := charset copyTo:idx-1
                    ].
                    destination notNil ifTrue:[
                        self characterEncoding:charset.
                    ].
                ].
            ]
        ].
    ].

    "Created: 30.6.1997 / 13:57:36 / cg"
    "Modified: 1.7.1997 / 00:38:04 / cg"
!

finishTextBlock
    "finish a scanned textBlock; add it to the markup list"

    self finishTextBlockWithDecode:true
!

finishTextBlockWithDecode:doDecode
    "finish a scanned textBlock; add it to the markup list"

    |m textString|

    textScannedSoFar notNil ifTrue:[
        textString := textScannedSoFar contents.
        textString notEmpty ifTrue:[
            (doDecode and:[characterDecoder notNil]) ifTrue:[
                textString := characterDecoder decodeString:textString.
            ].

            "/ share those (by identity) - they are very common.
            "/ saves us thousands of equal strings in larger documents.
            textString = SPACE ifTrue:[ textString := SPACE ]
            ifFalse:[ textString = CR ifTrue:[ textString := CR ]
            ifFalse:[textString = CRCR ifTrue:[ textString := CRCR ]
            ifFalse:[textString = CRCRCR ifTrue:[ textString := CRCRCR ]]]].

"/            (textString size == 1 and:[(textString at:1) == Character cr]) ifTrue:[
"/                m := HTMLCRMarkupText new.
"/            ] ifFalse:[
                m := HTMLMarkupText text:textString.
"/            ].

            lastMarkup isNil ifTrue:[
                lastMarkup := markupAnchor := m
            ] ifFalse:[
                lastMarkup next:m.
                lastMarkup := m
            ].
            outStream notNil ifTrue:[
                outStream nextPut:m
            ].
        ].
    ].

    textScannedSoFar := nil

    "Modified: / 01-07-1997 / 00:38:20 / cg"
    "Modified: / 08-08-2018 / 16:49:16 / Claus Gittinger"
!

parseMarkup
    "parse '<' and return a markup element"

    |startPos in markText m next more piece scriptText pos|

    in := inStream.
    startPos := in position-1.
    
    next := in peek.
    next isLetter ifFalse:[
        next == $/ ifFalse:[
            next == $!! ifTrue:[
                "/ comment
                self finishTextBlock.
                in next.
                in peekOrNil == $- ifTrue:[
                    pos := in position.
                    (in skipThroughAll:'-->') isNil ifTrue:[
                        in position:pos.
                        (in skipThroughAll:'>') isNil ifTrue:[
                            self infoMessage:'Unclosed comment'.
                        ] ifFalse:[
                            self infoMessage:'OldStyle comment'.
                        ]
                    ].
                ] ifFalse:[
                    (in skipThroughAll:'>') isNil ifTrue:[
                        self infoMessage:'Unclosed comment'
                    ].
                ].
                ^ self.
            ].
            next == $? ifTrue:[
                "/ processing instruction
                in next.
                pos := in position.
                (in skipThroughAll:'?>') isNil ifTrue:[
                    in position:pos.
                    self infoMessage:'Unclosed processing instruction'.
                ].
                ^ self.
            ].
            self infoMessage:('''<'' not followed by letter, ''/'' or ''!!'' - interpret as text').
            lastMarkup notNil ifTrue:[
                self infoMessage:('after: "',(lastMarkup printString),'"').
            ].    
            textScannedSoFar nextPut:$<.
            ^ self.
        ]
    ].

    self finishTextBlock.

    markText := ''.
    more := true.

    [more] whileTrue:[
        "/
        "/ handle \> escape within markUp; allows
        "/ > to occur within string-parameters.
        "/
        "/ piece := in throughAny:'>&' "#( $> $& )".
        piece := in through:$>.
        (piece size > 0) ifTrue:[
            piece last == $> ifTrue:[
                more := (piece size > 1) and:[piece endsWith:'\>'].
                more ifTrue:[
                    piece := (piece copyButLast:2) , '>'
                ] ifFalse:[
                    piece := (piece copyButLast:1)
                ]
            ] ifFalse:[
                 "/ piece := (piece copyButLast:1) , self ampersandEscapeString
            ].
            markText := markText , piece.
            lineNr := lineNr + (piece occurrencesOf:Character cr).
        ] ifFalse:[
            more := false
        ]
    ].
    m := HTMLMarkup for:markText.
    m sourcePosition:startPos.
    
    "/ special kludge for <script>
    "/ read everything up-to the </script>.
    "/ do not expand ampersand escapes; ignore other markup.

    m type == #script ifTrue:[
        scriptText := ''.
        more := true.
        [more] whileTrue:[
            scriptText := scriptText , (in upTo:$>).
            in atEnd ifTrue:[
                more := false
            ] ifFalse:[
                scriptText := scriptText , '>'.
                in atEnd ifTrue:[
                    more := false
                ]
            ].
            scriptText size > 8 ifTrue:[
                (scriptText endsWith:'>') ifTrue:[
                    (scriptText copyLast:9) asLowercase = '</script>' ifTrue:[
                        more := false
                    ]
                ]
            ].
        ].
        lineNr := lineNr + (scriptText occurrencesOf:Character cr).
        scriptText size >= 9 ifTrue:[
            (scriptText copyLast:9) asLowercase = '</script>' ifTrue:[ 
                m scriptText:(scriptText copyButLast:9).
            ].
        ].
        self script:m.
    ].

    lastMarkup isNil ifTrue:[
        lastMarkup := markupAnchor := m
    ] ifFalse:[
        lastMarkup next:m.
        lastMarkup := m
    ].

    "/
    "/ special kludge for <pre> ...
    "/ skip followup CR if there is one
    "/
    m type == #pre ifTrue:[
        in peekOrNil == Character cr ifTrue:[
            lineNr := lineNr + 1.
            in next
        ]
    ].

    "/
    "/ special kludge for <meta> ...
    "/ must extract encoding here (if possible)
    "/
    m type == #meta ifTrue:[
        self extractMetaInformationFrom:m.
    ].
    textScannedSoFar := nil

    "
     (HTMLParser new) parseText:'<font size=+2>world</font>'  
     (HTMLParser new) parseText:'hello <b>world</b> this is easy'  
     (HTMLParser new) parseText:'hello<br>world<p> this is easy'    
     (HTMLParser new) parseText:'hello< br>world<p> this is easy'    
    "

    "Modified: / 23-06-2017 / 08:58:33 / cg"
    "Modified: / 16-07-2018 / 19:48:03 / Claus Gittinger"
!

parseText:aStringOrStream
    "parse some string, return a list of markups"

    |in c numLinesInTextElement "{ Class: SmallInteger }"
     document ampersandEscapeString|

    lineNr := 1.
    numLinesInTextElement := 0.
    in := inStream := aStringOrStream readStream.
    markupAnchor := lastMarkup := nil.

    self startNewTextBlock.

    [(c := in next) notNil ] whileTrue:[
        c == $< ifTrue:[
            self parseMarkup.
            textScannedSoFar isNil ifTrue:[
                self startNewTextBlock.
                numLinesInTextElement := 0.
            ]
        ] ifFalse:[
            c == $& ifTrue:[
                textScannedSoFar isNil ifTrue:[
                    self startNewTextBlock.
                    numLinesInTextElement := 0.
                ].

                ampersandEscapeString := self ampersandEscape.
                (ampersandEscapeString size = 1
                and:[ampersandEscapeString first isControlCharacter not 
                     "/ 'öäüÖÄÜß' includes:ampersandEscapeString first
                ]) ifFalse:[
                    "suppress new text block, when escaping non-control characters
                     because a space is added between text blocks in HTMLUtilities #plainTextOfHTML
                     starting a new text block would cut words like 'Gebäude' 'Österreich' etc." 
                    self finishTextBlockWithDecode:false.
                    self startNewTextBlock.
                    numLinesInTextElement := 0.
                ].
            ] ifFalse:[
                c == Character return ifTrue:[
                    in peekOrNil == Character cr ifTrue:[
                        in next.
                    ].
                    c := Character cr.
                ].
                c == Character cr ifTrue:[
                    lineNr := lineNr + 1.
                    numLinesInTextElement := numLinesInTextElement + 1.
                    "/ break into two textElements after every 50 lines.
                    numLinesInTextElement > 50 ifTrue:[
                        self finishTextBlock.
                        self startNewTextBlock.
                        numLinesInTextElement := 0.
                    ].
                ].
                textScannedSoFar isNil ifTrue:[
                    self startNewTextBlock.
                    numLinesInTextElement := 0.
                ].
                textScannedSoFar nextPut:c
            ]
        ]
    ].
    self finishTextBlock.
    document := HTMLDocument new.
    document markup:markupAnchor.
    aStringOrStream isFileStream ifTrue:[
        document fileName:(aStringOrStream pathName).
    ].
    ^ document.

    "
     (HTMLParser new) parseText:'hello world - this is easy'  
     (HTMLParser new) parseText:'hello<a>world</a> - this is easy'  
     (HTMLParser new) parseText:'hello &lt; world > - this is easy'  
     (HTMLParser new) parseText:'hello <b>world</b> this is easy'  
     (HTMLParser new) parseText:'hello<br>world<p> this is easy'    
     (HTMLParser new) parseText:'hello<ul><li>world<li>foo</ul><p> this is easy'    
     (HTMLParser new) parseText:'<form><input></form><p> this is easy'    

     (HTMLParser new) 
        parseText:('../../doc/online/english/TOP.html' 
                        asFilename contentsOfEntireFile asString)

     (HTMLParser new) 
        parseText:('../../doc/online/english/TOP.html' 
                        asFilename readStream)

     (HTMLParser new) 
        parseText:('../../doc/online/english/programming/viewintro.html' 
                        asFilename contentsOfEntireFile asString)
    "

    "Created: / 19-07-1996 / 12:03:28 / cg"
    "Modified: / 05-08-1996 / 18:28:58 / stefan"
    "Modified: / 14-04-1998 / 18:52:15 / cg"
    "Modified (comment): / 29-06-2018 / 10:47:15 / Claus Gittinger"
!

parseText:aStringOrStream withBindings:metaBindings
    "parse some string, return a list of HTMLMarkups.
     Ampersand variables (i.e. &url) are expanded as given in the
     metabindings dictionary. 
     (this seems to be non-standard HTML, but is used in hotjava).
     The destination is only required for scripts, which may want to access
     document very early."

    bindings := metaBindings.
    ^ self parseText:aStringOrStream.

    "
     (HTMLParser new) parseText:'hello world - this is easy'  
     (HTMLParser new) parseText:'hello &lt; world > - this is easy'  
     (HTMLParser new) parseText:'hello <b>world</b> this is easy'  
     (HTMLParser new) parseText:'hello<br>world<p> this is easy'    
     (HTMLParser new) parseText:'hello<ul><li>world<li>foo</ul><p> this is easy'    
     (HTMLParser new) parseText:'<form><input></form><p> this is easy'    

     (HTMLParser new) 
        parseText:('../../doc/online/english/TOP.html' 
                        asFilename contentsOfEntireFile asString)
     (HTMLParser new) 
        parseText:('../../doc/online/english/programming/viewintro.html' 
                        asFilename contentsOfEntireFile asString)
    "

    "Modified: 5.1.1997 / 02:36:30 / cg"
    "Created: 21.1.1997 / 19:11:50 / cg"
!

parseText:aStringOrStream withBindings:metaBindings for:aDestination
    "parse some string, return a list of HTMLMarkups.
     Ampersand variables (i.e. &url) are expanded as given in the
     metabindings dictionary. 
     (this seems to be non-standard HTML, but is used in hotjava).
     The destination is only required for scripts, which may want to access
     document very early."

    |charset|

    bindings := metaBindings.
    destination := aDestination.
    charset := destination documentEncoding asLowercase asSymbol.
    characterDecoder := CharacterEncoder encoderFor:charset ifAbsent:nil.
    characterDecoder isNil ifTrue:[
        self infoMessage:('No decoder available for ''' , charset, '''').
    ].
    ^ DecodingError ignoreIn:[
        self parseText:aStringOrStream.
    ].

    "
     (HTMLParser new) parseText:'hello world - this is easy'  
     (HTMLParser new) parseText:'hello &lt; world > - this is easy'  
     (HTMLParser new) parseText:'hello <b>world</b> this is easy'  
     (HTMLParser new) parseText:'hello<br>world<p> this is easy'    
     (HTMLParser new) parseText:'hello<ul><li>world<li>foo</ul><p> this is easy'    
     (HTMLParser new) parseText:'<form><input></form><p> this is easy'    

     (HTMLParser new) 
        parseText:('../../doc/online/english/TOP.html' 
                        asFilename contentsOfEntireFile asString)
     (HTMLParser new) 
        parseText:('../../doc/online/english/programming/viewintro.html' 
                        asFilename contentsOfEntireFile asString)
    "

    "Created: / 10-07-1996 / 15:27:07 / cg"
    "Modified: / 30-06-1997 / 12:58:33 / cg"
    "Modified: / 05-03-2018 / 14:48:01 / stefan"
!

startNewTextBlock
    textScannedSoFar := (String uninitializedNew:50) writeStream.
! !

!HTMLParser methodsFor:'scripts'!

parseJavaScriptFrom:scriptStream
    |privateVariables scriptObject|

    Class withoutUpdatingChangesDo:[
        privateVariables := ''.

        Error handle:[:ex |
            destination catchErrors ifFalse:[
                ex reject
            ].
            self warn:'Script error: ' , ex description.
            ^ nil
        ] do:[
            scriptObject := "HTML" JavaScriptEnvironment new.
            scriptObject _setupForWindow:destination.
            scriptObject _beHTMLEnvironment.

            JavaScriptParser evaluateDeclarationsFrom:scriptStream for:scriptObject.
        ].
    ].
    ^ scriptObject

    "Created: / 16.5.1998 / 23:40:41 / cg"
    "Modified: / 17.5.1998 / 21:17:31 / cg"
!

parseSmalltalkScriptFrom:scriptStream
    |eClass sawExcla chunk chunkType 
     rslt reader privateVariables scriptObject|

    Class withoutUpdatingChangesDo:[
        privateVariables := ''.

        HTMLScriptEnvironment autoload.

        Error handle:[:ex |
            destination catchErrors ifFalse:[
                ex reject
            ].
            self warn:'Script error: ' , ex description.
            ^ nil
        ] do:[
            [scriptStream atEnd] whileFalse:[
                "/
                "/ get a chunk
                "/

                scriptStream skipSeparators.
                scriptStream atEnd ifFalse:[
                    sawExcla := scriptStream peekFor:$!!.
                    chunk := scriptStream nextChunk.
                    chunk size ~~ 0 ifTrue:[
                        sawExcla ifFalse:[
                            "/
                            "/ immediate evaluation chunk
                            "/
                            scriptObject isNil ifTrue:[
                                eClass notNil ifTrue:[
                                    scriptObject := eClass new.
                                    scriptObject _setupForWindow:destination.
                                ]
                            ].

                            rslt := Compiler
                                        evaluate:chunk 
                                        in:nil 
                                        receiver:scriptObject 
                                        notifying:nil
                                        logged:false
                                        ifFail:nil 
                                        compile:true
                        ] ifTrue:[
                            "/
                            "/ a definition chunk
                            "/
                            chunkType := chunk withoutSeparators asLowercase.

                            (chunkType = 'methods') ifTrue:[
                                "/
                                "/ a methods-definition chunk
                                "/
                                eClass isNil ifTrue:[
                                    "/
                                    "/ create an anonymous class ...
                                    "/
                                    eClass := HTMLScriptEnvironment class
                                        name:#Script
                                        inEnvironment:nil
                                        subclassOf:HTMLScriptEnvironment
                                        instanceVariableNames:privateVariables
                                        variable:false
                                        words:true
                                        pointers:true
                                        classVariableNames:''
                                        poolDictionaries:''
                                        category:''
                                        comment:nil
                                        changed:true.

                                    "/
                                    "/ and an instance of it ...
                                    "/
                                    scriptObject := eClass new.
                                    scriptObject _setupForWindow:destination.
                                ].

                                "/
                                "/ read methods for the class ...
                                "/
                                reader := ClassCategoryReader
                                                class:eClass category:'script methods'.
                                reader fileInFrom:scriptStream silent:true.
                            ].

                            (chunkType = 'variables') ifTrue:[
                                "/
                                "/ a variable-definition chunk
                                "/
                                eClass notNil ifTrue:[
                                    self error:'script: only one variable declaration allowed - must be the first chunk'
                                ].

                                privateVariables := scriptStream nextChunk withoutSeparators.
                                (privateVariables startsWith:'|') ifTrue:[
                                    (privateVariables endsWith:'|') ifTrue:[
                                        privateVariables := privateVariables copyFrom:2 to:(privateVariables size-1).
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ].
            scriptObject isNil ifTrue:[
                eClass notNil ifTrue:[
                    scriptObject := eClass new.
                    scriptObject _setupForWindow:destination.
                ]
            ].
        ].
    ].
    ^ scriptObject

    "Created: / 16.5.1998 / 23:30:32 / cg"
    "Modified: / 17.5.1998 / 19:59:30 / cg"
!

script:element
    "a <script> TAG was encountered.
     check for the language (which defaults to javaScript) and dispatch
     to a script language handler."

    |language selector|

    destination isView ifFalse:[^ self].        "/ ignored when printing

    language := element parameterFor:#'LANGUAGE'.
    language isNil ifTrue:[
        language := 'javascript'
    ].
    language := language asLowercase.

    destination scriptExecutionEnabled ifFalse:[
        self infoMessage:('Script execution disabled (' , language , ')').
        ^ self
    ].

    "/
    "/ invoke script_xxx:
    "/
    selector := ('script_' , language) asMutator.
    (self respondsTo:selector) ifTrue:[
        ^ self perform:selector with:element
    ].

    self infoMessage:('Sorry, unsupported script language: ' , language).

    "Modified: / 17.5.1998 / 20:24:51 / cg"
!

script_javascript:element
    "a <script language=javaScript> TAG was encountered.
     parse the script, and construct the scriptObject"

    |scriptStream scriptObject|

    "/
    "/ Java & JavaScript are provided as add-on package.
    "/
    JavaScriptParser isNil ifTrue:[
        self infoMessage:'Sorry, javaScript is not supported by this system'.
        ^ self.
    ].

    scriptStream := element scriptText readStream.

    Class withoutUpdatingChangesDo:[
        scriptObject := self parseJavaScriptFrom:scriptStream.
        element scriptObject:scriptObject
    ]

    "Modified: / 17.5.1998 / 20:21:06 / cg"
    "Created: / 17.5.1998 / 20:24:31 / cg"
!

script_smalltalkscript:element
    "a <script language=smalltalkScript> TAG was encountered.
     parse the script, and construct the scriptObject (which has the methods in
     its anonymous class)"

    |scriptStream scriptObject|

    scriptStream := element scriptText readStream.

    Class withoutUpdatingChangesDo:[
        scriptObject := self parseSmalltalkScriptFrom:scriptStream.
        element scriptObject:scriptObject
    ]

    "Modified: / 17.5.1998 / 20:20:43 / cg"
    "Created: / 17.5.1998 / 20:24:37 / cg"
! !

!HTMLParser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libhtml/HTMLParser.st,v 1.88 2018-08-08 15:57:32 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libhtml/HTMLParser.st,v 1.88 2018-08-08 15:57:32 cg Exp $'
! !


HTMLParser initialize!
