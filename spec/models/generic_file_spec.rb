require 'spec_helper'


describe GenericFile do
  before(:each) do 
    @file = GenericFile.new
  end 
  it "should have rightsMetadata" do
    @file.rightsMetadata.should be_instance_of Hydra::RightsMetadata
  end
  it "should have apply_depositor_metadata" do
    @file.apply_depositor_metadata('jcoyne')
    @file.rightsMetadata.edit_access.should == ['jcoyne']
  end
  it "should have a characterization datastream" do
    @file.characterization.should be_kind_of FitsDatastream
  end 
  it "should have a dc desc metadata" do
    @file.descMetadata.should be_kind_of Psu::DcDatastream
  end
end