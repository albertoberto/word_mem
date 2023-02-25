# frozen_string_literal: true

require_relative '../lib/word_mem'

RSpec.describe WordMem do
  it 'has a version number' do
    expect(WordMem::VERSION).not_to be nil
  end

  it 'specifies a project root' do
    expect(WordMem::PROJECT_ROOT).to eq(
      File.expand_path(File.join(__dir__, '..'))
    )
  end
end
