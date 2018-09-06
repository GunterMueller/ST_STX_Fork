"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1988 by Claus Gittinger
 COPYRIGHT (c) 2015 Jan Vrany
 COPYRIGHT (c) 2018 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

CharacterArray variableByteSubclass:#String
	instanceVariableNames:''
	classVariableNames:'CRLF CR LF TAB'
	poolDictionaries:''
	category:'Collections-Text'
!

!String primitiveDefinitions!
%{

#include <stdio.h>
#define _STDIO_H_INCLUDED_
#include <stdlib.h>
#include <ctype.h>

#ifdef LINUX
# define __STRINGDEFS__
# include <linuxIntern.h>
#endif

#ifdef __osx__
# include <string.h>
# include <stdlib.h>
#endif

#ifdef __MINGW__
# include <string.h>
# include <stdlib.h>
#endif

/*
 * old st/x creates strings with spaces in it;
 * new st/x will fill it with zeros (for st-80 compatibility)
 * the define below sets old behavior.
 */
#define INITIALIZE_WITH_SPACE

%}
! !

!String primitiveFunctions!
%{

static int
nextOnKeyboard(int char1, int char2)
{
    /* compare two characters if they are next to each other on a (US-) keyboard */

    static char *us_keys[] = { "1234567890-",
			    "*qwertyuiop",
			    "**asdfghjkl:",
			    "***zxcvbnm",
			    0 };
    static char *de_keys[] = { "1234567890-",
			    "*qwertzuiop",
			    "**asdfghjkl:",
			    "***yxcvbnm",
			    0 };
    char **keys = us_keys;
    char **line1, **line2;
    char *col1, *col2;
    int diff;

    for (line1 = keys; *line1 != 0; line1++) {
	for (col1 = *line1; *col1 != 0 && *col1 != char1; col1++)
	    continue;
    }
    if (*col1 == 0)
	return(0);

    for (line2 = keys; *line2 != 0; line2++) {
	for (col2 = *line2; *col2 != 0 && *col2 != char2; col2++)
	    continue;
    }
    if (*col2 == 0)
	return(0);

    diff = col1 - col2;
    if (diff > 1 || diff < -1)
	return(0);

    diff = line1 - line2;
    if (diff > 1 || diff < -1)
	return(0);
    return(1);
}

%}
! !

!String class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1988 by Claus Gittinger
 COPYRIGHT (c) 2015 Jan Vrany
 COPYRIGHT (c) 2018 Jan Vrany
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
    Strings are ByteArrays storing Characters.

    Strings are kind of kludgy: to allow for easy handling by C functions,
    there is always one 0-byte added at the end, which is not counted
    in the strings size, and is not accessible from the smalltalk level.
    This guarantees, that a smalltalk string can always be passed to a
    C- or a system api function without danger (of course, this does not
    prevent a nonsense contents ...)

    You cannot add any instvars to String, since the run time system & compiler
    creates literal strings and knows that strings have no named instvars.
    If you really need strings with instVars, you have to create a subclass
    of String (the access functions defined here can handle this).
    A little warning though: not all smalltalk systems allow subclassing String,
    so your program may become unportable if you do so.

    Strings have an implicit (assumed) encoding of ISO-8859-1.
    For strings with other encodings, either keep the encoding separately,
    or use instances of encodedString.

    Be careful when using the 0-byte in a String. This is not prohibited, but
    the implementations of some String methods use C functions and may
    therefore yield unexpected results (e.g. compareWith:collating:) when
    processing a String containing the 0-byte.

    [author:]
	Claus Gittinger

    [see also:]
	Text StringCollection TwoByteString JISEncodedString
	Symbol
"
! !

!String class methodsFor:'instance creation'!

basicNew:anInteger
    "return a new empty string with anInteger characters.
     In contrast to other smalltalks, this returns a string filled
     with spaces (instead of a string filled with 0-bytes).
     This makes much more sense, in that a freshly created string
     can be directly used as separator or for formatting."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( self.basicNew( anInteger.intValue() ));
#else
    OBJ newString;
    REGISTER INT len, instsize;
    REGISTER unsigned char *cp;
    int nInstVars;

    if (__isSmallInteger(anInteger)) {
	len = __intVal(anInteger);
	if (len >= 0) {
	    instsize = OHDR_SIZE + len + 1;
	    if (self == String || self == ImmutableString) {
		if (__CanDoQuickNew(instsize)) {        /* OBJECT ALLOCATION */
		    /*
		     * the most common case
		     */
		    __qCheckedNew(newString, instsize);
		    __InstPtr(newString)->o_class = self; /* no need for PROTECT - there was no GC */
		    __qSTORE(newString, self);

		    cp = __stringVal(newString);

# if defined(memset4)
		    {
			/*
			 * no sizeof(int) here please -
			 * - memset4 (if defined) fills 4-bytes on ALL machines
			 */
			int l4 = len >> 2;

			if (len & 3) l4++;
			memset4(cp, 0x20202020, l4);
			cp[len] = '\0';
		    }
# else
#  ifdef FAST_MEMSET
		    memset(cp, ' ', len);
		    cp[len] = '\0';
#  else
		    for ( ; len >= 8; cp += 8, len -= 8) {
#   ifdef INT64
			((INT64 *)cp)[0] = 0x2020202020202020L;
#   else
			((int *)cp)[0] = 0x20202020;
			((int *)cp)[1] = 0x20202020;
#   endif
		    }
		    while (len--)
			*cp++ = ' ';
		    *cp = '\0';
#  endif /* not FAST_MEMSET */
# endif /* not memset4 */

		    RETURN (newString);
		}
		nInstVars = 0;
	    } else {
		nInstVars = __intVal(__ClassInstPtr(self)->c_ninstvars);
		instsize += __OBJS2BYTES__(nInstVars);
	    }

	    __PROTECT_CONTEXT__;
	    __qNew(newString, instsize);        /* OBJECT ALLOCATION */
	    __UNPROTECT_CONTEXT__;

	    if (newString == nil) goto fail;

	    __InstPtr(newString)->o_class = self;
	    __qSTORE(newString, self);

	    cp = __stringVal(newString);
	    if (nInstVars) {
		OBJ *op;
		cp += __OBJS2BYTES__(nInstVars);

		/*
		 * nil-out instvars
		 */
# if defined(memset4)
		memset4(__InstPtr(newString)->i_instvars, nil, nInstVars);
# else
#  if defined(FAST_MEMSET) && ! defined(NEGATIVE_ADDRESSES)
		/*
		 * knowing that nil is 0
		 */
		memset(__InstPtr(newString)->i_instvars, 0, __OBJS2BYTES__(nInstVars));
#  else
		op = __InstPtr(newString)->i_instvars;
		do {
		    *op++ = nil;
		} while (--nInstVars);
#  endif  /* !FAST_MEMSET */
# endif
	    }

	    /*
	     * fill with spaces
	     */
# ifdef FAST_MEMSET
	    memset(cp, ' ', len);
	    *(cp + len) = '\0';
# else
	    while (len >= 8) {
#  ifdef INT64
		((INT64 *)cp)[0] = 0x2020202020202020L;
#  else
		((int *)cp)[0] = 0x20202020;
		((int *)cp)[1] = 0x20202020;
#  endif
		cp += 8;
		len -= 8;
	    }
	    while (len--)
		*cp++ = ' ';
	    *cp = '\0';
# endif /* !FAST_MEMSET */
	    RETURN (newString);
	}
    }
fail: ;;
#endif /* not __SCHTEAM__ */
%}.
    "
     invalid argument, or out-of-memory:
     use error handling in superclass
    "
    (anInteger < 0) ifTrue:[
	"
	 the argument is negative,
	"
	self error:'bad (negative) argument to new:'.
	^ nil
    ].

    ^ (super basicNew:anInteger+1) atAllPut:(Character space)
!

new:n
    "return a new empty string with n characters.
     In contrast to other smalltalks, this returns a string filled
     with spaces (instead of a string filled with 0-bytes).
     This makes much more sense, in that a freshly created string
     can be directly used as separator or for formatting.

     Redefined here with exactly the same code as in Behavior for
     better performance. "

    ^ self basicNew:n
!

readFrom:aStreamOrString onError:exceptionBlock
    "read & return the next String from the (character-)stream aStream;
     skipping all whitespace first; return the value of exceptionBlock,
     if no string can be read. The sequence of characters as read from the
     stream must be one as stored via storeOn: or storeString."

    "
     this method is not to be inherited
     (i.e. not ok for subclasses; Symbol, for example)
    "
    self ~~ String ifTrue:[
	^ super readFrom:aStreamOrString onError:exceptionBlock
    ].
    ^ self readSmalltalkStringFrom:aStreamOrString onError:exceptionBlock

    "
     String readFrom:('''hello world''' readStream)
     String readFrom:('''hello '''' world''' readStream)
     String readFrom:('1 ''hello'' ' readStream)
     String readFrom:('1 ''hello'' ' readStream) onError:['foobar']
    "

    "Modified: / 05-07-2006 / 16:41:29 / cg"
    "Modified: / 07-08-2006 / 15:03:09 / fm"
!

uninitializedNew:anInteger
    "return a new string with anInteger characters but undefined contents.
     Use this, if the string is filled anyway with new data, for example, if
     used as a stream buffer."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( self.basicNew( anInteger.intValue() ));
#else
    OBJ newString;
    REGISTER int len;
    REGISTER unsigned char *cp;
    REGISTER OBJ *op;
    int nInstVars, instsize;

    if (__isSmallInteger(anInteger)) {
	len = __intVal(anInteger);
	if (len >= 0) {
	    instsize = OHDR_SIZE + len + 1;
	    if (self == String) {
		if (__CanDoQuickNew(instsize)) {        /* OBJECT ALLOCATION */
		    /*
		     * the most common case
		     */
		    __qCheckedNew(newString, instsize);
		    __InstPtr(newString)->o_class = self; /* no need for PROTECT - there was no GC */
		    __qSTORE(newString, self);

		    cp = __stringVal(newString);
		    cp[len] = '\0';
		    RETURN (newString);
		}
		nInstVars = 0;
	    } else {
		nInstVars = __intVal(__ClassInstPtr(self)->c_ninstvars);
		instsize += __OBJS2BYTES__(nInstVars);
	    }

	    __PROTECT_CONTEXT__;
	    __qNew(newString, instsize);        /* OBJECT ALLOCATION */
	    __UNPROTECT_CONTEXT__;

	    if (newString == nil) goto fail;

	    __InstPtr(newString)->o_class = self;
	    __qSTORE(newString, self);

	    if (nInstVars) {
		/*
		 * nil-out instvars
		 */
# if defined(memset4)
		memset4(__InstPtr(newString)->i_instvars, nil, nInstVars);
# else
#  if defined(FAST_MEMSET) && ! defined(NEGATIVE_ADDRESSES)
		/*
		 * knowing that nil is 0
		 */
		memset(__InstPtr(newString)->i_instvars, 0, __OBJS2BYTES__(nInstVars));
#  else
		op = __InstPtr(newString)->i_instvars;
		do {
		    *op++ = nil;
		} while (--nInstVars);
#  endif
# endif
		cp = __stringVal(newString) + __OBJS2BYTES__(nInstVars);
	    } else {
		cp = __stringVal(newString);
	    }

	    *(cp + len) = '\0';
	    RETURN (newString);
	}
    }
fail: ;;
#endif /* not __SCHTEAM__ */
%}.
    "
     invalid argument, or out-of-memory:
     use error handling in superclass
    "
    (anInteger < 0) ifTrue:[
	"
	 the argument is negative,
	"
	self error:'bad (negative) argument to new:'.
	^ nil
    ].

    ^ self basicNew:anInteger

    "
     String uninitializedNew:100
    "
! !

!String class methodsFor:'Compatibility-Dolphin'!

lineDelimiter
    "Dolphin compatibility: answer CR LF"

    ^ self crlf
! !

!String class methodsFor:'Compatibility-Squeak'!

cr
    "return a string consisting of the cr-Character"

    "/ ATTENTION: you get a NL (for compatibility) here!!
    "/ please use String return  / String lf
    self halt:'please make it explicit, if a return or a linefeed is wanted.'.
    "/ for now.
    "/ will be changed, when the historic UNIX baggage is removed
    "/ and all cr's are really returns (instead of nl's).

    ^ self lf
!

crlf
    "return a string consisting of the cr-lf Characters"

    CRLF isNil ifTrue:[
	CRLF := String
		    with:Character return
		    with:Character linefeed
    ].
    ^ CRLF
!

lf
    "return a string consisting of the lf Character"

    LF isNil ifTrue:[
	LF := String with:Character linefeed
    ].
    ^ LF
!

return
    "return a string consisting of the cr-Character"

    CR isNil ifTrue:[
	CR := String with:Character return
    ].
    ^ CR
!

stringHash:aString initialHash:speciesHash
    "for squeak compatibility only; this is NOT the same hash as my instances use"

    | stringSize hash low |

    stringSize := aString size.
    hash := speciesHash bitAnd: 16rFFFFFFF.
    1 to: stringSize do: [:pos |
	hash := hash + (aString at: pos) asInteger.
	"Begin hashMultiply"
	low := hash bitAnd: 16383.
	hash := (16r260D * low + ((16r260D * (hash bitShift: -14) + (16r0065 * low) bitAnd: 16383) * 16384)) bitAnd: 16r0FFFFFFF.
    ].
    ^ hash.
!

tab
    "return a string consisting of the tab-Character"

    TAB isNil ifTrue:[
	TAB := String with:Character tab
    ].
    ^ TAB
! !



!String class methodsFor:'queries'!

defaultPlatformClass
    "dummy for ST-80 compatibility"

    ^ self

    "Created: 6.6.1997 / 18:25:56 / cg"
!

isBuiltInClass
    "return true if this class is known by the run-time-system.
     Here, true is returned for myself, false for subclasses."

    ^ self == String

    "Modified: 23.4.1996 / 16:00:38 / cg"
! !


!String methodsFor:'accessing'!

at:index
    "return the character at position index, an Integer.
     Reimplemented here to avoid the additional at:->basicAt: send
     (which we can do here, since at: is obviously not redefined in a subclass).
     This method is the same as at:."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    if (index.isSmallInteger()) {
	int idx1Based = context.stArg(0).intValue();   // st index is 1 based
	return context._RETURN( self.basicAt( idx1Based ));
    }
#else
    REGISTER INT indx;
    REGISTER OBJ slf, cls;

    if (__isSmallInteger(index)) {
	slf = self;
	cls = __qClass(slf);
	indx = __intVal(index) - 1;
	if (cls == String) {
	    fetch:
	    if ((unsigned INT)indx < (unsigned)(__stringSize(slf))) {
	        RETURN ( __MKCHARACTER(__stringVal(slf)[indx] & 0xFF) );
	    }	    
	   goto badIndex;
        }
	if (indx < 0) goto badIndex;
	indx += __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));
	goto fetch;
    }
badIndex: ;
#endif /* ! __SCHTEAM__ */
%}.
    ^ self basicAt:index
!

at:index put:aCharacter
    "store the argument, aCharacter at position index, an Integer.
     Return aCharacter (sigh).
     Reimplemented here to avoid the additional at:put:->basicAt:put: send
     (but only for Strings, since subclasses may redefine basicAt:put:).
     This method is the same as basicAt:put:."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    if (index.isSmallInteger()) {
	int idx1Based = index.intValue();   // st index is 1 based

	self.basicAt_put(idx1Based, aCharacter );
	return context._RETURN( aCharacter );
    }
#else
    REGISTER int value, indx;
    REGISTER OBJ slf;

    slf = self;

    if (__isString(slf)) {
	if (__isCharacter(aCharacter)) {
	    value = __intVal(__characterVal(aCharacter));
	    if (((unsigned)value <= 0xFF)
	     && __isSmallInteger(index)) {
		indx = __intVal(index) - 1;
		if ((unsigned INT)indx < (unsigned)(__stringSize(slf))) {
		    __stringVal(slf)[indx] = value;
		    RETURN ( aCharacter );
		}
	    }
	}
    }
#endif /* ! __SCHTEAM__ */
%}.
    ^ self basicAt:index put:aCharacter
!

basicAt:index
    "return the character at position index, an Integer
     - reimplemented here since we return characters"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    if (index.isSmallInteger()) {
	int idx1Based = index.intValue();   // st index is 1 based
	return context._RETURN( self.basicAt( idx1Based ));
    }
#else
    REGISTER INT indx;
    REGISTER OBJ slf, cls;

    if (__isSmallInteger(index)) {
	slf = self;
	cls = __qClass(slf);
	indx = __intVal(index) - 1;
	if (cls != String) {
	    if (indx < 0) goto badIndex;
	    indx += __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));
	}
	if ((unsigned INT)indx < (unsigned)(__stringSize(slf))) {
	    RETURN ( __MKCHARACTER(__stringVal(slf)[indx] & 0xFF) );
	}
    }
badIndex: ;
#endif /* not __SCHTEAM__ */
%}.
    index isInteger ifFalse:[
	^ self indexNotInteger:index
    ].
    index == super basicSize ifTrue:[
	^ self subscriptBoundsError:index
    ].
    ^ Character value:(super basicAt:index)
!

basicAt:index put:aCharacter
    "store the argument, aCharacter at position index, an Integer.
     Returns aCharacter (sigh).
     - reimplemented here since we store characters"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    if (index.isSmallInteger()) {
	int idx1Based = index.intValue();   // st index is 1 based

	self.basicAt_put(idx1Based, aCharacter );
	return context._RETURN( aCharacter );
    }
#else
    REGISTER int value, indx;
    REGISTER OBJ slf;
    REGISTER OBJ cls;

    slf = self;

    if (__isCharacter(aCharacter)) {
	value = __intVal(__characterVal(aCharacter));
	if (((unsigned)value <= 0xFF)
	 && __isSmallInteger(index)) {
	    cls = __qClass(slf);
	    indx = __intVal(index) - 1;
	    if (cls != String) {
		if (indx < 0) goto badIndex;
		indx += __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));
	    }
	    if ((unsigned INT)indx < (unsigned)(__stringSize(slf))) {
		__stringVal(slf)[indx] = value;
		RETURN ( aCharacter );
	    }
	}
    }
