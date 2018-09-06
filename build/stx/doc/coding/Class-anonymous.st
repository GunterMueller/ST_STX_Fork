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

"
 'anonymous classes' - demonstration
 -----------------------------------

 these examples show that classes can also be anonymous, for
 special applications this may make sense.

 (i.e. you CAN create classes on-the-fly without using the Browser).

 evaluate the expressions below ... (step by step, and read the code)
"!

"create an anonymous class ...

   |cls|

   cls := Behavior new.
   cls inspect

"create an anonymous class, an instance of it and inspect it ..."

   |cls inst|

   "create the class ..."
   cls := Behavior new.

   "create an instance"
   inst := cls new.
   inst inspect

"create an anonymous class, an instance of it, and learn it how
 to foo ..."

   |cls inst|

   "create the class ..."
   cls := Behavior new.

   "create an instance"
   inst := cls new.

   "now, tell it how to foo .."

   Compiler compile:'foo ''hello, here is foo'' printNL'
	   forClass:cls.

   Compiler compile:'bar Transcript showCR:''hello, here is bar'''
	   forClass:cls.

   inst foo.
   inst bar




