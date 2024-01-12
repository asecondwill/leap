module TextHelper
  def md(s)
    require 'github/markup'
    if s
      a = GitHub::Markup.render('README.markdown', s)            
      a.gsub!('.</strong>', '.</strong>&nbsp;')
      return a.html_safe 
    end
  end

  def markdown_filter(&block)
    concat(md(capture(&block)))
  end

  def snippet_filter(language, &block)    
    concat "<pre language='#{language}'><code>#{capture(&block)}</code></pre>".html_safe
   end

  def nl2br(str)
    str.gsub(/\r\n|\r|\n/, "<br />")
  end

  def errors_for(object)
    return '' unless object.errors.any?

    content_tag(:div, class: 'card border-danger') do
      concat(content_tag(:div, class: 'card-header bg-danger text-white') do
        concat "#{pluralize(object.errors.count, 'error')} prohibited this #{object.class.name.downcase} from being saved:"
      end)
      concat(content_tag(:ul, class: 'mb-0 list-group list-group-flush') do
        object.errors.full_messages.each do |msg|
          concat content_tag(:li, msg, class: 'list-group-item')
        end
      end)
    end
  end
end