require File.join(File.dirname(__FILE__), '..' , 'rakelib' , 'extensions')
require 'tmpdir'
require 'test/unit'

include RakeFileUtils

class RakeFileUtilsTests < Test::Unit::TestCase
  def test_which()    
    assert File.executable?( which('ls') )
    assert which('boguscommand').nil?
  end

  # A helper for `test_zip_01()`
  def test_zip_01_fmt(fmt)
    Dir.mktmpdir do | tmp |
      chdir File.join(File.dirname(__FILE__), '..') do
        archive = File.join(tmp, "rakelib#{fmt}")
        zip "rakelib", archive: archive
        assert File.exist? archive
        unzip archive
        assert File.exist? File.join(tmp, 'rakelib')
        assert File.exist? File.join(tmp, 'rakelib', 'extensions.rb')
        assert File.exist? File.join(tmp, 'rakelib', 'support.rb')
      end
    end
  end  

  def test_zip_01()    
    test_zip_01_fmt('.zip') if which 'zip'
    test_zip_01_fmt('.tar.bz2') if which 'tar' and which 'bzip2'
    test_zip_01_fmt('.tar.gz') if which 'tar' and which 'gzip'
  end

  def test_zip_02()     
    chdir File.join(File.dirname(__FILE__), '..') do        
      fmt = win32? ? '.zip' : '.tar.bz2'
      begin
        zip "rakelib"        
        assert(File.exist? "rakelib#{fmt}")
      ensure
        rm_f "rakelib#{fmt}" 
      end
    end
  end

  # A helper for `test_zip_03()`
  def test_zip_03_fmt(fmt)
    Dir.mktmpdir do | tmp |
      chdir File.join(File.dirname(__FILE__), '..') do
        archive = File.join(tmp, "rakelib#{fmt}")
        zip "rakelib", archive: archive, include: [ 'extensions.rb' ]
        assert File.exist? archive
        unzip archive
        assert File.exist? File.join(tmp, 'rakelib')
        assert File.exist? File.join(tmp, 'rakelib', 'extensions.rb')
        assert (not File.exist? File.join(tmp, 'rakelib', 'support.rb'))
      end
    end
  end  

  def test_zip_03()    
    test_zip_03_fmt('.zip') if which 'zip'
    test_zip_03_fmt('.tar.bz2') if which 'tar' and which 'bzip2'
    test_zip_03_fmt('.tar.gz') if which 'tar' and which 'gzip'
  end

  def test_rm_rf_ex() 
    def with_test_dir(&block) 
      Dir.mktmpdir do | tmp |
        chdir tmp do
          mkdir_p File.join("a", "b", "c")
          touch File.join("a", "aaa1.txt")
          touch File.join("a", "aaa2.txt")
          touch File.join("a", "aaa3.txt")
          touch File.join("a", "b", "bbb1.txt")
          touch File.join("a", "b", "bbb2.txt")
          touch File.join("a", "b", "bbb3.txt")
          touch File.join("a", "b", "c", "ccc1.txt")
          touch File.join("a", "b", "c", "ccc2.txt")
          touch File.join("a", "b", "c", "ccc3.txt")          
          yield block
        end
      end
    end    

    with_test_dir do
      rm_rf_ex "a"
      sh 'ls -lr'
      assert (not File.exists? "a")
    end

    with_test_dir do
      rm_rf_ex "a", exceptions: ['aaa1.txt']
      sh 'ls -lr'
      assert (    File.exists? "a")
      assert (    File.exists? (File.join("a", "aaa1.txt")))
      assert (not File.exists? (File.join("a", "aaa2.txt")))
      assert (not File.exists? (File.join("a", "aaa3.txt")))
      assert (not File.exists? (File.join("a", "b")))
    end

    with_test_dir do
      rm_rf_ex "a", exceptions: ['bogus']
      sh 'ls -lr'
      assert (not File.exists? "a")      
    end

    with_test_dir do
      rm_rf_ex "a", exceptions: [File.join('b' 'bogus')]
      sh 'ls -lr'
      assert (not File.exists? "a")      
    end

    with_test_dir do
      rm_rf_ex "a", exceptions: ['b']
      sh 'ls -lr'
      assert (    File.exists? "a")
      assert (not File.exists? (File.join("a", "aaa1.txt")))
      assert (not File.exists? (File.join("a", "aaa2.txt")))
      assert (not File.exists? (File.join("a", "aaa3.txt")))
      assert (    File.exists? (File.join("a", "b")))
      assert (    File.exists? (File.join("a", "b", "bbb1.txt")))
      assert (    File.exists? (File.join("a", "b", "bbb2.txt")))
      assert (    File.exists? (File.join("a", "b", "bbb3.txt")))
      assert (    File.exists? (File.join("a", "b", "c")))
      assert (    File.exists? (File.join("a", "b", "c", "ccc1.txt")))
      assert (    File.exists? (File.join("a", "b", "c", "ccc2.txt")))
      assert (    File.exists? (File.join("a", "b", "c", "ccc3.txt")))
    end

    with_test_dir do
      rm_rf_ex "a", exceptions: [File.join('b', 'bbb1.txt'), File.join('b', 'c', 'ccc3.txt') ]
      sh 'ls -lr'
      assert (    File.exists? "a")
      assert (not File.exists? (File.join("a", "aaa1.txt")))
      assert (not File.exists? (File.join("a", "aaa2.txt")))
      assert (not File.exists? (File.join("a", "aaa3.txt")))
      assert (    File.exists? (File.join("a", "b")))
      assert (    File.exists? (File.join("a", "b", "bbb1.txt")))
      assert (not File.exists? (File.join("a", "b", "bbb2.txt")))
      assert (not File.exists? (File.join("a", "b", "bbb3.txt")))
      assert (    File.exists? (File.join("a", "b", "c")))
      assert (not File.exists? (File.join("a", "b", "c", "ccc1.txt")))
      assert (not File.exists? (File.join("a", "b", "c", "ccc2.txt")))
      assert (    File.exists? (File.join("a", "b", "c", "ccc3.txt")))
    end
  end
end

if __FILE__ == $0
  require 'test/unit/ui/console/testrunner'
  Test::Unit::UI::Console::TestRunner.run(RakeFileUtilsTests)
end