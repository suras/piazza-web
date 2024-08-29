module Breadcrumbs
  extend ActiveSupport::Concern

  included do
    helper_method :breadcrumbs
  end


  class_methods do
    def drop_breadcrumb(*args, **options)
      label, path = args

      before_action(options) do |controller|
        controller.drop_breadcrumb(label, path)
      end
    end
  end

  protected

  def drop_breadcrumb(label, path = nil)

    path = send(path) if path.is_a? Symbol

    label = instance_exec(&label) if label.is_a? Proc
    path = instance_exec(&path) if path.is_a? Proc 
        
    breadcrumbs << Crumb.new(label, path)
    
  end

  # send(path) dynamically calls the 
  # method with the name path and assigns the return value to path.

#   instance_exec allows dynamic execution of 
#   a block of code in the context of the current instance, allowing it to access instance variables and methods.
# For example, if label is a 

# endProc like -> { "Welcome, #{current_user.name}" },
#  this line will exe<%# locals: () -%>
# cute that block and assign the result
#   (e.g., "Welcome, Alice") to label.

  private 

  def breadcrumbs
    @breadcrumbs ||= Trail.new
  end

end