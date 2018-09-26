module Fastlane
  module Actions
    module SharedValues
      CHECK_COVERAGE_CUSTOM_VALUE = :CHECK_COVERAGE_CUSTOM_VALUE
    end

class String
def black;          "\e[30m#{self}\e[0m" end
def red;            "\e[31m#{self}\e[0m" end
def green;          "\e[32m#{self}\e[0m" end
def brown;          "\e[33m#{self}\e[0m" end
def blue;           "\e[34m#{self}\e[0m" end
def magenta;        "\e[35m#{self}\e[0m" end
def cyan;           "\e[36m#{self}\e[0m" end
def gray;           "\e[37m#{self}\e[0m" end

def bg_black;       "\e[40m#{self}\e[0m" end
def bg_red;         "\e[41m#{self}\e[0m" end
def bg_green;       "\e[42m#{self}\e[0m" end
def bg_brown;       "\e[43m#{self}\e[0m" end
def bg_blue;        "\e[44m#{self}\e[0m" end
def bg_magenta;     "\e[45m#{self}\e[0m" end
def bg_cyan;        "\e[46m#{self}\e[0m" end
def bg_gray;        "\e[47m#{self}\e[0m" end

def bold;           "\e[1m#{self}\e[22m" end
def italic;         "\e[3m#{self}\e[23m" end
def underline;      "\e[4m#{self}\e[24m" end
def blink;          "\e[5m#{self}\e[25m" end
def reverse_color;  "\e[7m#{self}\e[27m" end
end

    class CheckCoverageAction < Action
      def self.run(params)
        # fastlane will take care of reading in the parameter and fetching the environment variable:        

        coverage_limit = 0
        project_coverage = 0

        if "#{params[:limit]}".to_s.empty?
        	coverage_limit = 80
        else
        	coverage_limit = "#{params[:limit]}"
        end

        UI.message("Coverage limit set to #{coverage_limit}%")

        # Retrieve options
        scheme = "#{params[:scheme]}"
        project = "#{params[:project]}"
        workspace = "#{params[:workspace]}"

        basenames = "#{params[:basename]}".split(",")
    	basename_option = ""
	    if basenames.length > 1
	    	basenames.each_with_index {|val, index|
	    		if index == 0
        			basename_option = "--binary-basename #{val} "
        		else
					basename_option += "--binary-basename #{val}"
        		end
	    	}
        else
			basename_option = "--binary-basename #{params[:basename]}"
        end


        # Slather command
		slather_command = "slather coverage --scheme #{scheme} #{basename_option} --workspace #{workspace} #{project}"

		UI.message("Executing #{slather_command}")
        # Shell command to execute
      	command_output = %x[#{slather_command}]
 		# Scan the output to find the coverage %
 		scan_output = command_output.scan(/Test Coverage: (\d+(\.\d+)?)/)
		if scan_output.length > 0
      		coverage_array = scan_output.last
      		if !coverage_array.to_s.empty?
	      		coverage_end = coverage_array.first
	      		if !coverage_end.to_s.empty?
	      			project_coverage = coverage_end.to_i
					UI.message("Coverage result #{project_coverage}%".magenta)
			
					# Raise an error if the coverage goal is not reach
					raise "You are under the coverage limit (#{coverage_limit}%): #{project_coverage}%" unless project_coverage >= coverage_limit.to_i
      			end
      		end
 		end


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
                                       description: "You can provide multiple projects basenane like \"B1,B2,B3\" or juste one like B1",
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
