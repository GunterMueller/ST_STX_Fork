struct _cons
{
  struct _cons *slots[2];
};

#define nil ((struct _cons*)0);

int
main (int argc, char **argv)
{
  struct _cons c1, c2, c3;

  c1.slots[0] = nil;
  c1.slots[1] = &c2;

  c2.slots[0] = nil;
  c2.slots[1] = &c3;

  c3.slots[0] = nil;
  c3.slots[1] = nil;

  return 0;			/* next line */
}
