module Fastlane
  module Actions
    module SharedValues
      CHECK_COVERAGE_CUSTOM_VALUE = :CHECK_COVERAGE_CUSTOM_VALUE
    end

    class CheckCoverageAction < Action
      def self.run(params)
        # fastlane will take care of reading in the parameter and fetching the environment variable:        
        coverage_limit = 80
        if "#{params[:limit]}"
        	coverage_limit = "#{params[:limit]}"
        end

        UI.message("Coverage limit set to #{coverage_limit}")

        # Paramater
        scheme = "#{params[:scheme]}"
        project = "#{params[:project]}"
        basename = "#{params[:basename]}"
        workspace = "#{params[:workspace]}"

		command = "slather coverage --scheme #{scheme} --binary-basename #{basename} --workspace #{workspace} --binary-basename #{basename} #{project}"

		UI.message(scheme)
		UI.message(project)
		UI.message(basename)
		UI.message(workspace)
		UI.message(command)

        # Shell acommand to execute
      	command_output = %x[#{command}]

      	coverage_output = command_output.scan(/Test Coverage: (\d+(\.\d+)?)/).last.first.to_i

      	UI.message("Full coverage: #{coverage_output}")

		raise "You are under the coverage limit (#{coverage_limit}%): #{coverage_output}%" unless coverage_output >= coverage_limit.to_i

		printf "Coverage result #{coverage_output}"

        # sh "shellcommand ./path"

        # Actions.lane_context[SharedValues::CHECK_COVERAGE_CUSTOM_VALUE] = "my_val"
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Check code coverage and fail if the coverage limit is not reach."
      end

      def self.details
        # Optional:
        # this is your chance to provide a more detailed description of this action
        "You can use this action to make the build fails if the coverage goal is not reach. This command require slather to be installed"
      end

      def self.available_options
        # Define all options your action supports. 
        
        # Below a few examples
        [
          FastlaneCore::ConfigItem.new(key: :limit,
                                       env_name: "FL_CHECK_COVERAGE_LIMIT", # The name of the environment variable
                                       description: "The % coverage to reach", # a short description of this parameter
                                       is_string: false
                                       ),
          FastlaneCore::ConfigItem.new(key: :scheme,
                                       env_name: "FL_CHECK_COVERAGE_SCHEME",
                                       description: "The project scheme",
                                       is_string: true, # true: verifies the input is a string, false: every kind of value
                                       default_value: false), # the default value if the user didn't provide one
          FastlaneCore::ConfigItem.new(key: :project,
                               env_name: "FL_CHECK_COVERAGE_PROJECT",
                               description: "The project",
                               is_string: true, # true: verifies the input is a string, false: every kind of value
                               default_value: false), # the default value if the user didn't provide one
          FastlaneCore::ConfigItem.new(key: :workspace,
                                       env_name: "FL_CHECK_COVERAGE_WORKSPACE", # The name of the environment variable
                                       description: "The workspace", # a short description of this parameter
                                       is_string: true
                                       ),
          FastlaneCore::ConfigItem.new(key: :basename,
                                       env_name: "FL_CHECK_COVERAGE_BASENAME",
                                       description: "The project basename",
                                       is_string: true, # true: verifies the input is a string, false: every kind of value
                                       default_value: false)
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ['CHECK_COVERAGE_CUSTOM_VALUE', 'A description of what this value contains']
        ]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ["Jimmy Yezeguelian"]
      end

      def self.is_supported?(platform)
        # you can do things like
        # 
        #  true
        # 
        #  platform == :ios
        # 
        #  [:ios, :mac].include?(platform)
        # 

        platform == :ios
      end
    end
  end
end
