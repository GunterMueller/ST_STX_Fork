# $Header: /cvs/stx/stx/rules/sgifix.awk,v 1.2 1999-12-01 10:53:37 cg Exp $
#
# awk assembler output processing.
# these are not really required for valid code, but
# slightly speedup / shorten the resulting code.
# Some of it is a bit magic ...
#
# This script changes some section attributes, to put read-only
# data areas into a common readonly (rdata) segment.

BEGIN   {
	    VERBOSE=0
	    VERBOSE2=0

	    STATE=0
	    KEEP=0
	    NBUFFER=0
	    SKIP=0
	    ESPMOVESELIMINATED=0
	    MOVESELIMINATED=0
	    MOVESRELAXED=0
	    JUMPSTOJUMPS=0
	    CONDBRANCHRRELAX=0
	    JUMPSREMOVED=0
	    ALIGNREMOVED=0
	    ADDSELIMINATED=0
	    PUSHESELIMINATED=0
	    PUSHESCONVERTED=0
	    POPSELIMINATED=0
	}

/__globals__:/ {
	    if (STATE == 0) {
		printf " .rdata\n"
		printf " .align 2\n"
		print $0
		KEEP=0
		SKIP=1
	    } else {
		KEEP=0
	    }
	}

/__methods__:/ {
	    if (STATE == 0) {
		printf " .rdata\n"
		printf " .align 2\n"
		print $0
		KEEP=0
		SKIP=1
	    } else {
		KEEP=0
	    }
	}

/__strings__:/ {
	   if (STATE == 0) {
		printf " .rdata\n"
		printf " .align 2\n"
		print $0
		KEEP=0
		SKIP=1
	    } else {
		KEEP=0
	    }
	}

/^lits[0-9]*:/ {
	    if (STATE == 0) {
		printf " .rdata\n"
		printf " .align 2\n"
		print $0
		KEEP=0
		SKIP=1
	    } else {
		KEEP=0
	    }
	}

# ----------------------
# common & default rule
# ----------------------

	{
	    if (KEEP == 1) {
		if (SKIP == 0) {
		    NBUFFER++
		    BUFFER[NBUFFER]=$0
		}
	    } else {
		IDX=1
		while (IDX <= NBUFFER) {
		    print BUFFER[IDX]
		    IDX++
		}
		NBUFFER=0
		if (SKIP == 0) print
	    }
	    SKIP=0
	    if (KEEP != 1) {
		if (VERBOSE2==1) printf "# reset state for:%s\n", $0
		STATE=0
	    }
	    KEEP=0
	}

END     {
	    printf "# %d .aligns eliminated\n",ALIGNREMOVED
	}

