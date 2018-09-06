"{ Package: 'stx:libjava/tools' }"

"{ NameSpace: Smalltalk }"

JavaAbstractSourceHighlighter subclass:#JavaAbstractLexicalHighlighter
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Tools-Source'
!

!JavaAbstractLexicalHighlighter class methodsFor:'documentation'!

documentation
"
    A syntax higlighter class that does only lexical highlighting (i.e., no parsing).
    It is therefore faster than full parsing highlighters but also less accurate
    and does not fill source index (so no navigation)

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!JavaAbstractLexicalHighlighter class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned here for myself only; false for subclasses.
     Abstract subclasses must redefine again."

    ^ self == JavaAbstractLexicalHighlighter.
! !

!JavaAbstractLexicalHighlighter methodsFor:'accessing-classes'!

scannerClass
    "Return a highlighting scanner class to use"

    ^ self subclassResponsibility

    "Created: / 25-06-2014 / 11:56:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaAbstractLexicalHighlighter methodsFor:'formatting'!

formatClassDefinition:source in:class
    ^ self format: source

    "Created: / 25-06-2014 / 12:51:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formatMethod:mth source:source in:class using: prefs
    ^ self format: source

    "Created: / 25-06-2014 / 12:52:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

formatMethod:mthd source:newCode line: line number: lnr in:cls using:syntaxPreferences
    | scanner |

    line isEmptyOrNil ifTrue:[ ^  nil ].

    sourceText := line asText.
    preferences := syntaxPreferences.
    preferences isNil ifTrue:[
        "/ The `...codeViewThene ? UserPreferences current` trick below is 
        "/ there to make this code working with both old and editor-thene-aware 
        "/ code. Will wanish as soon as editor thene support will be
        "/ integrated.
        preferences := UserPreferences current codeViewTheme ? UserPreferences current.
    ].
    scanner := self scannerClass for: line asString.
    scanner highlighter: self.
    [
        [ scanner nextToken ~~ #EOF ] whileTrue.
    ] on: Error do:[

    ].
    ^ sourceText

    "Created: / 04-08-2013 / 00:26:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-12-2017 / 21:17:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaAbstractLexicalHighlighter methodsFor:'formatting-private'!

format: source
    "Simple formatting based on lexical structure only"

    | scanner token lastValue0 lastPosition0 |
    preferences isNil ifTrue:[ 
        "/ The `...codeViewThene ? UserPreferences current` trick below is 
        "/ there to make this code working with both old and editor-thene-aware 
        "/ code. Will wanish as soon as editor thene support will be
        "/ integrated.
        preferences := UserPreferences current codeViewTheme ? UserPreferences current.
    ].
    sourceText := source asText.
    scanner := self scannerClass for: source string.
    scanner highlighter: self.
    Error ignoreIn:[
        [ (token := scanner nextToken) ~~ #EOF ] whileTrue:[
            "/ Here, try to guess what's selector...
            token == $( ifTrue:[
                lastPosition0 == #Identifier ifTrue:[
                    self markSelectorFrom: lastPosition0  to: lastPosition0 + lastValue0 size - 1.
                ].
            ].


            lastValue0 := scanner tokenValue.
            lastPosition0 := scanner tokenStartPosition.
        ].
    ].
    ^ sourceText

    "Created: / 03-10-2013 / 20:19:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-12-2017 / 21:17:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaAbstractLexicalHighlighter class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

