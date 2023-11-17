# ITS LEAP
Kick off a project like:
````bash
rails new appy24 -a propshaft  -d sqlite3  -m ../leap/template.rb
````
or for real projects
````bash
rails new appy24 -a propshaft  -d postgres  -m ../leap/template.rb
````

## Bootstrap Views
use like: 
````bash
rails g bootstrap:install  --simpleform --pagination 
````

If you want pagination tho, you need to change the controller index to:
````ruby
 @pagy, @boats = pagy(Boat.all, items: 5)
````

## Breadcrumbs
Add breadcrumbs with [breadcrumbs_on_rails](https://github.com/weppos/breadcrumbs_on_rails)
````ruby
  add_breadcrumb "home", :root_path
  add_breadcrumb "Boats", :boats_path
````

# TTD:
delayed jobs, but as simple as possible, ie use the default rails one
https://github.com/bensheldon/good_job#readme

acts_as_list	

gem "chartkick" and analytics?
error pages? gaffe?




postmark-rails

deployment ready on hatchbox

https://github.com/javan/whenever
breadcrumbs 





add pagy to controller? 
