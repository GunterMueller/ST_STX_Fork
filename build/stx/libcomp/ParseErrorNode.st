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
"{ Package: 'stx:libcomp' }"

"{ NameSpace: Smalltalk }"

ParseNode subclass:#ParseErrorNode
	instanceVariableNames:'errorString errorToken children'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler-Support'
!

!ParseErrorNode class methodsFor:'documentation'!

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
    ParseErrorNode represent an erroneous portion of the source code.
    Error nodes are created by error-tolerant parser. So far the only
    user is SmallSenseParser (https://bitbucket.org/janvrany/jv-smallsense).

    Error nodes may have children which may not be error nodes. Such
    children represent a part of the code that actuallu could be parsed.
    Example:

        printValue: value
            Transcript show: (value printStringRadix: 12
            Transcript cr

    The tolerant parser may create tree like:
        statement (StatementNode)
            #show: (MessageNode)
                Transcript (ContantNode)
                <<error>> (ParseErrorNode)
                    #printStringRadix: (MessageNode)
                        value (VariableNode)
                        12 (ContantNode)
        statement (StatementNode)
            #cr (MessageNode)
                Transcript (ContantNode)

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!ParseErrorNode class methodsFor:'instance creation'!

errorString:arg
    ^ self new errorString:arg
! !

!ParseErrorNode methodsFor:'accessing'!

children
    ^ children
!

children:aCollection
    children := aCollection.
    children do:[:each | each parent: self ].

    "Modified: / 15-08-2013 / 11:43:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

errorString
    ^ errorString
!

errorString:something
    errorString := something.
!

errorToken

    ^errorToken

    "Created: / 27-11-2011 / 09:25:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

errorToken:something

    errorToken := something

    "Created: / 27-11-2011 / 09:25:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

lineNumber

    ^self objectAttributeAt: #lineNumber

    "Created: / 09-07-2011 / 22:30:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

lineNumber: anInteger

    self objectAttributeAt: #lineNumber put: anInteger

    "Created: / 09-07-2011 / 22:29:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !


!ParseErrorNode methodsFor:'printing & storing'!

printAllOn:aStream indent:indent
    children do: [:each | each printAllOn:aStream indent:indent ].
    self printOn:aStream indent:indent

    "Created: / 15-08-2013 / 12:29:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

printOn:aStream indent:indent
    "append a user printed representation of the receiver to aStream.
     The format is suitable for a human - not meant to be read back."

    aStream next: indent put: Character tab.
    aStream nextPutAll:'"<< parse error here'.
    errorString notNil ifTrue:[
        aStream nextPutAll:': '.
        aStream nextPutAll: errorString
    ].
    errorToken notNil ifTrue:[
        aStream nextPutAll:' (error token: '.
        aStream nextPutAll: errorToken.
        aStream nextPutAll: ')'.
    ].
    aStream nextPutAll:'>>"'

    "Created: / 20-04-2005 / 14:21:46 / cg"
    "Modified: / 15-08-2013 / 12:32:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ParseErrorNode methodsFor:'queries'!

isErrorNode
    ^ true
! !

!ParseErrorNode methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitParseErrorNode:self
! !

!ParseErrorNode class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

