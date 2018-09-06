"{ Encoding: utf8 }"

"
 Copyright (c) 2007-2010 Jan Vrany, SWING Research Group, Czech Technical University in Prague
 Copyright (c) 2009-2010 eXept Software AG

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

"{ NameSpace: Smalltalk }"

Object subclass:#Diff
	instanceVariableNames:'equivMax heuristic nodiscards xvec yvec fdiag bdiag fdiagoff
		bdiagoff filevec cost snakeLimit inhibit'
	classVariableNames:''
	poolDictionaries:''
	category:'Collections-Support'
!

Link subclass:#Change
	instanceVariableNames:'inserted deleted line0 line1'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Diff
!

Object subclass:#Data
	instanceVariableNames:'bufferedLines equivs undiscarded realindexes nondiscardedLines
		changedFlag'
	classVariableNames:''
	poolDictionaries:''
	privateIn:Diff
!

Object subclass:#ForwardScript
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Diff
!

Object subclass:#ReverseScript
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:Diff
!

!Diff class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2007-2010 Jan Vrany, SWING Research Group, Czech Technical University in Prague
 Copyright (c) 2009-2010 eXept Software AG

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
!

documentation
"
    I'm standard diff implementation written purely in Smalltalk. I can
    compute differences between two sequenceable collections, not neccesaarily
    holding strings. Elements are compared using #=.

    Result of comparison is an edit script, a linked list of Diff::Changes,
    each keeping one difference: whether change is insert and/or delete,
    and positions in A and B.

    I'm a port of Java diff.

    [author:]
        Jakub Zelenka (zelenj7@fel.cvut.cz)
        Vladislav Skoumal (skoumal@skoumal.net)
        Jan Vrany (jan.vrany@fit.cvut.cz)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

documentation_czech
    "
první fáze:
#############################################################################################################################
first := #('prvni' 'druhy' 'treti' 'treti' 'paty' 'zeleny' 'ruzovy' ).
second := #('prvni' 'treti' 'zeleny' 'ruzovy' 'treti' 'bbb' 'ccc' 'aaa' 'aaa' 'hhh' 'iii' 'mmm' 'nnn' 'ppp' 'aaa' 'aaa' ).
############################################################################################################################
First a second pøedstavujou dvì pole, které chceme porovnávat. Jednotlivé poloky v poli si lze pøedstavit jako øádky, pøípadnì jako slova v øádku.
Podle toho, co je potøeba porovnávat.

*****************************************************************************************************************************
diff := FelDiff new felDiff.
*****************************************************************************************************************************
Zde probíhá inicializace defaultníh promìnných. Funguje to jako konstruktor.

############################################################################################################################
diff diff: first b: second
############################################################################################################################
První fáze nutná pro porovnávání polí.  Vzniknou dvì instance tøíde filedata uloené do pole. Tyto instance budou obsahovat následující údaje:

filevec[1].equivs=#(1 2 3 3 4 5 6)
filevec[1].bufferedLines=7
filevec[1].changedFlag=#()

filevec[2].equivs=#(1 3 6 7 3 8 9 10 10 11 12 13 14 15 10 10)
filevec[2].bufferedLines=16
filevec[2].changedFlag=#()

V zásadì se vytvoøila structura Dictionary, která jednotlivé øádky(slova) pøevedla na èísla. Pole equvs pak pøedstavuje èíselnì slova(øádky).
èísla, která se nalézají v obou dbou polí equivs znaèí, e soubory sdílí alespoò nìjaké slovo(øádek).

*****************************************************************************************************************************
change:= diff diff2: true.
*****************************************************************************************************************************

Zde ji dochází k porovnání obou dvou polí s øádky(slovy). Lze si vybrat mezi forwardscriptem a reversescriptem. 

1) metoda discardconfusinglines
výsledek:
filevec[1].undiscardeded=#(1 3 3 5 6 0 0)
filevec[1].realIndexes=  #(0 2 3 5 6 0 0)
filevec[1].nondiscardedLines=5
filevec[1].changedFlag=#(false false true false false true false false false)

filevec[2].undiscardeded=#(1 3 5 6 3 0 0 0 0 0 0 0 0 0 0 0)
filevec[2].realIndexes=  #(0 1 2 3 4 0 0 0 0 0 0 0 0 0 0 0)
filevec[2].nondiscardedLines=5

Undiscarded- Øádky soubory, které jsou shodné.
RealIndexes     - indexy øádkù v poli(je potøeba pøièíst jedna)
                        - to znamená e index prvního 3->3 pozice v prvním vstupním poli
                        - index druhého 3->2 pozice v druhém vstupním poli a 3->5 pozice v druhém vstupním poli 
NondiscardedLines- znaèí kolik èádkù(slov) je shodných v obou polích.

2)Následuje porovnávání jednotlivých polí a vytvoøení výsledku

3)Výsledek Reverse skript

