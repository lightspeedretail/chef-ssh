
def why_run_supported?
  true
end

def use_inline_resources
  true
end

action :create do
  directory_resource(:create)
  file_resource(:create)
end

action :delete do
  file_resource(:delete)
end

def directory_resource(exec_action)
  dir = ::File::dirname(new_resource.path)

  directory dir do
    owner   new_resource.user   || new_resource.default_user
    group   new_resource.group  || new_resource.default_user
    mode    0700
    action  exec_action
  end
end

def file_resource(exec_action)
  file new_resource.path do
    owner   new_resource.user   || new_resource.default_user
    group   new_resource.group  || new_resource.default_user
    mode    0600
    content new_resource.content
    action  exec_action
  end
end

