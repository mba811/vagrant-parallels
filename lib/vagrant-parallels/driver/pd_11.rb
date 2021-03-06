require 'log4r'

require 'vagrant/util/platform'

require File.expand_path('../pd_10', __FILE__)

module VagrantPlugins
  module Parallels
    module Driver
      # Driver for Parallels Desktop 11.
      class PD_11 < PD_10
        def initialize(uuid)
          super(uuid)

          @logger = Log4r::Logger.new('vagrant_parallels::driver::pd_11')
        end

        def create_snapshot(uuid, options)
          args = ['snapshot', uuid]
          args.concat(['--name', options[:name]]) if options[:name]
          args.concat(['--description', options[:desc]]) if options[:desc]

          stdout = execute_prlctl(*args)
          if stdout =~ /\{([\w-]+)\}/
            return $1
          end

          raise Errors::SnapshotIdNotDetected, stdout: stdout
        end

        def read_current_snapshot(uuid)
          if execute_prlctl('snapshot-list', uuid) =~ /\*\{([\w-]+)\}/
            return $1
          end

          nil
        end
      end
    end
  end
end
