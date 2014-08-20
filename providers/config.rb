
def why_run_supported?
  true
end

def use_inline_resources
  true
end

action :add do
  directory_resource(:create)
  file_resource(:create)
end

action :remove do
  directory_resource(:create)
  file_resource(:create)
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

def file_resource(exec_action)
  file new_resource.path do
    owner   new_resource.user   || new_resource.default_user
    group   new_resource.group  || new_resource.default_user
    mode    new_resource.default_path? ? 0644 : 0600
    content file_content
    action  exec_action
  end
end

def file_content
  content = ::File.read(new_resource.path) rescue ''
  value = fragment

  first = value.split("\n").compact.first
  last = value.split("\n").compact.last

  value = nil unless Array(new_resource.action).include? :add
  content.gsub(/#{first}(.*)#{last}/im, value)
end

def fragment
  content = "Host #{new_resource.host.strip}\n"
  content << new_resource.options.
    map { |k,v| "  #{k} #{v.to_s.strip}\n" }.
    join("\n")
  content << "#End Chef SSH for #{new_resource.host.strip}\n\n"
  content
end

