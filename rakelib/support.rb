require 'net/http'
require 'net/https'
require 'json'
require 'rakelib/extensions.rb'
require 'rakelib/rbspec.rb'
require 'rakelib/scm.rb'

# Following hack is required to allow passing variable
# values in `make` style, i.e., to allow for
#
#  rake PROJECT=stx:jv-branch compile
#
ARGV.each do |arg|
  name_and_value = /^([A-Za-z_]+)\w*=(.*)/.match(arg)
  self.class.const_set(name_and_value[1], name_and_value[2]) if name_and_value
end

# Update PATH for build so build scripts may access  scripts and programs 
# in `bin` directory. This is required especially on Windows as Windows do 
# not ship with some basic tools (e.g. zip) by default. As a courtesy to the
# user, provide our own. 
# NOTE that this MUST be the first entry in the PATH to be able to override
# MINGW/MSYS make.exe with Borland's ancient make.exe (sigh, St/X still deals
# with dinosaurs)
ENV['PATH'] = "#{File.expand_path('bin')};#{File::PATH_SEPARATOR}#{ENV['PATH']}"

# Return true if running under Jenkins, false otherwise
def jenkins?
  (ENV.has_key? 'WORKSPACE' and
      ENV.has_key? 'JOB_NAME' and
      ENV.has_key? 'BUILD_ID')
end

# Returns true if and only if this is machine of one of the core developers
# (currently only JV). 
# Indeed this is a feeble check and can be easily bypassed by changing the
# code or by setting a proper environment variable. But this should not hurt 
# much as in that case, unauthorized person wouldn't be able to connect to 
# stc and librun repository so the build will fail. 
def core_developer?
  # JV's box: jv@..., vranyj1@...
  user = ENV['USER'] || ENV['USERNAME']
  (user == 'jv') or (user == 'vranyj1') ? true : false
end

# A super simple API for Jenkins used to download pre-built stc and librun.
module Jenkins
  # Return an a Jenkins build with pre-built stc and librun. 
  # Used to download pre-build stc and librun
  def self.smalltalkx_jv_branch_build
    return Jenkins::Build.new(%Q{https://swing.fit.cvut.cz/jenkins/job/stx_jv/lastStableBuild})
  end

  class Artifact
    attr_reader :name
    attr_reader :uri

    def initialize(name, uri)
      @name = name
      @uri = uri
    end

    def download_to(destination)
      if !File.exist? destination
        raise Exception.new("Invalid destination for download: #{destination}") unless File.directory? File.dirname(destination)
      else
        if !File.directory? destination
          raise Exception.new("Invalid destination for download: #{destination}")
        else
          destination = File.join(destination, @name)
        end
      end
      Jenkins::get(@uri) do |response|
        File.open(destination, 'wb') do |file|
          response.read_body {|part| file.write part}
        end
      end
    end
  end

  class Build
    attr_reader :data
    attr_reader :uri

    def initialize(uri)
      @uri = uri
      @data = JSON.parse(Jenkins::get(URI(uri.to_s + '/api/json')))
    end

    # Return a list of artifacts (as instances of `Jenkins::Artifact`) 
    # associated with this build. 
    def artifacts
      unless @artifacts
        @artifacts = @data['artifacts'].collect {|each| Artifact.new(each['fileName'], URI(@uri.to_s + '/artifact/' + each['relativePath']))}
      end
      @artifacts
    end
  end

  # A private method to GET data over HTTP(S)  
  def self.get(uri, &block)
    # http parameters       
    http_host = Net::HTTP.new(uri.host, uri.port)
    http_host.use_ssl = (uri.scheme == 'https') # simple true enough

    if false # host verification not used (yet)
      http_host.verify_mode = OpenSSL::SSL::VERIFY_PEER
      http_host.cert_store = OpenSSL::X509::Store.new
      http_host.cert_store.set_default_paths
      http_host.cert_store.add_file('cacert.pem') # file downloaded from curl.haxx.se/ca/cacert.pem
    else
      http_host.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    # actual download
    body = nil
    http_host.start do |http|
      http.request_get(uri) {|response| block ? (yield response) : (body = response.body)}
    end
    body
  end
end