"
    The RegEx package was written and is copyrighted by Vassili Bykov
    (vbykov@cam.org).
    See #RxParser >> boringStuff on what you may (or may not do) with it.

    This package is not part of the ST/X licence - it is distributed with 
    ST/X for your convenience.
"
"{ Package: 'stx:goodies/regex' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_goodies_regex
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!

!stx_goodies_regex class methodsFor:'documentation'!

copyright
"
    The RegEx package was written and is copyrighted by Vassili Bykov
    (vbykov@cam.org).
    See #RxParser >> boringStuff on what you may (or may not do) with it.

    This package is not part of the ST/X licence - it is distributed with 
    ST/X for your convenience.
"
!

documentation
"
    Package documentation:

    Regular expression matcher package
    Original by Vassili Bykov, with slight enhancements by eXept.

    [author:]
        Vassili Bykov

    [primary maintainer:]
        cg
"
! !

!stx_goodies_regex class methodsFor:'description'!

excludedFromPreRequisites
    "obsolete; temporarily, this is still called for, but will eventually vanish.
    
     List packages which are to be explicitely excluded from the automatic constructed
     prerequisites lists (both). 
     If empty, everything that is found along the inheritance of any of
     my classes is considered to be a prerequisite package."

    ^ #(
    )
!

mandatoryPreRequisites
    "list packages which are mandatory as a prerequisite.
     This are packages containing superclasses of my classes and classes which
     are extended by myself.
     They are mandatory, because we need these packages as a prerequisite for loading and compiling.
     This method is generated automatically,
     by searching along the inheritance chain of all of my classes.
     Please take a look at the #referencedPreRequisites method as well."

    ^ #(
        #'stx:libbasic'    "ArrayedCollection - extended"
    )
!

referencedPreRequisites
    "list packages which are a prerequisite, because they contain
     classes which are referenced by my classes.
     These packages are NOT needed as a prerequisite for compiling or loading,
     however, a class from it may be referenced during execution and having it
     unloaded then may lead to a runtime doesNotUnderstand error, unless the caller
     includes explicit checks for the package being present.
     This method is generated automatically,
     by searching all classes (and their packages) which are referenced by my classes.
     Please also take a look at the #mandatoryPreRequisites method"

    ^ #(
    )
!

subProjects
    "list packages which are known as subprojects.
     The generated makefile will enter those and make there as well.
     However: they are not forced to be loaded when a package is loaded;
     for those, redefine #referencedPrerequisites or #mandatoryPreRequisites."

    ^ #(
    )
! !

!stx_goodies_regex class methodsFor:'description - compilation'!

additionalDefinitions_nt_dot_mak
    ^ '
# see stdHeader_nt for LIBREGEX_BASE
LIB_BASE_LD_ARG=-b:$(LIBREGEX_BASE)
'
!

stcOptimizationOptions
    ^ '+optinline +optinline2'
! !

!stx_goodies_regex class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        #'Regex::RxCharSetParser'
        #'Regex::RxMatchOptimizer'
        #'Regex::RxMatcher'
        #'Regex::RxParser'
        #'Regex::RxmLink'
        #'Regex::RxmTerminator'
        #'Regex::RxsNode'
        #'stx_goodies_regex'
        #'Regex::RxmBranch'
        #'Regex::RxmMarker'
        #'Regex::RxmPredicate'
        #'Regex::RxmRepetition'
        #'Regex::RxmSpecial'
        #'Regex::RxmSubstring'
        #'Regex::RxsBranch'
        #'Regex::RxsCharClass'
        #'Regex::RxsCharSet'
        #'Regex::RxsCharacter'
        #'Regex::RxsContextCondition'
        #'Regex::RxsEpsilon'
        #'Regex::RxsMessagePredicate'
        #'Regex::RxsPiece'
        #'Regex::RxsPredicate'
        #'Regex::RxsRange'
        #'Regex::RxsRegex'
        #'Regex::RxsSpecial'
        (#'Regex::ReadMe' autoload)
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector.
     A correponding method with real names must be present in my concrete subclasses
     if it has extensions."

    ^ #(
        CharacterArray allRegexMatches:
        CharacterArray asRegex
        CharacterArray asRegexIgnoringCase
        CharacterArray copyWithRegex:matchesReplacedWith:
        CharacterArray copyWithRegex:matchesTranslatedUsing:
        CharacterArray hasAnyRegexMatches:
        CharacterArray hasAnyRegexMatches:ignoringCase:
        CharacterArray hasAnyRegexMatchesIgnoringCase:
        CharacterArray matchesRegex:
        CharacterArray matchesRegex:caseSensitive:
        CharacterArray matchesRegex:ignoringCase:
        CharacterArray matchesRegexIgnoringCase:
        CharacterArray prefixMatchesRegex:
        CharacterArray prefixMatchesRegexIgnoringCase:
        CharacterArray regex:matchesCollect:
        CharacterArray regex:matchesDo:
    )
! !

!stx_goodies_regex class methodsFor:'description - project information'!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'Vassili Bykov / eXept Software AG'

    "Modified: / 18-11-2016 / 11:49:40 / cg"
!

description
    "Return a description string which will appear in nt.def / bc.def"

    ^ 'Smalltalk/X Regular Expressions'
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Vassili Bykov 1996,1999 \nCopyright Claus Gittinger\nCopyright eXept Software AG 2000'

    "Modified: / 18-11-2016 / 12:15:48 / cg"
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_goodies_regex class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/regex/stx_goodies_regex.st,v 1.26 2017-11-25 12:34:20 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/regex/stx_goodies_regex.st,v 1.26 2017-11-25 12:34:20 cg Exp $'
! !

