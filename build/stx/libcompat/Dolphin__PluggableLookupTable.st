"{ Package: 'stx:libcompat' }"

"{ NameSpace: Dolphin }"

PluggableDictionary subclass:#PluggableLookupTable
	instanceVariableNames:'searchPolicy'
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-Dolphin'
!

!PluggableLookupTable class methodsFor:'documentation'!

documentation
"
    Just enough to make Spray happy ...

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
!

examples
"
    |dict|

    dict := PluggableLookupTable new searchPolicy: SearchPolicy caseInsensitive.
    dict at:'abc'   put:1.
    dict at:'hello' put:2.
    dict at:'aBc'.    
    dict at:'HELLO'
"
! !

!PluggableLookupTable methodsFor:'accessing'!

searchPolicy:aSearchPolicy
    "set the value of the instance variable 'searchPolicy' (automatically generated)"

    searchPolicy := aSearchPolicy.
    hashFunction := aSearchPolicy hashBlock.
    compareFunction := aSearchPolicy compareBlock.
! !

!PluggableLookupTable methodsFor:'private'!

hashFor:aKey
    "return aKeys hash value - must correspond to compareSame:with:"

    ^ searchPolicy hashFor:aKey
! !

!PluggableLookupTable class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/Dolphin__PluggableLookupTable.st,v 1.5 2016-08-11 13:25:05 stefan Exp $'
!

version_SVN
    ^ '$Id: Dolphin__PluggableLookupTable.st,v 1.5 2016-08-11 13:25:05 stefan Exp $'
! !

