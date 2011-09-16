module FileHelpers
  def owner_and_group(path)
    stat = File.stat(File.join(current_dir, path))
    {:gid => stat.gid, :uid => stat.uid}
  end
end
World(FileHelpers)