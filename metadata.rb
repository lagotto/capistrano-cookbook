name              "capistrano"
maintainer        "Martin Fenner"
maintainer_email  "martin.fenner@datacite.org"
license           "Apache 2.0"
description       "Capistramo configuration"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.10.16"

# opscode cookbooks
depends           "apt"
depends           "nodejs"
depends           "consul"

# our own cookbooks
depends           "ruby", "~> 0.7.0"
depends           "dotenv", "~> 0.2.0"

%w{ ubuntu }.each do |platform|
  supports platform
end
