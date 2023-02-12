# frozen_string_literal: true

require 'word_mem/cli'

require_relative '../../../lib/word_mem'

RSpec.describe WordMem::CLI do
  subject(:cli) { described_class.new }

  let(:test_db_content) { File.read(test_db) }
  let(:test_db) do
    File.join(WordMem::PROJECT_ROOT, 'spec', 'integration', 'word_mem', 'db', 'db.csv')
  end

  let(:expression) { 'dummy' }

  before do
    stub_const('WordMem::Database::DB_FILE', test_db)
    cli.clear_db
  end

  after do
    cli.clear_db
  end

  describe '#add' do
    subject(:method_call) { cli.add(expression) }

    context 'with a non-empty empty expression database' do
      before do
        cli.add('word_that_was_already_there')
      end

      it "adds an expression to the project's expression database" do
        method_call
        expect(test_db_content.lines.length).to eq(2)
      end
    end

    context 'with an empty expression database' do
      it "adds an expression to the project's expression database" do
        method_call
        expect(test_db_content.lines.length).to eq(1)
      end
    end
  end

  describe '#clear_db' do
    subject(:method_call) { cli.clear_db }

    context 'with a non-empty expression database' do
      before do
        cli.add(expression)
      end

      it "removes all expressions from the project's expression database" do
        method_call
        expect(test_db_content.lines.length).to eq(0)
      end
    end

    context 'with an empty expression database' do
      it "removes all expressions from the project's expression database" do
        method_call
        expect(test_db_content.lines.length).to eq(0)
      end
    end
  end
end
