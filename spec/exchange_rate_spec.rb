RSpec.describe ExchangeRate do
  it 'has a version number' do
    expect(ExchangeRate::VERSION).not_to be nil
  end
  describe '#at' do
    it 'expects an error if arguments are missing' do
      expect{ExchangeRate.at(nil, nil, nil)}.to raise_error(ArgumentError)
    end
  end
end
