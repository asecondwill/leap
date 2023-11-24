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
  gem 'commonmarker'
  gem 'friendly_id'
  gem  'sitemap_generator'
  gem "devise-bootstrap-views", github: 'asecondwill/devise-bootstrap-views'
  gem 'pagy'
  gem "meta-tags"
  gem 'breadcrumbs_on_rails'
  gem 'bootstrap_views_generator', github: 'asecondwill/bootstrap_views_generator'

  gem_group :development do
    gem 'hirb'
    gem 'rails-erd'
    gem 'letter_opener'
  end
  
  git add: '.'
  git commit: "-a -m 'add gems'"
end

def run_generators   
  generate "friendly_id"
  generate "meta_tags:install"
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
  
  insert_into_file "app/javascript/application.js", "import * as bootstrap from 'bootstrap'
  \n"

  run "bin/importmap pin highlight.js"

  git add: '.'
  git commit: "-a -m 'pin bootstrap and and highlight.js password visibility'"

  insert_into_file "config/importmap.rb", "pin_all_from '.app/javascript/custom', under: 'custom'
  \n"      
  copy_file "app/javascript/custom/sprinkles.js"
  insert_into_file "app/javascript/application.js", "import \"custom/sprinkles\"
  \n" 
  git add: '.'
  git commit: "-a -m 'custom js'"
end

def add_storage_and_rich_text
  rails_command "active_storage:install"
  rails_command "action_text:install"

  git add: '.'
  git commit: "-a -m 'add storage and text'"
end

def bootstrap
  git submodule: "add -b main --name bootstrap https://github.com/twbs/bootstrap.git vendor/bootstrap"
  git add: '.'
  git commit: "-a -m 'Bootstrap as a submodule, add dart, set up sass'"
end

def dart_sass
  run "./bin/rails dartsass:install"  
  run "rm app/assets/stylesheets/application.css"

  initializer 'dartsass.rb', <<-CODE
  Rails.application.config.dartsass.builds = {
    "application.scss"        => "application.css",
    "site.scss"       => "site.css"
  }
  CODE

  git add: '.'
  git commit: "-a -m 'add dartsass config'"
end

def devise
  route "  devise_for :users "
  generate "devise:install"  
  generate :devise, "User", "first_name", "last_name", "admin:boolean", "time_zone:string"
  git add: '.'
  git commit: "-a -m 'setup devise '"
end

def user_settings
  route "get 'settings', to: 'users#settings'"
  route "patch 'settings', to: 'users#update_settings'"
  route "get 'change_password', to: 'users#password'"
  route "patch 'change_password', to: 'users#update_password'"
  git add: '.'
  git commit: "-a -m 'add user settings routes'"
end

def email
  environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }",
              env: 'development'
  environment "config.action_mailer.delivery_method = :letter_opener",
              env: 'development'  
  environment "config.action_mailer.perform_deliveries = true",
              env: 'development'  

  environment "config.action_mailer.smtp_settings = {
    :user_name => ENV['POSTMARK_API_KEY'],
    :password => ENV['POSTMARK_API_KEY'],
    :domain => 'example.com',
    :address => 'smtp.postmarkapp.com',
    :port => 587,
    :authentication => :plain,
    :enable_starttls_auto => true
  }", env: 'production'     
  git add: '.'
  git commit: "-a -m 'email setup'"       
end

def simple_form 
  generate "simple_form:install --bootstrap"  
  # Use Thor's uncomment_lines method to uncomment the line
  uncomment_lines("config/initializers/simple_form_bootstrap.rb", 
                  /#{Regexp.escape("Dir[Rails.root.join('lib/components/**/*.rb')].each { |f| require f }")}/)  
  git add: '.'
  git commit: "-a -m 'add simple_form and components'"

  lib 'components/input_group_component.rb', <<-CODE
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

def copy_stuff
  run "rm README.md"
  copy_file "README.md"
  #insert_into_file "README.md", "run to refresh sitemap: `rake sitemap:refresh`"  

  directory "app", force: true

  git add: '.'
  git commit: "-a -m 'copy app dir & other files'"  

  copy_file "lib/bootstrap_five_breadcrumbs.rb"
  git add: '.'
  git commit: "-a -m 'add breadcrumbs '"
  
  copy_file "locales/en.rb"
  copy_file "initializers/time_formats.rb"
  git add: '.'
  git commit: "-a -m 'add time formats '"
end


def routes
  route "root to: 'landings#home'"  
  route "get 'dash' => 'dashboards#home', as: :user_root "
  git add: '.'
  git commit: "-a -m 'assorted routes'"  
end

def tidy 
  environment "host = ENV['IS_STAGING'] ? 'example-staging.herokuapp.com' : 'example.com'", env: 'production'  
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
  dart_sass
  bootstrap
  devise
  email
  user_settings
  copy_stuff
  simple_form
  routes
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
