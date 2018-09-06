"
stx:libscm - a new source code management library for Smalltalk/X
Copyright (C) 2012-2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
"{ Package: 'stx:libscm/mercurial' }"

"{ NameSpace: Smalltalk }"

Object subclass:#HGCopyrightLine
	instanceVariableNames:'line prefix years holder'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Mercurial-StX-Tools'
!

!HGCopyrightLine class methodsFor:'documentation'!

copyright
"
stx:libscm - a new source code management library for Smalltalk/X
Copyright (C) 2012-2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
! !

!HGCopyrightLine class methodsFor:'instance creation'!

readFrom:aStringOrStream onError:aBlock 
    "Parse a copyright line from given `aStringOrStream` (line). If given
     stream does not contain copyright line, return value of `aBlock`"
    
    | l  s  c  p  y1  y2 |

    l := aStringOrStream readStream contents.
    s := l readStream.
     
    "/ skip leading whitespaces:    
    
    s skipSeparators.
     
    "/ skip (optional) asterisk and whitespace following it.    
    
    s peek == $* ifTrue:[
        s next.
        s skipSeparators.
    ].
     
    "/ look for 'Copyright (c)' string. If found, this is a copyright
    "/ line, otherwise it is not and we return `nil` to indicate that.
    
    c := (s "'COPYRIGHT (c) ' size" nextAvailable:14) asLowercase.
    c = 'copyright (c) ' ifFalse:[
        ^ aBlock value
    ].
    p := s position.
     
    "/ parse years
    
    s skipSeparators.
    s peek isDigit ifTrue:[
        y1 := y2 := s nextAvailable:4.
        s skipSeparators.
        s peek == $- ifTrue:[
            s next.
            s skipSeparators.
            y2 := (s nextAvailable:4) trimSeparators.
            s skipSeparators.
        ].
        (y1 allSatisfy:[:c | c isDigit ]) ifTrue:[
            y1 := y1 asNumber.
        ].
        (y2 allSatisfy:[:c | c isDigit ]) ifTrue:[
            y2 := y2 asNumber.
        ].
    ].
    ^ (HGCopyrightLine new)
        prefix:(l copyTo:p - 1);
        years:(y1 notNil ifTrue:[
                    y1 to:y2
                ] ifFalse:[ nil ]);
        holder:(l copyFrom:s position + 1);
        yourself

    "
     HGCopyrigtLine readFrom: ' COPYRIGHT (c) 1994 by Claus Gittinger'
     HGCopyrigtLine readFrom: '              All Rights Reserved'

     HGCopyrigtLine readFrom: ' * COPYRIGHT (c) 1988-1995 by Claus Gittinger'
     HGCopyrigtLine readFrom: ' *              All Rights Reserved'

     HGCopyrigtLine readFrom: ' * COPYRIGHT (c) 2011-now Jan Vrany'
     HGCopyrigtLine readFrom: ' *              All Rights Reserved'

     HGCopyrigtLine readFrom: ' COPYRIGHT (c) Claus Gittinger / eXept Software AG'"
    "Created: / 14-05-2018 / 16:12:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCopyrightLine methodsFor:'accessing'!

holder
    ^ holder
!

holder:something
    holder := something.
!

line
    ^ line
!

line:something
    line := something.
!

prefix
    ^ prefix ? ' COPYRIGHT (C)'

    "Modified: / 15-05-2018 / 13:16:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

prefix:something
    prefix := something.
!

years
    ^ years
!

years:something
    years := something.
! !

!HGCopyrightLine methodsFor:'comparing'!

< another
    years ~= another years ifTrue:[ 
        ^ years start < another years start
            or:[ years stop < another years stop ]
    ] ifFalse:[ 
        ^ holder < another holder
    ].

    "Created: / 14-05-2018 / 16:54:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

= another
    ^ self class == another class
        and: [ prefix = another prefix
        and: [ years = another years 
        and: [ holder = another holder ]]]

    "Created: / 14-05-2018 / 16:50:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hash

    "/ This is a really bad hash function, we need #hashMultiply:
    "/ For now...
    ^ prefix hash bitXor: (years hash bitXor: holder hash)

    "Created: / 14-05-2018 / 16:48:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCopyrightLine methodsFor:'converting'!

asString
    ^ String streamContents:[ :s|
        s nextPutAll: self prefix; space.
        years notNil ifTrue:[
            years start printOn: s.
            years start ~~ years stop ifTrue:[
                s nextPut:$-.
                years stop printOn: s.        
            ].
            s space.
        ].
        s nextPutAll: holder.
    ].

    "Created: / 14-05-2018 / 15:45:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-05-2018 / 13:16:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCopyrightLine methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation of the receiver to the argument, aStream"

    super printOn:aStream.
    aStream nextPut:$(.
    aStream nextPutAll: self asString.
    aStream nextPut:$).

    "Modified: / 14-05-2018 / 15:50:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCopyrightLine methodsFor:'testing'!

isYearToNow
    "
    Return true, if this copyright years is in form YYYY-now (such as 20017-now).
    These are now considered invalid
    "
    ^ years notNil and:[ years stop = 'now' ]

    "Created: / 15-05-2018 / 06:14:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

