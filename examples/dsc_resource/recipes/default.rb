dsc_resource 'archive resource' do
   resource :archive
   property :ensure, 'present'
   property :path, 'C:\Users\Public\Documents\example.zip'
   property :destination, 'C:\Users\Public\Documents\ExtractionPath'
 end

 dsc_resource 'group resource' do
  resource :group
  property :groupname, 'demo1'
  property :ensure, 'present'
end
