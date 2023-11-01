def source_paths
  [__dir__]
end


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
  
  run "rm app/assets/stylesheets/application.css"
  puts "config it"  
  puts "include it"

  git submodule: "add -b main --name bootstrap https://github.com/twbs/bootstrap.git vendor/bootstrap"
  git add: '.'
  git commit: "-a -m 'Bootstrap as a submodule, add dart, set up sass'"
end

def tidy 
  insert_into_file  ".gitignore", ".DS_Store"
  run "rm README.md"
  copy_file "README.md"
  
  directory "app", force: true
  
  route "root to: 'landings#home'"

  git add: '.'
  git commit: "-a -m 'copy app dir & final tidy'"
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


  #ttd:   scafold templates. 
  #       Devise screens
  #       simpleform extras 
  #       standard page templates. layouts:  site, app.  header, footer and menu.   
  #       CMS features
  #       copy  stuff from previous sites
  #       extract things to gems?
end