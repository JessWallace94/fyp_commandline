### Screen-Tec Windscreens - Quote Management Application ###

# Setting constant app_root as current file directory (fyp_commandline)
APP_ROOT = File.dirname(__FILE__)

# Requiring files for the application 
require File.join(APP_ROOT, 'lib', 'guide.rb')

guide = Guide.new('quotes.txt')
guide.launch!