
require 'shellwords'

def why_run_supported?
  true
end

def use_inline_resources
  true
end

def load_current_resource
  @host, @port = new_resource.host.split(':')
  @port = new_resource.port unless @port
  @port = @port.to_i

  @escaped = Shellwords.escape(@host)
end

action :add do
  directory_resource(:create)

  unless key = new_resource.key
    key = key_scan
    Chef::Application.fatal! key if key =~ /getaddrinfo/
  end

  key_exists = key_exists?
  execute "add known_host entry for #{@host}" do
    command "echo '#{key}' >> #{new_resource.path}"
    not_if { key_exists }
  end
end

action :remove do
  key_exists = key_exists?

  execute "remove known_host entry for #{@host}" do
    command "ssh-keygen -R #{Shellwords.escape(new_resource.host)} &>/dev/null"
    user new_resource.user
    umask '0600'
    only_if { key_exists }
  end
end

def key_scan
  cmd = "ssh-keyscan #{new_resource.hashed ? '-H ' : ''}"
  cmd << " -p #{@port} #{@escaped}"
  cmd << " 2>/dev/null"
  `#{cmd}`
end

def key_exists?
  `ssh-keygen -H -F #{@escaped} -f #{new_resource.path} 2>&1 | 
   grep 'Host #{@host} found'` =~ /Host.*found/
end

def directory_resource(exec_action)
  dir = ::File::dirname(new_resource.path)

  directory dir do
    owner   new_resource.user   || new_resource.default_user
    group   new_resource.group  || new_resource.default_user
    mode    new_resource.default_path? ? 0755 : 0700
    action  exec_action
  end
end


