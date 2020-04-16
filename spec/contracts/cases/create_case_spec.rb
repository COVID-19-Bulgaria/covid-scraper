# frozen_string_literal: true

RSpec.describe CovidScraper::Contracts::Cases::CreateCase do
  context 'requires attributes' do
    let(:input) do
      {}
    end

    let(:result) { subject.call(input) }

    it 'is invalid' do
      expect(result).to be_failure
      expect(result.errors[:infected]).to include('is missing')
      expect(result.errors[:cured]).to include('is missing')
      expect(result.errors[:fatal]).to include('is missing')
      expect(result.errors[:timestamp]).to include('is missing')
      expect(result.errors[:country_id]).to include('is missing')
    end
  end

  context 'given valid parameters' do
    let(:input) do
      {
        infected: 0,
        cured: 0,
        fatal: 0,
        men: 0,
        women: 0,
        hospitalized: 0,
        intensive_care: 0,
        medical_staff: 0,
        timestamp: Time.now,
        country_id: 1
      }
    end

    let(:result) { subject.call(input) }

    it 'is valid' do
      expect(result).to be_success
    end
  end
end
