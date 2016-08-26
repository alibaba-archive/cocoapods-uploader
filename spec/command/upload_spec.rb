require File.expand_path('../../spec_helper', __FILE__)

module Pod
  describe Command::upload do
    describe 'CLAide' do
      it 'registers it self' do
        Command.parse(%w{ upload }).should.be.instance_of Command::upload
      end
    end
  end
end

