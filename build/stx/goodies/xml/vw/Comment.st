"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

Node subclass:#Comment
	instanceVariableNames:'text'
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Nodes'
!

Comment comment:'This class represents an XML comment. XML comments may appear anywhere in an XML document outside other markup or within the document type declaration at places allowed by grammar.

 XML comments are delimited by the start-tag ''<!!!!!!!!--'' and the end-tag ''-->''. 

According to the XML 1.0 specification, for compatibilty, double-hyphens (the string ''--'') must not occur within comments.

Instance Variables:
	text    <String>  contents of the comment element
'
!


!Comment methodsFor:'accessing'!

text

	^text
!

text: aText

	text := aText
!

xPath
    ^ parent xPath
!

xpathStringData
    ^self text
! !

!Comment methodsFor:'comparing'!

= anXmlComment
    ^ anXmlComment isComment 
        and:[text = anXmlComment text].
!

hash
    ^ text hash
! !

!Comment methodsFor:'printing'!

prettyPrintOn: aStream depth: indent
        aStream
            spaces:indent;
            nextPutAll: '<!!--';
            nextPutAll: (text ? '');
            nextPutAll: '-->'.
!

printCanonicalOn: aStream

	^self
!

printHTMLOn: aStream

        self prettyPrintOn: aStream
!

printNoIndentOn: aStream endSpacing: endSpacingBlock spacing: spacingBlock

        ^self prettyPrintOn: aStream
!

printOn: aStream
        aStream 
            nextPutAll: '<!!--';
            nextPutAll: (text ? '');
            nextPutAll: '-->'.
! !

!Comment methodsFor:'testing'!

isComment

	^true
! !

!Comment methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitComment:self
! !

!Comment class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/Comment.st,v 1.12 2013-07-03 07:04:25 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/Comment.st,v 1.12 2013-07-03 07:04:25 stefan Exp $'
! !

