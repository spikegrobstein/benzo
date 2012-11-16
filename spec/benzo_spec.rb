require File.dirname(__FILE__) + '/spec_helper'

describe Benzo do

  context "#map!" do

    it "should append to @line if v evaluates to true"

    it "should not append to @line if v is nil"

    it "should not append to @line if v is false"

    it "should add to @vars if there's a symbol in the string"

    it "should not add to @vars if there's no symbol in the string"

  end

  context "#get_symbol" do

    it "should return the first symbol it sees"

    it "should find symbols with underscores"

    it "should find symbols with question mark"

    it "should not find symbols with dash"

    it "should not include dots in the symbol"

  end

end
