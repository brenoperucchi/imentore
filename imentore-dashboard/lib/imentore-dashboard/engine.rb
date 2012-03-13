module Imentore
  module Dashboard
    class Engine < Rails::Engine
      isolate_namespace Imentore
      engine_name "imentore_dashboard"
    end
  end
end