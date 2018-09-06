"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2010 by Jan Vrany, SWING Research Group. CTU in Prague
              All Rights Reserved

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the 'Software'), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Tools }"

TwoColumnTextView subclass:#DiffCodeView2
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-CodeView'
!

Object subclass:#DiffData
	instanceVariableNames:'text1 text2 inserted deleted changed'
	classVariableNames:''
	poolDictionaries:''
	privateIn:DiffCodeView2
!

!DiffCodeView2 class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2010 by Jan Vrany, SWING Research Group. CTU in Prague
              All Rights Reserved

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the 'Software'), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
"
! !

!DiffCodeView2 class methodsFor:'defaults'!

textViewClass
    "return the type of the synced subViews.
     Can be redefined in subclasses"

    ^ Tools::CodeView2

    "Created: / 06-03-2010 / 10:40:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DiffCodeView2 methodsFor:'accessing'!

classHolder: aValueModel

    textViews do:[:each|each classHolder: aValueModel].

    "Created: / 19-07-2011 / 12:55:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

codeAspect:aSymbol
    "tell the textViews what is shown, so they can adjust their
     syntaxhighlighters.
     See SyntaxHighlighter codeAspectXXX for possible aspects."

     textViews do:[:each|each codeAspect:aSymbol].

    "Created: / 27-07-2012 / 23:24:46 / cg"
!

languageHolder: aValueModel

    textViews do:[:each|each languageHolder: aValueModel].

    "Created: / 19-07-2011 / 12:55:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

modeHolder: aValueModel

    textViews do:[:each|each modeHolder: aValueModel].

    "Created: / 26-07-2012 / 19:19:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

text1:t1 text2:t2 
    |data|

    data := self computeDiffDataForText1:t1 text2:t2.

    (textViews at:1) 
        contents:(data text1);
        deletedLines:(data deleted);
        changedLines:(data changed);
        insertedLines:#();    
        originDiffText:t1;
        emptyLines:(data inserted).

    (textViews at:2) 
        contents:(data text2);
        deletedLines:#();
        changedLines:(data changed);
        insertedLines:(data inserted);
        originDiffText:t2;
        emptyLines:(data deleted).

    "Created: / 06-03-2010 / 10:45:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-06-2010 / 21:36:35 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 15-07-2010 / 23:08:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DiffCodeView2 methodsFor:'initialization'!

initialize
    super initialize.
    textViews do:[:thisView | 
        thisView diffMode:true.
        thisView ~= textViews first ifTrue:[
            thisView showGutterChannel value:false
        ].
        textViews do:[:otherView | 
            thisView == otherView ifFalse:[
                thisView synchronizeWith:otherView
            ]
        ]
    ].

    "Created: / 06-04-2010 / 14:15:03 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 23-06-2010 / 19:36:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DiffCodeView2 methodsFor:'private'!