inserted=12('treti' 'bbb' 'ccc' 'aaa' 'aaa' 'hhh' 'iii' 'mmm' 'nnn' 'ppp' 'aaa' 'aaa')
deleted=0
line0=7('ruzovy')
line1=4('ruzovy')
link=next

inserted- kolik znakù bylo vloeno
deleted - kolik znakù bylo smazáno
line0 - poøadí znaku za kterým bylo nìco vloeno(smazáno) v prvním poli(poslední znak který je shodný v obou polích)
line1 - poøadí znaku za kterým bylo nìco smazáno(vloeno) v prvním poli(poslední znak který je shodný v obou polích)

Take po znaku na pozici 4, je 12 vloených znakù oproti prvnímu 

Zbytek pole vypadá takto:

first := #('prvni' 'druhy' 'treti' 'treti' 'paty' 'zeleny' 'ruzovy' ).
second := #('prvni' 'treti' 'zeleny' 'ruzovy').

link není null a tudí odkazuje na dalí informace o zmìnách.
inserted=0
deleted=2('treti' 'paty')
line0=3('treti')
line1=2('treti')
link=next

zbytek pole vypadá takto:
first := #('prvni' 'druhy' 'treti' 'zeleny' 'ruzovy' ).
second := #('prvni' 'treti' 'zeleny' 'ruzovy').

link není null a tudí odkazuje na dalí informace o zmìnách.
inserted=0
deleted=1('druhy')
line0=1('prvni')
line1=1('prvni')
link=nil

zbytek pole vypadá takto:
first :=  #('prvni' 'treti' 'zeleny' 'ruzovy' ).
second := #('prvni' 'treti' 'zeleny' 'ruzovy').

link je nil. Neexistuje ádná zmìna a tato pole jsou shodná.

4)Výsledek Forward skript

inserted=0
deleted=1('druhy')
line0=1('prvni')
line1=1('prvni')
link=next

zbytek pole vypadá takto:
first :=  #('prvni' 'treti' 'treti' 'paty' 'zeleny' 'ruzovy' ).
second := #('prvni' 'treti' 'zeleny' 'ruzovy' 'treti' 'bbb' 'ccc' 'aaa' 'aaa' 'hhh' 'iii' 'mmm' 'nnn' 'ppp' 'aaa' 'aaa' ).

link není nil jdeme na odkaz:
inserted=0
deleted=2('treti' 'paty')
line0=3('treti')
line1=2('treti')
link=next

zbytek pole vypadá takto:
first :=  #('prvni' 'treti' 'zeleny' 'ruzovy' ).
second := #('prvni' 'treti' 'zeleny' 'ruzovy' 'treti' 'bbb' 'ccc' 'aaa' 'aaa' 'hhh' 'iii' 'mmm' 'nnn' 'ppp' 'aaa' 'aaa' ).

link není nil jdeme na odkaz:

inserted=12('treti' 'bbb' 'ccc' 'aaa' 'aaa' 'hhh' 'iii' 'mmm' 'nnn' 'ppp' 'aaa' 'aaa')
deleted=0
line0=7('ruzovy')
line1=4('ruzovy')
link=nil

zbytek pole vypadá takto:
first :=  #('prvni' 'treti' 'zeleny' 'ruzovy' ).
second := #('prvni' 'treti' 'zeleny' 'ruzovy').

Konec
"
! !

!Diff class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!Diff class methodsFor:'diffing'!

between: a and: b 

    ^self between: a and: b reverse: false

    "Created: / 16-02-2010 / 23:08:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

between: a and: b reverse: reverse

    ^self new
        a: a b: b;
        diff: reverse

    "Created: / 16-02-2010 / 23:04:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Diff methodsFor:'diffing'!

a:gA b:gB 
    "Prepare to find differences between two arrays.  Each element of
     the arrays is translated to an"
    "equivalence number"
    " based on
the result of <code>equals</code>.  The original Object arrays
are no longer needed for computing the differences.  They will
be needed again later to print the results of the comparison as
an edit script, if desired."
    
    |h data|

    h := Dictionary new:(gA size + gB size).
    data := Data new.
    data fileData.
    data 
        fileData:gA
        hashTable:h
        felDiff:self.
    self filevec at:1 put:data.
    data := Data new.
    data fileData.
    data 
        fileData:gB
        hashTable:h
        felDiff:self.
    self filevec at:2 put:data.

    "Modified: / 12-02-2010 / 14:22:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

diff

    ^self diff: false

    "Created: / 16-02-2010 / 22:50:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

diff:reverse 

    ^reverse 
        ifTrue:[self diffUsingScript: ReverseScript new]
        ifFalse:[self diffUsingScript: ForwardScript new]

    "Modified: / 16-02-2010 / 22:51:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

