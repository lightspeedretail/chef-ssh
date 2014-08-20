
actions :add, :remove
default_action :add

attribute :host,    kind_of: String, name_attribute: true
attribute :options, kind_of: Hash
attribute :user,    kind_of: String
attribute :group,   kind_of: String, default: lazy { user }
attribute :path,    kind_of: String, default: lazy { default_path }

def default_user
  "root"
end

def default_path
  if user
    "#{node[:password][:user][:dir]}/.ssh/ssh_config"
  else
    node[:ssh][:config_path]
  end
end

def default_path?
  path == node[:ssh][:config_path]
end


