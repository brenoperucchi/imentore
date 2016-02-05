if defined?(BetterErrors) && Rails.env.development?
  BetterErrors.ignored_instance_variables += [ :@_request, :@_assigns, :@_controller, :@ahoy, :@view_renderer ]
  BetterErrors.editor = proc { |full_path, line|
    full_path = full_path.sub(Rails.root.to_s, "/Users/brenoperucchi/Google-Drive/03-Apps/imentore")
    "subl://open?url=file://#{full_path}&line=#{line}"
  }
end
