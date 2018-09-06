module Rake::StX

  # Simple utility to add records to smalltalk ChangeSet
  class ChangeSet
    def initialize(filename) 
      @filename = filename
    end

    # Evaluates a block for each standard changeset found in
    # given directory (BUILD_DIR usually)
    def self.standardChangesetsDo(root)
      yield(ChangeSet.new(f)) if block_given? if File.exist?(f = root / 'stx' / 'st.chg')
      yield(ChangeSet.new(f)) if block_given? if File.exist?(f = root / 'project' / 'smalltalk' / 'st.chg')
    end

    def addInfoChange(info)
      if unix?
        hostname = `hostname`.chop
        username = ENV['USER']
      else
        hostname = '???'
        username = ENV['USERNAME']
      end
      timestamp = Time.now.strftime("%d-%m-%Y %H:%M:%S")
      file = File.open(@filename, 'a')
      begin
        file.print("'---- #{info} #{username}@#{hostname} #{timestamp} ----'!\n")
      ensure
        file.close
      end
    end

    def addTimestampInfo  # ? why it does not follow ruby's camel case?
      addInfoChange('timestamp')
    end

    def addRakeUpdateInfo
      addInfoChange('rake update')
    end

    def addRakeCompileInfo
      addInfoChange('rake compile')
    end
  end
end
