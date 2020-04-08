require "rails/generators/erb/scaffold/scaffold_generator"

class Erb::AjaxScaffoldGenerator < Erb::Generators::ScaffoldGenerator

  def copy_view_files
    # First do the normal view copy
    super
    
    # Now add in our js views
    available_js_views.each do |view|
      filename = filename_with_extensions(view, "js")
      template filename, File.join("app/views", controller_file_path, filename)
    end
  end
  

  private
    # Override parent function to add and remove some files 
    def available_views
      %w(_item _item_content index show _form)
    end
    
    def available_js_views
      %w(create update destroy)
    end
  
end
