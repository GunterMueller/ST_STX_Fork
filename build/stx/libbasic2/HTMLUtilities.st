"
 COPYRIGHT (c) 2007 by eXept Software AG
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

Object subclass:#HTMLUtilities
	instanceVariableNames:''
	classVariableNames:'EscapeControlCharacters'
	poolDictionaries:''
	category:'Net-Communication-Support'
!

!HTMLUtilities class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2007 by eXept Software AG
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
    Collected support functions to deal with HTML.
    Used both by HTML generators (DocGenerator), HTMLParsers and the webServer.
    Therefore, it has been put into libbasic2.
"
! !

!HTMLUtilities class methodsFor:'common actions'!

openLauncherOnDisplay:displayName
    <resource: #obsolete>

    "obsolete - do not use"

    self obsoleteMethodWarning.
    Error handle:[:ex |
        ^ ex description
    ] do:[
        NewLauncher openLauncherOnInitializedDisplayNamed:displayName
    ]

    "Modified: / 01-06-2010 / 11:25:12 / sr"
! !

!HTMLUtilities class methodsFor:'helpers'!

characterFromHtmlEntityNamed:anHtmlEntityName
    anHtmlEntityName = 'lt'     ifTrue:[^ $<].
    anHtmlEntityName = 'gt'     ifTrue:[^ $>].
    anHtmlEntityName = 'amp'    ifTrue:[^ $&].
    anHtmlEntityName = 'apos'   ifTrue:[^ $'].
    anHtmlEntityName = 'quot'   ifTrue:[^ $"].

    self halt. "/ where to get the mapping???

    ^ $~

    "Created: / 07-05-2015 / 15:23:40 / sr"
    "Modified: / 18-05-2015 / 12:15:36 / sr"
!

controlCharacters

    EscapeControlCharacters isNil ifTrue:[
        EscapeControlCharacters := Dictionary new.
        EscapeControlCharacters at:$< put:'&lt;'.
        EscapeControlCharacters at:$> put:'&gt;'.
        EscapeControlCharacters at:$& put:'&amp;'.
        EscapeControlCharacters at:$" put:'&quot;'.
        "/ EscapeControlCharacters at:$' put:'&apos;'.
    ].
    ^ EscapeControlCharacters.

    "Modified (comment): / 06-05-2015 / 16:17:31 / sr"
!

escapeCharacterEntities:aString
    "helper to escape invalid/dangerous characters in html strings.
     These are:
        control characters, '<', '>', '&' and space -> %XX ascii as hex digits
        %     -> %%
    "
    "/ TODO: this is similar to withSpecialHTMLCharactersEscaped.
    "/ we should refactor this into one method only (can we do hex escapes always ?).
    "/ Notice, that these two methods came into existance due to historic reasons
    "/ and were developed independent of each other, but later moved to this common place.


    ^self escapeCharacterEntities:aString andControlCharacters:self controlCharacters

    "
     self escapeCharacterEntities:'a<b'     
     self escapeCharacterEntities:'aöb'     
    "

    "Modified: / 06-05-2015 / 16:30:13 / sr"
!

escapeCharacterEntities:aString andControlCharacters:controlCharacters
    "helper to escape invalid/dangerous characters in html strings.
     These are:
        control characters, '<', '>', '&' and space -> %XX ascii as hex digits
        %     -> %%
    "
    "/ TODO: this is similar to withSpecialHTMLCharactersEscaped.
    "/ we should refactor this into one method only (can we do hex escapes always ?).
    "/ Notice, that these two methods came into existance due to historic reasons
    "/ and were developed independent of each other, but later moved to this common place.


    |rs ws c controlString|

    rs := ReadStream on: aString.
    ws := WriteStream on: ''.
    [ rs atEnd ] whileFalse: [
        c := rs next.
        controlString := controlCharacters notEmptyOrNil ifTrue:[controlCharacters at:c ifAbsent:nil] ifFalse:[nil].
        controlString notNil ifTrue:[
            ws nextPutAll:controlString.
        ] ifFalse:[
            c codePoint > 16r7F ifTrue:[
                ws 
                    nextPutAll:'&#';
                    nextPutAll:(c codePoint printString);
                    nextPutAll:';'.
            ] ifFalse:[
                ws nextPut:c.
            ]
        ]
    ].
    ^ ws contents
    
    "
     self escapeCharacterEntities:'a<b'     
     self escapeCharacterEntities:'aöb'     
    "

    "Created: / 06-05-2015 / 16:29:51 / sr"
!

extractCharSetEncodingFromContentType:contentTypeLine
    |idx rest encoding|

    idx := contentTypeLine findString:'charset='.
    idx == 0 ifTrue:[
	^ nil
    ].
    rest := (contentTypeLine copyFrom:idx+'charset=' size) withoutSeparators.
    idx := (rest indexOfSeparator) min:(rest indexOf:$;).
    idx == 0 ifTrue:[
	encoding := rest
    ] ifFalse:[
	encoding := rest copyTo:idx-1.
    ].
    (encoding startsWith:$") ifTrue:[
	encoding := encoding copyFrom:2 to:(encoding indexOf:$" startingAt:3)-1.
    ].
    ^ encoding.

    "
     self extractCharSetEncodingFromContentType:'text/html; charset=ascii'
     self extractCharSetEncodingFromContentType:'text/html; charset='
     self extractCharSetEncodingFromContentType:'text/html; fooBar=bla'
     self extractCharSetEncodingFromContentType:'text/xml; charset=utf-8'
     self extractCharSetEncodingFromContentType:'text/xml; charset=utf-8; bla=fasel'
    "
!

extractMimeTypeFromContentType:contentTypeLine
    |idx mimeAndEncoding|

    idx := contentTypeLine indexOf:$:.
    mimeAndEncoding := (contentTypeLine copyFrom:idx+1) withoutSeparators.

    (mimeAndEncoding includes:$;) ifFalse:[
	^ mimeAndEncoding
    ].

    idx := mimeAndEncoding indexOf:$;.
    ^ mimeAndEncoding copyTo:idx-1

    "
     self extractMimeTypeFromContentType:'text/html; charset=ascii'
     self extractMimeTypeFromContentType:'text/html; '
     self extractMimeTypeFromContentType:'text/html'
     self extractMimeTypeFromContentType:'text/xml; charset=utf-8'
    "
!

unEscape:aString
    "Convert escaped characters in an urls arguments or post fields back to their proper characters.
     Undoes the effect of urlEncode and urlEncode2.
     These are:
        + -> space
        %XX ascii as hex digits
        %uXXXX unicode as hex digits
        %% -> %
    "

    |rs ws c peekC isUnicodeEscaped|

    aString isNil ifTrue:[
        ^ nil.
    ].

    (aString includesAny:'+%') ifFalse:[        
        ^ aString
    ].

    rs := ReadStream on: aString.
    ws := CharacterWriteStream on: ''.
    isUnicodeEscaped := false.

    [rs atEnd] whileFalse:[
        c := rs next.

        isUnicodeEscaped ifTrue:[
            isUnicodeEscaped := false.
            c := (Integer readFrom:(rs nextAvailable:4) radix:16) asCharacter.
        ] ifFalse:[
            c == $+ ifTrue:[ 
                c := Character space.
            ] ifFalse:[
                c == $% ifTrue:[
                    peekC := rs peek.
                    (peekC notNil and:[peekC isHexDigit]) ifTrue:[
                        c := (Integer readFrom:(rs nextAvailable:2) radix:16) asCharacter. 
                    ] ifFalse:[
                        (peekC notNil and:[peekC == $u]) ifTrue:[
                            isUnicodeEscaped := true.
                            c := nil.
                        ] ifFalse:[
                            c := rs next.
                        ].
                    ].
                ].
            ].
        ].

        c notNil ifTrue:[ 
            ws nextPut:c.
        ].
    ].
    ^ ws contents

    "
     self unEscape:'a%20b'   
     self unEscape:'a%%b'
     self unEscape:'a+b' 
     self unEscape:'a%+b' 
     self unEscape:'a%' 
     self unEscape:'a%2' 
     self unEscape:'/Home/a%C3%A4%C3%B6%C3%BCa'
    "

    "Modified: / 09-01-2011 / 10:44:50 / cg"
    "Modified (comment): / 06-05-2015 / 15:40:04 / sr"
!

unescapeCharacterEntities:aString
    "helper to unescape character entities in a string.
     Normally, this is done by the HTMLParser when it scans text,
     but seems to be also used in post-data fields which contain non-ascii characters
     (for example: the login postdata of expeccALM).

     Sequences are:
        &<specialName>;
        &#<decimal>;            
        &#x<hex>

     From Reference:
        http://wiki.selfhtml.org/wiki/Referenz:HTML/Zeichenreferenz#HTML-eigene_Zeichen
    "

    |rs ws c 
     entity entityNumberPart
     htmlEntityMatchingFailed characterFromHtmlEntity|

    (aString includes:$&) ifFalse:[        
        ^ aString
    ].

    rs := ReadStream on:aString.
    ws := CharacterWriteStream on:''.

    [rs atEnd] whileFalse:[
        c := rs next.
        c == $& ifTrue:[
            entity := rs upToMatching:[:ch | ch == $;].
            entity notEmpty ifTrue:[
                rs peek == $; ifTrue:[ "/ something between & and ; 
                    rs next. "/ read over semicolon
                    htmlEntityMatchingFailed := false.

                    entity first == $# ifTrue:[ "/ entity is determined as number
                        entityNumberPart := entity copyFrom:2.
                        entityNumberPart notEmpty ifTrue:[
                            entityNumberPart first == $x ifTrue:[
                                entityNumberPart := entityNumberPart copyFrom:2.
                                entityNumberPart notEmpty ifTrue:[
                                    ws nextPut:(Character value:(Integer readFrom:entityNumberPart radix:16)).
                                ] ifFalse:[
                                    htmlEntityMatchingFailed := true. 
                                ].
                            ] ifFalse:[
                                entityNumberPart isNumeric ifTrue:[
                                    ws nextPut:(Character value:(Integer readFrom:entityNumberPart)).
                                ] ifFalse:[
                                    htmlEntityMatchingFailed := true. 
                                ].
                            ].
                        ] ifFalse:[
                            htmlEntityMatchingFailed := true. 
                        ].
                    ] ifFalse:[
                        characterFromHtmlEntity := self characterFromHtmlEntityNamed:entity.
                        characterFromHtmlEntity notNil ifTrue:[
                            ws nextPut:characterFromHtmlEntity.
                        ] ifFalse:[
                            htmlEntityMatchingFailed := true. 
                        ].
                    ].

                    htmlEntityMatchingFailed ifTrue:[
                        ws nextPut:c.
                        ws nextPutAll:entity.
                        ws nextPutAll:$;.
                    ].
                ] ifFalse:[
                    ws nextPut:c.
                    ws nextPutAll:entity.
                ].
            ] ifFalse:[
                ws nextPut:c.
            ].
        ] ifFalse:[
            ws nextPut:c.
        ].
    ].

    ^ ws contents

    "
     self unescapeCharacterEntities:'&;'            
     self unescapeCharacterEntities:'&16368;'            
     self unescapeCharacterEntities:'&16368;&16368'            
     self unescapeCharacterEntities:'&16368;&lt;'            
     self unescapeCharacterEntities:'&16368;&lt'            
     self unescapeCharacterEntities:'&#xaffe;'    
     self unescapeCharacterEntities:'&quot;&lt;foo'      
     self unescapeCharacterEntities:'&funny;&lt;foo'     
    "

    "Created: / 06-05-2015 / 16:56:14 / sr"
    "Modified: / 18-05-2015 / 12:13:35 / sr"
!

urlEncode2:aStringOrStream on:ws
    "helper to escape invalid/dangerous characters in an urls arguments.
     Similar to urlEncode, but treats '*','~' and spaces differently.
     (some clients, such as bitTorrent seem to require this - time will tell...)
     Any byte not in the set 0-9, a-z, A-Z, '.', '-', '_', is encoded using 
     the '%nn' format, where nn is the hexadecimal value of the byte.
        see: RFC1738"

    |rs c space|

    space := Character space.
    rs := aStringOrStream readStream.

    [rs atEnd] whileFalse: [
        c := rs next.

        (c isLetterOrDigit or:[ ('-_.' includes:c) ]) ifTrue:[
            ws nextPut:c.
        ] ifFalse:[
            ws nextPut: $%.
            c codePoint > 16rFF ifTrue:[
                ws nextPut: $u.
                c codePoint printOn:ws base:16 size:4 fill:$0.
            ] ifFalse:[
                c codePoint printOn:ws base:16 size:2 fill:$0.
            ]
        ].
    ].

    "Created: / 09-01-2011 / 10:32:27 / cg"
    "Modified: / 09-01-2011 / 13:11:17 / cg"
    "Modified: / 06-05-2015 / 15:43:39 / sr"
!

urlEncode:aStringOrStream on:ws
    "helper to escape invalid/dangerous characters in an urls arguments or post-fields.
     Similar to urlEncode2, but treats '*','~' and spaces differently.
     (some clients, such as bitTorrent seem to require urlEncode2 - time will tell...)
     Any byte not in the set 0-9, a-z, A-Z, '.', '-', '_' and '*', is encoded using 
     the '%nn' format, where nn is the hexadecimal value of the byte.
     Spaces are encoded as '+'.
        see: application/x-www-form-urlencoded  
        see: RFC1738"

    |rs c cp space|

    space := Character space.
    rs := aStringOrStream readStream.

    [rs atEnd] whileFalse: [
        c := rs next.

        (c isLetterOrDigit or:[ '-_.*' includes:c ]) ifTrue:[
            ws nextPut:c.
        ] ifFalse:[
            c == space ifTrue:[
                ws nextPut:$+.
            ] ifFalse:[
                ws nextPut: $%.
                (cp := c codePoint) > 16rFF ifTrue:[
                    ws nextPut: $u.
                    cp printOn:ws base:16 size:4 fill:$0.
                ] ifFalse:[
                    cp printOn:ws base:16 size:2 fill:$0.
                ].
            ].
        ].
    ].

    "Modified: / 09-01-2011 / 10:43:30 / cg"
    "Modified: / 06-05-2015 / 16:06:52 / sr"
!

urlEncoded2: aString
    "helper to escape invalid/dangerous characters in an urls arguments or post-fields.
     Similar to urlEncoded, but treats '*','~' and spaces differently.
     (some clients, such as bitTorrent seem to require this - time will tell...)
     Any byte not in the set 0-9, a-z, A-Z, '.', '-', '_' and '~', is encoded using 
     the '%nn' format, where nn is the hexadecimal value of the byte.
        see: application/x-www-form-urlencoded  
        see: RFC1738"

    |ws|

    ws := String writeStreamWithInitialSize:aString size.
    self urlEncode2:aString on:ws.
    ^ ws contents


    "
      self unEscape:(self urlEncoded:'_-.*Frankfurt(Main) Hbf')
      self urlEncoded2:'_-.*Frankfurt(Main) Hbf'

      self unEscape:(self urlEncoded:'-_.*%exept;')
      self urlEncoded2:'-_.*%exept;'  
      self urlEncoded:'-_.*%exept;'    
    "

    "Created: / 09-01-2011 / 10:34:50 / cg"
!

urlEncoded: aString
    "helper to escape invalid/dangerous characters in an urls arguments or post-fields.
     Similar to urlEncoded2, but treats '*','~' and spaces differently.
     (some clients, such as bitTorrent seem to require urlEncoded2 - time will tell...)
     Any byte not in the set 0-9, a-z, A-Z, '.', '-', '_' and '*', is encoded using 
     the '%nn' format, where nn is the hexadecimal value of the byte.
     Spaces are encoded as '+'.
        see: application/x-www-form-urlencoded  
        see: RFC1738"

    |ws|

    ws := String writeStreamWithInitialSize:aString size.
    self urlEncode:aString on:ws.
    ^ ws contents


    "
      self unEscape:(self urlEncoded:'_-.*Frankfurt(Main) Hbf')
      self urlEncoded:'_-.*Frankfurt(Main) Hbf'

      self unEscape:(self urlEncoded:'-_.*%exept;')
      self urlEncoded:'-_.*%exept;'
    "

    "Modified: / 09-01-2011 / 10:43:37 / cg"
!

withAllSpecialHTMLCharactersEscaped:aStringOrCharacter
    "replace ampersand, less, greater and quotes by html-character escapes"

    "/ TODO: this is similar to escapeCharacterEntities.
    "/ we should refactor this into one method only (can we do hex escapes always ?).
    "/ Notice, that these two methods came into existance due to historic reasons
    "/ and were developed independent of each other, but later moved to this common place.

    |resultStream|

"/    orgs  := #( $&      $<     $>     $"   $').
"/    repls := #( '&amp;' '&lt;' '&gt;' &quot; &apos;).

    (aStringOrCharacter isString
    and:[ (aStringOrCharacter includesAny:'&<>''"') not ]) ifTrue:[^ aStringOrCharacter].

    resultStream := CharacterWriteStream on:''.
    aStringOrCharacter asString do:[:eachCharacter |
        "/ huh - a switch. Sorry, but this method is used heavily.
        eachCharacter == $&
            ifTrue:[ resultStream nextPutAll:'&amp;' ]
            ifFalse:[
        eachCharacter == $<
            ifTrue:[ resultStream nextPutAll:'&lt;' ]
            ifFalse:[
        eachCharacter == $>
            ifTrue:[ resultStream nextPutAll:'&gt;' ]
            ifFalse:[
        eachCharacter == $"
            ifTrue:[ resultStream nextPutAll:'&quot;' ]
            ifFalse:[
        eachCharacter == $'
            ifTrue:[ resultStream nextPutAll:'&apos;' ]
            ifFalse:[
                resultStream nextPut:eachCharacter
            ]]]]].
    ].
    ^ resultStream contents

    "
     self withAllSpecialHTMLCharactersEscaped:'<>#&'     
     self withAllSpecialHTMLCharactersEscaped:$<
     self withAllSpecialHTMLCharactersEscaped:$#
    "

    "Modified: / 05-12-2006 / 13:48:59 / cg"
    "Modified: / 06-05-2015 / 15:41:06 / sr"
!

withSpecialHTMLCharactersEscaped:aStringOrCharacter
    "replace ampersand, less and greater by html-character escapes"

    "/ TODO: this is similar to escapeCharacterEntities.
    "/ we should refactor this into one method only (can we do hex escapes always ?).
    "/ Notice, that these two methods came into existance due to historic reasons
    "/ and were developed independent of each other, but later moved to this common place.

    |resultStream|

"/    orgs  := #( $&      $<     $>     ).
"/    repls := #( '&amp;' '&lt;' '&gt;' ).

    (aStringOrCharacter isString
     and:[ (aStringOrCharacter isWideString not)
     and:[ (aStringOrCharacter includesAny:'&<>') not ]]) ifTrue:[^ aStringOrCharacter].

    resultStream := CharacterWriteStream on:''.
    aStringOrCharacter asString do:[:eachCharacter |
        "/ huh - a switch. Sorry, but this method is used heavily.
        eachCharacter == $&
            ifTrue:[ resultStream nextPutAll:'&amp;' ]
            ifFalse:[
        eachCharacter == $<
            ifTrue:[ resultStream nextPutAll:'&lt;' ]
            ifFalse:[
        eachCharacter == $>
            ifTrue:[ resultStream nextPutAll:'&gt;' ]
            ifFalse:[
"/        eachCharacter codePoint > 16r7F
"/            ifTrue:[ 
"/                resultStream
"/                    nextPutAll:'&#';
"/                    nextPutAll:(eachCharacter codePoint printString);
"/                    nextPutAll:';']
"/            ifFalse:[
                resultStream nextPut:eachCharacter
"/            ]
            ]]].
    ].
    ^ resultStream contents

    "
     self withSpecialHTMLCharactersEscaped:'<>#&'
     self withSpecialHTMLCharactersEscaped:$<
     self withSpecialHTMLCharactersEscaped:$#
    "

    "Modified: / 13-04-2011 / 23:13:32 / cg"
    "Modified: / 06-05-2015 / 15:41:16 / sr"
! !

!HTMLUtilities class methodsFor:'queries'!

isUtilityClass
    ^ self == HTMLUtilities
! !

!HTMLUtilities class methodsFor:'serving-helpers'!

escape:aString
    "helper to escape invalid/dangerous characters in an url's arguments or post-fields.
     These are:
        control characters, dQuote, '+', ';', '?', '&' and space -> %XX ascii as hex digits
        %     -> %%
    "

    | rs ws c cp|

    rs := ReadStream on: aString.
    ws := WriteStream on: ''.
    [ rs atEnd ] whileFalse: [
        c := rs next.
        c == $% ifTrue:[
            ws nextPutAll: '%%'.
        ] ifFalse:[
            (((cp := c codePoint) < 16r7F)
             and:[ ('+;?&" ' includes:c) not ]) ifTrue: [ 
                ws nextPut: c.
            ] ifFalse:[
                ws nextPut: $%.
                cp printOn:ws base:16 size:(cp > 16rFF ifTrue:[4] ifFalse:[2]) fill:$0.
            ]
        ]
    ].
    ^ ws contents

    "
     self escape:'a b'      
     self escape:'a%b'    
     self escape:'a b'      
     self escape:'a+b'      
     self escape:'aäüöb'      
    "

    "Modified: / 06-05-2015 / 16:07:18 / sr"
    "Modified: / 25-11-2016 / 16:37:53 / cg"
! !

!HTMLUtilities class methodsFor:'text processing helpers'!

plainTextOfHTML:htmlString
    "given some HTML, extract the raw text. 
     Can be used to search for strings in some html text."

    |parser doc s first|


    parser := HTMLParser new.
    doc := parser parseText:htmlString.
    s := CharacterWriteStream on:(String new:100).
    first := true.
    doc markUpElementsDo:[:el |
        |t|

        el isTextElement ifTrue:[
            t := el text withoutSeparators.
            t notEmpty ifTrue:[
                first ifFalse:[    
                    s space.
                ].
                s nextPutAll:t.
                first := false    
            ].
        ] ifFalse:[
            "/ ignore non-text; however, we could care for text in info-titles
            "/ or scripts as well...
        ].
    ].
    ^ s contents

    "
     self plainTextOfHTML:'
bla1 bla2 <br>bla3 <table><tr><td>bla4</td></tr></table> bla5<p>bla6
'        
    "

    "Modified: / 06-05-2015 / 17:02:36 / sr"
! !

!HTMLUtilities class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