badIndex: ;
#endif /* not __SCHTEAM__ */
%}.
    (aCharacter isMemberOf:Character) ifFalse:[
	"
	 tried to store something which is not a character
	"
	^ self elementNotCharacter
    ].
    (aCharacter codePoint between:1 and:255) ifFalse:[
	"
	 tried to store a multibyte character
	"
	^ self elementBoundsError:aCharacter
    ].
    "
     invalid index
    "
    index isInteger ifFalse:[
	^ self indexNotInteger:index
    ].
    index == super basicSize ifTrue:[
	^ self subscriptBoundsError:index
    ].
    super basicAt:index put:aCharacter codePoint.
    ^ aCharacter
!

first
    "return the first character.
     Reimplemented here for speed"

%{  /* NOCONTEXT */

    REGISTER INT indx;
    REGISTER OBJ slf, cls;

    slf = self;
    cls = __qClass(slf);
    indx = 0;
    if (cls != String) {
	if (indx < 0) goto badIndex;
	indx += __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));
    }
    if ((unsigned INT)indx < (unsigned)(__stringSize(slf))) {
	RETURN ( __MKCHARACTER(__stringVal(slf)[indx] & 0xFF) );
    }
badIndex: ;
%}.
    ^ super first

    "
     'abc' first
     '' first
    "
! !


!String methodsFor:'character searching'!

identityIndexOf:aCharacter
    "return the index of the first occurrences of the argument, aCharacter
     in the receiver or 0 if not found - reimplemented here for speed."

    ^ self indexOf:aCharacter startingAt:1.

    "
     'hello world' identityIndexOf:(Character space)
     'hello world' identityIndexOf:$d
     'hello world' identityIndexOf:1
     #[0 0 1 0 0] asString identityIndexOf:(Character value:1)
     #[0 0 1 0 0] asString identityIndexOf:(Character value:0)
    "

    "Modified: / 10-01-2012 / 17:07:12 / cg"
!

identityIndexOf:aCharacter startingAt:index
    "return the index of the first occurrences of the argument, aCharacter
     in the receiver or 0 if not found - reimplemented here for speed."

    ^ self indexOf:aCharacter startingAt:index

    "
     'hello world' identityIndexOf:(Character space)
     'hello world' identityIndexOf:$d
     'hello world' identityIndexOf:1
     #[0 0 1 0 0] asString identityIndexOf:(Character value:1)
     #[0 0 1 0 0] asString identityIndexOf:(Character value:0)
    "

    "Created: / 10-01-2012 / 17:10:54 / cg"
!

includes:aCharacter
    "return true, if the receiver includes aCharacter.
     - redefined here for speed"

%{  /* NOCONTEXT */
#ifdef FAST_MEMCHR
    REGISTER unsigned char *cp;
    REGISTER unsigned byteValue;
    int last;
    OBJ cls;

    if (__isCharacter(aCharacter)) {
	byteValue = __intVal(__characterVal(aCharacter));
	if (byteValue <= 0xFF) {
	    last = __stringSize(self);
	    cp = __stringVal(self);
	    if ((cls = __qClass(self)) != String) {
		int numInstBytes = __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));

		cp += numInstBytes;
		last -= numInstBytes;
	    }
	    cp = (unsigned char *) memchr(cp, byteValue, last);
	    RETURN ( (cp == NULL) ? false : true );
	}
	RETURN (false);
    }
#endif
%}.
    ^ (self indexOf:aCharacter startingAt:1) ~~ 0

    "
     'hello world' includes:$l
     'hello world' includes:$W

     |s|
     s := String new:1024.
     s atAllPut:$a.
     s at:512 put:(Character space).
     Time millisecondsToRun:[
	1000000 timesRepeat:[ s includes:(Character space) ]
     ]

     timing (ms):
	    bcc                 OSX(2007 powerbook)
				 110
    "
!

includesAny:aCollection
    "return true, if the receiver includes any of the characters in the
     argument, aCollection.
     - redefined for speed if the argument is a String; especially optimized,
     if the searched collection has less than 6 characters."

%{  /* NOCONTEXT */

    REGISTER unsigned char *cp;
    REGISTER unsigned char *matchP;
    OBJ cls;
    int index, last;

    if (__isStringLike(aCollection)) {
	matchP = __stringVal(aCollection);
	last = __stringSize(self);
	cp = __stringVal(self);
	if ((cls = __qClass(self)) != String) {
	    int numInstBytes = __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));

	    cp += numInstBytes;
	    last -= numInstBytes;
	}
	index = 0;

	switch (__stringSize(aCollection)) {
	    case 5:
		/* five character search */
		{
		    unsigned char c1 = matchP[0];
		    unsigned char c2 = matchP[1];
		    unsigned char c3 = matchP[2];
		    unsigned char c4 = matchP[3];
		    unsigned char c5 = matchP[4];
		    unsigned char ch;

		    while (index < last) {
			ch = cp[index];
			if ((ch == c1) || (ch == c2) || (ch == c3) || (ch == c4) || (ch == c5)) {
			    RETURN ( true );
			}
			index++;
		    }
		    RETURN (false);
		}

	    case 4:
		/* four character search */
		{
		    unsigned char c1 = matchP[0];
		    unsigned char c2 = matchP[1];
		    unsigned char c3 = matchP[2];
		    unsigned char c4 = matchP[3];
		    unsigned char ch;

		    while (index < last) {
			ch = cp[index];
			if ((ch == c1) || (ch == c2) || (ch == c3) || (ch == c4)) {
			    RETURN ( true );
			}
			index++;
		    }
		    RETURN (false);
		}

	    case 3:
		/* three character search */
		{
		    unsigned char c1 = matchP[0];
		    unsigned char c2 = matchP[1];
		    unsigned char c3 = matchP[2];
		    unsigned char ch;

		    while (index < last) {
			ch = cp[index];
			if ((ch == c1) || (ch == c2) || (ch == c3)) {
			    RETURN ( true );
			}
			index++;
		    }
		    RETURN (false);
		}

	    case 2:
		/* two character search */
		{
#if 0
		    // this is roughly 10% slower (on OSX/64bit clang')
		    if (last < 2000) {
			if (strchr(cp, matchP[0])) {
			    RETURN ( true );
			}
			if (strchr(cp, matchP[1])) {
			    RETURN ( true );
			}
		    }
#endif

#if 1
		    // this is 30 %faster !
#                   define hasZeroByte(v) (((v) - 0x01010101UL) & ~(v) & 0x80808080UL)
#                   define hasByteM(v,m)   hasZeroByte( (v) ^ m)

		    unsigned char c1 = matchP[0];
		    unsigned char c2 = matchP[1];
		    int last4 = last-4;

		    int m1 = (~0UL/255 * (c1));
		    int m2 = (~0UL/255 * (c2));

		    while (index < last4) {
			unsigned int v = *(unsigned int *)(cp+index);

			if (hasByteM(v,m1)) {
			    RETURN ( true );
			}
			if (hasByteM(v,m2)) {
			    RETURN ( true );
			}
			index += 4;
		    }

#                   undef hasZeroByte
#                   undef hasByteM
#else
		    while (index < last4) {
			unsigned char ch;
			int any;

			ch = cp[index];
			any = ((ch == c1) || (ch == c2));
			ch = cp[index+1];
			any |= ((ch == c1) || (ch == c2));
			ch = cp[index+2];
			any |= ((ch == c1) || (ch == c2));
			ch = cp[index+3];
			any |= ((ch == c1) || (ch == c2));
			if (any) {
			    RETURN ( true );
			}
			index += 4;
		    }
#endif

		    while (index < last) {
			unsigned char ch;

			ch = cp[index];
			if ((ch == c1) || (ch == c2)) {
			    RETURN ( true );
			}
			index++;
		    }
		    RETURN (false);
		}

	    case 1:
		/* single character search */
		if (strchr(cp, matchP[0])) {
		    RETURN ( true );
		}
		RETURN ( false );

	    case 0:
		RETURN ( false );
	}

	{
	    unsigned char ch;

	    while (index < last) {
		ch = cp[index];
		if (strchr(matchP, ch)) {
		    RETURN ( true );
		}
		index++;
	    }
	}
	RETURN ( false );
    }
%}.
    ^ super includesAny:aCollection

    "
     'hello world' includesAny:'abcd'
     'hello world' includesAny:'xyz'
     'hello world' includesAny:'xz'
     'hello world' includesAny:'od'
     'hello world' includesAny:'xd'
     'hello world' includesAny:'dx'
     'hello world' includesAny:(Array with:$a with:$b with:$d)
     'hello world' includesAny:(Array with:$x with:$y)
     'hello world' includesAny:(Array with:1 with:2)

     |s|
     s := String new:1000 withAll:$a.
     Time millisecondsToRun:[
	1000000 timesRepeat:[
	    s includesAny:'12'
	]
     ].540 680 550 850 890 850

     |s|
     s := String new:2000 withAll:$a.
     Time millisecondsToRun:[
	1000000 timesRepeat:[
	    s includesAny:'12'
	]
     ]. 1030 1060 1650 1690

     |s|
     s := 'hello world'.
     Time millisecondsToRun:[
	1000000 timesRepeat:[
	    s includesAny:'12'
	]
     ].70 60
    "
!

indexOf:aCharacter startingAt:start
    "return the index of the first occurrence of the argument, aCharacter
     in myself starting at start, anInteger or 0 if not found;
     - reimplemented here for speed"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    if (start.isSmallInteger()
     && aCharacter.isSTCharacter()) {
	int idx1Based = start.intValue();   // st index is 1 based
	int jIdx = self.asString().indexOf(aCharacter.charValue(), idx1Based-1);

	return context._RETURN( jIdx+1 );    // st index is 1 based
    }

#else

# if defined(__BORLANDC__) || defined(__VISUALC__)
#  undef __UNROLL_LOOPS__
#  undef FAST_MEMCHR
#  define V2
# endif

    REGISTER unsigned char *cp;
    REGISTER INT index;
    REGISTER unsigned byteValue;
    int last;
    OBJ cls;

    if (__isSmallInteger(start)) {
	index = __intVal(start);
	if (index > 0) {
	    if (__isCharacter(aCharacter)) {
		byteValue = __intVal(__characterVal(aCharacter));
		if (byteValue <= 0xFF) {
		    last = __stringSize(self);
		    cp = __stringVal(self);
		    if ((cls = __qClass(self)) != String) {
			int numInstBytes = __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));

			cp += numInstBytes;
			last -= numInstBytes;
		    }
		    if (index <= last) {
# ifdef FAST_MEMCHR
			REGISTER unsigned char *ncp;

			ncp = (unsigned char *) memchr(cp+index-1, byteValue, last+1-index);
			if (ncp) {
			    RETURN ( __mkSmallInteger(ncp - cp + 1) );
			}
# else

#  ifdef V2
			{
			    // see bit twiddling hacks
#                           define hasZeroByte(v) (((v) - 0x01010101UL) & ~(v) & 0x80808080UL)
#                           define hasByteM(v,m)   hasZeroByte( (v) ^ m)
#   if __POINTER_SIZE__ == 8
#                           define hasZeroByte8(v) (((v) - 0x0101010101010101ULL) & ~(v) & 0x8080808080808080ULL)
#                           define hasByteM8(v,m)   hasZeroByte8( (v) ^ m)
			    // the following loop checks eight bytes at once
			    if (((index-1) & 0x7) == 0) {
				int last8 = last-8;
				INT m = (~0ULL/255 * (byteValue));

				while (index <= last8) {
				    unsigned INT v = *(unsigned INT *)(cp+index-1);

				    if (hasByteM8(v,m)) break;
				    index += 8;
				}
			    }
#   endif
			    // the following loop checks four bytes at once
			    if (((index-1) & 0x3) == 0) {
				int last4 = last-4;
				int m = (~0UL/255 * (byteValue));

				while (index <= last4) {
				    unsigned int v = *(unsigned int *)(cp+index-1);

				    if (hasByteM(v,m)) break;
				    index += 4;
				}
			    }
			}
#  else

#   ifdef __UNROLL_LOOPS__
			{
			    int last4 = last-4;

			    for (; index <= last4; index += 4) {
				if (cp[index-1] == byteValue) { RETURN ( __mkSmallInteger(index) ); }
				if (cp[index-1+1] == byteValue) { RETURN ( __mkSmallInteger(index+1) ); }
				if (cp[index-1+2] == byteValue) { RETURN ( __mkSmallInteger(index+2) ); }
				if (cp[index-1+3] == byteValue) { RETURN ( __mkSmallInteger(index+3) ); }
			    }
			}
#   endif
#  endif /* V2 */
			while (index <= last) {
			    if (cp[index-1] == byteValue) {
				RETURN ( __mkSmallInteger(index) );
			    }
			    index++;
			}
# endif
		    }
		}
	    }
	    RETURN ( __mkSmallInteger(0) );
	}
    }
# undef V2
#endif /* not SCHTEAM */
%}.
    ^ super indexOf:aCharacter startingAt:start

    "
     'hello world' indexOf:$0 startingAt:1
     'hello world' indexOf:$l startingAt:1
     'hello world' indexOf:$l startingAt:5
     'hello world' indexOf:$d startingAt:5
     #[0 0 1 0 0] asString indexOf:(Character value:1) startingAt:1
     #[0 0 1 0 0] asString indexOf:(Character value:0) startingAt:3

     '1234567890123456a' indexOf:$a
     '1234567890123456a' indexOf:$b

     |s|
     s := '12345678901234b'.
     self assert:(s indexOf:$x) == 0.
     self assert:(s indexOf:$1) == 1.
     self assert:(s indexOf:$2) == 2.
     self assert:(s indexOf:$3) == 3.
     self assert:(s indexOf:$4) == 4.
     self assert:(s indexOf:$5) == 5.
     self assert:(s indexOf:$0) == 10.
     self assert:(s indexOf:$b) == 15.

     |s|
     s := ''.
     self assert:(s indexOf:$1) == 0.
     s := '1'.
     self assert:(s indexOf:$1) == 1.
     self assert:(s indexOf:$2) == 0.
     s := '12'.
     self assert:(s indexOf:$1) == 1.
     self assert:(s indexOf:$2) == 2.
     self assert:(s indexOf:$3) == 0.
     s := '123'.
     self assert:(s indexOf:$1) == 1.
     self assert:(s indexOf:$2) == 2.
     self assert:(s indexOf:$3) == 3.
     self assert:(s indexOf:$4) == 0.
     s := '1234'.
     self assert:(s indexOf:$1) == 1.
     self assert:(s indexOf:$2) == 2.
     self assert:(s indexOf:$3) == 3.
     self assert:(s indexOf:$4) == 4.
     self assert:(s indexOf:$5) == 0.
     s := '12345'.
     self assert:(s indexOf:$1) == 1.
     self assert:(s indexOf:$2) == 2.
     self assert:(s indexOf:$3) == 3.
     self assert:(s indexOf:$4) == 4.
     self assert:(s indexOf:$5) == 5.
     self assert:(s indexOf:$6) == 0.
     s := '123456'.
     self assert:(s indexOf:$1) == 1.
     self assert:(s indexOf:$2) == 2.
     self assert:(s indexOf:$3) == 3.
     self assert:(s indexOf:$4) == 4.
     self assert:(s indexOf:$5) == 5.
     self assert:(s indexOf:$6) == 6.
     self assert:(s indexOf:$7) == 0.
     s := '1234567'.
     self assert:(s indexOf:$1) == 1.
     self assert:(s indexOf:$2) == 2.
     self assert:(s indexOf:$3) == 3.
     self assert:(s indexOf:$4) == 4.
     self assert:(s indexOf:$5) == 5.
     self assert:(s indexOf:$6) == 6.
     self assert:(s indexOf:$7) == 7.
     self assert:(s indexOf:$8) == 0.
     s := '12345678'.
     self assert:(s indexOf:$1) == 1.
     self assert:(s indexOf:$2) == 2.
     self assert:(s indexOf:$3) == 3.
     self assert:(s indexOf:$4) == 4.
     self assert:(s indexOf:$5) == 5.
     self assert:(s indexOf:$6) == 6.
     self assert:(s indexOf:$7) == 7.
     self assert:(s indexOf:$8) == 8.
     self assert:(s indexOf:$9) == 0.
     s := '123456789'.
     self assert:(s indexOf:$1) == 1.
     self assert:(s indexOf:$2) == 2.
     self assert:(s indexOf:$3) == 3.
     self assert:(s indexOf:$4) == 4.
     self assert:(s indexOf:$5) == 5.
     self assert:(s indexOf:$6) == 6.
     self assert:(s indexOf:$7) == 7.
     self assert:(s indexOf:$8) == 8.
     self assert:(s indexOf:$9) == 9.

     self assert:(s indexOf:$0) == 0.
     self assert:(s indexOf:$b) == 0.

     |s|
     s := String new:1024.
     s atAllPut:$a.
     s at:512 put:(Character space).
     Time millisecondsToRun:[
	1000000 timesRepeat:[ s indexOf:(Character space) ]
     ]

     timing (ms):
	    bcc                 OSX(2007 powerbook)
	v1: 1763 normal
	    2340 +unroll
	    3308 memsrch !!       90
	v2: 1045                150
    "

    "Modified: / 10-01-2012 / 17:09:34 / cg"
!

indexOfAny:aCollectionOfCharacters startingAt:start
    "return the index of the first occurrence of any character in aCollectionOfCharacters,
     in myself starting at start, anInteger or 0 if not found;
     - reimplemented here for speed if aCollectionOfCharacters is a string."

