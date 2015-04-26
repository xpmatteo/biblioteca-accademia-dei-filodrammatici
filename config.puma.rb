
# Redirect STDOUT and STDERR to files specified. The 3rd parameter
# ("append") specifies whether the output is appended, the default is
# "false".
#
log_file = File.dirname(__FILE__) + '/log/production.log'
stdout_redirect log_file, log_file, true

