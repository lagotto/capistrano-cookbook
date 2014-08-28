name              "rails"
maintainer        "Martin Fenner"
maintainer_email  "mfenner@plos.org"
license           "Apache 2.0"
description       "Capistramo configuration"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.2.17"
depends           "ruby", "~> 0.1.0"
depends           "mysql", '~> 5.4.3'
depends           "passenger_nginx", "~> 0.1.0"

%w{ ubuntu }.each do |platform|
  supports platform
end
