
actions :create, :delete
default_action :create

attribute :name,    kind_of: String, name_attribute: true
attribute :content, kind_of: Hash
attribute :user,    kind_of: String, required: true
attribute :path,    kind_of: String, default: lazy { default_path }

def default_path
  "#{node[:password][:user][:dir]}/.ssh/#{name}"
end

