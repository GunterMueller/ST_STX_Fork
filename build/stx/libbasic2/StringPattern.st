"
 COPYRIGHT (c) 2011 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice. This software may not
 be provided or otherwise made available to, or used by, any
 other person. No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

Object subclass:#StringPattern
	instanceVariableNames:'data'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Text-Support'
!

StringPattern subclass:#Includes
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:StringPattern
!

StringPattern subclass:#Matches
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:StringPattern
!

Object subclass:#Parser
	instanceVariableNames:'stream errorBlock'
	classVariableNames:''
	poolDictionaries:''
	privateIn:StringPattern
!

StringPattern subclass:#StartsWith
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:StringPattern
!

!StringPattern class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2011 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice. This software may not
 be provided or otherwise made available to, or used by, any
 other person. No title to or ownership of the software is
 hereby transferred.

"
!

documentation
"
    A StringPattern instances are used to match string. The
    pattern is build from a user-supplied string. It is the
    intention to let the user type the search pattern - it can
    be used for various live searches in lists, dialogs etc.

    This is an unfinished class. More detailed description about
    syntax and algorithm will be added once the results will be
    considered good and the API become stable. 
    If not, blame it on JV :-)

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!StringPattern class methodsFor:'instance creation'!

includes: aString

    ^Includes new on: aString

    "Created: / 18-10-2011 / 21:22:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

matches: aString

    ^Matches new on: aString

    "Created: / 18-10-2011 / 21:23:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readFrom:aStringOrStream onError:exceptionBlock

    ^Parser parse: aStringOrStream readStream onError: exceptionBlock

    "
        StringPattern readFrom: 'abcd'
        StringPattern readFrom: ' abcd'
        StringPattern readFrom: ' a??d'
        StringPattern readFrom: ' a*d*'
        StringPattern readFrom: 'abcd*'
    "

    "Created: / 09-08-2011 / 13:39:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

startsWith: aString

    ^StartsWith new on: aString

    "Created: / 09-08-2011 / 13:42:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !


!StringPattern methodsFor:'conversion'!

asString
    "Returns a string representation of the pattern.

     `StringPattern fromString: pattern asString` should return
     the same pattern (same meaning equal)"

    ^ self subclassResponsibility

    "Created: / 23-01-2015 / 17:36:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!StringPattern methodsFor:'initialization'!

on: anObject

    data := anObject.

    "Created: / 09-08-2011 / 13:42:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!StringPattern methodsFor:'matching'!

match: string 
    ^self match: string from: 1 to: string size

    "Created: / 09-08-2011 / 13:51:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-11-2014 / 07:00:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

match: string case: case 
    ^self match: string case: case relax: 1

    "Created: / 26-11-2014 / 07:02:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

match: string case: case relax: relax 
    ^self match: string from: 1 to: string size case: case relax: relax

    "Created: / 26-11-2014 / 07:02:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

match: string from: from to: to 
    ^self match: string from: 1 to: string size case: true

    "Created: / 26-11-2014 / 07:01:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

match: string from: from to: to case: case                                                              
    ^self match: string from: from to: to case: case relax: 1

    "Created: / 26-11-2014 / 07:01:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-11-2014 / 10:00:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

match: string from: from to: to case: case relax: relax
    "Answers true if receiver matches the given `string`
     portion starting at `from`, ending at `to`.
     If `case` is true, then perform natch case sensitive,
     otherwise match case insensitive.

     `relax` argument say how much the matching should
     be relaxed - relax is a number in <1..3>, where
     1 means no relaxing at all (aka exact match). 
     All patterns should support relax == 1. If the relax
     level is not supported by a pattern, false must be 
     returned."

    ^self subclassResponsibility

    "Created: / 26-11-2014 / 06:35:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

match: string from: from to: to relax: relax                                                              
    ^self match: string from: from to: string size case: true relax: relax

    "Created: / 26-11-2014 / 07:01:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

match: string relax: relax
    ^ self match: string case: true relax: relax

    "Created: / 09-08-2011 / 13:47:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-11-2014 / 07:03:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!StringPattern methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation of the receiver to the argument, aStream"

    super printOn:aStream.
    aStream nextPut:$(.
    data printOn: aStream.
    aStream nextPut:$).

    "Modified: / 18-10-2011 / 21:28:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!StringPattern methodsFor:'utilities'!

matchObject: anObject
    "Return true if pattern matches given object with relax level 1.

    Some heuristics is performed to obtain the object's textual representation."

    self matchObject: anObject relax: 1

    "Created: / 29-11-2011 / 15:34:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

matchObject: object relax: relax
    "Return true if pattern matches given object.

    Some heuristics is performed to obtain the object's textual representation."

    object isString ifTrue:[
        ^self match: object relax: relax.
    ].
    object isHierarchicalItem ifTrue:[
        ^self match: object label relax: relax.
    ].

    ^self match: object displayString relax: relax.

    "Created: / 29-11-2011 / 15:37:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!StringPattern::Includes methodsFor:'conversion'!

