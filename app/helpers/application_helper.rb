module ApplicationHelper

  def controller_action_scope_class
    "#{controller.controller_path.parameterize.tr('-', '_')} #{controller.action_name}"
  end

end
