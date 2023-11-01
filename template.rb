def add_my_gems
  gem 'devise' 
  gem "simple_form"
  gem 'dartsass-rails'
  gem 'annotate'

  git add: '.'
  git commit: "-a -m 'add gems'"
end

def run_generators
  generate "simple_form:install --bootstrap"
  generate "devise:install"
  generate :devise, "User", "first_name", "last_name", "admin:boolean"
end

def setup_js
  run "bin/importmap pin bootstrap"
  git add: '.'
  git commit: "-a -m 'pin bootstrap'"
end

def setup_scss
  
  puts "setup scss"
  run "./bin/rails dartsass:install"
  
  
  puts "rename application.css to scss"
  puts "config it"  
  puts "include it"

  git submodule: "add -b main --name bootstrap https://github.com/twbs/bootstrap.git vendor/bootstrap"
  git add: '.'
  git commit: "-a -m 'Bootstrap as a submodule, add dart, set up sass'"
end

def tidy 
  run "rm README.md"
  insert_into_file  ".gitignore", ".DS_Store"

  git add: '.'
  git commit: "-a -m 'final tidy'"
end


after_bundle do
  
  git :init
  git add: '.'
  git commit: "-a -m 'Initial commit'"

  add_my_gems

  run_generators

  # bin stubs created before this, so can do bundle stuff. 
  setup_js
  
  # fetch me some sass
  setup_scss

  tidy  
end
