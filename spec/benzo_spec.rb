require File.dirname(__FILE__) + '/spec_helper'

describe Benzo do

  let(:benzo) { Benzo.new 't', {} }

  context "::run!" do

    it "should not error out" do
      lambda { Benzo.run! 'echo', 'hello world' => true }.should_not raise_error
    end

    it "should return the correct output" do
      Benzo.run!('echo', '-n hello world' => true ).should == 'hello world'
    end

  end

  context "::command!" do

    it "should not error out" do
      lambda { Benzo.command! 'echo', 'hello world' => true }.should_not raise_error
    end

    it "should return the correct command" do
      Benzo.command!('echo', 'hello world' => true).should == 'echo hello world'
    end

  end

  context "#cocaine" do
    let(:benzo) { Benzo.new 'echo', '-n' => true, 'hello world' => true }

    it "should return a Cocaine::CommandLine object" do
      benzo.cocaine.class.should == ::Cocaine::CommandLine
    end

    it "should return a Cocaine::CommandLine object with the correct things set" do
      benzo.cocaine.instance_variable_get('@params').should == '-n hello world'
    end

    it "should return a Cocaine::CommandLine object with the right Cocaine options"

  end

  context "#command" do
    let(:benzo) { Benzo.new 'echo', 'hello world' => true }

    it "should properly interpolate variables" do
      benzo.command.should == 'echo hello world'
    end

  end

  context "#map!" do

    it "should append to @line if v evaluates to true" do
      benzo.options_map = { ':file_name' => 'demo.dat' }
      benzo.send(:map!)

      benzo.line.count.should == 1
      benzo.line.first.should == ':file_name'
    end

    it "should not append to @line if v is nil" do
      benzo.options_map = { ':file_name' => nil }
      benzo.send(:map!)

      benzo.line.count.should == 0
    end

    it "should not append to @line if v is false" do
      benzo.options_map = { ':file_name' => false }
      benzo.send(:map!)

      benzo.line.count.should == 0
    end

    it "should add to @vars if there's a symbol in the string" do
      benzo.options_map = { ':file_name' => 'demo.dat' }
      benzo.send(:map!)

      benzo.vars.keys.count.should == 1
      benzo.vars.keys.first.should == :file_name
    end

    it "should not add to @vars if there's no symbol in the string" do
      benzo.options_map = { '-v' => true }
      benzo.send(:map!)

      benzo.vars.keys.count.should == 0
    end

    it "should append the value to @vars if the key is a symbol" do
      benzo.options_map = { :logger => 'this_logger' }
      benzo.send(:map!)

      benzo.vars[:logger].should_not be_nil
    end

  end

  context "#get_symbol" do

    def get_symbol(str)
      benzo.send(:get_symbol, str)
    end

    it "should find the symbol" do
      get_symbol('-f :file').should == :file
    end

    it "should return the first symbol it finds" do
      get_symbol('-a :file :gooop').should == :file
    end

    it "should find symbols with underscores" do
      get_symbol('-d :db_name').should == :db_name
    end

    it "should find symbols with capital letters" do
      get_symbol(':FileName').should == :FileName
    end

    it "should raise an error if the symbol has other chars" do
      lambda { get_symbol('-q :what?') }.should raise_error
    end

    it "should raise an error when encountering symbols with dash" do
      lambda { get_symbol('-f :this-that') }.should raise_error
    end

    it "should not include dots in the symbol" do
      lambda { get_symbol('-f :file.ext') }.should raise_error
    end

  end

  context "when checking the ruby version" do

    it "should print a warning if the ruby version is 1.8"

  end

end
