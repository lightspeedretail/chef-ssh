
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
  unless key = new_resource.key
    key = begin
      results = key_scan
      results.strip!
      Chef::Application.fatal! results if key =~ /getaddrinfo/
      results
    end
  end

  exists = key_exists?

  execute "add known_host entry for #{@host}" do
    command "echo '#{key}' >> #{new_resource.path}"
    not_if { exists }
  end
end

action :remove do
  exists = key_exists?

  execute "remove known_host entry for #{@host}" do
    command "ssh-keygen -R #{Shellwords.escape(new_resource.host)}"
    user new_resource.user
    umask '0600'
    only_if { exists }
  end
end

def key_scan
  `ssh-keyscan #{new_resource.hashed ? '-H ' : ''} -p #{@port} #{@escaped}`
end

def key_exists?
  `ssh-keygen -H -F #{@escaped} -f #{new_resource.path} | 
   grep 'Host #{host} found'`
end

