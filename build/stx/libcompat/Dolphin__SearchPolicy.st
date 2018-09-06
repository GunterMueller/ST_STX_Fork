"{ Package: 'stx:libcompat' }"

"{ NameSpace: Dolphin }"

Object subclass:#SearchPolicy
	instanceVariableNames:'compareBlock hashBlock'
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-Dolphin'
!

!SearchPolicy class methodsFor:'documentation'!

documentation
"
    Just enough to make Spray using PluggableLookupTable happy ...

    Dolphin compatibility class.
    This may be required when existing code has to be ported to ST/X;
    however, it may not be complete and more protocol may be added in the future.
    The code here was created when public domain code (Manchester) had to
    be ported to ST/X and missing classes/methods were encountered, and code added
    by reasoning 'what the original class could probably do there'.

    This is currently not used by ST/X itself.

    This is an additional goody class; therefore:

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
! !

!SearchPolicy class methodsFor:'instance creation'!

caseInsensitive
    ^ self new caseInsensitive

    "
     self caseInsensitive compareSame:'hello' with:'Hello'.
     self caseInsensitive compareSame:'hello1' with:'Hello2'. 

     self caseInsensitive hashFor:'hello'.  
     self caseInsensitive hashFor:'Hello'.  
    "
! !

!SearchPolicy methodsFor:'accessing'!

compareBlock
    ^ compareBlock
!

hashBlock
    ^ hashBlock
! !

!SearchPolicy methodsFor:'pluggable dictionary interface'!

compareSame:element1 with:element2
    ^ compareBlock value:element1 value:element2
!

hashFor:aKey
    ^ hashBlock value:aKey
! !

!SearchPolicy methodsFor:'private'!

caseInsensitive
    compareBlock := [:a :b | self caseInsensitiveCompare:a with:b].
    hashBlock    := [:key  | self caseInsensitiveHashFor:key].
!

caseInsensitiveCompare:a with:b
    a isNil ifTrue:[^ b isNil].
    b isNil ifTrue:[^ false].
    ^ a asLowercase = b asLowercase
!

caseInsensitiveHashFor:aString
    ^ aString asLowercase hash
! !

!SearchPolicy class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/Dolphin__SearchPolicy.st,v 1.3 2016-08-11 13:24:31 stefan Exp $'
!

version_SVN
    ^ '$Id: Dolphin__SearchPolicy.st,v 1.3 2016-08-11 13:24:31 stefan Exp $'
! !