%{  /* NOCONTEXT */

    unsigned char *ccp;
    unsigned char *cp;
    INT index;
    unsigned char *matchP;
    unsigned char c, min, max;
    int len;
    OBJ cls;

    if (__isSmallInteger(start)
     && __isStringLike(aCollectionOfCharacters)) {
	matchP = __stringVal(aCollectionOfCharacters);
	index = __intVal(start);
	if (index > 0) {
	    cp = __stringVal(self) + index - 1;
	    if ((cls = __qClass(self)) != String) {
		cp += __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));
	    }
	    len = __stringSize(self);
	    if (index <= len) {

		if (matchP[0] == 0) {
		    /* matchSet is empty */
		    RETURN ( __mkSmallInteger(0) );
		}

		if (matchP[1] == 0) {
		    /* only a single character match */
		    unsigned char m = matchP[0];

# ifdef FAST_MEMCHR
		    ccp = (unsigned char *) memchr(cp, m, len+1-index);
		    if (ccp) {
			RETURN ( __mkSmallInteger((ccp - cp) + index) );
		    }
# else
		    while ((c = *cp++) != '\0') {
			if (c == m) {
			    RETURN ( __mkSmallInteger(index) );
			}
			index++;
		    }
# endif
		    RETURN ( __mkSmallInteger(0) );
		}

		if (matchP[2] == 0) {
		    /* two character matches */
		    unsigned char m1 = matchP[0];
		    unsigned char m2 = matchP[1];

		    while ((c = *cp++) != '\0') {
			if ((c == m1) || (c == m2)) {
			    RETURN ( __mkSmallInteger(index) );
			}
			index++;
		    }
		    RETURN ( __mkSmallInteger(0) );
		}

		min = max = matchP[0];

		for (ccp = matchP+1; *ccp ; ccp++) {
		    unsigned char c = *ccp;
		    if (c < min) min = c;
		    else if (c > max) max = c;
		}

		while ((c = *cp++) != '\0') {
		    if ((c >= min) && (c <= max)) {
			for (ccp = matchP; *ccp ; ccp++) {
			    if (*ccp == c) {
				RETURN ( __mkSmallInteger(index) );
			    }
			}
		    }
		    index++;
		}
	    }
	    RETURN ( __mkSmallInteger(0) );
	}
    }
%}.
    "/
    "/ fallback: 1st argument not a string or error
    "/
    ^ super indexOfAny:aCollectionOfCharacters startingAt:start

    "
     'hello world' indexOfAny:'eoa' startingAt:1
     'hello world' indexOfAny:'eoa' startingAt:6
     'hello world' indexOfAny:'AOE' startingAt:1
     'hello world' indexOfAny:'o' startingAt:6
     'hello world' indexOfAny:'o' startingAt:6
     'hello world§' indexOfAny:'#§$' startingAt:6
    "
!

indexOfControlCharacterStartingAt:start
    "return the index of the next control character;
     that is a character with asciiValue < 32.
     Return 0 if none is found."

%{  /* NOCONTEXT */

    REGISTER unsigned char *cp;
    REGISTER unsigned char c;
    REGISTER unsigned char *cpEnd;
    int len, index;
    OBJ cls;

    index = __intVal(start);
    if (index <= 0) {
	index = 1;
    }
    len = __stringSize(self);
    cp = __stringVal(self);
    if ((cls = __qClass(self)) != String) {
	int numInstBytes = __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));

	cp += numInstBytes;
	len -= numInstBytes;
    }
    while (index <= len) {
	REGISTER unsigned char c;

	c = cp[index - 1];
	if (c < ' ') {
	    RETURN ( __mkSmallInteger(index) );
	}
	index++;
    }
    RETURN ( __mkSmallInteger(0) );
%}.
    ^ super indexOfControlCharacterStartingAt:start

    "
     'hello world'             indexOfControlCharacterStartingAt:1
     'hello world\foo' withCRs indexOfControlCharacterStartingAt:1
     '1\' withCRs indexOfControlCharacterStartingAt:1
     '1\' withCRs indexOfControlCharacterStartingAt:2
    "
!

indexOfNonSeparatorStartingAt:start
    "return the index of the next non-whiteSpace character"

%{  /* NOCONTEXT */

    REGISTER unsigned char *cp;
    REGISTER unsigned char c;
    int len, index;
    OBJ cls;

    index = __intVal(start);
    if (index <= 0) {
	index = 1;
    }
    len = __stringSize(self);
    cp = __stringVal(self);
    if ((cls = __qClass(self)) != String) {
	int numInstBytes = __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));

	cp += numInstBytes;
	len -= numInstBytes;
    }
    while (index <= len) {
	REGISTER unsigned char c;

	c = cp[index - 1];
	if (c > ' ') {
	    if ((c != ' ') && (c != '\t') && (c != '\n')
	     && (c != '\r') && (c != '\f')) {
		RETURN ( __mkSmallInteger(index) );
	    }
	}
	index++;
    }
    RETURN ( __mkSmallInteger(0) );
%}.
    ^ super indexOfNonSeparatorStartingAt:start

    "
     'hello world' indexOfNonWhiteSpaceStartingAt:3
     'hello world' indexOfNonWhiteSpaceStartingAt:7
    "
!

indexOfSeparatorStartingAt:start
    "return the index of the next separator character"

%{  /* NOCONTEXT */

    if (__isSmallInteger(start)) {
	REGISTER unsigned char *cp;
	int len, index;
	OBJ cls;

	index = __intVal(start)-1;
	// is this a good idea?
	if (index < 0) {
	    index = 0;
	}
	len = __stringSize(self);
	cp = __stringVal(self);

	// care for subclasses of string
	if ((cls = __qClass(self)) != String) {
	    int numInstBytes = __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));

	    cp += numInstBytes;
	    len -= numInstBytes;
	}

	// these pre-loops do fast skip over non-separators
	// (anything above 0x32)
#if __POINTER_SIZE__ == 8
	if ((index & 7) == 0) {
	    int len8 = len-8;
	    while (index < len8) {
		REGISTER unsigned INT eightChars;
		REGISTER unsigned INT eightCharsMasked;

		eightChars = ((unsigned INT *)(cp+index))[0];
		eightCharsMasked = eightChars & 0xE0E0E0E0E0E0E0E0ULL;

		// any control char?
		// (these are 0..31 and also the space);
		// so we need two compares.
#               define hasZeroByte(v) (((v) - 0x0101010101010101ULL) & ~(v) & 0x8080808080808080ULL)
#               define hasByteM(v,m)   hasZeroByte( (v) ^ m)
#               define maskSpace       (~0ULL/255 * (32))

		if (hasByteM(eightChars, maskSpace)) break;
		if (hasZeroByte(eightCharsMasked)) break;

#               undef hasZeroByte
#               undef hasByteM
#               undef maskSpace

		index += 8;
	    }
	}
#endif /* POINTER_SIZE == 8*/

	if ((index & 3) == 0) {
	    int len4 = len-4;
	    while (index < len4) {
		REGISTER unsigned int fourChars;
		REGISTER unsigned int fourCharsMasked;

		fourChars = ((unsigned int *)(cp+index))[0];
		fourCharsMasked = fourChars & 0xE0E0E0E0UL;

		// any control char?
		// (these are 0..31 and also the space);
		// so we need two compares.
#               define hasZeroByte(v) (((v) - 0x01010101UL) & ~(v) & 0x80808080UL)
#               define hasByteM(v,m)   hasZeroByte( (v) ^ m)
#               define maskSpace       (~0UL/255 * (32))

		if (hasByteM(fourChars, maskSpace)) break;
		if (hasZeroByte(fourCharsMasked)) break;

#               undef hasZeroByte
#               undef hasByteM
#               undef maskSpace

		index += 4;
	    }
	}

	while (index < len) {
	    REGISTER unsigned char c;

	    c = cp[index];
	    if (c <= ' ') {
		if ((c == ' ') || (c == '\t') || (c == '\n')
		 || (c == '\r') || (c == '\f')) {
		    RETURN ( __mkSmallInteger(index+1) );
		}
	    }
	    index++;
	}
	RETURN ( __mkSmallInteger(0) );
    }
%}.
    ^ super indexOfSeparatorStartingAt:start

    " 123456789012
     'hello world ' indexOfSeparatorStartingAt:1 -> 6
     'hello world ' indexOfSeparatorStartingAt:3 -> 6
     'hello world ' indexOfSeparatorStartingAt:7 -> 12
     'hello world' indexOfSeparatorStartingAt:7  -> 0
     'helloworld' indexOfSeparatorStartingAt:1   -> 0
    "

    "
     |s|
     s := String new:1000 withAll:$a.
     self assert:(s indexOfSeparatorStartingAt:1) == 0.
     Time millisecondsToRun:[
	 1000000 timesRepeat:[ s indexOfSeparatorStartingAt:1 ]
     ]
     original (char-wise):760 760 750
     with 4-byte at a time: 640 650 620
     with 8-byte at a time: 300 290 320
    "
    "
     |s|
     s := String new:1000 withAll:$a.
     s at:400 put:(Character return).
     self assert:(s indexOfSeparatorStartingAt:1) == 400.
     Time millisecondsToRun:[
	 1000000 timesRepeat:[ s indexOfSeparatorStartingAt:1 ]
     ]
     original (char-wise):340 350
     with 4-byte at a time: 310 290 280
     with 8-byte at a time: 150 140 140
    "
    "
     |s|
     s := String new:1000 withAll:$a.
     s at:999 put:(Character space).
     self assert:(s indexOfSeparatorStartingAt:1) == 999.
     Time millisecondsToRun:[
	 1000000 timesRepeat:[ s indexOfSeparatorStartingAt:1 ]
     ]
     original (char-wise): 750 750 790
     with 4-byte at a time: 640 640 620
     with 8-byte at a time: 280 290 300
    "
!

occurrencesOf:aCharacter
    "count the occurrences of the argument, aCharacter in myself
      - reimplemented here for speed"

%{  /* NOCONTEXT */

    REGISTER unsigned char *cp;
    REGISTER unsigned byteValue;
    REGISTER INT count, limit;
    OBJ cls;

    if (__isCharacter(aCharacter)) {
	limit = __stringSize(self);
	count = 0;
	byteValue = __intVal(__characterVal(aCharacter));
	if (byteValue <= 0xFF) {
	    cp = __stringVal(self);
	    if ((cls = __qClass(self)) != String) {
		int n = __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));
		limit -= n;
		cp += n;
	    }
	    /* loop unrolled and software-pipelined
	     * (gives 30-40% speedup on Intel-DUO using borland bcc55)
	     */
	    while (limit >= 4) {
		register unsigned char c1, c2;

		c1 = cp[0];
		limit -= 4;
		c2 = cp[1];
		if (c1 == byteValue) count++;
		c1 = cp[2];
		if (c2 == byteValue) count++;
		c2 = cp[3];
		if (c1 == byteValue) count++;
		cp += 4;
		if (c2 == byteValue) count++;
	    }
	    while (limit > 0) {
		register unsigned char c1;

		c1 = cp[0];
		limit--;
		if (c1 == byteValue) count++;
		cp ++;
	    }
	}
	RETURN ( __mkSmallInteger(count) );
    }
%}.
    ^ super occurrencesOf:aCharacter

    "
     'hello world' occurrencesOf:$a
     'hello world' occurrencesOf:$w
     'hello world' occurrencesOf:$l
     'hello world' occurrencesOf:$x
     'hello world' occurrencesOf:1
     Time millisecondsToRun:[
	1000000 timesRepeat:[ 'abcdefghijklmn' occurrencesOf:$x ]
     ]. 219 203 156 203 204 204 219 172 187 187 141
    "
! !

!String methodsFor:'comparing'!

< aString
    "Compare the receiver with the argument and return true if the
     receiver is greater than the argument. Otherwise return false.
     No national variants are honored; use after: for this.
     In contrast to ST-80, case differences are NOT ignored, thus
     'foo' < 'Foo' will return false.
     This may change."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( self.stringLtP(aString) );
    /* NOTREACHED */
#else
    int len1, len2, cmp;
    unsigned char *cp1, *cp2;
    int argIsString;

    if (__isNonNilObject(aString)) {
	argIsString = __qIsStringLike(aString);
	if (argIsString || __qClass(aString) == __qClass(self)) {
	    cp2 = __stringVal(aString);
	    len2 = __stringSize(aString);
	    /*
	     * care for instances of subclasses ...
	     */
	    if (!argIsString) {
		int n = __OBJS2BYTES__(__intVal(__ClassInstPtr(__qClass(aString))->c_ninstvars));

		cp2 += n;
		len2 -= n;
	    }

	    cp1 = __stringVal(self);
	    len1 = __stringSize(self);
	    /*
	     * care for instances of subclasses ...
	     */
	    if (!__qIsStringLike(self)) {
		int n = __OBJS2BYTES__(__intVal(__ClassInstPtr(__qClass(self))->c_ninstvars));

		cp1 += n;
		len1 -= n;
	    }

	    if (len1 <= len2)
		cmp = strncmp(cp1, cp2, len1);
	    else
		cmp = strncmp(cp1, cp2, len2);

	    if (cmp < 0) {
		RETURN ( true );
	    }
	    if ((cmp == 0) && (len1 < len2)) {
		RETURN ( true );
	    }
	    RETURN ( false );
	}
    }
#endif
%}.
    ^ super < aString
!

= aString
    "Compare the receiver with the argument and return true if the
     receiver is equal to the argument. Otherwise return false.
     This compare is case-sensitive (i.e. 'Foo' is NOT = 'foo').
     Use sameAs: to compare with case ignored."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    if (aString == self) {
	return __c__._RETURN_true();
    }
    if (aString.isStringLike()) {
	return __c__._RETURN( self.isStringEqual(aString) ? STObject.True : STObject.False );
    }
    if (aString == STObject.Nil) {
	return __c__._RETURN_false();
    }
#else
    int l1, l2;
    unsigned char *cp1, *cp2;
    INT addrDelta;
    int argIsString;

    if (aString == self) {
	RETURN ( true );
    }
    if (! __isNonNilObject(aString)) {
	RETURN ( false );
    }

    argIsString = __qIsStringLike(aString);
    if (argIsString || __qClass(aString) == __qClass(self)) {
	cp2 = __stringVal(aString);
	l2 = __stringSize(aString);
	/*
	 * care for instances of subclasses ...
	 */
	if (!argIsString) {
	    int n = __OBJS2BYTES__(__intVal(__ClassInstPtr(__qClass(aString))->c_ninstvars));

	    cp2 += n;
	    l2 -= n;
	}

	cp1 = __stringVal(self);
	l1 = __stringSize(self);
	/*
	 * care for instances of subclasses ...
	 */
	if (!__qIsStringLike(self)) {
	    int n = __OBJS2BYTES__(__intVal(__ClassInstPtr(__qClass(self))->c_ninstvars));

	    cp1 += n;
	    l1 -= n;
	}

	if (l1 != l2) {
	    RETURN ( false );
	}
# ifdef FAST_MEMCMP
	RETURN ( (memcmp(cp1, cp2, l1) == 0) ? true : false );
# else
	addrDelta = cp2 - cp1;
#  ifdef __UNROLL_LOOPS__
	while (l1 >= (sizeof(unsigned INT)*4)) {
	    if (((unsigned INT *)cp1)[0] != ((unsigned INT *)(cp1+addrDelta))[0]) {
		RETURN (false);
	    }
	    if (((unsigned INT *)cp1)[1] != ((unsigned INT *)(cp1+addrDelta))[1]) {
		RETURN (false);
	    }
	    if (((unsigned INT *)cp1)[2] != ((unsigned INT *)(cp1+addrDelta))[2]) {
		RETURN (false);
	    }
	    if (((unsigned INT *)cp1)[3] != ((unsigned INT *)(cp1+addrDelta))[3]) {
		RETURN (false);
	    }
	    l1 -= (sizeof(unsigned INT) * 4);
	    cp1 += (sizeof(unsigned INT) * 4);
	}
#  endif /* __UNROLL_LOOPS__ */
	while (l1 >= sizeof(unsigned INT)) {
	    if (*((unsigned INT *)cp1) != *((unsigned INT *)(cp1+addrDelta))) {
		RETURN (false);
	    }
	    l1 -= sizeof(unsigned INT);
	    cp1 += sizeof(unsigned INT);
	}
	if (l1 >= sizeof(unsigned short)) {
	    if (*((unsigned short *)cp1) != *((unsigned short *)(cp1+addrDelta))) {
		RETURN (false);
	    }
	    l1 -= sizeof(unsigned short);
	    cp1 += sizeof(unsigned short);
	}
	while (l1) {
	    if (*cp1 != *(cp1+addrDelta)) {
		RETURN (false);
	    }
	    l1--;
	    cp1++;
	}

	RETURN (true);
# endif
    }
#endif /* not __SCHTEAM__ */
%}.
    ^ super = aString

    "
     'foo' = 'Foo'
     'foo' sameAs: 'Foo'
     #[0 0 1 0 0] asString = #[0 0 1 0 0] asString
    "
    "
     |tEmpty tCmp|

     tEmpty := Time millisecondsToRun:[
	 1000000 timesRepeat:[]
     ].
     tCmp := Time millisecondsToRun:[
	 1000000 timesRepeat:[ '1234567890' = '1234567890' ]
     ].
     tCmp - tEmpty
    "
!

> aString
    "Compare the receiver with the argument and return true if the
     receiver is greater than the argument. Otherwise return false.
     No national variants are honored; use after: for this.
     In contrast to ST-80, case differences are NOT ignored, thus
     'foo' > 'Foo' will return true.
     This may change."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( aString.stringLtP( self ) );
    /* NOTREACHED */
#else
    int len1, len2, cmp;
    unsigned char *cp1, *cp2;
    int argIsString;

    if (__isNonNilObject(aString)) {
	argIsString = __qIsStringLike(aString);
	if (argIsString || __qClass(aString) == __qClass(self)) {
	    cp2 = __stringVal(aString);
	    len2 = __stringSize(aString);
	    /*
	     * care for instances of subclasses ...
	     */
	    if (!argIsString) {
		int n = __OBJS2BYTES__(__intVal(__ClassInstPtr(__qClass(aString))->c_ninstvars));

		cp2 += n;
		len2 -= n;
	    }

	    cp1 = __stringVal(self);
	    len1 = __stringSize(self);
	    /*
	     * care for instances of subclasses ...
	     */
	    if (!__qIsStringLike(self)) {
		int n = __OBJS2BYTES__(__intVal(__ClassInstPtr(__qClass(self))->c_ninstvars));

		cp1 += n;
		len1 -= n;
	    }

	    if (len1 <= len2)
		cmp = strncmp(cp1, cp2, len1);
	    else
		cmp = strncmp(cp1, cp2, len2);

	    if (cmp > 0) {
		RETURN ( true );
	    }
	    if ((cmp == 0) && (len1 > len2)) {
		RETURN ( true );
	    }
	    RETURN ( false );
	}
    }
#endif /* not __SCHTEAM__ */
%}.
    ^ super > aString
!

compareCollatingWith:aString
    "Compare the receiver with the argument and return 1 if the receiver is
     greater, 0 if equal and -1 if less than the argument in a sorted list.
     The comparison is language specific, depending on the value of
     LC_COLLATE, which is in the shell environment."

    ^ self compareWith:aString collating:true

    "
     'hallo' compareWith:'hällo'
     'hbllo' compareWith:'hällo'

     'hallo' compareCollatingWith:'hällo'
     'hbllo' compareCollatingWith:'hällo'
    "
