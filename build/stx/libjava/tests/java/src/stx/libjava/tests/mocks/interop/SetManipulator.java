package stx.libjava.tests.mocks.interop;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.lang.Object;

@stx.libjava.annotation.Package("stx:libjava/tests")
public class SetManipulator
{
    public void addElement(Set<Object> s, Object o)
    {
        s.add(o);
    }

    public Integer getSize(Set<Object> s)
    {
        return s.size();
    }

    public Boolean contains(Set<Object> s, Object o)
    {
        return s.contains(o);
    }
    
    public Boolean isEmpty(Set<Object> s)
    {
        return s.isEmpty();
    }
    
    public void remove(Set<Object> s, Object o)
    {
        s.remove(o);
    }

    public Integer iterateCountSize(Set<Object> s)
    {
        Integer i = 0;
        for (Iterator<Object> it = s.iterator(); it.hasNext(); )
        {
            i++;
        }
        return i;
    }
    
    
    public List<Object> iterate(Set<Object> s)
    {
        List<Object> l = new ArrayList<Object>();
        for (Iterator<Object> it = s.iterator(); it.hasNext(); )
        {
            l.add(it.next());
        }
        return l;
    }

    public List<Object> iterateWithSyntaxSugar(Set<Object> s)
    {
        List<Object> l = new ArrayList<Object>();
        for (Object o : s)
        {
            l.add(o);
        }
        return l;
    }
    
}
