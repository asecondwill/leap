# ITS LEAP
Kick off a project like:
````bash
rails new MyNewApp -a propshaft  -d sqlite3  -m ../leap/template.rb
rails db:create & rails db:migrate 
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
So now you can do Scafold for your Crud like a bootstrap boss:
````ruby
rails generate scaffold boats  name:string title:string content:text
````
If you want pagination tho, you need to change the controller index to:
````ruby
 @pagy, @boats = pagy(Boat.all, items: 5)
````

For bootstrap pagination, You need to download this:
````ruby
cd config/initializers 
wget https://ddnexus.github.io/pagy/lib/config/pagy.rb
````
and uncomment

```` require 'pagy/extras/bootstrap' ``

TODO:  just do that in code?

## Breadcrumbs
Add breadcrumbs with [breadcrumbs_on_rails](https://github.com/weppos/breadcrumbs_on_rails) in your controller:
````ruby
  add_breadcrumb "home", :root_path
  add_breadcrumb "Boats", :boats_path

  def show
    add_breadcrumb @boat.name, boat_path(@boat)
  end
````
Or views, eg for devise views - copy them over from the views gem and add:
````ruby
<% add_breadcrumb "Edit #{@boat.name}", edit_boat_path(@boat) %>
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
