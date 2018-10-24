#
# Cookbook:: apache2
# Recipe:: apreq2
#
# modified from the python recipe by Jeremy Bingham
#
# Copyright:: 2008-2017, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

case node['platform_family']
when 'debian'
  package 'libapache2-mod-apreq2'
when 'suse'
  package 'apache2-mod_apreq2' do
    notifies :run, 'execute[generate-module-list]', :immediately
  end
when 'rhel', 'fedora', 'amazon'
  package 'libapreq2' do
    notifies :run, 'execute[generate-module-list]', :immediately
  end

  # seems that the apreq lib is weirdly broken or something - it needs to be
  # loaded as 'apreq', but on RHEL & derivitatives the file needs a symbolic
  # link to mod_apreq.so.
  link "#{libexec_dir}/mod_apreq.so" do
    to "#{libexec_dir}/mod_apreq2.so"
    only_if "test -f #{libexec_dir}/mod_apreq2.so"
  end
end

file "#{apache_dir}/conf.d/apreq.conf" do
  content '# conf is under mods-available/apreq.conf - apache2 cookbook\n'
  only_if { ::Dir.exist?("#{apache_dir}/conf.d") }
end

apache2_module 'apreq'
