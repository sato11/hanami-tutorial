RSpec.describe Web::Controllers::Books::Create, type: :action do
  let(:interactor) { instance_double('AddBook', call: nil) }
  let(:action) { described_class.new(interactor: interactor) }

  context 'with valid parameters' do
    let(:params) { Hash[book: { title: 'Confident Ruby', author: 'Avdi Grimm' }] }

    it 'calls interactor' do
      expect(interactor).to receive(:call)
      action.call(params)
    end

    it 'redirects the user to the books listing' do
      response = action.call(params)

      expect(response[0]).to eq(302)
      expect(response[1]['Location']).to eq('/books')
    end
  end

  context 'with invalid parameters' do
    let(:params) { Hash[book: {}] }

    it 'does not call interactor' do
      expect(interactor).to_not receive(:call)
      action.call(params)
    end

    it 'returns HTTP client error' do
      response = action.call(params)
      expect(response[0]).to eq(422)
    end

    it 'dumps errors in params' do
      action.call(params)
      errors = action.params.errors

      expect(errors.dig(:book, :title)).to eq(['is missing'])
      expect(errors.dig(:book, :author)).to eq(['is missing'])
    end
  end
end
