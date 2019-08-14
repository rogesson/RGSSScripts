# Name: Resque Reload
# Autor: Resque
# Email: rogessonb@gmail.com
# Engine: RPG Maker VX
# Created At: 13/08/2019

class Scene_Base
  RELOAD_BUTTON = :F5
  SCRIPT_PATH = "Scripts"
  FULL_PATH = "#{File.expand_path(Dir.pwd)}/#{SCRIPT_PATH}/*.rb"

  DEBUG_MODE = true

  def main
    start
    post_start
    update until scene_changing?
    pre_terminate
    terminate

  rescue Exception => e
    reload_with_error(e)
  end
  
  def update
    update_basic
    
    reload if Input.trigger?(RELOAD_BUTTON)
  end

  def reload
    puts "Reload Button [#{RELOAD_BUTTON}] was pressed"
    puts "Reloading the Code..."
    Scene_Base.load_files
    
    call_current_scene
    
    nil
  end

  def self.load_files
    puts "Loading Files..."
    dirs = Dir[Scene_Base::FULL_PATH]
    failed = []

    dirs.each do |dir| 
      Dir[dir].each do |file|
        begin
          class_name = file.split("/").last[0..-4]

          autoload class_name, file
          load(file)
          puts "#{class_name} Loaded" if Scene_Base::DEBUG_MODE 
        rescue NameError => e 
          failed << { class_name: class_name, file: file }
          next
        end
      end
    end

    self.retry_failed_files(failed)
    puts "Load completed"
  end

  def reload_with_error(e)
    error_message(e)
    SceneManager.call(Scene_Title)
  end

  private

    def self.retry_failed_files(failed_files)
      failed_files.each do |f|
        autoload f[:class_name], f[:file]
        load(f[:file])
        puts "#{f[:class_name]} Loaded" if Scene_Base::DEBUG_MODE 
      end
    end

    def error_message(e)
      puts "-----------------------\nERROR: #{e} \n-> #{e.backtrace}\n-----------------------"
    end

    def call_current_scene
      puts "#{self.class} Reloaded"
      SceneManager.call(self.class)
    end
end

Scene_Base.load_files