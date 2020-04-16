# frozen_string_literal: true

RSpec.describe CovidScraper::Repositories::CasesRepository do
  context '#create' do
    it 'creates a case' do
      new_case = subject.create(
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
      )

      expect(new_case).to be_a(CovidScraper::Case)
      expect(new_case.infected).to eq(0)
      expect(new_case.cured).to eq(0)
      expect(new_case.fatal).to eq(0)
      expect(new_case.men).to eq(0)
      expect(new_case.women).to eq(0)
      expect(new_case.hospitalized).to eq(0)
      expect(new_case.intensive_care).to eq(0)
      expect(new_case.medical_staff).to eq(0)
      expect(new_case.timestamp).not_to be_nil
      expect(new_case.country_id).to eq(1)
    end
  end
end