diffUsingScript:bld 
    "Get the results of comparison as an edit script.  The script
         is described by a list of changes.  The standard ScriptBuilder
         implementations provide for forward and reverse edit scripts.
         Alternate implementations could, for instance, list common elements
         instead of differences.
         @param bld an object to build the script from change flags
         @return the head of a list of changes
     Some lines are obviously insertions or deletions
           because they don't match anything.  Detect them now,
           and avoid even thinking about them in the main comparison algorithm."
    
    |diags first second ret|

    self discardConfusingLines.
     "Now do the main comparison algorithm, considering just the
     undiscarded lines."
    first := filevec at:1.
    second := filevec at:2.
    xvec := first undiscarded.
    yvec := second undiscarded.
    diags := (first nondiscardedLines) + (second nondiscardedLines) + 3.
    fdiag := Array new:diags withAll:0.
    fdiagoff := second nondiscardedLines + 1.
    bdiag := Array new:diags withAll:0.
    bdiagoff := second nondiscardedLines + 1.
    self 
        compareseq:0
        xlim:first nondiscardedLines
        yoff:0
        ylim:second nondiscardedLines.
    fdiag := nil.
    bdiag := nil.
    self shiftBoundaries.
    ret := bld 
                buildScript:first changedFlag
                length0:first bufferedLines
                changed1:second changedFlag
                length1:second bufferedLines.
    ^ ret.

    "Modified: / 12-02-2010 / 13:57:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Diff methodsFor:'initialization'!

initialize
    "konstruktor"
    
    equivMax := 1.
    heuristic := false.
    nodiscards := false.
    xvec := #().
    yvec := #().
    fdiag := #().
    bdiag := #().
    filevec := Array new:2.
    snakeLimit := 20.
    inhibit := false.

    "Modified: / 16-02-2010 / 22:51:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Diff methodsFor:'private'!

