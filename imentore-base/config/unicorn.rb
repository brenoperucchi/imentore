root = "/home/imentore/app/current/imentore-base"
worker_processes 1
working_directory "/home/imentore/app/current/imentore-base"

# This loads the application in the master process before forking
# worker processes
# Read more about it here:
# http://unicorn.bogomips.org/Unicorn/Configurator.html
preload_app true

# This is where we specify the socket.
# We will point the upstream Nginx module to this socket later on
listen "/home/imentore/app/shared/tmp/unicorn.sock", :backlog => 64
# listen 8080, :tcp_nopush => true
timeout 360

pid "/home/imentore/app/shared/pids/unicorn.pid"

# Set the path of the log files inside the log folder of the testapp
stderr_path "#{root}/log/unicorn.log"
stdout_path "#{root}/log/unicorn.log"

preload_app true
GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true

before_fork do |server, worker|
# This option works in together with preload_app true setting
# What is does is prevent the master process from holding
# the database connection
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
# Here we are establishing the connection after forking worker
# processes
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end