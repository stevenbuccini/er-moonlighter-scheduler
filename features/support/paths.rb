module NavigationHelpers
  def path_to(page_name)
    case page_name
    when /^the admin index$/
      '/admins'
    end
  end
end
World(NavigationHelpers)
