# $Header: /cvs/stx/stx/rules/interpret.i386.awk,v 1.3 1996-08-02 19:12:55 cg Exp $
#
# this little awk script removes a nonsense
# code sequence checking the boundary of a switch statement
# (which is known to be nonsense, since the switch is over a
#  byte value, which cannot be above 255)
#
# The sequence:
#	cmpl $255,any
#       ja   someLabel
#       jmp  *switchTable
#
# is replaced by:
#	jmp  *switchTable
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

/cmpl \$255,/ {
	    if (STATE == 0) {
		if (VERBOSE==1) printf "# got cmpl\n"
		STATE=1
		KEEP=1
	    } else {
		if (VERBOSE==1) printf "# got cmpl in wrong state\n"
		KEEP=0
		STATE=0
	    }
	}

/cmpl \$16,/ {
	    if (STATE == 0) {
                if (VERBOSE==1) printf "# got cmpl\n"
                STATE=1
                KEEP=1
            } else {
                if (VERBOSE==1) printf "# got cmpl in wrong state\n"
                KEEP=0
                STATE=0
            }
        }

/ja .L/ {
	    if (STATE == 1) {
	        if (VERBOSE==1) printf "# got ja\n"
		STATE=2
		KEEP=1
	    } else {
	        KEEP=0
		STATE=0
	    }
	}

/ja L/ {
            if (STATE == 1) {
                if (VERBOSE==1) printf "# got ja\n"
                STATE=2
                KEEP=1
            } else {
                KEEP=0
                STATE=0
            }
        }

/movl / {
	    if (STATE == 2) {
		INSN1=$0
		STATE=3
		KEEP=1
	    } else {
		KEEP=0
		STATE=0
	    }
	}

/jmp \*/ {
            if (STATE == 2) {
                if (VERBOSE==1) printf "# got jmp *\n"
                print
                NBUFFER=0
                KEEP=0
                STATE=0
                SKIP=1
            } else {
		if (STATE == 3) {
		    if (VERBOSE==1) printf "# got jmp *\n"
		    print INSN1
		    print
		    NBUFFER=0
		    KEEP=0
		    STATE=0
		    SKIP=1
		} else {
                    KEEP=0
                    STATE=0
		}
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
