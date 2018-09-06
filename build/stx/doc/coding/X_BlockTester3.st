"/ simple test & demo of recursive blocks ...
"/ stupid.

    |factFunction|

    factFunction :=
	 [ :n |
		n = 0
		    ifTrue: [ 1 ]
		    ifFalse: [ n * (factFunction value:(n - 1)) ]].

    Transcript showCR:(factFunction value:5).
    Transcript showCR:(factFunction value:200).

