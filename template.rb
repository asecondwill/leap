def source_paths
  [__dir__]
end

def setup
  insert_into_file  ".gitignore", ".DS_Store"
  git :init
  git add: '.'
  git commit: "-a -m 'Initial commit'"
end

def add_my_gems
  gem 'devise' 
  gem "simple_form"
  gem 'dartsass-rails'
  gem 'annotate'
  gem 'ransack'
  gem 'name_of_person'  
  gem 'github-markup'
  gem 'friendly_id'
  gem  'sitemap_generator'
  gem "devise-bootstrap-views", github: 'asecondwill/devise-bootstrap-views'
 
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
  rails_command "sitemap:install"
  git add: '.'
  git commit: "-a -m 'run generators'"
end

def setup_js
  run "bin/importmap pin bootstrap"
  run "bin/importmap pin stimulus-password-visibility"
  insert_into_file "app/javascript/controllers/index.js", "import PasswordVisibility from 'stimulus-password-visibility'
  \n"            
  insert_into_file "app/javascript/controllers/index.js", "application.register('password-visibility', PasswordVisibility)
  \n"            

  git add: '.'
  git commit: "-a -m 'pin bootstrap and password visibility'"
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

  # git submodule: "add -b main --name bootstrap https://github.com/twbs/bootstrap.git vendor/bootstrap"
  # git add: '.'
  # git commit: "-a -m 'Bootstrap as a submodule, add dart, set up sass'"
end




def add_some_files
  initializer 'dartsass.rb', <<-CODE
  Rails.application.config.dartsass.builds = {
    "application.scss"        => "application.css",
    "site.scss"       => "site.css"
  }
  CODE

  git add: '.'
  git commit: "-a -m 'add dartsass config'"

  lib 'input_group_component.rb', <<-CODE
  # custom component requires input group wrapper
  module InputGroup
    def prepend(wrapper_options = nil)
      template.content_tag(:span, options[:prepend], class: "input-group-text")
    end

    def append(wrapper_options = nil)
      template.content_tag(:span, options[:append], class: "input-group-text")
    end
  end

  # Register the component in Simple Form.
  SimpleForm.include_component(InputGroup)
  CODE

  git add: '.'
  git commit: "-a -m 'add inputgroup component '"
end




def tidy 
  
  run "rm README.md"
  copy_file "README.md"
  
  directory "app", force: true
  
  route "root to: 'landings#home'"
  
  route "get 'dash' => 'dashboards#home', as: :user_root "

  environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }",
              env: 'development'

  insert_into_file "README.md", "run to refresh sitemap: `rake sitemap:refresh`"            

  git add: '.'
  git commit: "-a -m 'copy app dir & final tidy'"

  # Use Thor's uncomment_lines method to uncomment the line
  uncomment_lines("config/initializers/simple_form_bootstrap.rb", 
                  /#{Regexp.escape("Dir[Rails.root.join('lib/components/**/*.rb')].each { |f| require f }")}/)  

  

  git add: '.'
  git commit: "-a -m 'add simple_form components'"
end

setup
add_my_gems

after_bundle do
  # bin stubs created before this, so can do bundle stuff. 
  
  run_generators
  setup_js
  setup_scss
  add_storage_and_rich_text
  add_some_files
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
