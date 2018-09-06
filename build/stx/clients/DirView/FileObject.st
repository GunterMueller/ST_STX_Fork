"
 COPYRIGHT (c) 1991 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 This is a demo example:

 THIS SOFTWARE IS PROVIDED BY THE CONTRIBUTOR ``AS IS'' AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED.  IN NO EVENT SHALL THE CONTRIBUTOR BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 SUCH DAMAGE.
"




"{ Package: 'stx:clients/DirView' }"

"{ NameSpace: Demos }"

DirectoryViewObject subclass:#FileObject
	instanceVariableNames:''
	classVariableNames:'Icon Mask IconCache'
	poolDictionaries:''
	category:'demos-DirectoryView'
!

FileObject comment:'
 any file

 %W% %E%
 written jan 91 by claus
'
!

!FileObject class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1991 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 This is a demo example:

 THIS SOFTWARE IS PROVIDED BY THE CONTRIBUTOR ``AS IS'' AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED.  IN NO EVENT SHALL THE CONTRIBUTOR BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 SUCH DAMAGE.
"



!

documentation
"
    any file in a directoryView

    [author:]
        Claus Gittinger (jan 91)
"
!

examples
"
    examples to be added.
"
! !

!FileObject class methodsFor:'specification'!

icon
    Icon isNil ifTrue:[
	Icon := Form fromFile:(self iconFileName) resolution:100
    ].
    ^ Icon
!

iconFileBaseName
    ^ 'FileObj'
!

mask
    Mask isNil ifTrue:[
	Mask := Form fromFile:(self maskFileName) resolution:100
    ].
    ^ Mask
! !

!FileObject methodsFor:'accessing'!

icon
    |i mime fn picFile|

    IconCache isNil ifTrue:[
        IconCache := CacheDictionary new:150.
    ].

    i := IconCache at:pathName ifAbsent:nil.
    i notNil ifTrue:[
        ^ i
    ].

    mime := MIMETypes mimeTypeForFilename:pathName.
    (mime notNil and:[mime startsWith:'image/']) ifTrue:[
        fn := pathName asFilename.
        picFile := (fn directory construct:'.xvpics') construct:(fn baseName).
        picFile exists ifTrue:[
            i := Image fromFile:picFile.
            i notNil ifTrue:[
                IconCache at:pathName put:i.
                ^ i.
            ].
        ].
        i := Image fromFile:pathName.
        i notNil ifTrue:[
            i := i magnifiedTo:48@64.
            IconCache at:pathName put:i.
            ^ i.
        ].
    ].
    ^ super icon
! !

!FileObject class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DirView/FileObject.st,v 1.10 2002-12-09 10:11:02 cg Exp $'
! !
