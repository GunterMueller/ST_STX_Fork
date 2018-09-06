"
 COPYRIGHT (c) 1995 by Claus Gittinger
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

Object subclass:#SourceFileLoader
	instanceVariableNames:'myStream currentSource package wantChangeLog currentNameSpace
		usedNameSpaces reader'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler'
!

Object subclass:#SourceFileReader
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:SourceFileLoader
!

!SourceFileLoader class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
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
    Instances of this class are created temporary during fileIn.
    They get notified about any errors. Currently, all we
    do here is to output the error on the Transcript;
    eventually, we will open a box showing the position of the error.

    Also, information found in scanned compiler directives is remembered
    here, for later queries (this is required, since the fileIn mechanism
    creates new parsers for every chunk - someone has to remember this
    information across chunks ...).

    [author:]
        Claus Gittinger
"
! !

!SourceFileLoader class methodsFor:'instance creation'!

on:aStream
    ^ self new reader:aStream wantChangeLog:false
! !

!SourceFileLoader methodsFor:'accessing'!

reader:something
    "to fileIn gravel-Smalltalk sources"

    reader := something.
!

source:aString
    "this is optionally sent by the chunk reader,
     to pass a single chunks source before its evaluated.
     This allows me to show the erroneous code in a TextView
     (but this is not yet implemented)"

    currentSource := aString

    "Modified: 5.1.1997 / 03:06:32 / cg"
! !

!SourceFileLoader methodsFor:'compiler queries'!

currentNameSpace
    "sent by the compiler to ask for the current nameSpace.
     This is still to be finished ..."

    currentNameSpace isNil ifTrue:[
        currentNameSpace := Class nameSpaceQuerySignal query.
        "/ currentNameSpace := Smalltalk defaultNameSpace
    ].
    ^ currentNameSpace

    "Created: / 5.11.1996 / 22:05:19 / cg"
    "Modified: / 20.12.1996 / 00:01:32 / cg"
    "Modified: / 18.3.1999 / 18:28:24 / stefan"
!

isWorkspace
    "back-query from the compiler to ask if this is an interactive view
     (for error feedback)"

    ^ false

    "Created: / 19-10-2006 / 01:44:58 / cg"
!

packageToInstall
    "sent by the compiler to ask in which package new methods/classes
     are to be installed.
     This is still to be finished ..."

    package isNil ifTrue:[
        package := Class packageQuerySignal query.
        "/ package := Project currentPackageName
    ].
    ^ package

    "Created: / 5.11.1996 / 19:56:03 / cg"
    "Modified: / 20.12.1996 / 00:01:41 / cg"
    "Modified: / 18.3.1999 / 18:28:30 / stefan"
!

usedNameSpaces
    "sent by the compiler to ask for a list of used nameSpaces.
     This is still to be finished ..."

    ^ usedNameSpaces

    "Created: 5.11.1996 / 22:05:37 / cg"
!

wantChangeLog
    "sent by the compiler to ask if a changeLog entry should
     be written. Return false here, since SourceFileLaoders are
     used to read existing source files"

    ^ wantChangeLog
! !

!SourceFileLoader methodsFor:'directive processing'!

addUsedSpace:aNameSpace
    "sent by the compiler, whenever it encounters a 'Uses:'
     directive; collect used namespaces here, for later namespace
     queries"

    usedNameSpaces isNil ifTrue:[
        usedNameSpaces := OrderedCollection new.
    ].
    usedNameSpaces add:aNameSpace

    "Created: 19.12.1996 / 22:26:12 / cg"
    "Modified: 5.1.1997 / 03:07:17 / cg"
!

addUsedSpaces:aNameSpaceList
    "sent by the compiler, whenever it encounters a 'Uses:'
     directive; collect used namespaces here, for later namespace
     queries"

    usedNameSpaces isNil ifTrue:[
        usedNameSpaces := OrderedCollection new.
    ].
    aNameSpaceList do:[:aNameSpace |
        usedNameSpaces add:aNameSpace
    ].

    "Created: 19.12.1996 / 22:26:23 / cg"
    "Modified: 5.1.1997 / 03:07:24 / cg"
!

requirePackage:packageName
    "sent by the compiler, whenever it encounters a 'Prerequisites:'
     directive. For now, this is ignored."

    'SourceFileLoader require package: ' errorPrint.
    packageName errorPrintCR.

    "Modified: 5.1.1997 / 03:08:06 / cg"
!

setNameSpace:aNameSpaceName
    "sent by the compiler, whenever it encounters a 'NameSpace:'
     directive. Remember the namespace for further variable resolving
     and nameSpace queries."

    currentNameSpace := NameSpace fullName:aNameSpaceName

    "Modified: 5.1.1997 / 03:08:43 / cg"



!

setPackage:packageName
    "sent by the compiler, whenever it encounters a 'Package:'
     directive. Remember the package for further queries."

    package := packageName asSymbol

    "Modified: 5.1.1997 / 03:09:00 / cg"
!

