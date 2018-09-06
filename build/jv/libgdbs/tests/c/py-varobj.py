import gdb
import gdb.types
import sys

if sys.version_info[0] > 2:
    long = int
    imap = map

class cons_pp(object):
  def __init__(self, val):
    self._val = val

  def to_string(self):
    if long(self._val) == 0:
      return "nil"
    else:
      return "(...)"

  def children(self):
    if long(self._val) == 0:
      return []
    else:
      return [
        ('car' , self._val["slots"][0]),
        ('cdr' , self._val["slots"][1])
      ]

def cons_pp_lookup(val):
  if str(val.type) == 'struct _cons *':
    return cons_pp(val)
  else:
    return None

del gdb.pretty_printers[1:]
gdb.pretty_printers.append(cons_pp_lookup)