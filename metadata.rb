name              "rails"
maintainer        "Martin Fenner"
maintainer_email  "mfenner@plos.org"
license           "Apache 2.0"
description       "Capistramo configuration"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.1.6"
depends           "mysql", '~> 5.4.3'
depends           "database", '~> 2.3.0'
depends           "passenger_nginx", "~> 0.1.0"

%w{ ubuntu }.each do |platform|
  supports platform
end