asString
    "Returns a string representation of the pattern.
     
     `StringPattern fromString: pattern asString` should return
     the same pattern (same meaning equal)"

    ^ ' ', data

    "Created: / 23-01-2015 / 17:40:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!StringPattern::Includes methodsFor:'matching'!

match:string from: from to: to case: case relax:relax

    relax == 1 ifTrue:[
        | i |
        i := string indexOfSubCollection:data startingAt:from ifAbsent:0 caseSensitive:case.
        ^ i between: from and: to - data size + 1 
    ].
    ^false.

    "Created: / 26-11-2014 / 06:40:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!StringPattern::Matches methodsFor:'conversion'!

asString
    "Returns a string representation of the pattern.
     
     `StringPattern fromString: pattern asString` should return
     the same pattern (same meaning equal)"

    ^ data

    "Created: / 23-01-2015 / 17:41:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!StringPattern::Matches methodsFor:'matching'!

match:string from: from to: to case: case relax:relax
    | pattern |

    relax > 2 ifTrue:[ ^ false ].

    pattern := data.
    relax == 2 ifTrue:[
        data first ~~  $* ifTrue:[
            pattern := '*' , pattern.
        ].
        data last ~~  $* ifTrue:[
            pattern := pattern , '*'.
        ].
    ].
    ^ pattern match: string from: from to: to caseSensitive: case.

    "Created: / 26-11-2014 / 06:43:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!StringPattern::Parser class methodsFor:'parsing'!

parse: aStream onError: errorBlock

    ^self new parse: aStream onError: errorBlock

    "Created: / 09-08-2011 / 13:39:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!StringPattern::Parser methodsFor:'parsing'!

parse

    "Sorry, no fancy AND/OR patterns now"

   ^self parsePattern.

    "Created: / 09-08-2011 / 13:41:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parse: aStream onError: aBlock

    stream := aStream.
    errorBlock := aBlock.
    ^self parse.

    "Created: / 09-08-2011 / 13:40:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parsePattern

    | data |

    stream position == 0 ifTrue:[
        (stream peek notNil and:[stream peek isSeparator]) ifFalse:[
            data := stream upToEnd."/upToSeparator.
            (data includes: $*) ifTrue:[
                ^StringPattern matches: data
            ].
            (data includes: $?) ifTrue:[
                ^StringPattern matches: data
            ].
            ^StringPattern startsWith: data    
        ].
    ].

    stream skipSeparators.
    data := stream upToSeparator.
    (data includes: $*) ifTrue:[
        ^StringPattern matches: data
    ].
    (data includes: $?) ifTrue:[
        ^StringPattern matches: data
    ].
    ^StringPattern includes: data

    "Created: / 18-10-2011 / 21:26:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-12-2011 / 23:19:06 / jv"
    "Modified (format): / 09-01-2015 / 13:09:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!StringPattern::StartsWith methodsFor:'conversion'!

asString
    "Returns a string representation of the pattern.
     
     `StringPattern fromString: pattern asString` should return
     the same pattern (same meaning equal)"

    ^ data

    "Created: / 23-01-2015 / 17:41:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!StringPattern::StartsWith methodsFor:'matching'!

match: string from: from to: to case: case relax: relax

    relax == 1 ifTrue:[
        (case and:[from == 1]) ifTrue:[
            ^ string startsWith: data.
        ] ifFalse:[ 
            | stringSz dataSz |

            stringSz := string size.
            dataSz := data size.
            stringSz >= (from + dataSz - 1) ifTrue:[ 
                | i |

                i := dataSz.
                case ifTrue:[
                    [ i > 0 ] whileTrue:[ 
                        (string at: from + i - 1) ~~ (data at: i) ifTrue:[  ^ false ].
                        i := i - 1.
                    ].
                ] ifFalse:[
                    [ i > 0 ] whileTrue:[ 
                        (string at: from + i - 1) asLowercase ~~ (data at: i) asLowercase ifTrue:[  ^ false ].
                        i := i - 1.
                    ].
                ].
                ^ true
            ].
            ^ false
        ].
    ].
    relax == 2 ifTrue:[
        | i |
        i := string indexOfSubCollection:data startingAt:from ifAbsent:0 caseSensitive:case.
        ^ i between: from and: to - data size + 1 
    ].
    relax == 3 ifTrue:[
        ^ ('*', data, '*') match: string from: from to: to caseSensitive: case.
    ].
    ^false.

    "
        (StringPattern startsWith: 'String') match: 'StringPattern'
        (StringPattern startsWith: 'STring') match: 'StringPattern' relax: 2
        (StringPattern startsWith: 'Pattern') match: 'StringPattern' from: 7 to: 13 relax: 1   
        (StringPattern startsWith: 'String') match: 'StringPattern' from: 7 to: 13 relax: 1   
        (StringPattern startsWith: 'Pattern') match: 'StringPattern' relax: 2   

    "

    "Created: / 26-11-2014 / 06:45:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-11-2014 / 09:58:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!StringPattern class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