computeDiffDataForText1:t1 text2:t2 
    "created diffText object from two strings
     This processes the DiffData as returned by the (now internal) Diff-tool"
    
    "/ cg: same code as in Diff2CodeView2!!!!!!
    "/ please refactor and make this a utility method on the class side

    |array1 array2 diff change index1 index2 text1 text2 i 
     diffData deleted inserted helperText addConstant1 addConstant2 changed helper ins del pom
     array1Size array2Size cr|

    cr := Character cr asString.

    "create line arrays from origin text(1 item/row)"
    array1 := self createArray:t1.
    array2 := self createArray:t2.
     "inserted,deleted, cahnged lines"
    inserted := OrderedCollection new.
    deleted := OrderedCollection new.
    changed := OrderedCollection new.
     "indicates which row of origin text is added to ne text"
    index1 := 1.
    index2 := 1.
     "indicate how much rows were deleted or inserted "
    addConstant1 := 0.
    addConstant2 := 0.
    text1 := OrderedCollection new.
    text2 := OrderedCollection new.
    diff := Diff new.
    diff a:array1 b:array2.
    change := diff diff:false.
    diffData := DiffData new.
    [ change notNil ] whileTrue:[
        "check first lines which are same"
        (((change line0) > 0) and:[ ((change line1) > 0) ]) ifTrue:[
            [
                index1 <= (change line0)
            ] whileTrue:[
                helperText := (array1 at:index1) asText.
                text1 add: helperText asString.
                index1 := index1 + 1.
            ].
            [
                index2 <= (change line1)
            ] whileTrue:[
                helperText := (array2 at:index2) asText.
                text2 add: helperText.
                index2 := index2 + 1.
            ].
        ].
        ins := change inserted.
        del := change deleted.
        index1 := (change line0) + 1.
        index2 := (change line1) + 1.
         "find replaced lines "
        ((del > 0) and:[ ins > 0 ]) ifTrue:[
            helper := del - ins.
            (helper <= 0) ifTrue:[
                pom := change deleted.
            ].
            (helper > 0) ifTrue:[
                pom := change inserted.
            ].
             "its same count row"
            i := 1.
            [ i <= pom ] whileTrue:[
                changed add:index1 + addConstant1.
                text1 add: (array1 at:index1) asString.
                text2 add: (array2 at:index2) asString.
                index1 := index1 + 1.
                index2 := index2 + 1.
                del := del - 1.
                ins := ins - 1.
                i := i + 1.
            ].
        ].
         "find deleted lines"
        (del > 0) ifTrue:[
            i := 1.
            [ i <= del ] whileTrue:[
                deleted add:index1 + addConstant1.
                text2 add: cr.
                addConstant2 := addConstant2 + 1.
                text1 add: (array1 at:index1) asString.
                index1 := index1 + 1.
                i := i + 1.
            ].
        ].
         "find inserted lines"
        (ins > 0) ifTrue:[
            i := 1.
            [ i <= ins ] whileTrue:[
                inserted add:index2 + addConstant2.
                text1 add: cr.
                addConstant1 := addConstant1 + 1.
                text2 add: (array2 at:index2) asString.
                index2 := index2 + 1.
                i := i + 1.
            ].
        ].
        change := change nextLink.
    ].
     "kontrola zda nam nechybi posledni znaky"
    array1Size := array1 size.
    (index1 <= array1Size) ifTrue:[
        [ index1 <= array1Size ] whileTrue:[
            helperText := (array1 at:index1) asText.
            text1 add: helperText.
            index1 := index1 + 1.
        ].
    ].
    array2Size := array2 size.
    (index2 <= array2Size) ifTrue:[
        [ index2 <= array2Size ] whileTrue:[
            helperText := (array2 at:index2) asText.
            text2 add: helperText.
            index2 := index2 + 1.
        ].
    ].

    1 to:(text1 size min:text2 size) do:[:idx |
        |l1 l2|

        l1 := text1 at:idx.
        l2 := text2 at:idx.
        l1 = l2 ifTrue:[
            text1 at:idx put:l1 string.   "/ remove color
            text2 at:idx put:l2 string.
            changed remove:idx ifAbsent:[].
        ] ifFalse:[
            l1 withoutSeparators = l2 withoutSeparators ifTrue:[
                text1 at:idx put:l1 string.     "/ remove color  
                text2 at:idx put:l2 string.
                changed remove:idx ifAbsent:[].
            ] ifFalse:[
                "/ self halt.
            ]
        ]
    ].

    diffData text1:(text1 asStringWith:'').
    diffData text2:(text2 asStringWith:'').
    diffData changed:changed.
    diffData inserted:inserted.
    diffData deleted:deleted.
    ^ diffData.

    "Modified: / 22-06-2010 / 21:02:50 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 24-06-2010 / 21:07:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-07-2012 / 18:55:01 / cg"
!

createArray:text1
    "cg: isn't that an obfuscated variation of #asCollectionOfLines ?"

    "/ ^ text1 asStringCollection. "/ yes, it looks like !! 

    "/ JV@2012-07-26: Yes, looks like but it is not!! This version
    "/ keeps CRs in lines. Do not change it back - if you do, DiffCodeView2 
    "/ will show whole source in a single line.

    | array src line c |

    array := StringCollection new.
    src := text1 readStream.
    line := (String new: 80) writeStream.
    [ src atEnd ] whileFalse:[
        c := src next.
        line nextPut: c.
        c == Character cr ifTrue:[
            array add: line contents.
            line reset.
        ]        
    ].
    line position ~~ 0 ifTrue:[
        array add: line contents
    ].
    ^array

    "Created: / 22-03-2010 / 14:48:27 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 17-07-2012 / 18:55:21 / cg"
    "Modified (comment): / 26-07-2012 / 21:45:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

