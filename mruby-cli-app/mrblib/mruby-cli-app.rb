def __main__(argv)
  if argv[1] == "version"
    puts "v#{MrubyCliApp::VERSION}"
  else
    puts "Hello World"
  end
end