!

compareWith:aString
    "Compare the receiver with the argument and return 1 if the receiver is
     greater, 0 if equal and -1 if less than the argument.
     This comparison is based on the elements' codepoints -
     i.e. upper/lowercase & national characters are NOT treated specially.
     'foo' compareWith: 'Foo' will return 1.
     while 'foo' sameAs:'Foo' will return true"

    ^ self compareWith:aString collating:false
!

compareWith:aString collating:collatingBoolean
    "Compare the receiver with the argument and return 1 if the receiver is
     greater, 0 if equal and -1 if less than the argument.
     If the collatingBoolean is true, the comparison will be based on the
     current setting of LC_COLLATE in the locale (which is set in the shell environment);
     otherwise, it will be a simple string-compare.
     This comparison is based on the elements' codepoints -
     i.e. upper/lowercase & national characters are NOT treated specially.
     'foo' compareWith: 'Foo' will return 1.
     while 'foo' sameAs:'Foo' will return true"

%{  /* NOCONTEXT */

    int cmp;
    unsigned char *cp1, *cp2;
    int argIsString;

    if (__isNonNilObject(aString)) {
	argIsString = __qIsStringLike(aString);
	if (argIsString || __qClass(aString) == __qClass(self)) {
	    //
	    // care for instances of subclasses ...
	    //
	    cp1 = __stringVal(self);
	    if (!__qIsStringLike(self)) {
		int n = __OBJS2BYTES__(__intVal(__ClassInstPtr(__qClass(self))->c_ninstvars));

		cp1 += n;
	    }

	    //
	    // care for instances of subclasses ...
	    //
	    cp2 = __stringVal(aString);
	    if (!argIsString) {
		int n = __OBJS2BYTES__(__intVal(__ClassInstPtr(__qClass(aString))->c_ninstvars));

		cp2 += n;
	    }
	    if (collatingBoolean == true) {
#ifdef HAS_STRCOLL
		cmp = strcoll(cp1, cp2);
#else
		// bail out, to give programmer a chance to do it in Smalltalk (inherited)
		goto getOutOfHere;
#endif
	    } else {
		cmp = strcmp(cp1, cp2);
	    }
	    {
		// int signum = (cmp>0) ? 1 : ((cmp<0) ? -1 : 0);
		int signum = (cmp > 0) - (cmp < 0);
		RETURN( __mkSmallInteger( signum ) );
	    }
	}
    }
getOutOfHere: ;
%}.
    "
     currently, this operation is only defined for strings, symbols and subclasses.
     allow for an implementation in Smalltalk
    "
    ^ super compareWith:aString collating:collatingBoolean
!

hash
    "return an integer useful as a hash-key.
     This default method uses whichever hash algorithm
     used in the ST/X VM (which is actually fnv-1a)"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    STString me = self.asSTString();
    long h = me.hash_fnv1a();
    return __c__._RETURN(STInteger._new(h));
#else
    /* Following code is inlined FNV1a hash. 
     * Inlined for speed (to avoid send).
     * DO NOT use __symbolHash() here as it 
     * does not handle characters with codepoint 0
     * properly - see
     * https://swing.fit.cvut.cz/projects/stx-jv/ticket/65
     */
    REGISTER unsigned int h;
    REGISTER unsigned char *cp;
    int l;

    cp = __stringVal(self);
    l = __stringSize(self);
    if (__qClass(self) == String) {
	cont:    
	h = 2166136261U;
	while (l >= 4) {
	    l -= 4;
	    h = (h ^ cp[0]) * 16777619;
	    h = (h ^ cp[1]) * 16777619;
	    h = (h ^ cp[2]) * 16777619;
	    h = (h ^ cp[3]) * 16777619;
	    cp += 4;
    	}
    	while (l--) {
	    h = (h ^ *cp++) * 16777619;
    	}
    	// make it a smallInteger
    	h = (h ^ (h >> 30)) & 0x3FFFFFFF;
    	RETURN ( __mkSmallInteger(h));
    } else {        
	int n = __OBJS2BYTES__(__intVal(__ClassInstPtr(__qClass(self))->c_ninstvars));
	cp += n;
	goto cont;
    }
#endif /* not SCHTEAM */
%}.
    ^ self primitiveFailed

    "
     'a' hash
     'ab' hash = 'ab' asUnicode16String hash
    "

    "Created: / 26-12-2011 / 13:53:09 / cg"
!

hash_dragonBook
    "return an integer useful as a hash-key.
     This method implements the dragon-book algorithm (aho, ullman)."

%{  /* NOCONTEXT */

    REGISTER unsigned g, val;
    REGISTER unsigned char *cp, *cp0;
    int l;

    cp = __stringVal(self);
    l = __stringSize(self);
    if (__qClass(self) != @global(String)) {
	int n = __OBJS2BYTES__(__intVal(__ClassInstPtr(__qClass(self))->c_ninstvars));

	cp += n;
	l -= n;
    }

    /*
     * this is the dragon-book algorithm
     */

    val = 0;
    switch (l) {
    default:
	for (cp0 = cp, cp += l - 1; cp >= cp0; cp--) {
	    val = (val << 4) + *cp;
	    if ((g = (val & 0xF0000000)) != 0) {
		val ^= g >> 24;
		val ^= g;
	    }
	}
	break;
    case 6:
	val = cp[5] << 4;
    case 5:
	val = (val + cp[4]) << 4;
    case 4:
	val = (val + cp[3]) << 4;
    case 3:
	val = (val + cp[2]) << 4;
    case 2:
	val = (val + cp[1]) << 4;
    case 1:
	val = val + cp[0];
    case 0:
	break;
    }

    /*
     * multiply by large prime to spread values
     * This speeds up Set and Dictionary by a factor of 10!
     */
    val *= 31415821;
    RETURN ( __mkSmallInteger(val & _MAX_INT));
%}.
    ^ self primitiveFailed
!

hash_fnv1a
    "return an integer useful as a hash-key.
     This method uses the fnv-1a algorithm
     (which is actually a pretty good one)."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    STString me = self.asSTString();
    long h = me.hash_fnv1a();
    return __c__._RETURN(STInteger._new(h));
#else
    REGISTER unsigned int h;
    REGISTER unsigned char *cp;
    int l;

    cp = __stringVal(self);
    l = __stringSize(self);
    if (__qClass(self) == String) {
	cont:    
	h = 2166136261U;
	while (l >= 4) {
	l -= 4;
	h = (h ^ cp[0]) * 16777619;
	h = (h ^ cp[1]) * 16777619;
	h = (h ^ cp[2]) * 16777619;
	h = (h ^ cp[3]) * 16777619;
	cp += 4;
    	}
    	while (l--) {
	h = (h ^ *cp++) * 16777619;
    	}
    	// make it a smallInteger
    	h = (h ^ (h >> 30)) & 0x3FFFFFFF;
    	RETURN ( __mkSmallInteger(h));
    } else {        
	int n = __OBJS2BYTES__(__intVal(__ClassInstPtr(__qClass(self))->c_ninstvars));
	cp += n;
	goto cont;
    }
#endif /* not SCHTEAM */
%}.
    ^ self primitiveFailed

    "
     'a' hash_fnv1a
    "
!

hash_java
    "return an integer useful as a hash-key.
     This method uses the same algorithm as used in
     the java virtual machine (which is actually a bad one)."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    STString me = self.asSTString();
    long h = me.hash_java();
    return __c__._RETURN(STInteger._new(h));
#else
    REGISTER unsigned INT val;
    REGISTER unsigned char *cp;
    int l;

    cp = __stringVal(self);
    l = __stringSize(self);
    if (!__qIsStringLike(self)) {
	int n = __OBJS2BYTES__(__intVal(__ClassInstPtr(__qClass(self))->c_ninstvars));

	cp += n;
	l -= n;
    }

    /*
     * this is the jvm algorithm
     */
    val = 0;
    while (l >= 4) {
	l -= 4;
	val = ((val * 31) & 0xFFFFFFFF) + cp[0];
	val = ((val * 31) & 0xFFFFFFFF) + cp[1];
	val = ((val * 31) & 0xFFFFFFFF) + cp[2];
	val = ((val * 31) & 0xFFFFFFFF) + cp[3];
	cp += 4;
    }
    while (l--) {
	val = ((val * 31) & 0xFFFFFFFF) + *cp++;
    }
    RETURN ( __MKUINT(val));
#endif /* not SCHTEAM */
%}.
    ^ self primitiveFailed

    "
     'a' hash_java
    "
!

hash_sdbm
    "return an integer useful as a hash-key.
     This method implements the sdbm algorithm."

%{  /* NOCONTEXT */

    REGISTER unsigned INT val;
    REGISTER unsigned char *cp;
    int l;

    cp = __stringVal(self);
    l = __stringSize(self);
    if (!__qIsStringLike(self)) {
	int n = __OBJS2BYTES__(__intVal(__ClassInstPtr(__qClass(self))->c_ninstvars));

	cp += n;
	l -= n;
    }

    /*
     * this is the sdbm algorithm
     */
    val = 0;
    while (l >= 4) {
	l -= 4;
	val = ((val * 65599) & _MAX_INT) + cp[0];
	val = ((val * 65599) & _MAX_INT) + cp[1];
	val = ((val * 65599) & _MAX_INT) + cp[2];
	val = ((val * 65599) & _MAX_INT) + cp[3];
	cp += 4;
    }
    while (l--) {
	val = ((val * 65599) & _MAX_INT) + *cp++;
    }
    RETURN ( __mkSmallInteger(val & _MAX_INT));
%}.
    ^ self primitiveFailed

    "
     'a' hash
     'ab' hash = 'ab' asUnicode16String hash
    "

    "Created: / 26-12-2011 / 13:53:09 / cg"
!

~= aString
    "Compare the receiver with the argument and return true if the
     receiver is not equal to the argument. Otherwise return false.
     This compare is case-sensitive (i.e. 'Foo' is NOT = 'foo').
     Actually, there is no need to redefine that method here,
     the default (= not as inherited) works ok.
     However, this may be heavily used and the redefinition saves an
     extra message send."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    if (aString == self) {
	return __c__._RETURN_false();
    }
    if (aString.isStringLike()) {
	return __c__._RETURN( self.isStringEqual(aString) ? STObject.False : STObject.True );
    }
    if (aString == STObject.Nil) {
	return __c__._RETURN_true();
    }
#else
    int l1, l2;
    unsigned char *cp1, *cp2;
    OBJ cls, myCls;
    INT addrDelta;
    int argIsString;

    if (aString == self) {
	RETURN ( false );
    }
    if (! __isNonNilObject(aString)) {
	RETURN ( true );
    }

    argIsString = __qIsStringLike(aString);
    if (argIsString || __qClass(aString) == __qClass(self)) {
	cp1 = __stringVal(self);
	l1 = __stringSize(self);
	/*
	 * care for instances of subclasses ...
	 */
	if (!__qIsStringLike(self)) {
	    int n = __OBJS2BYTES__(__intVal(__ClassInstPtr(__qClass(self))->c_ninstvars));

	    cp1 += n;
	    l1 -= n;
	}

	cp2 = __stringVal(aString);
	l2 = __stringSize(aString);
	/*
	 * care for instances of subclasses ...
	 */
	if (!argIsString) {
	    int n = __OBJS2BYTES__(__intVal(__ClassInstPtr(__qClass(aString))->c_ninstvars));

	    cp2 += n;
	    l2 -= n;
	}

	if (l1 != l2) {
	    RETURN ( true );
	}

	addrDelta = cp2 - cp1;
# ifdef __UNROLL_LOOPS__
	while (l1 >= (sizeof(unsigned INT)*4)) {
	    if (((unsigned INT *)cp1)[0] != ((unsigned INT *)(cp1+addrDelta))[0]) {
		RETURN (true);
	    }
	    if (((unsigned INT *)cp1)[1] != ((unsigned INT *)(cp1+addrDelta))[1]) {
		RETURN (true);
	    }
	    if (((unsigned INT *)cp1)[2] != ((unsigned INT *)(cp1+addrDelta))[2]) {
		RETURN (true);
	    }
	    if (((unsigned INT *)cp1)[3] != ((unsigned INT *)(cp1+addrDelta))[3]) {
		RETURN (true);
	    }
	    l1 -= (sizeof(unsigned INT) * 4);
	    cp1 += (sizeof(unsigned INT) * 4);
	}
# endif /* __UNROLL_LOOPS__ */
	while (l1 >= sizeof(unsigned INT)) {
	    if (*((unsigned INT *)cp1) != *((unsigned INT *)(cp1+addrDelta))) {
		RETURN (true);
	    }
	    l1 -= sizeof(unsigned INT);
	    cp1 += sizeof(unsigned INT);
	}
	if (l1 >= sizeof(unsigned short)) {
	    if (*((unsigned short *)cp1) != *((unsigned short *)(cp1+addrDelta))) {
		RETURN (true);
	    }
	    l1 -= sizeof(unsigned short);
	    cp1 += sizeof(unsigned short);
	}
	while (l1) {
	    if (*cp1 != *(cp1+addrDelta)) {
		RETURN (true);
	    }
	    l1--;
	    cp1++;
	}
	RETURN (false);
    }
#endif /* not __SCHTEAM__ */
%}.
    ^ super ~= aString
! !

!String methodsFor:'converting'!

asAsciiZ
    "if the receiver does not end with a 0-valued character, return a copy of it,
     with an additional 0-character. Otherwise return the receiver. This is sometimes
     needed when a string has to be passed to C, which needs 0-terminated strings.
     Notice, that all singleByte strings are already 0-terminated in ST/X, whereas wide
     strings are not."

    ^ self

    "
     'abc' asAsciiZ
     'abc' asWideString asAsciiZ
    "
!

asByteArray
    "return a new ByteArray with the receiver's elements.
     This redefined method is faster than Collection>>#asByteArray"

    |bytes sz|

    sz := self size.
    bytes := ByteArray new:sz .
    bytes replaceFrom:1 to:sz with:self startingAt:1.
    ^ bytes

    "
     'fooBar' asByteArray.
    "

    "Modified (comment): / 26-07-2012 / 22:55:26 / cg"
!

asExternalBytes
    "return a 0-terminated externalBytes collection containing
     my characters.
     The returned collection is save from being garbage collected;
     i.t. it can be handed to a C-function, and must
     (either there or here) be freed explicitly or unprotectedFromGC"

    ^ (ExternalBytes new:(self size + 1))
	replaceNullTerminatedFromString:self

    "
     |x|
     x := 'fooBar' asExternalBytes.
     x unprotectFromGC.
     ObjectMemory garbageCollect
    "

    "Modified: / 03-08-2006 / 14:45:32 / fm"
!

asExternalBytesUnprotected
    "Like asExternalBytes, but does not register the bytes so
     bytes are GARBAGE-COLLECTED!!"

    ^ (ExternalBytes unprotectedNew:(self size + 1))
	replaceNullTerminatedFromString:self

    "
     |x|
     x := 'fooBar' asExternalBytesUnprotected.
     ObjectMemory garbageCollect
    "

    "Created: / 05-06-2012 / 14:12:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-11-2013 / 11:41:40 / cg"
!

asImmutableString
    "return a write-protected copy of myself"

    ^ self copy changeClassTo:ImmutableString
!

asLowercase
    "a tuned version for Strings with size < 255. Some apps call this very heavily.
     We can do this for 8-bit strings, since the mapping is well known and lowercase chars
     fit in one byte also."

%{  /* NOCONTEXT */
#ifndef __SCHTEAM__
    REGISTER OBJ slf = self;

    if (__isStringLike(slf)) {
	char quickBuffer[256];
	int sz = __stringSize(slf);

	if (sz < (sizeof(quickBuffer)-1)) {
	    REGISTER int i = 0;
	    int anyChange = 0;
	    REGISTER unsigned char *cp = __stringVal(slf);

	    // fast advance
	    // all uppercase chars are in the ranges 0x41 .. 0x5A (A..Z)
	    // or 0xC0 .. 0xDF.
	    // I.e. they have the 0x20 bit clear.
	    // Thus, we can fast skip over lowercase, spaces and some punctuation,
	    // if all bytes of a word have the x20 bit set.

#if __POINTER_SIZE__ == 8
	    for (; i < (sz-8); i += 8) {
		unsigned INT eightChars = *(unsigned INT *)(cp+i);
		if ((eightChars & 0x2020202020202020ULL) != 0x2020202020202020ULL) goto convert;
		*(unsigned INT *)(quickBuffer+i) = eightChars;
	    }
#endif
	    for (; i < (sz-4); i += 4) {
		unsigned int fourChars = *(unsigned int *)(cp+i);
		if ((fourChars & 0x20202020U) != 0x20202020U) break;
		*(unsigned int *)(quickBuffer+i) = fourChars;
	    }
convert:
	    for (; i<sz; i++) {
		unsigned char ch = cp[i];

		quickBuffer[i] = ch;
		if ((ch & 0x60) == 0x40) {
		    if (ch >= 'A' && ch <= 'Z') {
			quickBuffer[i] = ch - 'A' + 'a';
			anyChange = 1;
		    } else {
			// deal with national latin1 characters
			if (ch >= 0xC0 && ch <= 0xDE && ch != 0xD7) {
			    quickBuffer[i] = ch + 0x20;
			    anyChange = 1;
			}
		    }
		}
	    }
	    if (! anyChange) {
		RETURN(slf);
	    }
	    quickBuffer[i] = '\0';
	    RETURN (__MKSTRING_L(quickBuffer, i));
	}
    }
#endif /* ! __SCHTEAM__ */
%}.
    ^ super asLowercase

    "
	'Hello WORLD' asLowercase
	(String new:300) asLowercase
    "
!

asPackageId
    "given a package-string as receiver, return a packageId object.
     packageIds hide the details of module/directory handling inside the path.
     See PackageId for the required format of those strings."

    ^ PackageId from: self

    "
     'stx:libbasic' asPackageId
     'stx:goodies/net/ssl' asPackageId
     'stx:hello' asPackageId
    "

    "Created: / 18-08-2006 / 12:19:54 / cg"
!

asSingleByteString
    "I am a string"

    ^ self
!

asSingleByteStringIfPossible
    "I am a single-byte string"

    ^ self
!

