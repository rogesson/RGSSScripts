# Autor: Resque
# E-mail: Rogessonb@gmail.com
# Data: 28/01/2017
# Engine: RPG Maker Ace VX

module Rmock
  def self.define(klass_name, opt)
    name = opt[:as]
    Struct.new(klass_name)
    struct_class = Object.const_set("#{klass_name}", Struct.new(nil)).new

    self.create_instance_method(struct_class,name)

    yield struct_class

    self.create_class_method(struct_class, name)

    struct_class
  end

  private

  def self.create_instance_method(struct_class, name)
    struct_class.instance_eval do
      def self.method_missing(name, *args)
        self.class.instance_eval do
          define_method name do
            args.first
          end
        end
      end
    end
  end

  def self.create_class_method(struct_class, name)
    Object.class_eval do
      define_method name do
        struct_class
      end
    end
  end
end