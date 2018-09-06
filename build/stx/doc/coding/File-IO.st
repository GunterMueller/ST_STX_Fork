"
 COPYRIGHT (c) 1994 by Claus Gittinger
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

 'fileIO' - examples
 -------------------

 short coding fragments on file I/O


  Textfiles:

    writing (create the file, or truncate if existing):

	|myStream|

	myStream := 'testfile' asFilename writeStream.
	myStream nextPutAll:'hello world'.
	myStream cr.
	myStream close

	alternative:

	|myStream|

	myStream := FileStream newFileNamed:'testfile'.
	myStream nextPutAll:'hello world'.
	myStream cr.
	myStream close

    appending:

	|myStream|

	myStream := FileStream appendingOldFileNamed:'testfile'.
	myStream nextPutAll:'hello world'.
	myStream cr.
	myStream close

    rewriting:

	|myStream|

	myStream := FileStream oldFileNamed:'testfile'.
	myStream nextPutAll:'***** *****'.
	myStream close


  Binaryfiles:

    writing (create the file, or truncate if existing):

	|myStream buffer|

	myStream := 'testfile2' asFilename writeStream.
	myStream binary.
	myStream nextPut:1;     "writing bytes"
		 nextPut:2;
		 nextPut:3;
		 nextPut:4.
	myStream nextPutShort:16r1234 MSB:true.
	myStream nextPutShort:16r1234 MSB:true.
	myStream nextPutShort:16r1234 MSB:false.
	myStream nextPutShort:16r1234 MSB:false.
	myStream nextPutShort:16r8765 MSB:true.
	myStream nextPutShort:16r8765 MSB:true.
	myStream nextPutShort:16r8765 MSB:false.
	myStream nextPutShort:16r8765 MSB:false.

	myStream nextPutLong:16r12345678 MSB:true.
	myStream nextPutLong:16r12345678 MSB:true.
	myStream nextPutLong:16r12345678 MSB:false.
	myStream nextPutLong:16r12345678 MSB:false.
	myStream nextPutLong:16r87654321 MSB:true.
	myStream nextPutLong:16r87654321 MSB:true.
	myStream nextPutLong:16r87654321 MSB:false.
	myStream nextPutLong:16r87654321 MSB:false.

	myStream nextPutLong:16r12345678 MSB:true.
	myStream nextPutLong:16r12345678 MSB:true.
	myStream nextPutLong:16r12345678 MSB:false.
	myStream nextPutLong:16r12345678 MSB:false.
	myStream nextPutLong:16r87654321 MSB:true.
	myStream nextPutLong:16r87654321 MSB:true.
	myStream nextPutLong:16r87654321 MSB:false.
	myStream nextPutLong:16r87654321 MSB:false.

	myStream nextPutAll:#[10 9 8 7 6 5 4 3 2 1].    "a byte array"
	buffer := 'abcdefghijklmnopqrstuvwxyz'.
	myStream nextPutBytes:16 from:buffer startingAt:3.
	myStream close

    reading:

	|myStream buffer|

	Integer displayRadix:16.   "looks better here ..."
	myStream := 'testfile2' asFilename readStream.
	myStream binary.

	Transcript cr; showCR:'bytes ...'.
	Transcript showCR:(myStream next:4).

	Transcript cr; showCR:'shorts ...'.
	Transcript show:(myStream nextShortMSB:true) displayString; space.
	Transcript show:(myStream nextShortMSB:false) displayString; space.
	Transcript show:(myStream nextShortMSB:true) displayString; space.
	Transcript show:(myStream nextShortMSB:false) displayString; space.
	Transcript show:(myStream nextShortMSB:true) displayString; space.
	Transcript show:(myStream nextShortMSB:false) displayString; space.
	Transcript show:(myStream nextShortMSB:true) displayString; space.
	Transcript show:(myStream nextShortMSB:false) displayString; space.
	Transcript cr.

	Transcript cr; showCR:'longs ...'.
	Transcript show:(myStream nextLongMSB:true) displayString; space.
	Transcript show:(myStream nextLongMSB:false) displayString; space.
	Transcript show:(myStream nextLongMSB:true) displayString; space.
	Transcript show:(myStream nextLongMSB:false) displayString; space.
	Transcript show:(myStream nextLongMSB:true) displayString; space.
	Transcript show:(myStream nextLongMSB:false) displayString; space.
	Transcript show:(myStream nextLongMSB:true) displayString; space.
	Transcript show:(myStream nextLongMSB:false) displayString; space.
	Transcript cr.

	Transcript cr; showCR:'unsigned longs ...'.
	Transcript show:(myStream nextUnsignedLongMSB:true) displayString; space.
	Transcript show:(myStream nextUnsignedLongMSB:false) displayString; space.
	Transcript show:(myStream nextUnsignedLongMSB:true) displayString; space.
	Transcript show:(myStream nextUnsignedLongMSB:false) displayString; space.
	Transcript show:(myStream nextUnsignedLongMSB:true) displayString; space.
	Transcript show:(myStream nextUnsignedLongMSB:false) displayString; space.
	Transcript show:(myStream nextUnsignedLongMSB:true) displayString; space.
	Transcript show:(myStream nextUnsignedLongMSB:false) displayString; space.
	Transcript cr.

	Transcript cr; showCR:'bytes ...'.
	Transcript showCR:(myStream next:10).

	Transcript cr; showCR:'more bytes ...'.
	buffer := String new:16.
	Transcript show:(myStream nextBytes:16 into:buffer); space; showCR:buffer.
	myStream close.
	Integer displayRadix:10.
