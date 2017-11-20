# Example of a whyrun_safe_ruby_block that will execute when test is run

whyrun_safe_ruby_block 'Hello World from whyrun' do
  block do
    puts ''
    puts ''
    puts 'Hello World from whyrun!'
  end
end