asSingleByteStringReplaceInvalidWith:replacementCharacter
    "return the receiver converted to a 'normal' string,
     with invalid characters replaced by replacementCharacter.
     Can be used to convert from 16-bit strings to 8-bit strings
     and replace characters above code-255 with some replacement.
     Dummy here, because I am already a single byte string."

    ^ self

    "Modified: / 07-08-2006 / 15:04:45 / fm"
!

asSymbol
    "Return a unique symbol with the name taken from the receiver's characters."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( STSymbol._new(self.asString()) );
#else
    OBJ newSymbol;
    OBJ cls;
    char *cp = __stringVal(self);

    /* care for instances of a subclass with instVars */
    cls = __qClass(self);
    if (cls != String) {
	cp += __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));
    }
    newSymbol = __MKSYMBOL(cp, (OBJ *)0);
    if (newSymbol) {
	RETURN ( newSymbol);
    }
#endif /* not __SCHTEAM__ */
%}.
    ^ AllocationFailure raise.

    "
     'hello' asSymbol
    "
!

asSymbolIfInterned
    "If a symbol with the receiver's characters is already known, return it. Otherwise, return nil.
     This can be used to query for an existing symbol and is the same as:
	self knownAsSymbol ifTrue:[self asSymbol] ifFalse:[nil]
     but slightly faster, since the symbol lookup operation is only
     performed once."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    STObject symbolOrNull = STSymbol.asSymbolIfInterned( self.asString() );

    return context._RETURN( symbolOrNull == null ? STObject.Nil : symbolOrNull );
#else
    OBJ cls = __qClass(self);
    int indx;

    if (cls != String && cls != ImmutableString) {
	indx = __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));
    } else {
	indx = 0;
    }
    RETURN ( __SYMBOL_OR_NIL(__stringVal(self) + indx));
#endif /* not __SCHTEAM__ */
%}.
    ^ self primitiveFailed
    "
     'hello' asSymbolIfInterned
     'fooBarBaz' asSymbolIfInterned
    "
!

beImmutable
    "make myself write-protected"

    super beImmutable.
    self changeClassTo:ImmutableString
!

withTabsExpanded:numSpaces
    "return a string with the characters of the receiver where all tabulator characters
     are expanded into spaces (assuming numSpaces-col tabs).
     Notice: if the receiver does not contain any tabs, it is returned unchanged;
     otherwise a new string is returned.
     This does handle multiline strings.
     Rewritten for speed - because this is very heavily used when reading
     big files in the FileBrowser (and therefore speeds up fileReading considerably)."

%{  /* STACK:700 */
    unsigned char buffer[80*8 + 10];
    unsigned char *srcP, *dstP, *cp0;
    int idx, sz;
    int any = 0;
    OBJ newString;
    char c;
    int n;

    if ((__qClass(self) == String)
     && __isSmallInteger(numSpaces)) {
	n = __intVal(numSpaces);

	/*
	 * for small strings (< 80), do it without a prescan ...
	 * the buffer is large enough to even convert a
	 * receiver consisting fully of tabs.
	 */
	if (__stringSize(self) < 80) {
	    idx = 1;
	    for (srcP = __stringVal(self), dstP = buffer; (c = *srcP); srcP++) {
		if (c == '\t') {
		    any = 1;
		    while (idx % n) {
			idx++;
			*dstP++ = ' ';
		    }
		    idx++;
		    *dstP++ = ' ';
		} else {
		    *dstP++ = c;
		    idx++;
		    if (c == '\n') {
			idx = 1;
		    }
		}
	    }
	    if (! any) RETURN(self);
	    *dstP = '\0';
	    RETURN (__MKSTRING_L(buffer, (dstP-buffer)));
	}
	/*
	 * for large strings, we compute the new size, allocate a new string
	 * and expand it.
	 *
	 * first, scan for size ...
	 */
	idx = 1;
	for (srcP = __stringVal(self), sz = 0; (c = *srcP); srcP++) {
	    if (c == '\t') {
		any = 1;
		while (idx % n) {
		    idx++;
		    sz++;
		}
		idx++; sz ++;
	    } else {
		sz++; idx++;
		if (c == '\n') {
		    idx = 1;
		}
	    }
	}
	if (! any) RETURN(self);

	/*
	 * get the string
	 */
	sz = OHDR_SIZE + sz + 1;
	__qNew(newString, sz);  /* OBJECT ALLOCATION */
	if (newString != nil) {
	    __InstPtr(newString)->o_class = String;
	    __qSTORE(newString, String);

	    /*
	     * expand
	     */
	    idx = 1;
	    for (srcP = __stringVal(self), dstP = cp0 = __stringVal(newString); (c = *srcP); srcP++) {
		if (c == '\t') {
		    while (idx % n) {
			idx++;
			*dstP++ = ' ';
		    }
		    idx++;
		    *dstP++ = ' ';
		} else {
		    *dstP++ = c; idx++;
		    if (c == '\n') {
			idx = 1;
		    }
		}
	    }
	    *dstP++ = '\0';
	    RETURN (newString);
	}
    }
%}.
    ^ super withTabsExpanded:numSpaces
! !

!String methodsFor:'copying'!

, aStringOrCharacter
    "return the concatenation of myself and the argument, aStringOrCharacter as a String.
     - reimplemented here for speed"

%{
#ifdef __SCHTEAM__
    if ( aStringOrCharacter.isStringLike() && self.isStringLike() ) {
	STString me = self.asSTString();
	STString other = aStringOrCharacter.asSTString();
	int myLength = me.characters.length;
	int otherLength = other.characters.length;

	char[] newChars = new char[myLength + otherLength];
	System.arraycopy(me.characters, 0, newChars, 0, myLength);
	System.arraycopy(other.characters, 0, newChars, myLength, otherLength);
	return context._RETURN( new STString( newChars ));
    }
#else
    /*
     * can do it here if both are Strings/Symbols:
     */
    if (__qIsStringLike(self)) {
	char *cp1 = (char *) __stringVal(self);
	INT l1 = __stringSize(self);
	INT l2;
	char *cp2 = 0;
	INT sz;
	OBJ newString;
	char character;

	if (__isCharacter(aStringOrCharacter)) {
	    if (__intVal(__characterVal(aStringOrCharacter)) <= 0 || __intVal(__characterVal(aStringOrCharacter)) > 255)
		goto out;

	    character = __intVal(__characterVal(aStringOrCharacter));
	    l2 = 1;
	    cp2 = &character;
	} else if (__isStringLike(aStringOrCharacter)) {
	    l2 = __stringSize(aStringOrCharacter);
	} else
	    goto out;

	/* 
	 * FIXME: check for overflow!!! 
	 */
	sz = OHDR_SIZE + l1 + l2 + 1;
	__qNew(newString, sz);      /* OBJECT ALLOCATION */

	cp1 = (char *) __stringVal(self);
	if (cp2 == 0)
	    cp2 = (char *) __stringVal(aStringOrCharacter);

	if (newString != nil) {
	    REGISTER unsigned char *dstp;

	    __InstPtr(newString)->o_class = String;
	    __qSTORE(newString, String);
	    dstp = __stringVal(newString);

# if defined(bcopy4)
	    /* knowing that allocation is 4-byte aligned and
	     * size rounded up to next 4-byte, the first copy
	     * can be done word-wise.
	     * that speeds up size-10-string , size-10-string
	     * by 10% on a P5/200.
	     */
	    {
		INT nw = l1 >> 2;

		if (l1 & 3) nw++;
		bcopy4(cp1, dstp, nw);
		dstp += l1;
	    }
# elif defined(FAST_MEMCPY)
	    memcpy(dstp, cp1, l1);
	    dstp += l1;
# else
	    while (l1 >= 4) {
		*(int *)dstp = *(int *)cp1;
		dstp += 4; cp1 += 4;
		l1 -= 4;
	    }
	    while (l1--) *dstp++ = *cp1++;
# endif

# ifdef bcopy4
	    if (((INT)dstp & 3) == 0) {
		INT nw = l2 >> 2;

		if (l2 & 3) nw++;
		bcopy4(cp2, dstp, nw);
		*(dstp + l2) = '\0';
		RETURN ( newString );
	    }
# endif

# ifdef FAST_MEMCPY
	    memcpy(dstp, cp2, l2+1);
	    dstp[l2] = '\0';
# else
	    while (l2--) *dstp++ = *cp2++;
	    *dstp = '\0';
# endif
	    RETURN ( newString );
	}
    }
out:;
#endif /* not SCHTEAM */
%}.
    ^ super , aStringOrCharacter

    "
     'hello' , ' world' asImmutableString
     'hello ' , #world
     'hello ' , $w
     #[0 0 0 1] asString, #[0 0 0 2 0] asString
    "

    "Modified: / 01-04-2012 / 13:19:44 / cg"
!

concatenate:string1 and:string2
    "return the concatenation of myself and the arguments, string1 and string2.
     This is equivalent to self , string1 , string2
     - generated by compiler when such a construct is detected"

    |newString|

%{
    int len1, len2, len3, sz;
#if !defined(FAST_MEMCPY)
    REGISTER unsigned char *srcp;
#endif
    REGISTER unsigned char *dstp;

    if (__qIsStringLike(self)
	    && __isStringLike(string1)
	    && __isStringLike(string2)) {
	len1 = __stringSize(self);
	len2 = __stringSize(string1);
	len3 = __stringSize(string2);
	sz = OHDR_SIZE + len1 + len2 + len3 + 1;
	__qNew(newString, sz);  /* OBJECT ALLOCATION */
	if (newString != nil) {
	    __InstPtr(newString)->o_class = String;
	    __qSTORE(newString, String);
	    dstp = __stringVal(newString);
#ifdef FAST_MEMCPY
	    memcpy(dstp, __stringVal(self), len1);
	    memcpy(dstp + len1, __stringVal(string1), len2);
	    memcpy(dstp + len1 + len2, __stringVal(string2), len3+1);
	    *(dstp + len1 + len2 + len3) = '\0';
#else
	    srcp = __stringVal(self);
	    while (len1--) *dstp++ = *srcp++;
	    srcp = __stringVal(string1);
	    while (len2--) *dstp++ = *srcp++;
	    srcp = __stringVal(string2);
	    while (len3--) *dstp++ = *srcp++;
	    *dstp = '\0';
#endif
	    RETURN ( newString );
	}
    }
%}.
    ^ super , string1 , string2
!

concatenate:string1 and:string2 and:string3
    "return the concatenation of myself and the string arguments.
     This is equivalent to self , string1 , string2 , string3
     - generated by compiler when such a construct is detected"

    |newString|

%{
    int len1, len2, len3, len4, sz;
#if !defined(FAST_MEMCPY)
    REGISTER unsigned char *srcp;
#endif
    REGISTER unsigned char *dstp;

    if (__qIsStringLike(self)
     && __isStringLike(string1)
     && __isStringLike(string2)
     && __isStringLike(string3)) {
	len1 = __stringSize(self);
	len2 = __stringSize(string1);
	len3 = __stringSize(string2);
	len4 = __stringSize(string3);
	sz = OHDR_SIZE + len1 + len2 + len3 + len4 + 1;
	__qNew(newString, sz);  /* OBJECT ALLOCATION */
	if (newString != nil) {
	    __InstPtr(newString)->o_class = String;
	    __qSTORE(newString, String);
	    dstp = __stringVal(newString);
#ifdef FAST_MEMCPY
	    memcpy(dstp, __stringVal(self), len1);
	    memcpy(dstp + len1, __stringVal(string1), len2);
	    memcpy(dstp + len1 + len2, __stringVal(string2), len3);
	    memcpy(dstp + len1 + len2 + len3, __stringVal(string3), len4+1);
	    *(dstp + len1 + len2 + len3 + len4) = '\0';
#else
	    srcp = __stringVal(self);
	    while (len1--) *dstp++ = *srcp++;
	    srcp = __stringVal(string1);
	    while (len2--) *dstp++ = *srcp++;
	    srcp = __stringVal(string2);
	    while (len3--) *dstp++ = *srcp++;
	    srcp = __stringVal(string3);
	    while (len4--) *dstp++ = *srcp++;
	    *dstp = '\0';
#endif
	    RETURN ( newString );
	}
    }
%}.
    ^ super , string1 , string2 , string3
!

copy
    "return a copy of the receiver"

    (self class == String) ifTrue:[
	^ self copyFrom:1
    ].
    ^ super copy
!

copyFrom:start
    "return a new collection consisting of receiver's elements from startIndex to the end of the collection.
     This method will always return a string, even if the receiver
     is a subclass-instance. This might change if there is a need.
     - reimplemented here for speed"

%{  /* NOCONTEXT */

    REGISTER unsigned char *srcp;
    REGISTER unsigned char *dstp;
    REGISTER int count;
    int len, index1, sz;
    OBJ newString;

#ifndef NO_PRIM_STRING
    if (__isSmallInteger(start) && __qIsStringLike(self)) {
	len = __stringSize(self);
	index1 = __intVal(start);
	if (index1 > 0) {
	    if (index1 <= len) {
		count = len - index1 + 1;
		sz = OHDR_SIZE + count + 1;

		__PROTECT_CONTEXT__
		__qNew(newString, sz);  /* OBJECT ALLOCATION */
		__UNPROTECT_CONTEXT__

		if (newString != nil) {
		    __InstPtr(newString)->o_class = String;
		    __qSTORE(newString, String);
		    dstp = __stringVal(newString);
		    srcp = __stringVal(self) + index1 - 1;
#ifdef FAST_MEMCPY
		    memcpy(dstp, srcp, count);
		    dstp[count] = '\0';
#else
		    while (count--) {
			*dstp++ = *srcp++;
		    }
		    *dstp = '\0';
#endif
		    RETURN ( newString );
		}
	    }
	}
    }
#endif
%}.
    "fall back in case of non-integer index or out-of-bound index;
     will eventually lead to an out-of-bound signal raise"

    ^ super copyFrom:start

    "
	'12345' copyFrom:3
	'12345678' copyFrom:9 -> empty string
	'12345678' copyFrom:0 -> error
    "
!

copyFrom:start to:stop
    "return the substring starting at index start, anInteger and ending
     at stop, anInteger. This method will always return a string, even
     if the receiver is a subclass-instance. This might change if there is a need.
     - reimplemented here for speed"

%{  /* NOCONTEXT */

    REGISTER unsigned char *srcp;
    REGISTER unsigned char *dstp;
    REGISTER int count;
    int len, sz, index1, index2;
    OBJ newString;

#ifndef NO_PRIM_STRING
    if (__bothSmallInteger(start, stop) && __qIsStringLike(self)) {
	len = __stringSize(self);
	index1 = __intVal(start);
	index2 = __intVal(stop);

	if ((index1 <= index2) && (index1 > 0)) {
	    if (index2 <= len) {
		count = index2 - index1 + 1;
		sz = OHDR_SIZE + count + 1;

		__PROTECT_CONTEXT__
		__qNew(newString, sz);  /* OBJECT ALLOCATION */
		__UNPROTECT_CONTEXT__

		if (newString != nil) {
		    __InstPtr(newString)->o_class = String;
		    __qSTORE(newString, String);
		    dstp = __stringVal(newString);
		    srcp = __stringVal(self) + index1 - 1;
#ifdef bcopy4
		    {
			int nw = count >> 2;

			if (count & 3) {
			    nw++;
			}
			bcopy4(srcp, dstp, nw);
			dstp[count] = '\0';
		    }
#else
# ifdef FAST_MEMCPY
		    memcpy(dstp, srcp, count);
		    dstp[count] = '\0';
# else
		    while (count--) {
			*dstp++ = *srcp++;
		    }
		    *dstp = '\0';
# endif
#endif
		    RETURN ( newString );
		}
	    }
	}
	/*
	 * allow empty copy
	 */
	if (index1 > index2) {
	    __PROTECT_CONTEXT__
	    __qNew(newString, OHDR_SIZE+1);     /* OBJECT ALLOCATION */
	    __UNPROTECT_CONTEXT__
	    if (newString != nil) {
		__InstPtr(newString)->o_class = String;
		(__stringVal(newString))[0] = '\0';
		RETURN ( newString );
	    }
	}
    }
#endif
%}.
    "fall back in case of non-integer index or out-of-bound index;
     will eventually lead to an out-of-bound signal raise"

    ^ super copyFrom:start to:stop

    "
	'12345678' copyFrom:3 to:7
	'12345678' copyFrom:3 to:3
	'12345678' copyFrom:3 to:2 -> empty string

	'12345678' copyFrom:9 to:9 -> error
	'12345678' copyFrom:3 to:9 -> error
	'12345678' copyFrom:0 to:8 -> error

	(Unicode16String with:(Character value:16r220) with:$a with:$b with:(Character value:16r221) with:(Character value:16r222))
	    copyFrom:2 to:3
	((Unicode16String with:(Character value:16r220) with:$a with:$b with:(Character value:16r221) with:(Character value:16r222))
	    copyFrom:2 to:3) asSingleByteString
    "
!

copyWith:aCharacter
    "return a new string containing the receiver's characters
     and the single new character, aCharacter.
     This is different from concatentation, which expects another string
     as argument, but equivalent to copy-and-addLast.
     Reimplemented here for more speed"

%{  /* NOCONTEXT */

    int count;
    int sz;
    REGISTER unsigned char *dstp;
    OBJ cls, newString;

#ifndef NO_PRIM_STRING
    if (__isCharacter(aCharacter)) {
	unsigned int cVal = __intVal(__characterVal(aCharacter));

	if ((cVal <= 0xFF) && __qIsStringLike(self)) {
	    count = __stringSize(self);
	    sz = OHDR_SIZE + count + 1 + 1;

	    __PROTECT_CONTEXT__
	    __qNew(newString, sz);  /* OBJECT ALLOCATION */
	    __UNPROTECT_CONTEXT__

	    if (newString) {
		__InstPtr(newString)->o_class = String;
		__qSTORE(newString, String);
		dstp = __stringVal(newString);

# ifdef bcopy4
		{
		    int nw = count >> 2;
		    char *srcp = (char *)__stringVal(self);

		    if (count & 3) {
			nw++;
		    }
		    bcopy4(srcp, dstp, nw);
		    dstp += count;
		}
# else
#  ifdef FAST_MEMCPY
		memcpy(dstp, __stringVal(self), count);
		dstp += count;
#  else
		{
		    REGISTER unsigned char *srcp;

		    srcp = __stringVal(self);
		    while ((*dstp = *srcp++) != '\0')
			dstp++;
		}
#  endif
# endif
		*dstp++ = cVal;
		*dstp = '\0';
		RETURN (newString );
	    }
	}
    }
#endif
%}.
    "fall back in case of non-character arg or non-single-byte character.
     will lead to an bad element signal raise or a UnicodeString to be returned"

    ^ super copyWith:aCharacter

    "
     '1234567' copyWith:$8
     '1234567' copyWith:(Character value:16r220)
    "
