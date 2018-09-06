// Tags: JDK1.4
// Copyright (C) 2004  Michael Koch <konqueror@gmx.de>
// This file is part of Mauve.
// Mauve is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2, or (at your option)
// any later version.
// Mauve is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// You should have received a copy of the GNU General Public License
// along with Mauve; see the file COPYING.  If not, write to
// the Free Software Foundation, 59 Temple Place - Suite 330,
// Boston, MA 02111-1307, USA.
package gnu.testlet.javax.imageio.spi.IIORegistry;

import gnu.testlet.Testlet;
import gnu.testlet.TestHarness;

import javax.imageio.spi.IIORegistry;

/**
 * @author Michael Koch (konqueror@gmx.de)
 */
public class getDefaultInstance
      implements Testlet {

    public void test(TestHarness h) {
        IIORegistry registry = IIORegistry.getDefaultInstance();

        // check #1: Return valid registry.
        h.check(registry != null);
    }
}