old_computeDiffDataForText1:t1 text2:t2 
    "created diffText object from two strings
     This processes the DiffData as returned by the (now internal) Diff-tool"
    
    "/ cg: same code as in Diff2CodeView2!!!!!!
    "/ please refactor and make this a utility method on the class side

    |array1 array2 diff change index1 index2 text1 text2 i 
     diffData deleted inserted helperText addConstant1 addConstant2 changed helper ins del pom
     array1Size array2Size|

    "create line arrays from origin text(1 item/row)"
    array1 := self createArray:t1.
    array2 := self createArray:t2.
     "inserted,deleted, cahnged lines"
    inserted := OrderedCollection new.
    deleted := OrderedCollection new.
    changed := OrderedCollection new.
     "indicates which row of origin text is added to ne text"
    index1 := 1.
    index2 := 1.
     "indicate how much rows were deleted or inserted "
    addConstant1 := 0.
    addConstant2 := 0.
    text1 := ''.
    text2 := ''.
    diff := Diff new.
    diff a:array1 b:array2.
    change := diff diff:false.
    diffData := DiffData new.
    [ change notNil ] whileTrue:[
        "check first lines which are same"
        (((change line0) > 0) and:[ ((change line1) > 0) ]) ifTrue:[
            [
                index1 <= (change line0)
            ] whileTrue:[
                helperText := (array1 at:index1) asText.
                text1 := text1 asString , helperText asString.
                index1 := index1 + 1.
            ].
            [
                index2 <= (change line1)
            ] whileTrue:[
                helperText := (array2 at:index2) asText.
                text2 := text2 , helperText.
                index2 := index2 + 1.
            ].
        ].
        ins := change inserted.
        del := change deleted.
        index1 := (change line0) + 1.
        index2 := (change line1) + 1.
         "find replaced lines "
        ((del > 0) and:[ ins > 0 ]) ifTrue:[
            helper := del - ins.
            (helper <= 0) ifTrue:[
                pom := change deleted.
            ].
            (helper > 0) ifTrue:[
                pom := change inserted.
            ].
             "its same count row"
            i := 1.
            [ i <= pom ] whileTrue:[
                changed add:index1 + addConstant1.
                text1 := text1 , (array1 at:index1) asString.
                text2 := text2 , (array2 at:index2) asString.
                index1 := index1 + 1.
                index2 := index2 + 1.
                del := del - 1.
                ins := ins - 1.
                i := i + 1.
            ].
        ].
         "find deleted lines"
        (del > 0) ifTrue:[
            i := 1.
            [ i <= del ] whileTrue:[
                deleted add:index1 + addConstant1.
                text2 := text2 , Character cr.
                addConstant2 := addConstant2 + 1.
                text1 := text1 , (array1 at:index1) asString.
                index1 := index1 + 1.
                i := i + 1.
            ].
        ].
         "find inserted lines"
        (ins > 0) ifTrue:[
            i := 1.
            [ i <= ins ] whileTrue:[
                inserted add:index2 + addConstant2.
                text1 := text1 , Character cr.
                addConstant1 := addConstant1 + 1.
                text2 := text2 , (array2 at:index2) asString.
                index2 := index2 + 1.
                i := i + 1.
            ].
        ].
        change := change nextLink.
    ].
     "kontrola zda nam nechybi posledni znaky"
    array1Size := array1 size.
    (index1 <= array1Size) ifTrue:[
        [ index1 <= array1Size ] whileTrue:[
            helperText := (array1 at:index1) asText.
            text1 := text1 , helperText.
            index1 := index1 + 1.
        ].
    ].
    array2Size := array2 size.
    (index2 <= array2Size) ifTrue:[
        [ index2 <= array2Size ] whileTrue:[
            helperText := (array2 at:index2) asText.
            text2 := text2 , helperText.
            index2 := index2 + 1.
        ].
    ].
    diffData text1:text1.
    diffData text2:text2.
    diffData changed:changed.
    diffData inserted:inserted.
    diffData deleted:deleted.
    ^ diffData.

    "Modified: / 22-06-2010 / 21:02:50 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 24-06-2010 / 21:07:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-07-2012 / 18:55:01 / cg"
! !

!DiffCodeView2::DiffData methodsFor:'accessing'!

changed

    ^changed copy

    "Modified: / 02-05-2010 / 19:31:18 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 16-07-2010 / 09:35:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changed:something
    changed := something.
!

deleted
    ^ deleted
!

deleted:something
    deleted := something.
!

inserted
    ^ inserted
!

inserted:something
    inserted := something.
!

text1
    ^ text1
!

text1:something
    text1 := something.
!

text2
    ^ text2
!

text2:something
    text2 := something.
! !

!DiffCodeView2 class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !

