"
 COPYRIGHT (c) 1988 by Claus Gittinger
 COPYRIGHT (c) 2009-2010 Jan Vrany
 COPYRIGHT (c) 2015 Jan Vrany
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

String variableByteSubclass:#Symbol
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Text'
!

!Symbol class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1988 by Claus Gittinger
 COPYRIGHT (c) 2009-2010 Jan Vrany
 COPYRIGHT (c) 2015 Jan Vrany
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
    Symbols represent unique strings - every symbol with same printString
    exists exactly once in the system; Symbols are used for selectors, global
    variable-keys etc. Symbols can also be used to represent things which are
    enumeration type values in other programming languages (since symbols are
    created at compile time, comparing them using == is a fast pointer compare).

    A symbol may not change its characters - i.e. it is constant over its lifetime.
    Other than that, symbols behave much like strings.

    The most prominent use of symbols is as key for message sending: methods are stored
    in a classes method dictionary, where symbols are used as key to map names to methods.
    Also, symbols are used as key to map class names (global names) to actual class objects.

    Special ST/X feature:
	The ST/X VM method lookup supports selector namespaces for method extensions.
	This means, that a class may contain method extensions in another namespace,
	which are only seen and invoked if called from a class within that namespace.
	Technically, this is done by storing the method under a special namespace-selector,
	which is a symbol consisting of the user visible name, prefixed by ':<ns>::'.
	The VM's method lookup algorithm contains special handling code for such constructs.
	Thus, if two methods are stored as 'foo' and ':NS::foo' are present in a class,
	any send of 'foo' from wthin the NS-namespace will invoke the second method.
	Any other send will invoke the first one.


    [author:]
	Claus Gittinger
"
! !

!Symbol class methodsFor:'instance creation'!

basicNew:size
    "redefined to return a string instead of a symbol -
     this allows all copy methods inherited from String to
     return strings containing the symbols characters.
     Real symbols are only created with #intern: or #asSymbol."

    ^ String new:size

    "Modified: 26.2.1996 / 12:51:38 / cg"
!

fromString:aString
    "same as intern: for Symbol, but may be used to create interned instances
     of subclasses.
     Notice: this fails, if you try to intern an instance of a subclass, AND
     a symbol with the same name already exists. In this case, the original
     symbol is returned. To use it for enum-type symbols, make certain, that the
     names are unique (for example by including the classes name as a prefix-string)."

    |sym len|

    sym := aString asSymbolIfInterned.
    sym notNil ifTrue:[
	^ sym
    ].

    "
     create a new uninterned instance first
    "
    len := aString size.
    sym := super basicNew:len.
    sym replaceFrom:1 to:len with:aString.

    "now, intern it"
%{
    sym = __INTERNSYMBOL(sym, (OBJ *)0, __context);
%}.
    ^ sym
!

intern:aString
    "return a unique symbol with printname taken from the String-argument"

%{  /* NOCONTEXT */
    OBJ newSymbol;

    if (__isSymbol(aString)) {
	RETURN (aString);
    }
    if (__isStringLike(aString)) {
	newSymbol = __MKSYMBOL(__stringVal(aString), (OBJ *)0);
	if (newSymbol != nil) {
	    RETURN (newSymbol);
	}
    }
%}.
    (aString class ~~ String and:[aString class ~~ ImmutableString]) ifTrue:[
	"only allowed to intern strings"
	^ self mustBeString
    ].
    ^ AllocationFailure raise.
!

internCharacter:aCharacter
    "return a unique symbol with printname taken from the Character-argument"

    ^ self intern:(aCharacter asString)
!

new:size
    "redefined to return a string instead of a symbol -
     this allows all copy methods inherited from String to
     return strings containing the symbols characters.
     Real symbols are only created with intern: or asSymbol."

    ^ String new:size
! !




!Symbol class methodsFor:'queries'!

findInterned:aString
    "for ST-80 compatibility - if the argument, aString is known
     as Symbol, return this symbol. Otherwise return nil."

    ^ aString asSymbolIfInterned
!

hasInterned:aString
    "return true, if the argument, aString is known as Symbol;
     false otherwise"

    ^ aString knownAsSymbol
!

hasInterned:aString ifTrue:trueBlock
    "for ST-80 compatibility - if the argument, aString is known
     as Symbol, evaluate the block with the corresponding symbol
     as argument and return true; otherwise return false"

    |sym|

    (sym := aString asSymbolIfInterned) notNil ifTrue:[
	trueBlock value:sym.
	^ true
    ].
    ^ false
!

hasSharedInstances
    "return true if this class has shared instances, that is, instances
     with the same value are identical.
     True returned here - there is only one of each symbol (per contents)."

    ^ true

! !


!Symbol methodsFor:'Compatibility-Squeak'!

precedence
    "the precedence in an expression; 0 is highest;
	unary < binary < keyword"

    self size = 0
	ifTrue: [^ 0].
    self first isLetter
	ifFalse: [^ 2].
    self last = $:
	ifTrue: [^ 3].
    ^ 1

    "
     self assert:(#foo precedence < #+ precedence).
     self assert:(#+ precedence < #key: precedence).
     self assert:(#foo precedence < #key: precedence).
    "

    "Created: / 12-09-2011 / 14:53:54 / cg"
! !

!Symbol methodsFor:'Compatibility-VW'!

<< catalogID
    "create and return a new UserMessage, with the receiver as key,
     and the argument as cataglogID.
     VW compatibility."

    ^ UserMessage key:self catalogID:catalogID

    "
     (#theFooMessage << #myMessages)
     (#theFooMessage << #myMessages >> 'cannot read subclass of metaclass')
     (#theFooMessage >> 'cannot read subclass of metaclass')
    "
!

>> aString
    "create and return a new UserMessage, with the receiver as key,
     and the argument as defaultString.
     VW compatibility."

    ^ UserMessage key:self defaultString:aString

    "
     (#theFooMessage << #myMessages)
     (#theFooMessage << #myMessages >> 'cannot read subclass of metaclass')
     (#theFooMessage >> 'cannot read subclass of metaclass')
    "
! !


!Symbol methodsFor:'accessing'!

basicAt:index put:something
    "report an error if an interned symbol is about to be changed
     - interned symbols may NOT be changed.
     For uninterned symbols, this is allowed."

    self knownAsSymbol ifTrue:[
	self noModificationError.
	"Even if you hit continue - you cannot change symbols.
	 Raise again non-resumable"
	NoModificationError raiseWith:self errorString:' - interned symbols cannot be changed'.
    ].
    "
     uninterned - allow change
    "
    ^ super basicAt:index put:something

    "Modified: 19.4.1996 / 11:16:10 / cg"
!

nameSpace
    "if I have the format of a namespace-selector,
     retrieve the namespace. Otherwise, return nil.
     Also return nil, if that namespace does not exist (in contrast to nameSpacePart).
     Namespace selectors have a special, fix defined format, which is also known in the VM.
     They must be of the form :<ns>::<sel>,
     where <ns> is the namespace and <sel> is the raw selector.
     This special format (a symbol starting with a colon) was chosen, because almost every other selector
     is legal, and this can be checked quickly by just looking at the first character."

     |nsPart|

     nsPart := self nameSpaceAndSelectorParts first.
     nsPart isNil ifTrue:[^ nil].
     ^ Smalltalk at:nsPart asSymbol

    "
     #':foo:' nameSpace       -> nil (bad format)
     #':foo::bar' nameSpace   -> nil (non existing)
     #':Tools::bar' nameSpace -> Tools
     #'bar' nameSpace -> nil
     #'bar:' nameSpace -> nil
    "

    "Created: / 20-07-2010 / 10:41:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nameSpaceAndSelector
    "return a two element tuple consisting of the namespace and the raw selector.
     If I do not have the format of a namespace-selector, or the namespace is non-existing,
     the first element of the returned tuple will be nil.
     Namespace selectors have a special, fix defined format, which is also known in the VM.
     They must be of the form :<ns>::<sel>,
     where <ns> is the namespace and <sel> is the raw selector.
     This special format (a symbol starting with a colon) was chosen, because almost every other selector
     is legal, and this can be checked quickly by just looking at the first character."

    |parts ns|

    self isNameSpaceSelector ifFalse:[
	^ Array with:nil with:self
    ].
    parts := self nameSpaceAndSelectorParts.
    ns := Smalltalk at:parts first asSymbol.
    ^ Array with:ns with:parts second

    "
     #':foo:bar' nameSpaceAndSelector     -> #(nil #':foo:bar')
     #':foo::bar' nameSpaceAndSelector    -> #(nil #bar)
     #':Tools::foo' nameSpaceAndSelector  -> #(Tools (* NameSpace *) #foo)
    "

    "Created: / 20-07-2010 / 10:23:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nameSpaceAndSelectorParts
    "return a two element tuple consisting of the namespace name and the raw selector.
     If I do not have the format of a namespace-selector,
     the first element of the returned tuple will be nil.
     Namespace selectors have a special, fix defined format, which is also known in the VM.
     They must be of the form :<ns>::<sel>,
     where <ns> is the namespace and <sel> is the raw selector.
     This special format (a symbol starting with a colon) was chosen, because almost every other selector
     is legal, and this can be checked quickly by just looking at the first character."

     |nsPart selPart idx|

    self isNameSpaceSelector ifFalse:[
	^ Array with:nil with:self
    ].
    idx := self indexOf:$: startingAt:3.
    nsPart := self copyFrom:2 to:idx - 1.
    selPart := self copyFrom:idx + 2.
    ^ Array with:nsPart with:selPart asSymbol

    "
     #':foo:bar' nameSpaceAndSelectorParts     -> #(nil #':foo:bar')
     #':foo:bar' nameSpaceAndSelector          -> #(nil #':foo:bar')

     #':foo::bar' nameSpaceAndSelectorParts    -> #('foo' #bar)
     #':foo::bar' nameSpaceAndSelector         -> #(nil #bar)

     #'bar' nameSpaceAndSelectorParts          -> #(nil #bar)
     #'bar' nameSpaceAndSelector               -> #(nil #bar)

     #':Tools::foo' nameSpaceAndSelectorParts  -> #('Tools' #foo)
     #':Tools::foo' nameSpaceAndSelector       -> #(Tools (* NameSpace *) #foo)
    "

    "Created: / 20-07-2010 / 10:23:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nameSpacePart
    "if I have the format of a namespace-selector,
     retrieve the namespace name. Otherwise, return nil.
     Namespace selectors have a special, fix defined format, which is also known in the VM.
     They must be of the form :<ns>::<sel>,
     where <ns> is the namespace and <sel> is the raw selector.
     This special format (a symbol starting with a colon) was chosen, because almost every other selector
     is legal, and this can be checked quickly by just looking at the first character."

     ^ self nameSpaceAndSelectorParts first.

    "
     #':foo:' nameSpacePart       -> nil (bad format)
     #':foo::bar' nameSpacePart   -> 'foo'
     #':Tools::bar' nameSpacePart -> 'Tools'
    "
!

selector
    <resource: #obsolete>

    "if I have the format of a namespace-selector, retrieve the raw selector.
     Otherwise, return myself.
     Namespace selectors have a special, fix defined format, which is also known in the VM.
     They must be of the form :<ns>::<sel>,
     where <ns> is the namespace and <sel> is the raw selector.
     This special format (a symbol starting with a colon) was chosen,
     because almost every other selector is legal,
     and this can be checked quickly in the VM, by just looking at the first character."

     self obsoleteMethodWarning:'use selectorWithoutNameSpace'.
    ^ self selectorWithoutNameSpace
!

selectorWithoutNameSpace
    "if I have the format of a namespace-selector, retrieve the raw selector.
     Otherwise, return myself.
     Namespace selectors have a special, fix defined format, which is also known in the VM.
     They must be of the form :<ns>::<sel>,
     where <ns> is the namespace and <sel> is the raw selector.
     This special format (a symbol starting with a colon) was chosen, because almost every other selector
     is legal, and this can be checked quickly by just looking at the first character."

     ^ self nameSpaceAndSelectorParts second

    "
     #':foo:' selectorWithoutNameSpace       -> #':foo:' (bad format)
     #':foo::bar' selectorWithoutNameSpace   -> bar
     #':Tools::bar' selectorWithoutNameSpace -> bar
    "

    "Created: / 20-07-2010 / 10:41:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !


!Symbol methodsFor:'comparing'!

= something
    "return true, if the receiver and argument consist of the same characters.
     Redefined here, for more efficient comparison of symbols
     (which can to be compared using #==).
     If the argument is a symbol, we use a quick pointer compare, instead of
     the inherited value compare."

%{   /* NOCONTEXT */
#ifdef __SCHTEAM__
    if (something.isSymbol()) {
	return context._RETURN ( self == something ? STObject.True : STObject.False );
    }
    if (something.isSTString()) {
	return context._RETURN ( something.isStringEqual(self) ? STObject.True : STObject.False );
    }
    if (something == STObject.Nil) {
	return context._RETURN_false ( );
    }
#else
    OBJ cls;

    if (something == self) RETURN(true);
    if (! __isNonNilObject(something)) RETURN(false);
    if ((cls = __qClass(something)) == Symbol) {
	RETURN (false);
    }
    if (cls == String || cls == ImmutableString) {
	RETURN (strcmp(__stringVal(self), __stringVal(something)) == 0 ? true : false);
    }
#endif
%}.
    "fall back; could be a TwoByteString, or a collection of Characters"

    ^ super = something
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
    extern unsigned int __symbolHash(char *);
    unsigned char *cp;
    unsigned int h;

    cp = __stringVal(self);
    if (__qClass(self) == Symbol) {    
	cont:
	/* Use __symbolHash() to make sure it's the same used by the VM */
	h = __symbolHash(cp);
	RETURN(__mkSmallInteger(h));
    } else {
	int n = __OBJS2BYTES__(__intVal(__ClassInstPtr(__qClass(self))->c_ninstvars));
	cp += n;    
	goto cont;
    }
#endif /* not SCHTEAM */
%}.
    ^ self primitiveFailed

!

identityHash
    "interned symbols can return a better hash key"

%{  /* NOCONTEXT */

    REGISTER unsigned int val; // yes: only 32 bit

    if (__qIsSymbol(self)) {
	val = __GET_HASH(self);
	/*
	 * only do it, if I have no standard hash key
	 * assigned (which can only happen due to a #become:,
	 * or by creating a symbol uninterned, and interning it
	 * after it got a hashKey assigned.
	 */
	if (val == 0) {
	    extern unsigned int __symbolHash(char *);

	    val = __symbolHash(__stringVal(self));
	    // make sure, it fits into a smallInt
	    val = (val ^ (val >> 30)) & 0x3FFFFFFF;
	} else {
	    val = __MAKE_HASH__(val);
	}
	RETURN ( __mkSmallInteger(val) );
    }
%}.

     ^ super identityHash.

     "
	|hashColl hashSet|

	hashColl := OrderedCollection new:20000.
	Symbol allInstancesDo:[:instance |
	    hashColl add:instance identityHash
	].
	hashSet := hashColl asSet.

	Transcript showCR:'Symbols: ', hashColl size printString,
			  ' unique hash keys: ', hashSet size printString,
			  ' collisions:', (hashColl size - hashSet size) printString.
    "

    "Modified (comment): / 26-12-2011 / 14:32:10 / cg"
!

~= something
    "return true, if the receiver and argument do not consist of the same characters.
     Redefined here, for more efficient #~= comparison of symbols
     (which ought to be compared using #~~).
     If the argument is a symbol, we use a quick pointer compare, instead of
     the inherited value compare."

%{   /* NOCONTEXT */
#ifdef __SCHTEAM__
    if (something.isSymbol()) {
	return context._RETURN ( self == something ? STObject.False : STObject.True );
    }
    if (something.isSTString()) {
	return context._RETURN ( something.isStringEqual(self) ? STObject.False : STObject.True );
    }
    if (something == STObject.Nil) {
	return context._RETURN_true ( );
    }
#else
    OBJ cls;

    if (! __isNonNilObject(something)) RETURN(true);    /* cannot be equal */
    if ((cls = __qClass(something)) == Symbol) {
	RETURN (self == something ? false : true);
    }
    if (cls == String || cls == ImmutableString) {
	RETURN (strcmp(__stringVal(self), __stringVal(something)) == 0 ? false : true);
    }
#endif
%}.
    "fall back; could be a TwoByteString, or a collection of Characters"

    ^ super ~= something
! !

!Symbol methodsFor:'converting'!

asString
    "return a string with printname taken from mine"

%{  /* NOCONTEXT */
    OBJ s;

    s = __MKSTRING_ST(self);
    if (s != nil) {
	RETURN (s);
    }
%}.
    ^ (String new:(self size))
	replaceFrom:1 with:self startingAt:1
!

asSymbol
    "Return a unique symbol with the name taken from the receiver's characters.
     Since I am a symbol - just return myself"

    ^ self
!

asSymbolIfInterned
    "If a symbol with the receiver's characters is already known, return it. Otherwise, return nil.
     Since I am a symbol - just return myself"

    ^ self
!

asSymbolIfInternedOrSelf
    ^ self
! !

!Symbol methodsFor:'copying'!

copy
    "return a copy of myself
     - reimplemented here since symbols are immutable."

     ^ self
!

copyReplaceAll:oldElement with:newElement
    "return a copy of the receiver as a string, where all elements equal to oldElement
     have been replaced by newElement."

"/    'Warning: #copyReplaceAll:with: will change semantics as defined in ANSI soon' errorPrintCR.
    ^ self asString replaceAll:oldElement with:newElement

    "Created: / 18.7.1998 / 23:03:38 / cg"
!

copyReplacing:oldElement withObject:newElement
    "return a copy of the receiver, where all elements equal to oldElement
     have been replaced by newElement.
     ANSI version of what used to be #copyReplaceAll:with:"

    ^ self asString replaceAll:oldElement with:newElement
!

deepCopy
    "return a copy of myself
     - reimplemented here since symbols are immutable."

     ^ self
!

deepCopyUsing:aDictionary postCopySelector:postCopySelector
    "return a deep copy of myself
     - reimplemented here since symbols are immutable."

     ^ self
!

shallowCopy
    "return a copy of myself
     - reimplemented here since symbols are immutable and unique,
     so we return the receiver."

     ^ self

    "Modified: / 31-05-2007 / 15:32:30 / cg"
!

simpleDeepCopy
    "return a copy of myself
     - reimplemented here since symbols are immutable."

     ^ self
! !

!Symbol methodsFor:'evaluation'!

value: el
    "this is sent by collection enumeration methods,
     if a symbol is given instead of a block as loop-block argument"

    ^ el perform:self.

    "
     this allows us to say:

     #(1 2 3 4) do: #printCR
     #(1 -2 -3 4) collect: #abs
     someCollection collect: #withoutSeparators
    "
!

value: el value:arg
    "this is sent by collection enumeration methods,
     if a symbol is given instead of a block as loop-block argument"

    ^ el perform:self with:arg.

    "
     this allows us to say:

     #(1 2 3 4) with:#(10 20 30 40) collect: #+
    "
! !


!Symbol methodsFor:'printing & storing'!

printOn:aStream
    "append a user printed representation of the receiver to aStream.
     The format is suitable for a human - not meant to be read back.

     In contrast to ST-80, this does return the symbols characters
     without any leading #. Therefore, you can directly send symbols'
     printStrings to some output device. This is incompatible, but easier
     to use."

"/ ST-80 behavior:

"/  self storeOn:aStream

    aStream nextPutAll:self
!

printString
    "return a printed representation of the receiver.
     In contrast to ST-80, this does return the symbols characters
     without any leading #. Therefore, you can directly send symbols'
     printStrings to some output device. This is incompatible, but easier
     to use."

"/ ST-80 behavior:
"/  ^ self storeString

    ^ self asString
!

storeArrayElementOn:aStream
    "store myself on a stream.
     I am stored as an array element, so the '#' may be omitted sometimes.
     Take care for special symbols"

    |storeString|

    storeString := self storeString.
    (self == #true or:[self == #false or:[self == #nil or:[(storeString at:2) == $']]]) ifTrue:[
	aStream nextPutAll:storeString.
    ] ifFalse:[
	aStream nextPutAll:self.
    ].
!

storeOn:aStream
    "store myself on a stream"

    aStream nextPutAll:(self storeString)
!

storeString
    "return a String for storing the receiver"

    |sz "{Class: SmallInteger }"
     c anyColon|

    sz := self size.
    (sz ~~ 0 and:[(self at:1) isLetter]) ifTrue:[
	anyColon := false.
	2 to:sz do:[:index |
	    c := self at:index.
	    c == $: ifTrue:[
		(index == sz or:[(self at:(index+1)) isLetterOrDigit]) ifFalse:[
		    ^ '#' , super storeString.
		].
		anyColon := true.
	    ] ifFalse:[
		c isLetterOrDigit ifFalse:[
		    ^ '#' , super storeString
		].
	    ].
	].
	"no colon in symbol or symbol ends with a colon"
	(anyColon and:[c ~~ $:]) ifFalse:[
	    ^ '#' , self
	].
    ].
    ^ '#' , super storeString

    "
      #'abc'       storeString
      #'abc:'      storeString
      #'abc:def:'  storeString
      #'abc:def'   storeString
      #'abc::def'  storeString
      #'abc &^*'   storeString
      #'abcdef::'  storeString
      #'hello''world'  storeString
      #'' storeString
      #'''' storeString
      #'_hello' storeString
      #'123'  storeString
    "
! !

!Symbol methodsFor:'queries'!

species
    "when copying, or concatenating, return instances of this class"

    ^ String
! !

!Symbol methodsFor:'system primitives'!

become:anotherObject
    "make all references to the receiver become references to anotherObject
     and vice-versa. For symbols, some special action is required, to
     correctly handle a become of the global dictionaries.
     Anyway: this is very dangerous - mysterous side-effects are to be
     expected.

     Notice: because of the danger here, this method may report an error
	     in future versions"

    (Smalltalk includesKey:self) ifTrue:[
	super become:anotherObject.
%{
	__rehashSystemDictionaries();
%}.
    ] ifFalse:[
	super become:anotherObject
    ]
!

becomeNil
    "make all references to the receiver become nil - effectively getting
     rid of the receiver. For symbols, this is not allowed, if the receiver
     is used as a key in some SystemDictionary.
     This can be a very dangerous operation - be warned.

     Notice: because of the danger here, this method may report an error
	     in future versions"

    (Smalltalk includesKey:self) ifTrue:[
	self primitiveFailed
    ] ifFalse:[
	super becomeNil
    ]
!

grow:newSize
    "blocked"

    self fixedSizeError

    "Created: / 20-06-2011 / 14:57:36 / cg"
!

removeAll
    "blocked"

    self fixedSizeError

    "Created: / 20-06-2011 / 14:59:02 / cg"
! !

!Symbol methodsFor:'testing'!

isSingleByteString
    "returns true only for strings and immutable strings.
     Must replace foo isMemberOf:String and foo class == String"

    ^ false
!

isSymbol
    "return true, if the receiver is some kind of symbol.
     Since I am a symbol, return always true"

    ^ true
! !

!Symbol methodsFor:'tracing'!

traceInto:aRequestor level:level from:referrer
    "double dispatch into tracer, passing my type implicitely in the selector"

    ^ aRequestor traceSymbol:self level:level from:referrer


! !

!Symbol methodsFor:'visiting'!

acceptVisitor:aVisitor with:aParameter
    "dispatch for visitor pattern; send #visitSymbol:with: to aVisitor"

    ^ aVisitor visitSymbol:self with:aParameter
! !

!Symbol class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$ Id: Symbol.st 10648 2011-06-23 15:55:10Z vranyj1  $'
! !

