# Autor: Resque
# E-mail: Rogessonb@gmail.com
# Data: 28/01/2017
# Engine: RPG Maker Ace VX

module RTest
  class Test
    extend Rmock

    attr_accessor :current_test_name
    @@subject = nil

    protected

    def self.subject
      @@subject = yield if block_given?
      @@subject
    end

    def self.before(&block)
      yield
    end

    def self.describe(method_name)
      yield
    end

    def self.assert(value)
      return true if value == true
      default_error_message(true, value)
    end

    def self.assert_equal(this, that)
      return true if this == that

      default_error_message(this, that)
    end

    def self.assert_not_equal(this, that)
      return true if this != that

      default_error_message(this, that)
    end

    def self.it(test_name, &block)
      @current_test_name = test_name
      if yield == true
        print '.'
      else
        puts "Error Test: #{test_name}"
        puts yield
      end
    end

    def self.allow(resource)
      resource.define_singleton_method(:to_receive) do |*args|
        method_name = args.first
        original_args_size = self.method(method_name).arity

        fake_arg_size = args.size - 1

        if original_args_size != fake_arg_size && !self.singleton_methods.include?(method_name)
          raise ArgumentError.new("Method [#{method_name}] wrong number of arguments (#{fake_arg_size} for #{original_args_size})")
        end

        self.define_singleton_method(method_name) do |*args|
          yield if block_given?
        end

        self
      end

      resource
    end

    private

    def self.default_error_message(that, this)
      puts "\nError Test: #{@current_test_name}\n"
      puts "\n    - The expected value was <#{that}>, but <#{this}> was founded\n"
    end

    @@subject = nil
  end
end