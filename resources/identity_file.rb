
actions :create, :delete
default_action :create

attribute :name,    kind_of: String, name_attribute: true
attribute :content, kind_of: String
attribute :user,    kind_of: String, required: true

def group(arg=nil)
  arg = user if @group.nil? and arg.nil?
  set_or_return(:group, arg, kind_of: String)
end

def path(arg=nil)
  arg = default_path if @path.nil? and arg.nil?
  set_or_return(:path, arg, kind_of: String)
end

def default_path
  "#{node[:etc][:passwd][user][:dir]}/.ssh/#{name}"
end

