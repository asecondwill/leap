def source_paths
  [__dir__]
end

def add_my_gems
  gem 'devise' 
  gem "simple_form"
  gem 'dartsass-rails'
  gem 'annotate'
  gem 'ransack'
  gem 'name_of_person'
  gem "image_processing", ">= 1.2"
  gem 'github-markup'
  gem 'friendly_id'
 
  gem_group :development do
    gem 'hirb'
    gem 'rails-erd'
    gem 'letter_opener'
  end
  
  git add: '.'
  git commit: "-a -m 'add gems'"
end

def run_generators
  generate "simple_form:install --bootstrap"
  generate "devise:install"  
  generate :devise, "User", "first_name", "last_name", "admin:boolean"
  generate "friendly_id"
  git add: '.'
  git commit: "-a -m 'run generators'"
end

def setup_js
  run "bin/importmap pin bootstrap"
  git add: '.'
  git commit: "-a -m 'pin bootstrap'"
end

def add_storage_and_rich_text
  rails_command "active_storage:install"
  rails_command "action_text:install"

  git add: '.'
  git commit: "-a -m 'add storage and text'"
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

  environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }",
              env: 'development'

  git add: '.'
  git commit: "-a -m 'copy app dir & final tidy'"
end



after_bundle do
  # bin stubs created before this, so can do bundle stuff. 

  git :init
  git add: '.'
  git commit: "-a -m 'Initial commit'"

  add_my_gems
  run_generators
  setup_js
  setup_scss
  add_storage_and_rich_text
  tidy  

  #ttd:   scafold templates.  - ideally, have block or table ones, admin ones. 
  #       Devise screens
  #       restrict users area as a demo
  #       create a user
  #       simpleform extras 
  #       standard page templates. layouts:  site, app.  header, footer and menu.   
  #       CMS features
  #       copy  stuff from previous sites
  #       extract things to gems?
end
