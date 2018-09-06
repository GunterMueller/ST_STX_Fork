#include <stdio.h>
#include "vogl.h"

#ifndef MULTI_X
static TokList		*currentTokens;
#endif

/*
 * newtokens
 *
 *	returns the space for num tokens
 */
Token *
newtokens(num)
	int	num;
{
	TokList	*tl;
	Token	*addr;
	int	size;

	if (vdevice.tokens == (TokList *)NULL || num >= MAXTOKS - currentTokens->count) {
		if ((tl = (TokList *)malloc(sizeof(TokList))) == (TokList *)NULL) {
			verror("newtokens: malloc returns NULL");
			return (Token *)0;
		}

		if (vdevice.tokens != (TokList *)NULL)
			currentTokens->next = tl;
		else 
			vdevice.tokens = tl;

		tl->count = 0;
		tl->next = (TokList *)NULL;
		if (num > MAXTOKS)
			size = num;
		else
			size = MAXTOKS;
		if ((tl->toks = (Token *)malloc(size * sizeof(Token))) == (Token *)NULL) {
			verror("newtokens: malloc returns NULL");
			return (Token *)0;
		}

		currentTokens = tl;
	}

	addr = &currentTokens->toks[currentTokens->count];
	currentTokens->count += num;

	return(addr);
}
