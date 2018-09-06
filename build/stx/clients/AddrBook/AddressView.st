"
 COPYRIGHT (c) 1993 by Claus Gittinger
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

View subclass:#AddressView
	instanceVariableNames:'label1 label2 label3 label4 label5 label6 label7 label8 label9
		label10 label11 label12 companyField prenameField streetField
		plzField townField telField telPrivateField faxField emailField
		textField titleField nameField enterFieldGroup1 fields'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-AddressBook'
!

!AddressView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
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
    built with an old, preliminary version of the Interface Builder
"
! !

!AddressView class methodsFor:'startup'!

start
    |top|

    top := StandardSystemView new.
    top label:'Addresses'.
    top extent:565@460.
    self origin:0.0 @ 0.0 extent:1.0 @ 1.0 in:top.
    top realize
! !

!AddressView methodsFor:'accessing'!

fields
    ^ fields
!

leaveAction:aBlock
     enterFieldGroup1 leaveAction:aBlock
! !

!AddressView methodsFor:'initialization'!

initialize
    super initialize.
    self setupSubViews.
    self setupLocalStuff.

    fields := Dictionary new.
    fields at:#company put:companyField.
    fields at:#title put:titleField.
    fields at:#name put:nameField.
    fields at:#firstName put:prenameField.
    fields at:#street put:streetField.
    fields at:#zip put:plzField.
    fields at:#city put:townField.
    fields at:#telno put:telField.
    fields at:#telno2 put:telPrivateField.
    fields at:#email put:emailField.
    fields at:#fax put:faxField.
    fields at:#text put:textField.

    enterFieldGroup1 := EnterFieldGroup new.
    enterFieldGroup1 add:companyField.
    enterFieldGroup1 add:titleField.
    enterFieldGroup1 add:prenameField.
    enterFieldGroup1 add:nameField.
    enterFieldGroup1 add:streetField.
    enterFieldGroup1 add:plzField.
    enterFieldGroup1 add:townField.
    enterFieldGroup1 add:telField.
    enterFieldGroup1 add:telPrivateField.
    enterFieldGroup1 add:faxField.
    enterFieldGroup1 add:emailField.

    self delegate:enterFieldGroup1 "/ (KeyboardForwarder to:enterFieldGroup1)
!

setupLocalStuff
    ^ self
!

setupSubViews
    |v f|


    f := (Font family:'helvetica'
		    face:'medium'
		   style:'roman'
		    size:10).

    label1 := Label in:self.
    label1 origin:(18@9) extent:(46@20).
    label1 label:'Firma:'.
    label1 borderWidth:0.
    label1 font:f; adjust:#right.

    label2 := Label in:self.
    label2 origin:(11@34) extent:(53@20).
    label2 label:'Anrede:'.
    label2 borderWidth:0.
    label2 font:f; adjust:#right.

    label3 := Label in:self.
    label3 origin:(217@59) extent:(39@20).
    label3 label:'Name:'.
    label3 borderWidth:0.
    label3 font:f; adjust:#right.

    label4 := Label in:self.
    label4 origin:(4@59) extent:(60@20).
    label4 label:'Vorname:'.
    label4 borderWidth:0.
    label4 font:f; adjust:#right.

    label5 := Label in:self.
    label5 origin:(4@96) extent:(60@20).
    label5 label:'Strasse:'.
    label5 borderWidth:0.
    label5 font:f; adjust:#right.

    label6 := Label in:self.
    label6 origin:(32@121) extent:(32@20).
    label6 label:'PLZ:'.
    label6 borderWidth:0.
    label6 font:f; adjust:#right.

    label7 := Label in:self.
    label7 origin:(157@121) extent:(32@20).
    label7 label:'Ort:'.
    label7 borderWidth:0.
    label7 font:f; adjust:#right.

    label8 := Label in:self.
    label8 origin:(266@161) extent:(102@20).
    label8 label:'Tel. (privat):'.
    label8 borderWidth:0.
    label8 font:f; adjust:#right.

    label9 := Label in:self.
    label9 origin:(4@161) extent:(95@20).
    label9 label:'Tel. (buero):'.
    label9 borderWidth:0.
    label9 font:f; adjust:#right.

    label10 := Label in:self.
    label10 origin:(53@213) extent:(46@20).
    label10 label:'eMail:'.
    label10 borderWidth:0.
    label10 font:f; adjust:#right.

    label11 := Label in:self.
    label11 origin:(67@187) extent:(32@20).
    label11 label:'Fax:'.
    label11 borderWidth:0.
    label11 font:f; adjust:#right.

    label12 := Label in:self.
    label12 origin:(25@251) extent:(39@20).
    label12 label:'Text:'.
    label12 borderWidth:0.
    label12 font:f; adjust:#right.

    f := (Font family:'courier'
		    face:'medium'
		   style:'roman'
		    size:10).

    companyField := EditField in:self.
    companyField origin:(71@9) "extent:(483@18)" corner:0.98@27.
    companyField font:f.

    prenameField := EditField in:self.
    prenameField origin:(71@59) extent:(139@18).
    prenameField font:f.

    streetField := EditField in:self.
    streetField origin:(71@96) "extent:(483@18)" corner:0.98@114.
    streetField font:f.

    plzField := EditField in:self.
    plzField origin:(71@121) extent:(80@18).
    plzField font:f.

    townField := EditField in:self.
    townField origin:(200@121) extent:(354@19).
    townField font:f.

    telField := EditField in:self.
    telField origin:(106@162) extent:(154@17).
    telField font:f.

    telPrivateField := EditField in:self.
    telPrivateField origin:(377@162) extent:(177@17).
    telPrivateField font:f.

    faxField := EditField in:self.
    faxField origin:(106@188) extent:(154@17).
    faxField font:f.

    emailField := EditField in:self.
    emailField origin:(105@214) extent:(265@18).
    emailField font:f.

    v := ScrollableView for:EditTextView in:self.
    v origin:(70@251) "extent:(484@76)" corner:0.98@0.98.
    textField := v scrolledView.
    titleField := EditField in:self.
    titleField origin:(71@34) extent:(80@18).
    titleField font:f.

    nameField := EditField in:self.
    nameField origin:(266@59) "extent:(288@18)" corner:0.98@77.
    nameField font:f.

    ^ self
! !

!AddressView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/AddrBook/AddressView.st,v 1.8 1996-05-10 13:32:11 cg Exp $'
! !
