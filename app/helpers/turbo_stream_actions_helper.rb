module TurboStreamActionsHelper

  def switch_class(target, class_name)
    turbo_stream_action_tag(
    :switch_class,
    target: target,
    class: class_name
    )
  end
end

Turbo::Streams::TagBuilder.prepend(TurboStreamActionsHelper)