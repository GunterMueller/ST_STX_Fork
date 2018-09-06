"
 COPYRIGHT (c) 2003 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libcompat' }"

"{ NameSpace: Smalltalk }"

TwoByteString variableWordSubclass:#TwoByteSymbol
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-ST80'
!

!TwoByteSymbol class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2003 by eXept Software AG
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
    This is a dummy stub - only present to provide a superclass for
    some VW Public Domain code (which subclasses or adds extensions to TwoByteSymbol).

    ST/X does not support (by purpose) general unicode symbols.
    Why: 
        A while ago, I have been shocked by getting a Smalltalk program which was
        written in another (national) language. All method, class and argument names where
        completely unreadable to me. And I could not really understand, what the program was doing.
        I still occasionally receive individual methods with local variables and comments
        in another language, and it is very hard at times to understand it.

        The above were using latin1 characters, so just imagine the additional confusion,
        if the program was written using non latin characters.
        
        So this artificial 'limitation' forces people to at least use words which are readable to
        everyone. I now even request programs to be written in english, using english coments and
        english variable names. As every programmer from the far east understands english, but not vice versa,
        this should make communication easier.

        It has nothing to do with 'western cultural imperialism', as some might think, 
        but is purely practical: it should support the comprehensability of programs among
        a worldwide community.

        Notice: general Unicode IS supported in Strings and Character literals. 
        So this affects only program code - not user interfaces.
        
"
! !

!TwoByteSymbol class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/TwoByteSymbol.st,v 1.7 2017-08-30 21:32:10 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libcompat/TwoByteSymbol.st,v 1.7 2017-08-30 21:32:10 cg Exp $'
! !

