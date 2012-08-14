app_env = ENV["APP_ENV"] || "production"
root_dir = File.expand_path(File.join(__FILE__, "..", ".."))

pid File.join(root_dir, "tmp", "pids", app_env + ".pid")

listen File.join(root_dir, "tmp", "unicorn.sock")

logger Logger.new(File.join(root_dir, "log", app_env + ".log"))

working_directory root_dir
worker_processes 2
