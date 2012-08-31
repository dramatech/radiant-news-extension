require File.expand_path("../../spec_helper", __FILE__)

describe Page do
  its(:news?){should be_false}
end
