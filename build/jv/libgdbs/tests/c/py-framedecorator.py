import gdb
from itertools import chain
from gdb.FrameDecorator import FrameDecorator, SymValueWrapper

class FrameDecoratorWithSyntheticArgs(FrameDecorator):
    def __init__(self, fobj):
        super(FrameDecoratorWithSyntheticArgs, self).__init__(fobj)
        self.fobj = fobj

    def frame_args (self):
        r_args = super(FrameDecoratorWithSyntheticArgs, self).frame_args()
        s_args = [
            SymValueWrapper("syntheticArg0",gdb.Value(12)),
            SymValueWrapper("syntheticArg1","Stuff"),
            SymValueWrapper("syntheticArg2",42)
        ]
        return chain(s_args, r_args)

    def frame_locals (self):
        r_locals = super(FrameDecoratorWithSyntheticArgs, self).frame_locals()
        s_locals = [
            SymValueWrapper("syntheticLocal0",gdb.Value(12)),
            SymValueWrapper("syntheticLocal1","Stuff"),
            SymValueWrapper("syntheticLocal2",42)
        ]
        return chain(s_locals, r_locals)

class FrameFilterWithSyntheticArgs ():
    def __init__ (self):
        self.name = "SyntaticArgs"
        self.priority = 100
        self.enabled = True
        gdb.frame_filters [self.name] = self

    def filter(self, frames):
        return map(lambda f : FrameDecoratorWithSyntheticArgs(f), frames)


FrameFilterWithSyntheticArgs()


