# $Header: /cvs/stx/stx/rules/interpret.alpha.awk,v 1.2 1999-12-01 10:53:34 cg Exp $
#
# awk assembler output processing.
# this little awk script removes a nonsense
# code sequence checking the boundary of a switch statement
#
# The code sequence only appears in interpret.c
#

BEGIN   {
	    VERBOSE=0

	    STATE=0
	    KEEP=0
	    NBUFFER=0
	    SKIP=0
	}

/cmpult[\t ]*\$[0-9]*, 256, \$24/  {
	    if (STATE == 0) {
		STATE=1
		if (VERBOSE==1) printf "# got cmpult $0,256,$24\n"
		KEEP=1
	    } else {
		KEEP=0
		STATE=0
	    }
	}

/beq[\t ]*\$24,/ {
	    if (STATE == 1) {
		STATE=2
		if (VERBOSE==1) printf "# got beq\n"
		KEEP=1
	    } else {
		KEEP=0
		STATE=0
	    }
	}

/\.set/ {
	    if (STATE == 2) {
		print $0
		NBUFFER=0
		KEEP=0
		STATE=0
		SKIP=1
	    } else {
		KEEP=0
		STATE=0
	    }
	}

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
