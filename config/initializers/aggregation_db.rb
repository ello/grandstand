AGGREGATION_DB = YAML::load(ERB.new(File.read(Rails.root.join("config","aggregation_database.yml"))).result)[Rails.env]
