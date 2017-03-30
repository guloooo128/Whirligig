Pod::Spec.new do |s| 
  s.name         = "Whirligig"
  s.version      = "0.0.2"
  s.summary      = "A simple image infinite loop Library." 
  s.homepage     = "https://github.com/guloooo128/Whirligig"
  s.license      = { :type => 'MIT' }
  s.author       = { "Gollum" => "my128s@sohu.com" }  
  s.ios.deployment_target = '8.0' 
  s.source       = { :git => "https://github.com/guloooo128/Whirligig.git", :tag => "#{s.version}" }
  s.source_files = 'Whirligig/*.swift'
  s.requires_arc = true
  s.dependency  'Kingfisher', '~> 3.5.2'
end
