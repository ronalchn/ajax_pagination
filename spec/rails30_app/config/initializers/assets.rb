require 'rails/generators'

# regenerates assets into /public/javascripts, /public/stylesheets, /public/images folders

Rails::Generators.invoke("jquery:install",["-f"]);
Rails::Generators.invoke("historyjs:install",["-f"]);
Rails::Generators.invoke("ajax_pagination:assets",["-f"]);

