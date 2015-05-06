module NavigationHelpers
  def path_to(page_name)
    case page_name
    when /^the admin index$/
      '/admins'
    when /^the create email page$/
      '/create-email'
    when /^the edit page$/
      '/users'
    end
  end
end
World(NavigationHelpers)
