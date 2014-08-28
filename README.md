Capistrano Cookbook
====================

Chef cookbook to configure [Capistrano](http://capistranorb.com/).


Requirements
------------
Requires Chef 0.10.10+ and Ohai 0.6.10+ for `platform_family` attribute use.

### Platforms
Tested on the following platforms:

- Ubuntu 12.04, 14.04

### Cookbooks
Opscode cookbooks:

- apt
- build-essential

Other cookbooks:

- [ruby](https://github.com/articlemetrics/ruby-cookbook)
- [passenger_nginx](https://github.com/articlemetrics/passenger_nginx-cookbook)

Attributes
----------
* `node['capistrano']['application']` - Defaults to `app`.
* `node['capistrano']['rails_env']` - Defaults to `production`.
* `node['capistrano']['deploy_user']` - Defaults to `vagrant`.
* `node['capistrano']['group']` - Defaults to `www-data`.
* `node['capistrano']['db_user']` - Defaults to `root`.
* `node['capistrano']['db_password']` - Defaults to `node['mysql']['server_root_password']`.
* `node['capistrano']['db_host']` - Defaults to `localhost`.
* `node['capistrano']['linked_files']` - Defaults to `[]`.
* `node['capistrano']['linked_dirs']` - Defaults to `[]`.


Recipes
-------
### default
Configures server for Capistrano deployment tool:

* configure application for Nginx
* set up `shared` folder
* symlink shared folders and files

### deploy
Duplicates some of the capistrano functionality (e.g. for a development environment):

* bundle install all gems
* precompile assets
* create database (if it doesn't exist), and run migrations


License & Authors
-----------------
- Author: Martin Fenner (<mfenner@plos.org>)

```text
Copyright: 2014, Public Library of Science

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