setSyntax:aSyntaxName
    "sent by the compiler, whenever it encounters a 'Syntax:' directive. 
     Remember the syntax for further parsing."

    "/ currentSyntax := aSyntaxName
! !

!SourceFileLoader methodsFor:'error handling'!

correctableError:aMessage position:position to:endPos from:aCompiler
    "correctable error notification during fileIn.
     This is sent by the compiler/evaluator if it detects undefined variables-errors."

    "/ Transcript show:'**  '; showCR:aMessage.
    "/ self showWherePosition:position to:endPos from:aCompiler.

"/    Transcript show:'===>  '; showCR:aMessage.
"/    self showWherePosition:position to:endPos from:aCompiler.
    ^ false "/ no correction    

    "Modified: 8.11.1996 / 18:53:17 / cg"
!

correctableSelectorWarning:aMessage position:position to:endPos from:aCompiler
    "correctable error notification during fileIn."

    ^ false

    "Modified: / 19.1.2000 / 16:25:58 / cg"
    "Created: / 19.1.2000 / 16:27:25 / cg"
!

correctableWarning:aMessage position:position to:endPos from:aCompiler
    "correctable error notification during fileIn.
     This is sent by the compiler/evaluator if it detects undefined variables-errors."

    "/ Transcript show:'**  '; showCR:aMessage.
    "/ self showWherePosition:position to:endPos from:aCompiler.

    ^ self correctableError:aMessage position:position to:endPos from:aCompiler

    "Created: / 02-11-2010 / 13:29:15 / cg"
!

error:aMessage position:position to:endPos from:aCompiler
    "error notification during fileIn.
     This is sent by the compiler/evaluator if it detects errors."

    "
     will eventually open a TextBox here, showing the error ....
    "
    Transcript show:'===>  '; showCR:aMessage.
    self showWherePosition:position to:endPos from:aCompiler.
    ^ false

    "Modified: 8.11.1996 / 18:49:41 / cg"
!

insertAndSelect:aString at:aCharacterPosition
    "ST-80 compatible error notification during fileIn."

    "
     will eventually open a TextBox here, showing the error ....
    "
    Transcript show:'===>  '; showCR:aString.
    ^ false

    "Modified: 18.5.1996 / 15:44:54 / cg"
!

showWherePosition:position to:endPos from:aCompiler
    "show more details about the errors/warnings position."

    |cls sel where|

    "
     will eventually open a TextBox here, showing the error ....
    "
    (aCompiler notNil and:[(cls := aCompiler targetClass) notNil]) ifTrue:[
        (sel := aCompiler selector) notNil ifTrue:[
            Transcript show:'      when compiling '; show:cls name.
            Transcript show:'>>'; show:sel.
        ] ifFalse:[
            Transcript show:'      when compiling/evaluating for '; show:cls name.
        ].
        Transcript cr.
    ].
    myStream inputStream isFileStream ifTrue:[
        Transcript show:'      while reading '; showCR:myStream inputStream pathName.
    ].
    myStream lineNumber notNil ifTrue:[
        Transcript show:'      at or near line '; showCR: myStream lineNumber.
    ].
    (aCompiler notNil and:[(where := aCompiler lastTokenLineNumber) notNil]) ifTrue:[
        Transcript show:'      at or near line '; show:where; showCR:' [relative to chunk start]'.
    ].

    "Created: 8.11.1996 / 18:49:08 / cg"
    "Modified: 5.1.1997 / 03:04:05 / cg"
!

unusedVariableWarning:aString position:relPos to:relEndPos from:aCompiler
    "compiler notifies us of a (or some) unused variables;
     hilight the error (relPos to relEndPos) and show a Box asking for continue/correct/abort;
     this method should return true to the compiler if user wants the error
     to be corrected; false otherwise"

    ^ false
!

warning:aMessage position:position to:endPos from:aCompiler
    "warning notification during fileIn - ignore it.
     This is sent by the compiler/evaluator if it detects errors."

    ^ self
! !

!SourceFileLoader methodsFor:'private-accessing'!

reader:aStream wantChangeLog:aBoolean
    myStream := aStream.
    wantChangeLog := aBoolean
! !

!SourceFileLoader::SourceFileReader class methodsFor:'utilities'!

classNameMappingFor:aGravelClassName
    (aGravelClassName startsWith:'st.gravel.lang.') ifTrue:[
        ^ aGravelClassName copyFrom:'st.gravel.lang.' size + 1.
    ].
    self halt.
    ^ aGravelClassName
! !

!SourceFileLoader::SourceFileReader methodsFor:'class definition chunk API'!

addClassInstVar:instVarNameString
    self halt.
!

addClassMethod:methodCategoryString
    self halt.
!

addInstVar:instVarNameString
    self halt.
!

addMethod:methodCategoryString
    self halt.
!

addSimpleClassTrait:classNameString
    self halt.
!

addSimpleTrait:classNameString
    self halt.
!

defineClass:classNameString superclass:superClassNameString
    self halt.
!

extendClass:classNameString
    self halt.
!

extendTrait:classNameString
    self halt.
! !

!SourceFileLoader class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