compareseq:gXoff xlim:gXlim yoff:gYoff ylim:gYlim
    "Compare in detail contiguous subsequences of the two files
     which are known, as a whole, to match each other.

     The results are recorded in the vectors filevec[N].changedflag, by
     storing a 1 in the element for each line that is an insertion or deletion.

     The subsequence of file 0 is [XOFF, XLIM) and likewise for file 1.

     Note that XLIM, YLIM are exclusive bounds.
     All line numbers are origin-0 and discarded lines are not counted."

    |xoff xlim yoff ylim c d f b|

    xoff := gXoff.
    xlim := gXlim.
    yoff := gYoff.
    ylim := gYlim.

    "Slide down the bottom initial diagonal."
    [(xoff < xlim) and: [(yoff < ylim) and: [(xvec at: xoff + 1) = (yvec at: yoff + 1)]]] whileTrue:
    [
        xoff := xoff + 1.
        yoff := yoff + 1.
    ].

    "Slide up the top initial diagonal."
    [(xlim > xoff) and: [(ylim > yoff) and: [(xvec at: xlim) = (yvec at: ylim)]]] whileTrue:
    [
        xlim := xlim - 1.
        ylim := ylim - 1.
    ].

    "Handle simple cases."

    (xoff = xlim) ifTrue:
    [
        [yoff < ylim] whileTrue:
        [
            ((filevec at: 2) changedFlag) at: (2 + ((filevec at: 2) realindexes at: yoff+1)) put: true.
            yoff := yoff + 1.
        ]
    ]
    ifFalse:
    [
        (yoff = ylim) ifTrue:
        [
            [xoff < xlim] whileTrue:
            [
                ((filevec at: 1) changedFlag) at: (2 + ((filevec at: 1) realindexes at: xoff+1)) put: true.
                xoff := xoff + 1.
            ]
        ]
        ifFalse:
        [
            "Find a point of correspondence in the middle of the files."
            d := self diag: xoff xlim: xlim yoff: yoff ylim: ylim.
            c := cost.
            f := fdiag at: (fdiagoff + d+1).
            b := bdiag at: (bdiagoff + d+1).

            (c = 1) ifTrue:
            [
                "This should be impossible, because it implies that
                 one of the two subsequences is empty,
                 and that case was handled above without calling `diag'.
                 Let's verify that this is true."
                d := Exception new.
                d raiseSignal.
            ]
            ifFalse:
            [
                 "Use that point to split this problem into two subproblems."
                 self compareseq: xoff xlim: b yoff: yoff ylim: (b - d).
                 "This used to use f instead of b,
                  but that is incorrect!!
                  It is not necessarily the case that diagonal d
                  has a snake from b to f."
                 self compareseq: b xlim: xlim yoff: (b - d) ylim: ylim.
            ]
        ]
    ]
!

diag: anXoff xlim: anXlim yoff: aYoff ylim: aYlim
    |fd bd xv yv dmin dmax fmid fmax bmid bmax fmin bmin odd c cont d bigsnake tlo thi x oldx y best bestpos dd v temp k cont2|
    fd := fdiag.    "Give the compiler a chance."
    bd := bdiag.    "Additional help for the compiler."
    xv := xvec.     "Still more help for the compiler."
    yv := yvec.     "And more and more . . ."
    dmin := anXoff-aYlim.   "Minimum valid diagonal."
    dmax := anXlim-aYoff.   "Maximum valid diagonal."
    fmid := anXoff-aYoff.   "Center diagonal of top-down search."
    bmid := anXlim-aYlim.   "Center diagonal of bottom-up search."
    fmin := fmid.   "Limits of top-down search."
    fmax := fmid.   " --||-- "
    bmin := bmid.   "Limits of bottom-up search."
    bmax := bmid.   " --||-- "

    odd := (fmid-bmid) odd. "True if southeast corner is on an odd diagonal with respect to the northwest."

    "Added + 1 to all arrays since StX uses index 1 as first"
    fd at:(fdiagoff+fmid + 1) put: anXoff.
    bd at:(bdiagoff+bmid + 1) put: anXlim.

    c := 1.
    cont := true.
    [cont = true] whileTrue:[
        d := nil.   "Active diagonal."
        bigsnake := false.

        "Extend the top-down search by an edit step in each diagonal."
        (fmin > dmin) ifTrue:[
            fmin := fmin-1.
            fd at:(fdiagoff + fmin - 1 + 1) put: -1.
        ]   ifFalse:[ fmin := fmin + 1. ].
        (fmax < dmax) ifTrue:[
            fmax := fmax+1.
            fd at:(fdiagoff + fmax + 1 + 1) put: -1.
        ]   ifFalse:[ fmax := fmax - 1. ].

        d := fmax.
        [(d >= fmin)] whileTrue:[
            tlo := fd at:(fdiagoff + d - 1 + 1).
            thi := fd at:(fdiagoff + d + 1 + 1).
            (tlo >= thi) ifTrue:[
                x := tlo + 1.
            ]   ifFalse:[ x := thi. ].
            oldx := x.
            y := x - d.
            [(x < anXlim) and: [(y < aYlim) and: [((xv at: (x+1)) = (yv at: (y+1)))]]] whileTrue:[
                x := x+1.
                y := y+1.
            ].
            ((x-oldx) > snakeLimit) ifTrue:[
                bigsnake := true.
            ].
            fd at: (fdiagoff + d + 1) put: x.
            (odd and: [bmin <= d and: [d <= bmax and:[(bd at:(bdiagoff + d + 1)) <= (fd at:(fdiagoff + d + 1))]]]) ifTrue:[
                cost := (2 * c) - 1.
                ^d.
            ]   ifFalse:[ d := d - 2.].
        ].

        "Similar extend the bottom-up search."
        (bmin > dmin) ifTrue:[
            bmin := bmin - 1.
            bd at:(bdiagoff + bmin - 1 + 1) put: 2147483647.
        ]   ifFalse:[ bmin := bmin + 1.].
        (bmax < dmax) ifTrue:[
            bmax := bmax + 1.
            bd at:(bdiagoff + bmax + 1 + 1) put: 2147483647.
        ] ifFalse:[ bmax := bmax - 1.].

        d := bmax.
        [(d >= bmin)] whileTrue:[
            tlo := bd at:(bdiagoff + d - 1 + 1).
            thi := bd at:(bdiagoff + d + 1 + 1).
            (tlo < thi) ifTrue:[
                x := tlo.
            ]   ifFalse:[ x := thi - 1. ].
            oldx := x.
            y := x - d.
            [(x > anXoff) and: [(y > aYoff) and: [((xv at: (x-1+1)) = (yv at: (y-1+1)))]]] whileTrue:[
                x := x-1.
                y := y-1.
            ].
            ((x-oldx) > snakeLimit) ifTrue:[
                bigsnake := true.
            ].
            bd at: (bdiagoff + d + 1) put: x.
            ((odd = false) and: [fmin <= d and: [d <= fmax and:[(bd at:(bdiagoff + d + 1)) <= (fd at:(fdiagoff + d + 1))]]]) ifTrue:[
                cost := (2 * c).
                ^d.
            ]   ifFalse:[ d := d - 2.].
        ].

        "Heuristic: check occasionally for a diagonal that has made
        lots of progress compared with the edit distance.
        If we have any such, find the one that has made the most
        progress and return it as if it had succeeded.

        With this heuristic, for files with a constant small density
        of changes, the algorithm is linear in the file size."
        ((c>200) and:[bigsnake and:[heuristic]]) ifTrue:[
            best := 0.
            bestpos := -1.
            d := fmax.
            [(d >= fmin)] whileTrue:[
                dd := d - fmid.
                x := fd at: (fdiagoff + d + 1).
                y := x - d.
                v := ((x - anXoff) * 2) - dd.
                temp := ((dd abs) + c) * 12.
                (v > temp) ifTrue:[
                    ((v > best) and:[(anXoff + snakeLimit <= x) and:[(x < anXlim) and:[(aYoff + snakeLimit <= y) and:[(y < aYlim)]]]]) ifTrue:[
                        "We have a good enough best diagonal;
                        now insist that it end with a significant snake."
                        k := 1.
                        cont2 := true.
                        [(xvec at:(x-k + 1)) = (yvec at:(y-k + 1)) and:[cont2]] whileTrue:[
                            (k = snakeLimit) ifTrue:[
                                best := v.
                                bestpos := d.
                                cont2 := false.
                            ]   ifFalse:[ k := k + 1.].
                        ].
                    ].
                ].
                d := d - 2.
            ].
            (best > 0) ifTrue:[
                cost := (2 * c) - 1.
                ^bestpos.
            ].

            best := 0.
            d := bmax.
            [(d >= bmin)] whileTrue:[
                dd := d - bmid.
                x := bd at: (bdiagoff + d + 1).
                y := x - d.
                v := ((anXlim - x) * 2) + dd.
                temp := ((dd abs) + c) * 12.
                (v > temp) ifTrue:[
                    ((v > best) and:[(anXoff < x) and:[(x <= (anXlim - snakeLimit)) and:[(aYoff < y) and:[(y <= (aYlim - snakeLimit))]]]]) ifTrue:[
                        "We have a good enough best diagonal;
                        now insist that it end with a significant snake."
                        k := 0.
                        cont2 := true.
                        [((xvec at:(x+k + 1)) = (yvec at:(y+k + 1))) and:[cont2]] whileTrue:[
                            (k = snakeLimit) ifTrue:[
                                best := v.
                                bestpos := d.
                                cont2 := false.
                            ]   ifFalse:[ k := k + 1.].
                        ].
                    ].
                ].
                d := d - 2.
            ].
            (best > 0) ifTrue:[
                cost := (2 * c) - 1.
                ^bestpos.
            ].
        ].
        c := c + 1.
    ]
!

discardConfusingLines
    "Discard lines from one file that have no matches in the other file."
    
    |first second|

    first := filevec at:1.
    second := filevec at:2.
    first discardConfusingLines:second  felDiff:self.
    second discardConfusingLines: first felDiff:self.
!

equivMax
    ^ equivMax
!

equivMax:something
    equivMax := something.
!

filevec
    ^ filevec
!

nodiscards
    ^ nodiscards
!

nodiscards:something
    nodiscards := something.
!

shiftBoundaries
    "Adjust inserts/deletes of blank lines to join changes
         as much as possible."
    
    |first second|

    (inhibit) ifTrue:[
        ^ nil.
    ].
    first := filevec at:1.
    second := filevec at:2.
    first shiftBoundaries:second.
    second shiftBoundaries:first.
! !

!Diff::Change class methodsFor:'documentation'!

documentation
"
     The result of comparison is an ""edit script"": a chain of change objects.
     Each change represents one place where some lines are deleted
     and some are inserted.

     LINE0 and LINE1 are the first affected lines in the two files (origin 0).
     DELETED is the number of lines deleted here from file 0.
     INSERTED is the number of lines inserted here in file 1.

     If DELETED is 0 then LINE0 is the number of the line before
     which the insertion was done; vice versa for INSERTED and LINE1.
"
! !

!Diff::Change methodsFor:'accessing'!

deleted
    "Line number of 1st deleted line."
    ^ deleted
!

inserted
    "# lines of file 0 changed here."
    ^ inserted
!

line0
    "Line number of 1st deleted line."
    ^ line0
!

line1
    "Line number of 1st inserted line."
    ^ line1
! !

!Diff::Change methodsFor:'enumerating'!

do: aBlock

    | chg |
    chg := self.
    [ chg notNil ] whileTrue:
        [aBlock value: chg.
        chg := chg nextLink].

    "Created: / 16-02-2010 / 22:53:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Diff::Change methodsFor:'instance creation'!

newLine0:aLine0 line1:aLine1 deleted:aDeleted inserted:aInserted next: nextChange 
    "Cons an additional entry onto the front of an edit script OLD.
     LINE0 and LINE1 are the first affected lines in the two files (origin 0).
     DELETED is the number of lines deleted here from file 0.
     INSERTED is the number of lines inserted here in file 1.

     If DELETED is 0 then LINE0 is the number of the line before
     which the insertion was done; vice versa for INSERTED and LINE1."
    
    line0 := aLine0.
    line1 := aLine1.
    deleted := aDeleted.
    inserted := aInserted.
    nextLink := nextChange.

    "Modified: / 12-02-2010 / 13:42:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Diff::Data methodsFor:'accessing'!

bufferedLines
    ^ bufferedLines
!

changedFlag
    ^ changedFlag
!

nondiscardedLines
    ^ nondiscardedLines
!

realindexes
    ^ realindexes
!

undiscarded
    ^ undiscarded
! !

!Diff::Data methodsFor:'default'!

clear
    "Allocate changed array for the results of comparison. 
     Allocate a flag for each line of each file, saying whether that line
     is an insertion or deletion. allocate an extra element, always zero, 
     at each end of each vector."
    
    changedFlag := Array new:bufferedLines + 2 withAll:false

    "Modified: / 12-02-2010 / 13:55:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

discard:discards felDiff:fellDiffClass
"Actually discard the lines.
      @param discards flags lines to be discarded"
|end j i|
end:=bufferedLines.
j:=0.
i:=0.
[i<end]whileTrue:[
    (fellDiffClass nodiscards or:[(discards at:i+1)=0])ifTrue:[
        undiscarded at:j+1 put:(equivs at:i+1).
        realindexes at:j+1 put:i.
        j:=j+1.
        ]ifFalse:[
        changedFlag at:(i+1+1) put:true.        
        ].
nondiscardedLines :=j.
i:=i+1.
    ].
!

discardConfusingLines: f felDiff: felDiff 
"
Discard lines that have no matches in another file.

       A line which is discarded will not be considered by the actual
       comparison algorithm; it will be as if that line were not in the file.
       The file's `realindexes' table maps virtual line numbers
       (which don't count the discarded lines) into real line numbers;
       this is how the actual comparison algorithm produces results
       that are comprehensible when the discarded lines are counted.

       When we discard a line, we also mark it as a deletion or insertion
       so that it will be printed in the output.  
      @param f the other file
"
        | discarded |
        self clear.

        "Set up table of which lines are going to be discarded."
        discarded := self discardable: (f equivCount: felDiff).

        "Don't really discard the provisional lines except when they occur
         in a run of discardables, with nonprovisionals at the beginning
         and end."
        self filterDiscards: discarded.

        "Actually discard the lines."
        self discard: discarded felDiff: felDiff.
!

discardable: counts 
" Mark to be discarded each line that matches no line of another file.
       If a line matches many lines, mark it as provisionally discardable.
       @see equivCount()
       @param counts The count of each equivalence number for the other file.
       @return 0=nondiscardable, 1=discardable or 2=provisionally discardable
        for each line"
    | nmatch i end discards equivs2 many tem |
    end := bufferedLines.
    discards := Array new: end.
    equivs2 := equivs.
    many := 5.
    tem := (end / 64).
	tem :=tem asInteger.
    tem := tem >> 2.
	i:=1.
	[i<=end]whileTrue:[discards at:i put:0.
	i:=i+1.].
"Multiply MANY by approximate square root of number of lines.
     That is the threshold for provisionally discardable lines. "
    [tem > 0]
        whileTrue: [many := many * 2.
	tem := tem >> 2
	].
            i := 1.
            [i <= end]
                whileTrue: [(equivs2 at: i)
                            = 0
                        ifFalse: [nmatch := counts
                                        at: (equivs2 at: i)+1.
                            nmatch = 0
                                ifTrue: [discards at: i put: 1]
                                ifFalse: [nmatch > many
                                        ifTrue: [discards at: i put: 2]]].
                    i := i + 1].
            
    ^ discards
!

equivCount: felDiff
        | pom i equivCount size|
        equivCount := Array new: (felDiff equivMax) withAll: 0.
                i:=1.
                size:=equivCount size.
                [i<=size]whileTrue:[
                equivCount at:i put:0.
                i:=i+1.
                ].
        
        i := 0.
        [i < bufferedLines]
                whileTrue: [
                                        pom:=equivs at: i+1.
                        pom := equivCount at: pom+1.
                                        pom := pom + 1.
                        equivCount at: (equivs at: i+1)+1 put: pom.
                                        i := i + 1.].
        ^ equivCount

    "Modified: / 12-02-2010 / 13:56:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileData
"konstruktor"
    equivs := #().
    undiscarded := #().
    realindexes := #().
    nondiscardedLines := 0.
    changedFlag := #().
!

fileData: data hashTable: h felDiff:fellDiffClass
    | i size ir|
    bufferedLines := data size.

    equivs := Array new: bufferedLines withAll: 0.

    undiscarded := Array new: bufferedLines withAll: 0.

    realindexes := Array new: bufferedLines withAll: 0.

    size := data size.
    i := 1.
    [i<=size]whileTrue: [ir := h at: (data at: i) ifAbsent: nil.
            ir isNil
                ifTrue: [ 
                    equivs at: i put:fellDiffClass equivMax.
                                fellDiffClass equivMax:( fellDiffClass equivMax + 1).
                    h at: (data at: i) put: (equivs at: i)]
                ifFalse: [equivs at: i put: ir].
i:=i+1].

    "Modified: / 12-02-2010 / 13:56:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

filterDiscards:discards 
    "Don't really discard the provisional lines except when they occur
           in a run of discardables, with nonprovisionals at the beginning
           and end."
    
    |end i j length provisional bool consec minimum tem|

    end := bufferedLines.
    i := 0.
    [ i < end ] whileTrue:[
        "Cancel provisional discards not in middle of run of discards."
        ((discards at:i + 1) isNil) ifTrue:[
            discards at:i + 1 put:0
        ].
        (discards at:i + 1) = 2 ifTrue:[
            discards at:i + 1 put:0
        ] ifFalse:[
            (discards at:i + 1) = 0 ifFalse:[
                "We have found a nonprovisional discard."
                provisional := 0.
                j := i.
                bool := true.
                 "Find end of this run of discardable lines.
                 Count how many are provisionally discardable."
                [ bool and:[ j < end ] ] whileTrue:[
                    (discards at:j + 1) = 2 ifTrue:[
                        provisional := provisional + 1
                    ].
                    (discards at:j + 1) = 0 ifTrue:[
                        bool := false
                    ] ifFalse:[ j := j + 1 ]
                ].
                 "Cancel provisional discards at end, and shrink the run."
                [
                    j > i and:[ (discards at:j - 1 + 1) = 2 ]
                ] whileTrue:[
                    j := j - 1.
                    discards at:j + 1 put:0.
                    provisional := provisional - 1
                ].
                 "Now we have the length of a run of discardable lines
                 whose first and last are not provisional."
                length := j - i.
                (provisional * 4 > length) ifTrue:[
                    [ j > i ] whileTrue:[
                        j := j - 1.
                        (discards at:j + 1) = 2 ifTrue:[
                            discards at:j + 1 put:0
                        ]
                    ]
                ] ifFalse:[
                    "MINIMUM is approximate square root of LENGTH/4.
                                   A subrun of two or more provisionals can stand
                                   when LENGTH is at least 16.
                                   A subrun of 4 or more can stand when LENGTH >= 64."
                    minimum := 1.
                    tem := (length / 4) asInteger.
                    tem := tem >> 2.
                    [ tem > 0 ] whileTrue:[
                        minimum := minimum * 2.
                        tem := tem >> 2
                    ].
                    minimum := minimum + 1.
                     "Cancel any subrun of MINIMUM or more provisionals
                     within the larger run."
                    j := 0.
                    consec := 0.
                    [ j < length ] whileTrue:[
                        (discards at:i + j + 1) ~= 2 ifTrue:[
                            consec := 0
                        ] ifFalse:[
                            consec := consec + 1.
                            minimum = consec ifTrue:[
                                "Back up to start of subrun, to cancel it all."
                                j := j - consec
                            ] ifFalse:[
                                discards at:i + j + 1 put:0
                            ]
                        ].
                        j := j + 1
                    ].
                     "Scan from beginning of run
                     until we find 3 or more nonprovisionals in a row
                     or until the first nonprovisional at least 8 lines in.
                     Until that point, cancel any provisionals."
                    j := 0.
                    consec := 0.
                    bool := true.
                    [
                        bool and:[ j < length ]
                    ] whileTrue:[
                        (j >= 8 and:[ (discards at:i + j + 1) = 1 ]) ifTrue:[
                            bool := false
                        ] ifFalse:[
                            (discards at:i + j + 1) = 2 ifTrue:[
                                consec := 0.
                                discards at:i + j + 1 put:0
                            ] ifFalse:[
                                (discards at:i + j + 1) = 0 ifTrue:[
                                    consec := 0
                                ] ifFalse:[
                                    consec := consec + 1
                                ]
                            ]
                        ].
                        (consec = 3) ifTrue:[
                            bool := false
                        ].
                        j := j + 1
                    ].
                     "I advances to the last line of the run."
                    i := i + length - 1.
                    bool := true.
                     "Same thing, from end. "
                    j := 0.
                    consec := 0.
                    [
                        bool and:[ j < length ]
                    ] whileTrue:[
                        (j >= 8 and:[ (discards at:i - j + 1) = 1 ]) ifTrue:[
                            bool := false
                        ] ifFalse:[
                            (discards at:i - j + 1) = 2 ifTrue:[
                                consec := 0.
                                discards at:i - j + 1 put:0
                            ] ifFalse:[
                                (discards at:i - j + 1) = 0 ifTrue:[
                                    consec := 0
                                ] ifFalse:[
                                    consec := consec + 1
                                ]
                            ]
                        ].
                        (consec = 3) ifTrue:[
                            bool := false
                        ].
                        j := j + 1
                    ]
                ]
            ]
        ].
        i := i + 1.
    ]
!

shiftBoundaries:f 
    "Adjust inserts/deletes of blank lines to join changes
           as much as possible.
           We do something when a run of changed lines include a blank
           line at one end and have an excluded blank line at the other.
           We are free to choose which blank line is included.
           `compareseq' always chooses the one at the beginning,
           but usually it is cleaner to consider the following blank line
           to be the change.  The only exception is if the preceding blank line
           would join this change to other changes.
          param f the file being compared against"

    |changed otherChanged i j iEnd preceding otherPreceding bool start end otherStart bool2|

    changed := changedFlag.
    otherChanged := f changedFlag.
    i := 0.
    j := 0.
    iEnd := bufferedLines.
    preceding := -1.
    otherPreceding := -1.
    bool := true.
    bool2 := true.
    [ bool ] whileTrue:[
        [
"Scan forwards to find beginning of another run of changes.
         Also keep track of the corresponding point in the other file. "
            i < iEnd and:[ ((changed at:(i + 1+1)) = false)]
        ] whileTrue:[
            [otherChanged at:( 1 + j +1)] whileTrue:[
"Non-corresponding lines in the other file
           will count as the preceding batch of changes."
                j := j + 1.
                otherPreceding := j.
            ].
                        j:=j+1.
                i := i + 1.
        ].

        (i >= iEnd) ifTrue:[
            bool := false.
        ] ifFalse:[
            start := i.
            otherStart := j.
            bool2 := true.
"Now find the end of this run of changes."
            [ bool2 ] whileTrue:[
                [i < iEnd and:[ changed at:(i + 1+1) ]] 
                    whileTrue:[ i := i + 1. ].
                end := i.
"If the first changed line matches the following unchanged one,
         and this run does not follow right after a previous run,
         and there are no lines deleted from the other file here,
         then classify the first changed line as unchanged
         and the following line as changed in its place.  */

          /* You might ask, how could this run follow right after another?
         Only because the previous run was shifted here."
                (end ~= iEnd and:[((equivs at:start+1) = (equivs at:end+1))
                            and:[((otherChanged at:(j + 1+1)) = false) 
                            and:[false = ((preceding >= 0 and:[start = preceding]) or:[ otherPreceding >= 0 and:[ otherStart = otherPreceding ]])
                                 ]
                            ]
                    ]) 
                        ifTrue:[
                            changed at:(1 + end+1) put:true.
                            end := end + 1.
                            changed at:(1 + start+1) put:false.
                            start := start + 1.
" Since one line-that-matches is now before this run
             instead of after, we must advance in the other file
             to keep in synch."
                            i := i + 1.
                            j := j + 1.
                        ]
                        ifFalse:[ bool2 := false ].
            ].
            preceding := i.
            otherPreceding := j.
        ].
    ].
! !

!Diff::ForwardScript methodsFor:'default'!

buildScript:aChanged0 length0:aLen0 changed1:aChanged1 length1:aLen1 
    "Scan the tables of which lines are inserted and deleted,
           producing an edit script in forward order."
    
    |script i0 i1 line0 line1|
    script := nil.
    i0 := aLen0.
    i1 := aLen1.
    [i0 >= 0 or:[i1 >= 0]] whileTrue:
            [((aChanged0 at:i0 + 1) or:[aChanged1 at:i1 + 1]) 
                ifTrue:
                    [line0 := i0.
                    line1 := i1.
                     "Find # lines changed here in each file."
                    [aChanged0 at:i0 + 1] whileTrue:[i0 := i0 - 1].
                    [aChanged1 at:i1 + 1] whileTrue:[i1 := i1 - 1].
                     "Record this change."
                    script := Diff::Change new 
                                newLine0:i0
                                line1:i1
                                deleted:line0 - i0
                                inserted:line1 - i1
                                next:script.].
             "We have reached lines in the two files that match each other."
            i0 := i0 - 1.
            i1 := i1 - 1.].
    ^script.

    "Modified: / 16-02-2010 / 22:49:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Diff::ReverseScript methodsFor:'default'!

buildScript:aChanged0 length0:aLen0 changed1:aChanged1 length1:aLen1 
    "Scan the tables of which lines are inserted and deleted,
     producing an edit script in reverse order."
    
    |script i0 i1 line0 line1|
    script := nil.
    i0 := 0.
    i1 := 0.
    [i0 < aLen0 or:[i1 < aLen1]] whileTrue:
            [((aChanged0 at:(1 + i0 + 1)) or:[aChanged1 at:(1 + i1 + 1)]) 
                ifTrue:
                    [line0 := i0.
                    line1 := i1.
                     "Find # lines changed here in each file."
                    [aChanged0 at:(1 + i0 + 1)] whileTrue:[i0 := i0 + 1].
                    [aChanged1 at:(1 + i1 + 1)] whileTrue:[i1 := i1 + 1].
                     "Record this change."
                    script := Diff::Change new 
                                newLine0:line0
                                line1:line1
                                deleted:(i0 - line0)
                                inserted:(i1 - line1)
                                next:script.].
             "We have reached lines in the two files that match each other."
            i0 := i0 + 1.
            i1 := i1 + 1.].
    ^script.

    "Modified: / 12-02-2010 / 14:15:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Diff class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !

