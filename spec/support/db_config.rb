require 'logger'
ActiveRecord::Base.logger = Logger.new(STDOUT)

db_yml = File.expand_path('../database.yml', __FILE__)
db_config = YAML.load_file(db_yml)['test']
ActiveRecord::Base.establish_connection(db_config)
