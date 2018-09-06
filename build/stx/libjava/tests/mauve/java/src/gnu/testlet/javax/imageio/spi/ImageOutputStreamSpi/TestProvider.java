// Tags: not-a-test
// Copyright (C) 2004 Sascha Brawer <brawer@dandelis.ch>
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
package gnu.testlet.javax.imageio.spi.ImageOutputStreamSpi;

import java.io.File;
import java.util.Locale;
import javax.imageio.spi.ImageOutputStreamSpi;
import javax.imageio.stream.ImageOutputStream;

class TestProvider
      extends ImageOutputStreamSpi {

    public TestProvider(String vendorName, String version,
          Class outputClass) {
        super(vendorName, version, outputClass);
    }

    public TestProvider() {
    }

    public String getDescription(Locale locale) {
        return "desc";
    }

    public ImageOutputStream createOutputStreamInstance(Object obj,
          boolean useCache,
          File cacheFile) {
        return null;
    }
}
