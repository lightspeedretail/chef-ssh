
actions :add, :remove
default_action :add

attribute :host,    kind_of: String, name_attribute: true
attribute :options, kind_of: Hash
attribute :user,    kind_of: String

def group(arg=nil)
  arg = user if @group.nil? and arg.nil?
  set_or_return(:group, arg, kind_of: String)
end

def path(arg=nil)
  arg = default_path if @path.nil? and arg.nil?
  set_or_return(:path, arg, kind_of: String)
end

def default_user
  "root"
end

def default_path
  if user
    "#{node[:etc][:passwd][user][:dir]}/.ssh/ssh_config"
  else
    node[:ssh][:config_path]
  end
end

def default_path?
  path == node[:ssh][:config_path]
end


