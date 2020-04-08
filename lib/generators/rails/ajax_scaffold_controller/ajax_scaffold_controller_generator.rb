# A modified version of rails scaffolding controller that uses modals for new/edit and ajax for create/update/delete

require "rails/generators/rails/scaffold_controller/scaffold_controller_generator"

class Rails::AjaxScaffoldControllerGenerator < Rails::Generators::ScaffoldControllerGenerator

  hook_for :template_engine, as: :ajax_scaffold do |template_engine|
    invoke template_engine unless options.api?
  end

  hook_for :test_framework, as: :ajax_scaffold

end