!

deepCopy
    "return a copy of the receiver"

    "
     could be an instance of a subclass which needs deepCopy
     of its named instvars ...
    "
    (self class == String) ifTrue:[
	^ self copyFrom:1
    ].
    ^ super deepCopy
!

deepCopyUsing:aDictionary postCopySelector:postCopySelector
    "return a deep copy of the receiver - reimplemented to be a bit faster"

    "
     could be an instance of a subclass which needs deepCopy
     of its named instvars ...
    "
    (self class == String) ifTrue:[
	^ self copyFrom:1
    ].
    ^ super deepCopyUsing:aDictionary postCopySelector:postCopySelector
!

shallowCopy
    "return a copy of the receiver"

    (self class == String) ifTrue:[
	^ self copyFrom:1
    ].
    ^ super shallowCopy
!

simpleDeepCopy
    "return a copy of the receiver"

    "
     could be an instance of a subclass which needs deepCopy
     of its named instvars ...
    "
    (self class == String) ifTrue:[
	^ self copyFrom:1
    ].
    ^ super simpleDeepCopy
! !


!String methodsFor:'filling & replacing'!

atAllPut:aCharacter
    "replace all elements with aCharacter
     - reimplemented here for speed"

%{  /* NOCONTEXT */

#ifndef FAST_MEMSET
    REGISTER unsigned char *dst;
#endif
    REGISTER int l;
    REGISTER int byteValue;

    if (__isCharacter(aCharacter) && __isString(self)) {
	byteValue = __intVal(__characterVal(aCharacter));
	if ((unsigned)byteValue <= 0xFF) {
	    l = __stringSize(self);

#ifdef FAST_MEMSET
	    if (l > 0) {
		memset(__stringVal(self), byteValue, l);
	    }
#else
	    {
		INT v;

		v = (byteValue << 8) | byteValue;
		v = (v << 16) | v;

		dst = __stringVal(self);

# ifdef FAST_MEMSET4 /* sorry intel: your stosd instruction is slower ... */
		if (l > 0) {
		    memset4(dst, v, l>>2);
		    l = l & 3;
		}
# else
#  ifdef UINT64
		{
		    UINT64 v64;

		    v64 = v;
		    v64 = (v64 << 32) | v;
		    while (l >= 8) {
			((UINT64 *)dst)[0] = v64;
			dst += 8;
			l -= 8;
		    }
		}
#  else /* no UINT64 */
		while (l >= 16) {
		    ((int *)dst)[0] = v;
		    ((int *)dst)[1] = v;
		    ((int *)dst)[2] = v;
		    ((int *)dst)[3] = v;
		    dst += 16;
		    l -= 16;
		}
		if (l >= 8) {
		    ((int *)dst)[0] = v;
		    ((int *)dst)[1] = v;
		    dst += 8;
		    l -= 8;
		}
		if (l >= 4) {
		    ((int *)dst)[0] = v;
		    dst += 4;
		    l -= 4;
		}
#   if 0
		if (l >= 2) {
		    ((short *)dst)[0] = v;
		    dst += 2;
		    l -= 2;
		}
#   endif

#  endif /* UINT64 */
# endif /* FAST_MEMSET4 */
	    }

	    /*
	     * remaining bytes
	     */
	    while (l-- > 0)
		*dst++ = byteValue;

#endif /* no FAST_MEMSET */

	    RETURN ( self );
	}
    }
%}.
    ^ super atAllPut:aCharacter

    "
     (String new:10) atAllPut:$*
     String new:10 withAll:$*
    "
!

replaceAll:oldCharacter with:newCharacter
    "replace all oldCharacters by newCharacter in the receiver.

     Notice: This operation modifies the receiver, NOT a copy;
     therefore the change may affect all others referencing the receiver."

%{  /* NOCONTEXT */

    REGISTER unsigned char *srcp;
    REGISTER unsigned oldVal, newVal;
    unsigned char c, cNext;

    if (__isCharacter(oldCharacter)
     && __isCharacter(newCharacter)
     && __isString(self)) {
	srcp = (unsigned char *)__stringVal(self);
	oldVal = __intVal(__characterVal(oldCharacter));
	newVal = __intVal(__characterVal(newCharacter));
	if ((oldVal <= 0xFF)
	 && (newVal <= 0xFF)) {
	    cNext = *srcp;
	    while ((c = cNext) != '\0') {
		cNext = srcp[1];
		if (c == oldVal)
		    *srcp = newVal;
		srcp++;
	    }
	}
	RETURN ( self );
    }
%}.
    newCharacter isCharacter ifFalse:[self halt:'please change the sender'].
    ^ super replaceAll:oldCharacter with:newCharacter

    "
     'helloWorld' copy replaceAll:$o with:$O
     'helloWorld' copy replaceAll:$d with:$*
     'helloWorld' copy replaceAll:$h with:$*
    "
!

replaceFrom:start to:stop with:aString startingAt:repStart
    "replace the characters starting at index start, anInteger and ending
     at stop, anInteger with characters from aString starting at repStart.
     Return the receiver.

     - reimplemented here for speed"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    if ( aString.isStringLike()
     && self.isStringLike()
     && start.isSmallInteger()
     && stop.isSmallInteger()
     && repStart.isSmallInteger()) {
	STString me = self.asSTString();
	STString other = aString.asSTString();
	int _start = start.intValue() - 1;
	int _stop = stop.intValue() - 1;
	int _repStart = repStart.intValue() - 1;
	int mySize = me.characters.length;
	int otherSize = other.characters.length;
	int count = _stop - _start + 1;

	if (_start >= 0
	 && _repStart >= 0
	 && _stop < mySize
	 && (_repStart + count) <= otherSize) {
	    if (count > 0) {
		System.arraycopy(other.characters, _repStart, me.characters, _start, count);
	    }
	    return context._RETURN(self);
	}
    }
#else

    REGISTER unsigned char *srcp, *dstp;
    REGISTER int count;
    int len, index1, index2;
    int repLen, repIndex;

# ifndef NO_PRIM_STRING
    if (__isStringLike(aString)
     && __isString(self)
     && __bothSmallInteger(start, stop)) {
	len = __stringSize(self);
	index1 = __intVal(start);
	index2 = __intVal(stop);
	count = index2 - index1 + 1;
	if (count <= 0) {
	     RETURN (self);
	}
	if ((index2 <= len) && (index1 > 0)) {
	    repLen = __stringSize(aString);
	    repIndex = __intVal(repStart);
	    if ((repIndex > 0) && ((repIndex + count - 1) <= repLen)) {
		srcp = __stringVal(aString) + repIndex - 1;
		dstp = __stringVal(self) + index1 - 1;
		if (aString == self) {
		    /* take care of overlapping copy */
		    memmove(dstp, srcp, count);
		    RETURN (self);
		}
#  ifdef bcopy4
		/* copy quadbytes if pointers are aligned */
		/*
		 * no sizeof(int) here please -
		 * - bcopy4 (if defined) copies 4-bytes on ALL machines
		 */
		if ((count > 12)
		 && (((unsigned INT)srcp & 3) == 0)
		 && (((unsigned INT)dstp & 3) == 0)) {
		    int n;

		    n = count >> 2;        /* make it quads */
		    bcopy4(srcp, dstp, n);
		    n <<= 2;               /* back to chars */
		    dstp += n;
		    srcp += n;
		    count -= n;
		}
		while (count-- > 0) {
		    *dstp++ = *srcp++;
		}
#  else
#   ifdef FAST_MEMCPY
		memcpy(dstp, srcp, count);
#   else
		/* copy longs if pointers are aligned */
		if ((((unsigned INT)srcp & (sizeof(INT)-1)) == 0)
		 && (((unsigned INT)dstp & (sizeof(INT)-1)) == 0)) {
		    while (count >= sizeof(INT)) {
			*((unsigned INT *)dstp) = *((unsigned INT *)srcp);
			dstp += sizeof(INT);
			srcp += sizeof(INT);
			count -= sizeof(INT);
		    }
		}
		while (count-- > 0) {
		    *dstp++ = *srcp++;
		}
#   endif
#  endif
		RETURN (self);
	    }
	}
    }
# endif
#endif /* not SCHTEAM */
%}.
    ^ super replaceFrom:start to:stop with:aString startingAt:repStart
!

withoutSeparators
    "return a string containing the chars of myself
     without leading and trailing whitespace.
     If there is no whitespace, the receiver is returned.
     Notice, this is different from String>>withoutSpaces."

    |startIndex "{ Class: SmallInteger }"
     endIndex   "{ Class: SmallInteger }"
     sz|

    startIndex := 0.

%{
    REGISTER unsigned char *cp;
    REGISTER unsigned char *ep;
    REGISTER unsigned char c;
    REGISTER unsigned char *cp0;
    REGISTER unsigned char *ep0;

    /* ignore instances of subclasses ... */
    if (__qClass(self) == String) {
	cp = cp0 = __stringVal(self);

	/*
	 * find first non-whiteSpace from beginning
	 */
#ifdef UINT64
	while (*((UINT64 *)cp) == 0x2020202020202020L) {
	    cp += 8;
	}
#endif
	while (*((unsigned *)cp) == 0x20202020) {
	    cp += 4;
	}
	while ((c = *cp)
	 && (c <= ' ')
	 && ((c == ' ') || (c == '\n') || (c == '\t')
			|| (c == '\r') || (c == '\f'))
	) {
	    cp++;
	}

	/*
	 * find first non-whiteSpace from end
	 */
	ep = ep0 = cp0 + __stringSize(self) - 1;
	while ((ep >= cp) && (*ep == ' ')) ep--;
	c = *ep;
	while ((ep >= cp) &&
	       (c <= ' ') &&
	       ((c == ' ') || (c == '\n') || (c == '\t')
			   || (c == '\r') || (c == '\f'))) {
	    ep--;
	    c = *ep;
	}

	/*
	 * no whiteSpace ?
	 */
	if ((cp == cp0) && (ep == ep0)) {
	    RETURN(self);
	}

	startIndex = __mkSmallInteger(cp - cp0 + 1);
	endIndex = __mkSmallInteger(ep - cp0 + 1);
    }
%}.
    startIndex == 0 ifTrue:[^ super withoutSeparators].

    startIndex > endIndex ifTrue:[^ ''].
    ^ self copyFrom:startIndex to:endIndex

    "
     'hello' withoutSeparators
     '    hello' withoutSeparators
     '    hello ' withoutSeparators
     '    hello  ' withoutSeparators
     '    hello   ' withoutSeparators
     '    hello    ' withoutSeparators
     '        ' withoutSeparators
    "
!

withoutSpaces
    "return a string containing the characters of myself
     without leading and trailing spaces.
     If there are no spaces, the receiver is returned unchanged.
     Notice, this is different from String>>withoutSeparators."

    |startIndex "{ Class: SmallInteger }"
     endIndex   "{ Class: SmallInteger }"
     sz blank|

    startIndex := 0.
%{
    REGISTER unsigned char *cp;
    REGISTER unsigned char *ep;
    unsigned char *cp0;
    unsigned char *ep0;

    /* ignore instances of subclasses ... */
    if (__qClass(self) == String) {
	cp = cp0 = __stringVal(self);

	/*
	 * find first non-blank from beginning
	 */
#ifdef UINT64
	while (*((UINT64 *)cp) == 0x2020202020202020L) {
	    cp += 8;
	}
#endif /* UINT64 */
	while (*((unsigned *)cp) == 0x20202020) {
	    cp += 4;
	}
	while (*cp == ' ') cp++;

	/*
	 * find first non-blank from end
	 */
	ep = ep0 = cp0 + __stringSize(self) - 1;
	while ((ep >= cp) && (*ep == ' ')) ep--;

	/*
	 * no blanks ?
	 */
	if ((cp == cp0) && (ep == ep0)) {
	    RETURN(self);
	}

	startIndex = __mkSmallInteger(cp - cp0 + 1);
	endIndex = __mkSmallInteger(ep - cp0 + 1);
    }
%}.
    startIndex == 0 ifTrue:[^ super withoutSpaces].

    startIndex > endIndex ifTrue:[^ ''].
    ((startIndex == 1) and:[endIndex == self size]) ifTrue:[^ self].
    ^ self copyFrom:startIndex to:endIndex

    "
     '    hello' withoutSpaces
     '    hello ' withoutSpaces
     '    hello  ' withoutSpaces
     '    hello   ' withoutSpaces
     '    hello    ' withoutSpaces
     '        ' withoutSpaces
    "
! !

!String methodsFor:'printing & storing'!

_errorPrint
    "Do not use this in user code.
     Print the receiver on standard error.
     This method does NOT (by purpose) use the stream classes and
     will therefore work even in case of emergency during early startup
     or in a crash situation (MiniDebugger)."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    if (self.isStringLike()) {
        org.exept.stj.STSystem.err.print(self.asString());
        return context._RETURN(self);
    }
#else
    if (__qIsStringLike(self)) {
        console_fprintf(stderr, "%s" , __stringVal(self));
        console_fflush(stderr);
        RETURN (self);
    }
#endif /* not SCHTEAM */
%}.
!

_errorPrintCR
    "Do not use this in user code.
     Print the receiver on standard error.
     This method does NOT (by purpose) use the stream classes and
     will therefore work even in case of emergency during early startup
     or in a crash situation (MiniDebugger)."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    if (self.isStringLike()) {
        org.exept.stj.STSystem.err.println(self.asString());
        return context._RETURN(self);
    }
#else
    if (__qIsStringLike(self)) {
        console_fprintf(stderr, "%s\n" , __stringVal(self));
        console_fflush(stderr);
        RETURN (self);
    }
#endif
%}.
!

_print
    "Do not use this in user code.
     Print the receiver on standard output.
     This method does NOT (by purpose) use the stream classes and
     will therefore work even in case of emergency during early startup
     or in a crash situation (MiniDebugger)."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    org.exept.stj.STSystem.out.print(self.toString());
    return context._RETURN(self);
#else
    if (__qIsStringLike(self)) {
        console_fprintf(stdout, "%s" , __stringVal(self));
        console_fflush(stdout);
        RETURN (self);
    }
#endif
%}.
!

_printCR
    "Do not use this in user code.
     Print the receiver on standard output.
     This method does NOT (by purpose) use the stream classes and
     will therefore work even in case of emergency during early startup
     or in a crash situation (MiniDebugger)."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    org.exept.stj.STSystem.out.println(self.toString());
    return context._RETURN(self);
#else
    if (__qIsStringLike(self)) {
        console_fprintf(stdout, "%s\n" , __stringVal(self));
        console_fflush(stdout);
        RETURN (self);
    }
#endif
%}.
!

displayString
    "return a string used when displaying the receiver in a view."

    ^ super displayString.
"/    ^ self storeString.

    "
     'hello' -> 'hello'
    "
!

errorPrint
    "print the receiver on standard error, if the global Stderr is nil;
     otherwise, fall back to the inherited errorPrint, which sends the string to
     the Stderr stream or to a logger.
     Redefined to be able to print during early startup, 
     when the stream classes have not yet been initialized (i.e. Stderr is nil)."

    Stderr isNil ifTrue:[
        self _errorPrint
    ] ifFalse:[
        super errorPrint
    ].

    "
      'hello world' asUnicode16String errorPrint
      (Character value:356) asString errorPrint
      'Bönnigheim' errorPrint
      'Bönnigheim' asUnicodeString errorPrint
    "
!

errorPrintCR
    "print the receiver on standard error, followed by a cr,
     if the global Stderr is nil; otherwise, fall back to the inherited errorPrintCR,
     which sends the string to the Stderr stream or to a logger.
     Redefined to be able to print during early startup, 
     when the stream classes have not yet been initialized (i.e. Stderr is nil)."

    Stderr isNil ifTrue:[
        self _errorPrintCR
    ] ifFalse:[
        super errorPrintCR
    ].
!

lowLevelErrorPrint
    "Do not use this in user code.
     Print the receiver on standard error.
     This method does NOT (by purpose) use the stream classes and
     will therefore work even in case of emergency during early startup
     or in a crash situation (MiniDebugger)."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    if (self.isStringLike()) {
        org.exept.stj.STSystem.err.print(self.asString());
        return context._RETURN(self);
    }
#else
    if (__qIsStringLike(self)) {
        console_fprintf(stderr, "%s" , __stringVal(self));
        console_fflush(stderr);
        RETURN (self);
    }
#endif /* not SCHTEAM */
%}.

    "
      'hello world' asUnicode16String errorPrint
      (Character value:356) asString errorPrint
      'Bönnigheim' errorPrint
      'Bönnigheim' asUnicodeString errorPrint
    "
!

lowLevelErrorPrintCR
    "Do not use this in user code.
     Print the receiver on standard error.
     This method does NOT (by purpose) use the stream classes and
     will therefore work even in case of emergency during early startup
     or in a crash situation (MiniDebugger)."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    if (self.isStringLike()) {
        org.exept.stj.STSystem.err.println(self.asString());
        return context._RETURN(self);
    }
#else
    if (__qIsStringLike(self)) {
        console_fprintf(stderr, "%s\n" , __stringVal(self));
        console_fflush(stderr);
        RETURN (self);
    }
#endif
%}.
!

lowLevelPrint
    "Do not use this in user code.
     Print the receiver on standard output.
     This method does NOT (by purpose) use the stream classes and
     will therefore work even in case of emergency during early startup
     or in a crash situation (MiniDebugger)."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    org.exept.stj.STSystem.out.print(self.toString());
    return context._RETURN(self);
#else
    if (__qIsStringLike(self)) {
        console_fprintf(stdout, "%s" , __stringVal(self));
        console_fflush(stdout);
        RETURN (self);
    }
#endif
%}.
!

lowLevelPrintCR
    "Do not use this in user code.
     Print the receiver on standard output.
     This method does NOT (by purpose) use the stream classes and
     will therefore work even in case of emergency during early startup
     or in a crash situation (MiniDebugger)."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    org.exept.stj.STSystem.out.println(self.toString());
    return context._RETURN(self);
