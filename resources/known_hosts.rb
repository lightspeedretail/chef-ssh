
actions :add, :remove
default_action :add

attribute :host,    kind_of: String, name_attribute: true
attribute :port,    kind_of: Integer, default: 22
attribute :hashed,  kind_of: [TrueClass, FalseClass], default: TrueClass
attribute :key,     kind_of: String
attribute :user,    kind_of: String
attribute :path,    kind_of: String, default: lazy { default_path }

def default_user
  "root"
end

def default_path
  if user
    "#{node[:password][:user][:dir]}/.ssh/known_hosts"
  else
    node[:ssh][:known_hosts_path]
  end
end

def default_path?
  path == node[:ssh][:known_hosts_path]
end



