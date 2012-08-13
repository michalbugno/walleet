Airbrake.configure do |config|
  path = File.join(Rails.root, "config", "airbrake.yml")
  if File.file?(path)
    global = YAML.load_file(path)
    env_config = global[Rails.env]
    config.api_key = env_config if env_config
  end
end