#else
    if (__qIsStringLike(self)) {
        console_fprintf(stdout, "%s\n" , __stringVal(self));
        console_fflush(stdout);
        RETURN (self);
    }
#endif
%}.
!

print
    "print the receiver on standard output, if the global Stdout is nil;
     otherwise, fall back to the inherited print,
     which sends the string to the Stdout stream.
     Redefined to be able to print during early startup, 
     when the stream classes have not yet been initialized (i.e. Stdout is nil)."

    Stdout isNil ifTrue:[
        self _print
    ] ifFalse:[
        super print
    ].
!

printCR
    "print the receiver on standard output, followed by a cr,
     if the global Stdout is nil; otherwise, fall back to the inherited errorPrintCR,
     which sends the string to the Stdout stream.
     Redefined to be able to print during early startup, 
     when the stream classes have not yet been initialized (i.e. Stdout is nil)."

    Stdout isNil ifTrue:[
        self _printCR
    ] ifFalse:[
        super printCR
    ].
!

printfPrintString:formatString
    "non-standard but sometimes useful.
     Return a printed representation of the receiver as specified by formatString,
     which is defined by printf.
     This method is NONSTANDARD and may be removed without notice.
     WARNNG: this goes directly to the C-printf function and may therefore be inherently unsafe.
     Please use the printf: method, which is both safe 
     and completely implemented in Smalltalk."

%{  /* STACK: 1000 */
#ifndef __SCHTEAM__
    char buffer[800];
    char *buf = buffer;
    int bufsize = sizeof(buffer);
    char *mallocbuf = NULL;
    char *cp;
    int len;
    OBJ s;
    extern void *malloc();

    if (__isStringLike(formatString)) {
        cp = (char *)__stringVal(self);
        if (__qClass(self) != String) {
            cp += __OBJS2BYTES__(__intVal(__ClassInstPtr(__qClass(self))->c_ninstvars));
        }
again:
        /*
         * actually only needed on sparc: since thisContext is
         * in a global register, which gets destroyed by printf,
         * manually save it here - very stupid ...
         */
        __BEGIN_PROTECT_REGISTERS__

        len = snprintf(buf, bufsize, (char *)__stringVal(formatString), cp);

        __END_PROTECT_REGISTERS__

        if ((len < 0) || (len > bufsize)) {
            if (len < 0) {
                bufsize = bufsize * 2;
            } else {
                bufsize = len + 1;
            }
            if (mallocbuf)
                free(mallocbuf);
            buf = mallocbuf = malloc(bufsize);
            if (buf == NULL)
                goto fail;
            goto again;
        }

        s = __MKSTRING_L(buf, len);

        if (mallocbuf)
            free(mallocbuf);

        if (s != nil) {
            RETURN (s);
        }
    }
fail:;
#endif
%}.
    self primitiveFailed

    "
     'hello' printfPrintString:'%%s -> %s'
     (String new:900) printfPrintString:'%%s -> %s'
     'hello' printfPrintString:'%%10s -> %10s'
     'hello' printfPrintString:'%%-10s -> %-10s'
     'hello' printfPrintString:'%%900s -> %900s'
     'hello' printfPrintString:'%%-900s -> %-900s'
    "
!

storeOn:aStream
    "put the storeString of myself onto a aStream"

    aStream nextPut:$'.
    (self includes:$') ifTrue:[
        self printWithQuotesDoubledOn:aStream
    ] ifFalse:[
        aStream nextPutAll:self
    ].
    aStream nextPut:$'

    "Modified: / 15.6.1998 / 17:21:51 / cg"
!

storeString
    "return a String for storing myself"

    ^ self basicStoreString.
! !

!String methodsFor:'queries'!

basicSize
    "return the number of characters in myself.
     Redefined here to exclude the 0-byte at the end."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( STInteger._new( self.basicSize() ) );
#else
    REGISTER OBJ slf, cls;

    slf = self;
    cls = __qClass(slf);
    if (cls == String) {
	RETURN ( __mkSmallInteger(__stringSize(slf)) );
    }
    RETURN ( __mkSmallInteger(__stringSize(slf)
			  - __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars))));
#endif
%}.
    ^ super basicSize - 1
!

bitsPerCharacter
    "return the number of bits each character has.
     Here, 8 is returned (storing single byte characters)."

    ^ 8

    "Modified: 20.4.1996 / 23:08:42 / cg"
!

bytesPerCharacter
    "return the number of bytes each character has.
     Here, 1 is returned (storing single byte characters)."

    ^ 1
!

characterSize
    "answer the size in bits of my largest character (actually only 7 or 8)"

%{  /* NOCONTEXT */

    REGISTER unsigned char *cp = __stringVal(self);
    REGISTER unsigned char *last = cp + __stringSize(self);

    if (!__isStringLike(self)) {
	cp += __OBJS2BYTES__(__intVal(__ClassInstPtr(__qClass(self))->c_ninstvars));
    }
#if __POINTER_SIZE__ == 8
    if (sizeof(unsigned INT) == 8) {
	for ( ; (cp+8) <= last; cp += 8) {
	    if (*(unsigned INT *)cp & 0x8080808080808080) {
		RETURN ( __mkSmallInteger(8) );
	    }
	}
    }
#endif
    if (sizeof(int) == 4) {
	for ( ; (cp+4) <= last; cp += 4) {
	    if (*(unsigned int *)cp & 0x80808080) {
		RETURN ( __mkSmallInteger(8) );
	    }
	}
    }
    for ( ; (cp+2) <= last; cp += 2) {
	if (*(unsigned short *)cp & 0x8080) {
	    RETURN ( __mkSmallInteger(8) );
	}
    }
    for ( ; cp < last; cp++) {
	if (*cp & 0x80) {
	    RETURN ( __mkSmallInteger(8) );
	}
    }
    RETURN ( __mkSmallInteger(7) );
%}.
    ^ super characterSize

    "
     'hello world' characterSize
     'hello world' asUnicode16String characterSize
     ('hello world' , (Character value:16r88) asString) characterSize
    "
!

containsNon7BitAscii
    "return true, if the underlying string contains 8BitCharacters (or widers)
     (i.e. if it is non-ascii)"

%{  /* NOCONTEXT */

    REGISTER unsigned char *cp = __stringVal(self);
    REGISTER unsigned char *last = cp + __stringSize(self);

    if (!__isStringLike(self)) {
	cp += __OBJS2BYTES__(__intVal(__ClassInstPtr(__qClass(self))->c_ninstvars));
    }
#if __POINTER_SIZE__ == 8
    if (sizeof(unsigned INT) == 8) {
	for ( ; (cp+8) <= last; cp += 8) {
	    if (*(unsigned INT *)cp & 0x8080808080808080) {
		RETURN ( true );
	    }
	}
    }
#endif
    if (sizeof(int) == 4) {
	for ( ; (cp+4) <= last; cp += 4) {
	    if (*(unsigned int *)cp & 0x80808080) {
		RETURN ( true );
	    }
	}
    }
    for ( ; (cp+2) <= last; cp += 2) {
	if (*(unsigned short *)cp & 0x8080) {
	    RETURN ( true );
	}
    }
    for ( ; cp < last; cp++) {
	if (*cp & 0x80) {
	    RETURN ( true );
	}
    }
    RETURN (false);
%}.
    ^ super containsNon7BitAscii

    "
     'hello world' containsNon7BitAscii
     'hello world' asTwoByteString containsNon7BitAscii
     ('hello world' , (Character value:16r88) asString) containsNon7BitAscii
    "
!

containsNon8BitElements
    "return true, if the underlying string contains elements larger than a single byte"

    ^ false.
!

isWideString
    "true if I require more than one byte per character"

    ^ false
!

knownAsSymbol
    "return true, if there is a symbol with same characters in the
     system.
     Can be used to check for existance of a symbol without creating one"

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( (STSymbol.asSymbolIfInterned(self.asSTString().asString()) != null) ? STObject.True : STObject.False );
#else
    OBJ cls;
    int indx;

    cls = __qClass(self);
    if (cls != String) {
	indx = __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));
    } else {
	indx = 0;
    }
    RETURN ( __KNOWNASSYMBOL(__stringVal(self) + indx) );
#endif /* ! __SCHTEAM__ */
%}.
"/    ^ self asSymbolIfInterned notNil.
    self primitiveFailed

    "
     'hello' knownAsSymbol
     'fooBarBaz' knownAsSymbol
    "
!

size
    "return the number of characters in myself.
     Reimplemented here to avoid the additional size->basicSize send
     (which we can do here, since size is obviously not redefined in a subclass).
     This method is the same as basicSize."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    return context._RETURN( STInteger._new( self.basicSize() ) );
#else
    REGISTER OBJ cls, slf;

    slf = self;
    cls = __qClass(slf);
    if (cls == String) {
	RETURN ( __mkSmallInteger(__stringSize(slf)) );
    }
    RETURN ( __mkSmallInteger(__stringSize(slf)
			 - __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars))));
#endif
%}.
    ^ self basicSize
!

stringSpecies
    ^ self species
!

utf8DecodedMaxBytes
    "return the number of charcters needed when this string is
     decoded from UTF-8."

%{  /* NOCONTEXT */

    unsigned char *cp = __stringVal(self);
    unsigned char *last = cp + __stringSize(self);
    int max = 1;

    if (!__isStringLike(self)) {
	cp += __OBJS2BYTES__(__intVal(__ClassInstPtr(__qClass(self))->c_ninstvars));
    }

    for ( ; cp < last; cp++) {
	unsigned char mask = *cp & 0xF0;
	if (mask != 0) {
	    if ((mask & 0xE0 )== 0xC0) {  if (max < 2) max = 2; }
	    else if (mask == 0xE0) { if (max < 3) max = 3; }
	    else if (mask == 0xF0) { max = 4; break;}
	}
    }
    RETURN (__mkSmallInteger(max));
%}.

    "
     'hello world' utf8DecodedMaxBytes
     'ä' utf8Encoded utf8DecodedMaxBytes
     'äΣΔΨӕἤῴ' utf8Encoded utf8DecodedMaxBytes
    "
!

utf8DecodedSize
    "return the number of charcters needed when this string is
     decoded from UTF-8."

%{  /* NOCONTEXT */

    unsigned char *cp = __stringVal(self);
    unsigned char *last = cp + __stringSize(self);
    unsigned INT len = 0;

    if (!__isStringLike(self)) {
	cp += __OBJS2BYTES__(__intVal(__ClassInstPtr(__qClass(self))->c_ninstvars));
    }
    // count the number of start-bytes
    for ( ; cp < last; cp++) {
	if ((*cp & 0xC0) != 0x80) len++;
    }
    RETURN (__mkSmallInteger(len));
%}.

    "
     'hello world' utf8DecodedSize
     'ä' utf8Encoded utf8DecodedSize
     'äΣΔΨӕἤῴ' utf8Encoded utf8DecodedSize
    "
! !

!String methodsFor:'sorting & reordering'!

reverse
    "in-place reverse the characters of the string.
     WARNING: this is a destructive operation, which modifies the receiver.
	      Please use reversed (with a d) for a functional version."

    "Q: is there a need to redefine it here ?"

%{  /* NOCONTEXT */
#ifndef __SCHTEAM__
    REGISTER char c;
    REGISTER unsigned char *hip, *lowp;

    if (__isString(self)) {
	lowp = __stringVal(self);
	hip = lowp + __stringSize(self) - 1;
	while (lowp < hip) {
	    c = *lowp;
	    *lowp = *hip;
	    *hip = c;
	    lowp++;
	    hip--;
	}
	RETURN ( self );
    }
    #endif
%}.
    ^ super reverse
! !

!String methodsFor:'substring searching'!

indexOfSubCollection:aSubString startingAt:startIndex ifAbsent:exceptionValue caseSensitive:caseSensitive
    "redefined as primitive for maximum speed (BM)"

    |notFound|

%{  /* STACK:4000 */
#ifndef __SCHTEAM__
    if (__qIsStringLike(self)
     && __isStringLike(aSubString)
     && (caseSensitive == true)
     && (__isSmallInteger(startIndex))
     && (__intVal(startIndex) > 0)
    ) {
	unsigned char *y = __stringVal(self);
	unsigned char *x = __stringVal(aSubString);
	int m = __stringSize(aSubString);
	int n = __stringSize(self);
#       define MAX_PATTERN_SIZE 128
#       define XSIZE 256
#       define ASIZE 256
#       define MAX(a,b) (a>b ? a : b)

	if (m == 0) {
#if 1
	    /* empty string does not match */
	    RETURN(__mkSmallInteger(0));
#else
	    /* empty string matches */
	    RETURN(startIndex);
#endif
	}
	if (m <= XSIZE) {
	    int i, j;
	    static int lastPatternSize = 0;
	    static char lastPattern[MAX_PATTERN_SIZE+1] = { 0 };
	    static int bmGs[XSIZE+1], bmBc[ASIZE];

#           define preBmBc(x, m, bmBc) {          \
	       int i;                             \
						  \
	       for (i = 0; i < ASIZE; ++i)        \
		  bmBc[i] = m;                    \
	       for (i = 0; i < m - 1; ++i)        \
		  bmBc[x[i]] = m - i - 1;         \
	    }

#           define suffixes(x, m, suff) {                       \
	       int f, g, i;                                     \
								\
	       suff[m - 1] = m;                                 \
	       g = m - 1;                                       \
	       for (i = m - 2; i >= 0; --i) {                   \
		  if (i > g && suff[i + m - 1 - f] < i - g)     \
		     suff[i] = suff[i + m - 1 - f];             \
		  else {                                        \
		     if (i < g)                                 \
			g = i;                                  \
		     f = i;                                     \
		     while (g >= 0 && x[g] == x[g + m - 1 - f]) \
			--g;                                    \
		     suff[i] = f - g;                           \
		  }                                             \
	       }                                                \
	    }

#           define preBmGs(x, m, bmGs) {                        \
	       int i, j, suff[XSIZE];                           \
								\
	       suffixes(x, m, suff);                            \
								\
	       for (i = 0; i < m; ++i)                          \
		  bmGs[i] = m;                                  \
	       j = 0;                                           \
	       for (i = m - 1; i >= 0; --i)                     \
		  if (suff[i] == i + 1)                         \
		     for (; j < m - 1 - i; ++j)                 \
			if (bmGs[j] == m)                       \
			   bmGs[j] = m - 1 - i;                 \
	       for (i = 0; i <= m - 2; ++i)                     \
		  bmGs[m - 1 - suff[i]] = m - 1 - i;            \
	    }

	    /* tables only depend on pattern; so we can cache them in case the same string is searched again */
	    if ((m == lastPatternSize)
	     && (strcmp(lastPattern, x) == 0)) {
		/* tables are still valid */
		// printf("valid: \"%s\"\n", lastPattern);
	    } else {
		/* Preprocessing */
		// printf("compute: \"%s\"\n", lastPattern);
		preBmGs(x, m, bmGs);
		preBmBc(x, m, bmBc);
		if (m <= MAX_PATTERN_SIZE) {
		    // printf("cache for: \"%s\"\n", lastPattern);
		    strcpy(lastPattern, x);
		    lastPatternSize = m;
		}
	    }

	    /* Searching */
	    j = __intVal(startIndex) - 1;
	    while (j <= n - m) {
	       for (i = m - 1; i >= 0 && x[i] == y[i + j]; --i);
	       if (i < 0) {
		  RETURN (__mkSmallInteger(j+1));
		  j += bmGs[0];
	       } else {
		  int s1 = bmGs[i];
		  int s2 = bmBc[y[i + j]] - m + 1 + i;
		  j += MAX(s1, s2);
	       }
	    }
	    notFound = true;
	}
    }
#endif /* ! __SCHTEAM__ */
%}.
    notFound == true ifTrue:[
	^ exceptionValue value.
    ].
    ^ self slowIndexOfSubCollection:aSubString startingAt:startIndex ifAbsent:exceptionValue caseSensitive:caseSensitive

    "Modified: / 05-08-2012 / 12:27:31 / cg"
!

slowIndexOfSubCollection:aSubString startingAt:startIndex ifAbsent:exceptionValue caseSensitive:caseSensitive
    "naive search fallback (non-BM).
     Use this for short searchStrings (<= 2)
     or for caseInSensitive searches"

    |notFound|

