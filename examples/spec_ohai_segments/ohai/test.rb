Ohai.plugin(:test) do
  provides 'test'
  collect_data(:linux) do
    Mash.new
  end
end
