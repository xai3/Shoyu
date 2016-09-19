Pod::Spec.new do |s|
  s.name = 'Shoyu'
  s.version = '0.2.0'
  s.license = 'MIT'
  s.homepage = 'https://github.com/yukiasai/'
  s.summary = 'Table view datasource and delegate library in Swift'
  s.authors = { 'yukiasai' => 'yukiasai@gmail.com' }
  s.source = { :git => 'https://github.com/yukiasai/Shoyu.git', :tag => s.version }

  s.ios.deployment_target = '8.0'
  
  s.source_files = 'Classes/*.swift'
end

