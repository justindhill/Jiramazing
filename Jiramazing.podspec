Pod::Spec.new do |s|

  s.name         = "Jiramazing"
  s.version      = "0.0.1"
  s.summary      = "Ever wanted to talk to Jira on an Apple OS? Now you can."

  s.description  = <<-DESC
  DESC

  s.homepage     = "http://github.com/justindhill/Jiramazing"
  s.license      = { :type => "MIT", :file => "LICENSE.md" }
  s.author             = { "Justin Hill" => "jhill.d@gmail.com" }
  s.source       = { :git => "http://github.com/justindhill/Jiramazing.git", :tag => "#{s.version}" }

  s.source_files  = "src", "src/**/*.{h,m,swift}"

end
