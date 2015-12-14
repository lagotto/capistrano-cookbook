name              "capistrano"
maintainer        "Martin Fenner"
maintainer_email  "mfenner@datacite.org"
license           "Apache 2.0"
description       "Capistramo configuration"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "1.0.14"

# opscode cookbooks
depends           "apt"
depends           "nodejs"
depends           "consul"
depends           "rsyslog"

# our own cookbooks
depends           "ruby", "~> 0.7.0"
depends           "dotenv", "~> 1.0.0"

%w{ ubuntu }.each do |platform|
  supports platform
end
