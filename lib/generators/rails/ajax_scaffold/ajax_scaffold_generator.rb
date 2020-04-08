# A modified version of rails scaffolding that uses modals for new/edit and ajax for create/update/delete

require "rails/generators/rails/scaffold/scaffold_generator"

class Rails::AjaxScaffoldGenerator < Rails::Generators::ScaffoldGenerator

  # Switch from the default scaffold_controller to our new one
  remove_hook_for :scaffold_controller
  hook_for :ajax_scaffold_controller, required: true, default: :ajax_scaffold_controller
end
