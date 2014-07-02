Pod::Spec.new do |s|
  s.name         = "HLLBadgeView"
  s.version      = "0.1"
  s.summary      = "Set UIFont style(Bold,Italic,Light,Oblique and combo)."

  s.description  = <<-DESC
                   HLLBadgeView allows you to easily add badge and custom style.

                    * HLLBadgeView extends UIView using category.
                    * Use 1 method to set badge
                    * Can custom badge style
                    * Do not use?, set nil.
                   DESC
  s.homepage     = "http://www.couldhll.com"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "could_hll" => "could_hll@hotmail.com" }
  s.platform     = :ios, '5.0'
  s.source       = { :git => "https://github.com/couldhll/HLLBadgeView.git", :tag => s.version.to_s }
  s.source_files  = 'HLLBadgeView/*.{h,m}'
  s.exclude_files = 'Classes/Exclude'
  s.requires_arc = true
end
