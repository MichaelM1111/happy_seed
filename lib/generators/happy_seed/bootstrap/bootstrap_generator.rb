module HappySeed
  module Generators
    class BootstrapGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def update_application_haml
        gem 'bootstrap-sass'
        gem 'modernizr-rails'
        gem 'haml-rails'
        gem 'meta-tags', :require => 'meta_tags'

        Bundler.with_clean_env do
          run "bundle install"
        end

        remove_file 'app/views/layouts/application.html.erb'
        remove_file 'app/assets/javascripts/application.js'
        remove_file 'app/helpers/application_helper.rb'
        remove_file 'app/assets/stylesheets/application.css'
        directory 'app'
        directory 'lib'
        directory 'docs'

        inject_into_file 'config/application.rb', before: "end\nend\n" do <<-'RUBY'
  config.action_view.field_error_proc = Proc.new { |html_tag, instance| html_tag }
    config.generators do |g|
      g.stylesheets = false
      g.scaffold_controller "scaffold_controller"
    end
  
RUBY
        end
        if File.exists?( File.join( destination_root, ".env" ) )
          append_to_file ".env", "GOOGLE_ANALYTICS_SITE_ID=\n"
        end
      end
    end
  end
end