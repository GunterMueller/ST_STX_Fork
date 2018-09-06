# $Header: /cvs/stx/stx/rules/interpret.88k.awk,v 1.3 1999-12-01 10:53:33 cg Exp $
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

/cmp[\t ]*r1[123],r1[0123],255/  {
	    if (STATE == 0) {
		STATE=1
		if (VERBOSE==1) printf "# got cmp r13,r12,255\n"
		KEEP=1
	    } else {
		KEEP=0
		STATE=0
	    }
	}

/cmp[\t ]*r1[12345],r1[012345],16/ {
	    if (STATE == 0) {
		STATE=1
		if (VERBOSE==1) printf "# got cmp r13,r12,16\n"
		KEEP=1
	    } else {
		KEEP=0
		STATE=0
	    }
	}

/cmp[\t ]*r1[012345],r[12345],16/ {
	    if (STATE == 0) {
		STATE=1
		if (VERBOSE==1) printf "# got cmp r13,r12,16\n"
		KEEP=1
	    } else {
		KEEP=0
		STATE=0
	    }
	}

/bb0[\t ]*ls,r1[012345],@L/ {
	    if (STATE == 1) {
		STATE=2
		if (VERBOSE==1) printf "# got bb0\n"
		KEEP=1
	    } else {
		KEEP=0
		STATE=0
	    }
	}

/bb0\.n[\t ]*ls,r1[012345],@L/ {
	    if (STATE == 1) {
		STATE=2
		if (VERBOSE==1) printf "# got bb0\n"
		KEEP=1
	    } else {
		KEEP=0
		STATE=0
	    }
	}

/st[\t ]*.*/ {
	    if (STATE == 2) {
		STATE=3
		if (VERBOSE==1) printf "# got or\n"
		KEEP=1
		INSN1=$0
	    } else {
		KEEP=0
		STATE=0
	    }
	}
            
/or[\t ]*.*lo16.*/ {
	    if (STATE == 2) {
		STATE=3
		if (VERBOSE==1) printf "# got or\n"
		KEEP=1
		INSN1=$0
	    } else {
		KEEP=0
		STATE=0
	    }
	}

/ld[\t ]*.*\[r1[012345]\]/ {
	    if (STATE == 3) {
		print INSN1
		print $0
		if (VERBOSE==1) printf "# got ld ...[]\n"
		NBUFFER=0
		KEEP=0
		STATE=0
		SKIP=1
	    } else {
		KEEP=0
		STATE=0
	    }
	}

/ld[\t ]*.*\[r[12345]\]/ {
	    if (STATE == 3) {
		print INSN1
		print $0
		if (VERBOSE==1) printf "# got ld ...[]\n"
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
