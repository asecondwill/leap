module BootstrapHelper
  def bootstrap_class_for(flash_type)
    {
      success: "alert-success",
      error: "alert-danger",
      alert: "alert-warning",
      notice: "alert-info"
    }.stringify_keys[flash_type.to_s] || flash_type.to_s
  end

  def pillify_boolean(value, yes_text = 'YES', no_text = 'NO')
    if value
      "<span class='badge rounded-pill text-bg-success'>#{yes_text}</span>".html_safe
    else
      "<span class='badge rounded-pill text-bg-secondary'>#{no_text}</span>".html_safe
    end
  end

  
end