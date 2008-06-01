require 'fileutils'
include FileUtils

# locate ~/.shoes
require 'tmpdir'

lib_dir = nil
homes = []
homes << [ENV['HOME'], File.join( ENV['HOME'], '.shoes' )] if ENV['HOME']
homes << [ENV['APPDATA'], File.join( ENV['APPDATA'], 'Shoes' )] if ENV['APPDATA']
homes.each do |home_top, home_dir|
  next unless home_top
  if File.exists? home_top
    lib_dir = home_dir
    break
  end
end
LIB_DIR = lib_dir || File.join(Dir::tmpdir, "shoes")
SITE_LIB_DIR = File.join(LIB_DIR, '+lib')
GEM_DIR = File.join(LIB_DIR, '+gem')
CACHE_DIR = File.join(LIB_DIR, '+cache')
GEM_CENTRAL_DIR = File.join(DIR, "ruby/gems")

mkdir_p(CACHE_DIR)
$:.unshift SITE_LIB_DIR
$:.unshift GEM_DIR

require 'rbconfig'
config = {
  'prefix' => "#{DIR}", 
  'rubylibdir' => "#{DIR}/ruby/lib",
  'datarootdir' => "#{DIR}/share",
  'dvidir' => "#{DIR}/doc/${PACKAGE}",
  'psdir' => "#{DIR}/doc/${PACKAGE}",
  'htmldir' => "#{DIR}/doc/${PACKAGE}",
  'docdir' => "#{DIR}/doc/${PACKAGE}",
  'archdir' => "#{DIR}/ruby/lib/#{PLATFORM}",
  'sitedir' => SITE_LIB_DIR,
  'sitelibdir' => SITE_LIB_DIR,
  'sitearchdir' => "#{SITE_LIB_DIR}/#{PLATFORM}",
  'LIBRUBYARG_STATIC' => "",
  'libdir' => "#{DIR}",
  'LDFLAGS' => "-L. -L#{DIR}"
}
Config::CONFIG.merge! config
Config::MAKEFILE_CONFIG.merge! config