%{
#ifndef __SCHTEAM__
    if (__qIsStringLike(self)
     && __isStringLike(aSubString)
     && (__isSmallInteger(startIndex))
     && (__intVal(startIndex) > 0)
    ) {
	unsigned char *c_pSelf = __stringVal(self);
	unsigned char *c_substring = __stringVal(aSubString);
	unsigned char *c_pSelfI, *c_pSelfMax;
	int c_lenSelf = __stringSize(self);
	int c_lenSubstring = __stringSize(aSubString);
	int c_idx0Max = c_lenSelf - c_lenSubstring;
	unsigned char c_first;
	unsigned char c_ucFirst;
	unsigned char c_lcFirst;
	unsigned char c_oppositeCaseFirst;
	int i;

	if (c_lenSubstring == 0) {
#if 1
	    /* empty string does not match */
	    notFound = true;
	    goto getOutOfHere;
#else
	    /* empty string matches */
	    RETURN(startIndex);
#endif
	}

	// searched string's length > string
	if (c_idx0Max < 0) {
	    notFound = true;
	    goto getOutOfHere;
	}

	c_first = c_lcFirst = c_substring[0];
	if (((c_first >= 'A') && (c_first <= 'Z'))
	 || ((c_first >= 0xC0) && (c_first <= 0xDE))) {
	    c_ucFirst = c_first;
	    c_lcFirst = c_oppositeCaseFirst = c_first - 'A' + 'a';
	} else {
	    if (((c_first >= 'a') && (c_first <= 'z'))
	     || ((c_first >= 0xE0) && (c_first <= 0xFE))) {
		c_lcFirst = c_first;
		c_ucFirst = c_oppositeCaseFirst = c_first - 'a' + 'A';
	    }
	}

	// idx:
	// 0123456789

	// 1234567890 - lenSelf = 10
	// abc        - lenSubstring = 3
	//            - idx0Max = 7 (last legal startIndex)

	i = __intVal(startIndex) - 1;
	c_pSelfI = c_pSelf + i;
	c_pSelfMax = c_pSelf + c_idx0Max;

	for (; c_pSelfI <= c_pSelfMax; c_pSelfI++) {
	    int j;
	    unsigned char c_selfChar;

	    // find the first char
	    c_selfChar = c_pSelfI[0];
	    if (c_selfChar != c_first) {
		if (caseSensitive == true) continue;
		if (c_selfChar != c_oppositeCaseFirst) {
searchNext: ;
		    continue;
		}
	    }

	    // first char matches
	    // compare rest
	    for (j=1; j<c_lenSubstring; j++) {
		unsigned char c_selfChar, c_subChar, c_lcSubChar, c_ucSubChar;

		c_subChar = c_substring[j];
		c_selfChar = c_pSelfI[j];

		if (c_selfChar == c_subChar) continue;
		if (caseSensitive == true) goto searchNext;

		c_lcSubChar = c_subChar;
		if (((c_lcSubChar >= 'A') && (c_lcSubChar <= 'Z'))
		 || ((c_lcSubChar >= 0xC0) && (c_lcSubChar <= 0xDE))) {
		    c_lcSubChar = c_subChar - 'A' + 'a';
		    if (c_selfChar != c_lcSubChar) goto searchNext;
		} else {
		    if (((c_lcSubChar >= 'a') && (c_lcSubChar <= 'z'))
		     || ((c_lcSubChar >= 0xE0) && (c_lcSubChar <= 0xFE))) {
			c_ucSubChar = c_subChar - 'a' + 'A';
			if (c_selfChar != c_ucSubChar) goto searchNext;
		    } else {
			goto searchNext;
		    }
		}
	    }
	    // if we arrive here, we have a match at i
	    RETURN( __mkSmallInteger( c_pSelfI - c_pSelf + 1 ) );
	}
	notFound = true;
    }

    getOutOfHere: ;
#endif /* ! __SCHTEAM__ */
%}.
    "/ arrive here if either not found, or invalid arguments
    notFound == true ifTrue:[
	^ exceptionValue value.
    ].
    ^ super indexOfSubCollection:aSubString startingAt:startIndex ifAbsent:exceptionValue caseSensitive:caseSensitive

    "
     'abcdefg' slowIndexOfSubCollection:'abc' startingAt:1 ifAbsent:nil caseSensitive:false
     'abcdefg' slowIndexOfSubCollection:'bcd' startingAt:1 ifAbsent:nil caseSensitive:false
     'abcdefg' slowIndexOfSubCollection:'cde' startingAt:1 ifAbsent:nil caseSensitive:false
     'abcabcg' slowIndexOfSubCollection:'abc' startingAt:2 ifAbsent:nil caseSensitive:false

     'ABCDEFG' slowIndexOfSubCollection:'abc' startingAt:1 ifAbsent:nil caseSensitive:false
     'ABCDEFG' slowIndexOfSubCollection:'Abc' startingAt:1 ifAbsent:nil caseSensitive:false
     'ABCDEFG' slowIndexOfSubCollection:'aBC' startingAt:1 ifAbsent:nil caseSensitive:false
     'ABCDEFG' slowIndexOfSubCollection:'ABC' startingAt:1 ifAbsent:nil caseSensitive:false

     'ABCDEFG' slowIndexOfSubCollection:'a' startingAt:1 ifAbsent:nil caseSensitive:false
     'ABCDEFG' slowIndexOfSubCollection:'A' startingAt:1 ifAbsent:nil caseSensitive:false

     'ABCDEFG' slowIndexOfSubCollection:'bcd' startingAt:1 ifAbsent:nil caseSensitive:false
     'ABCDEFG' slowIndexOfSubCollection:'cde' startingAt:1 ifAbsent:nil caseSensitive:false
     'ABCABCG' slowIndexOfSubCollection:'abc' startingAt:2 ifAbsent:nil caseSensitive:false

     '1234567890' slowIndexOfSubCollection:'abc' startingAt:1 ifAbsent:nil caseSensitive:false
     '1234567890' slowIndexOfSubCollection:'123' startingAt:1 ifAbsent:nil caseSensitive:false
     '1234567890' slowIndexOfSubCollection:'123' startingAt:1 ifAbsent:nil caseSensitive:true
     '1234567890' slowIndexOfSubCollection:'234' startingAt:1 ifAbsent:nil caseSensitive:true
     '1234567890' slowIndexOfSubCollection:'345' startingAt:1 ifAbsent:nil caseSensitive:true
     '1231231231' slowIndexOfSubCollection:'123' startingAt:1 ifAbsent:nil caseSensitive:true
     '1231231231' slowIndexOfSubCollection:'123' startingAt:2 ifAbsent:nil caseSensitive:true
     '1231231231' slowIndexOfSubCollection:'123' startingAt:3 ifAbsent:nil caseSensitive:true
     '1231231231' slowIndexOfSubCollection:'123' startingAt:4 ifAbsent:nil caseSensitive:true
     '1231231231' slowIndexOfSubCollection:'123' startingAt:5 ifAbsent:nil caseSensitive:true
     '1231231231' slowIndexOfSubCollection:'123' startingAt:6 ifAbsent:nil caseSensitive:true
     '1231231231' slowIndexOfSubCollection:'123' startingAt:7 ifAbsent:nil caseSensitive:true
     '1231231231' slowIndexOfSubCollection:'123' startingAt:8 ifAbsent:nil caseSensitive:true
     '1231231231' slowIndexOfSubCollection:'123' startingAt:9 ifAbsent:nil caseSensitive:true
     '1231231231' slowIndexOfSubCollection:'123' startingAt:10 ifAbsent:nil caseSensitive:true
     '1231231231' slowIndexOfSubCollection:'123' startingAt:11 ifAbsent:nil caseSensitive:true
     '1231231231' slowIndexOfSubCollection:'231' startingAt:1 ifAbsent:nil caseSensitive:true
     '1231231231' slowIndexOfSubCollection:'231' startingAt:3 ifAbsent:nil caseSensitive:true
     '1231231231' slowIndexOfSubCollection:'231' startingAt:5 ifAbsent:nil caseSensitive:true
     '1231231231' slowIndexOfSubCollection:'231' startingAt:6 ifAbsent:nil caseSensitive:true
     '1231231231' slowIndexOfSubCollection:'231' startingAt:8 ifAbsent:nil caseSensitive:true
     '1231231231' slowIndexOfSubCollection:'231' startingAt:9 ifAbsent:nil caseSensitive:true
     '1231231231' slowIndexOfSubCollection:'2310' startingAt:6 ifAbsent:nil caseSensitive:true
     '1231231231' slowIndexOfSubCollection:'2310' startingAt:8 ifAbsent:nil caseSensitive:true
    "
! !

!String methodsFor:'testing'!

endsWith:aStringOrChar
    "return true, if the receiver ends with something, aStringOrChar.
     If aStringOrChar is an empty string, true is returned"

%{  /* NOCONTEXT */
#ifndef __SCHTEAM__
    int len1, len2;
    REGISTER unsigned char *src1, *src2;
    unsigned char c;
    REGISTER OBJ slf = self;

    if (__isStringLike(slf) && __isStringLike(aStringOrChar)) {
	len1 = __qSize(slf);
	len2 = __qSize(aStringOrChar);
	if (len1 < len2) {
	    RETURN ( false );
	}

	src1 = __stringVal(slf) + (len1 - len2);
	src2 = __stringVal(aStringOrChar);
	while ((c = *src2++) != '\0') {
	    if (c != *src1++) {
		RETURN ( false );
	    }
	}
	RETURN (true);
    }
    if (__isCharacter(aStringOrChar)) {
	int val;

	val = __intVal(__characterVal(aStringOrChar));
	if ((unsigned)val <= 0xFF) {
	    len1 = __stringSize(slf);
	    if (len1 > 0) {
		RETURN ( (__stringVal(slf)[len1-1] == val) ? true : false);
	    }
	}
	RETURN ( false );
    }
#endif /* ! __SCHTEAM__ */
%}.
    ^ super endsWith:aStringOrChar

    "
     'hello world' endsWith:'world'
     'hello world' endsWith:'earth'
     'hello world' endsWith:$d
     'hello world' endsWith:$e
     '' endsWith:$d
     'hello world' endsWith:#($r $l $d)
     'hello world' endsWith:''
    "
!

isBlank
    "return true, if the receiver's size is 0 or if it contains only spaces.
     Q: should we care for whiteSpace in general here ?"

%{  /* NOCONTEXT */
#ifndef __SCHTEAM__
    REGISTER unsigned char *src;
    REGISTER unsigned char c;
    OBJ cls;

    src = __stringVal(self);
    if ((cls = __qClass(self)) != String)
	src += __OBJS2BYTES__(__intVal(__ClassInstPtr(cls)->c_ninstvars));

# ifdef UINT64
    while (*((UINT64 *)src) == 0x2020202020202020L) {
	src += 8;
    }
# endif /* UINT64 */

    while (*((unsigned *)src) == 0x20202020) {
	src += 4;
    }

    while ((c = *src++) == ' ')
	;; /* just walking along */
    if (c != '\0') {
	RETURN ( false );
    }
    RETURN ( true );
# endif /* ! __SCHTEAM__ */
%}.
    ^ super isBlank
!

isEmpty
    "return true if the receiver is empty (i.e. if size == 0)
     Redefined here for performance"

%{  /* NOCONTEXT */
#ifndef __SCHTEAM__
    OBJ cls;

    cls = __qClass(self);
    if ((cls == String) || (cls == Symbol)) {
	RETURN ( (__stringSize(self) == 0) ? true : false);
    }
#endif /* ! __SCHTEAM__ */
%}.
    ^ self size == 0
!

isLiteral
    "return true, if the receiver can be used as a literal constant in ST syntax
     (i.e. can be used in constant arrays)"

    ^ true
!

levenshteinTo:aString s:substWeight k:kbdTypoWeight c:caseWeight i:insrtWeight d:deleteWeight
    "parametrized levenshtein. arguments are the costs for
     substitution, case-change, insertion and deletion of a character."

%{  /* STACK: 2000 */
#ifndef __SCHTEAM__
    /*
     * this is very heavy used when correcting errors
     * (all symbols are searched for best match) - therefore it must be fast
     */

    unsigned short *data;
    int l1, l2;
    REGISTER int sz;
    unsigned char *s1, *s2;
    int v1, v2, v3;
    INT m;
    REGISTER unsigned short *dp;
    REGISTER int rowDelta;
    REGISTER int j;
    int i;
    int iW, cW, sW, kW, dW;
#   define FASTSIZE 30  /* increase STACK if you increase this ... */
    unsigned short fastData[(FASTSIZE + 1) * (FASTSIZE + 1)];
    extern void *malloc();

    if (__qIsStringLike(self) && __isStringLike(aString)
	&& __bothSmallInteger(insrtWeight, caseWeight)
	&& __bothSmallInteger(substWeight, deleteWeight)
	&& __isSmallInteger(kbdTypoWeight)
    ) {
	iW = __intVal(insrtWeight);
	cW = __intVal(caseWeight);
	sW = __intVal(substWeight);
	kW = __intVal(kbdTypoWeight);
	dW = __intVal(deleteWeight);
	s1 = __stringVal(self);
	s2 = __stringVal(aString);
	l1 = __stringSize(self);
	l2 = __stringSize(aString);

	sz = (l1 < l2) ? l2 : l1;
	rowDelta = sz + 1;
	if (sz <= FASTSIZE) {
	    data = fastData;
	} else {
	    /* add ifdef ALLOCA here ... */
	    data = (unsigned short *)malloc(rowDelta * rowDelta * sizeof(short));
	    if (! data) goto mallocFailed;
	}

	data[0] = 0;
	for (j=1, dp=data+1; j<=sz; j++, dp++)
	    *dp = dp[-1] + iW;

	for (i=1, dp=data+rowDelta; i<=sz; i++, dp+=rowDelta)
	    *dp = dp[-rowDelta] + dW;

	for (i=0; i<l1; i++) {
	    for (j=0; j<l2; j++) {
		if (s1[i] == s2[j])
		    m = 0;
		else if (tolower(s1[i]) == tolower(s2[j]))
		    m = cW;
		else if (sW != kW && nextOnKeyboard(tolower(s1[i]), tolower(s2[j])))
		    m = kW;
		else
		    m = sW;

		dp = data + ((i+1)*rowDelta) + j;
		v2 = dp[0] + iW;
		v1 = dp[-rowDelta] + m;
		v3 = dp[-rowDelta+1] + dW;
		if (v1 < v2) {
		    if (v1 < v3)
			m = v1;
		    else
			m = v3;
		} else {
		    if (v2 < v3)
			m = v2;
		    else
			m = v3;
		}
		dp[1] = m;
	    }
	}
	m = data[l1*rowDelta + l2];
	if (sz > FASTSIZE)
	    free(data);
	RETURN ( __mkSmallInteger(m) );
    }
mallocFailed: ;
#endif /* ! __SCHTEAM__ */
%}.

    ^ super levenshteinTo:aString
			s:substWeight k:kbdTypoWeight c:caseWeight
			i:insrtWeight d:deleteWeight

    "
     'ocmprt' levenshteinTo:'computer'
     'computer' levenshteinTo:'computer'
     'ocmputer' levenshteinTo:'computer'
     'cmputer' levenshteinTo:'computer'
     'computer' levenshteinTo:'cmputer'
     'computer' levenshteinTo:'vomputer'
     'computer' levenshteinTo:'bomputer'
     'Computer' levenshteinTo:'computer'
    "
!

notEmpty
    "return true if the receiver is not empty (i.e. if size ~~ 0)
     Redefined here for performance"

%{  /* NOCONTEXT */
#ifndef __SCHTEAM__
    OBJ cls;

    cls = __qClass(self);
    if ((cls == String) || (cls == Symbol)) {
	RETURN ( (__stringSize(self) != 0) ? true : false);
    }
#endif /* ! __SCHTEAM__ */
%}.
    ^ self size ~~ 0
!

startsWith:aStringOrChar
    "return true, if the receiver starts with something, aStringOrChar.
     If the argument is empty, true is returned.
     Notice, that this is similar to, but slightly different from VW's and Squeak's beginsWith:,
     which are both inconsistent w.r.t. an empty argument."

%{  /* NOCONTEXT */
#ifdef __SCHTEAM__
    if (self.isSTString()) {
	if (aStringOrChar.isSTString()) {
	    java.lang.String me = self.asString();
	    java.lang.String other = aStringOrChar.asString();
	    return __c__._RETURN( me.startsWith(other) ? STObject.True : STObject.False);
	}
	if (aStringOrChar.isSTCharacter()) {
	    char[] me = self.asSTString().characters;
	    char ch = aStringOrChar.charValue();
	    return __c__._RETURN( ((me.length > 0)
				  && (me[0] == ch)) ? STObject.True : STObject.False);
	}
    }
#else
    int len1, len2;
    REGISTER unsigned char *src1, *src2;
    unsigned char c;
    REGISTER OBJ slf = self;

    if (__qIsStringLike(slf) &&__isStringLike(aStringOrChar)) {
	src1 = __stringVal(slf);
	src2 = __stringVal(aStringOrChar);

	if (src1[0] != src2[0]) {
	    if (__qSize(aStringOrChar) == (OHDR_SIZE+1) /* 1 for the 0-byte */) {
		RETURN (true);
	    }
	    RETURN ( false );
	}

	len1 = __qSize(slf);
	len2 = __qSize(aStringOrChar);
	if (len1 < len2) {
	    RETURN ( false );
	}

# ifdef UINT64
	while (len2 > (OHDR_SIZE+sizeof(UINT64))) {
	    if ( ((UINT64 *)src1)[0] != ((UINT64 *)src2)[0] ) {
		RETURN (false);
	    }
	    len2 -= sizeof(UINT64);
	    src1 += sizeof(UINT64);
	    src2 += sizeof(UINT64);
	}
# else
#  ifdef __UNROLL_LOOPS__
	while (len2 > (OHDR_SIZE+sizeof(INT)*4)) {
	    if ( ((unsigned INT *)src1)[0] != ((unsigned INT *)src2)[0]) {
		RETURN (false);
	    }
	    if ( ((unsigned INT *)src1)[1] != ((unsigned INT *)src2)[1]) {
		RETURN (false);
	    }
	    if ( ((unsigned INT *)src1)[2] != ((unsigned INT *)src2)[2]) {
		RETURN (false);
	    }
	    if ( ((unsigned INT *)src1)[3] != ((unsigned INT *)src2)[3]) {
		RETURN (false);
	    }
	    len2 -= sizeof(INT)*4;
	    src1 += sizeof(INT)*4;
	    src2 += sizeof(INT)*4;
	}
#  endif /* __UNROLL_LOOPS__ */
# endif /* UINT64 */

	while (len2 > (OHDR_SIZE+sizeof(INT))) {
	    if ( ((unsigned INT *)src1)[0] != ((unsigned INT *)src2)[0]) {
		RETURN (false);
	    }
	    len2 -= sizeof(INT);
	    src1 += sizeof(INT);
	    src2 += sizeof(INT);
	}

	while ((c = *src2++) != '\0') {
	    if (c != *src1) {
		RETURN ( false );
	    }
	    src1++;
	}
	RETURN (true);
    }
    if (__isCharacter(aStringOrChar)) {
	int val;

	val = __intVal(__characterVal(aStringOrChar));
	if ((unsigned)val <= 0xFF) {
	    len1 = __stringSize(slf);
	    if (len1 > 0) {
		RETURN ( (__stringVal(slf)[0] == val) ? true : false);
	    }
	}
	RETURN ( false );
    }
#endif /* not __SCHTEAM__ */
%}.
    ^ super startsWith:aStringOrChar

    "
     'hello world' startsWith:'hello'
     'hello world' startsWith:'hella'
     'hello world' startsWith:'hi'
     'hello world' startsWith:$h
     'hello world' startsWith:$H
     'hello world' startsWith:(Character value:16rFF00)
     'hello world' startsWith:60
     'hello world' startsWith:#($h $e $l)
     'hello world' startsWith:''
    "
! !

!String methodsFor:'tracing'!

isSingleByteString
    "returns true only for strings and immutable strings.
     Must replace foo isMemberOf:String and foo class == String"

    ^ true
!

traceInto:aRequestor level:level from:referrer
    "double dispatch into tracer, passing my type implicitely in the selector"

    ^ aRequestor traceString:self level:level from:referrer


! !

!String class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

