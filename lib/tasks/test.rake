Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['./test/models/*_test.rb']
  t.verbose = true
end
