"
 COPYRIGHT (c) 2004 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: CharacterEncoderImplementations }"

SingleByteEncoder subclass:#MS_Symbol
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Text-Encodings'
!

!MS_Symbol class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2004 by eXept Software AG
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
    CP1258 / Microsoft Symbol

    [see with:]
        CharacterEncoderImplementations::MS_Symbol showCharacterSet

    [author:]
        Claus Gittinger
"
! !

!MS_Symbol class methodsFor:'mapping'!

mapFileURL2_relativePathName
    ^ 'CP10008 '

    "
     self generateCode
    "
!

mapping
"
# From: http://std.dkuug.dk/i18n/charmaps/CP1258

<!!DOCTYPE HTML PUBLIC '-//IETF//DTD HTML 2.0//EN'>
<HTML><HEAD>
<TITLE>300 Multiple Choices</TITLE>
</HEAD><BODY>
<H1>Multiple Choices</H1>
The document name you requested (<code>/i18n/charmaps/CP1258</code>) could not be found on this server.
However, we found documents with names similar to the one you requested.<p>Available documents:
<ul>
<li><a href='/i18n/charmaps/CP1250'>/i18n/charmaps/CP1250</a> (mistyped character)
<li><a href='/i18n/charmaps/CP1251'>/i18n/charmaps/CP1251</a> (mistyped character)
<li><a href='/i18n/charmaps/CP1252'>/i18n/charmaps/CP1252</a> (mistyped character)
<li><a href='/i18n/charmaps/CP1253'>/i18n/charmaps/CP1253</a> (mistyped character)
<li><a href='/i18n/charmaps/CP1254'>/i18n/charmaps/CP1254</a> (mistyped character)
<li><a href='/i18n/charmaps/CP1255'>/i18n/charmaps/CP1255</a> (mistyped character)
<li><a href='/i18n/charmaps/CP1256'>/i18n/charmaps/CP1256</a> (mistyped character)
<li><a href='/i18n/charmaps/CP1257'>/i18n/charmaps/CP1257</a> (mistyped character)
</ul>
</BODY></HTML>

"
! !

!MS_Symbol class methodsFor:'documentation'!

version
    ^ '$Id: CharacterEncoderImplementations__MS_Symbol.st 10842 2012-09-07 10:49:18Z vranyj1 $'
!

version_SVN
    ^ '$Id:: CharacterEncoderImplementations__MS_Symbol.st 10842 2012-09-07 10:49:18Z vranyj1                                       $'
! !
