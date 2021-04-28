# frozen_string_literal: true

AGGREGATION_DB = YAML.safe_load(ERB.new(File.read(Rails.root.join('config/aggregation_database.yml'))).result, aliases: true)[Rails.env]
