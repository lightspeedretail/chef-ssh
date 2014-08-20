
actions :add, :remove
default_action :add

attribute :host,    kind_of: String, name_attribute: true
attribute :port,    kind_of: Integer, default: 22
attribute :hashed,  kind_of: [TrueClass, FalseClass], default: TrueClass
attribute :key,     kind_of: String
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
    "#{node[:etc][:passwd][user][:dir]}/.ssh/known_hosts"
  else
    node[:ssh][:known_hosts_path]
  end
end

def default_path?
  path == node[:ssh][:known_hosts_path]
end



