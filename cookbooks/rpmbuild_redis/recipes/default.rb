# setup rpm build environment
package "rpmdevtools"
package "yum-utils"
package "rpm-build"

bash "rpmdev-setuptree" do
  code "rpmdev-setuptree"
  not_if {::File.exist?(node["redis_build"]["dir"])}
end

# prepare redis 
SOURCES_DIR = "#{node["redis_build"]["dir"]}/SOURCES"
SPECS_DIR = "#{node["redis_build"]["dir"]}/SPECS"
REDIS_FILENAME = "redis-#{node["redis"]["version"]}.tar.gz"

["redis.init", "redis.logrotate", "redis-#{node["redis"]["version"]}-redis.conf.patch"].each do |file|
  cookbook_file "#{SOURCES_DIR}/#{file}" do
    mode 0644
    action :create
  end
end

remote_file "#{SOURCES_DIR}/#{REDIS_FILENAME}" do
  source "#{node["redis"]["url"]}/#{REDIS_FILENAME}"
  owner node["redis_build"]["user"]
end

template "#{SPECS_DIR}/redis.spec" do
  mode 0644
end

package "tcl"
