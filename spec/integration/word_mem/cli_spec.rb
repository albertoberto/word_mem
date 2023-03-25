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

  describe '#reset_db' do
    subject(:method_call) { cli.reset_db }

    context 'with a non-empty expression database' do
      let(:db_element) { WordMem::Database.new.elements.first }
      let(:element_reset?) do
        db_element.expression == expression.expression &&
          db_element.reviews_b2t.to_i.zero? &&
          db_element.reviews_t2b.to_i.zero? &&
          db_element.score_b2t.to_i.zero? &&
          db_element.score_t2b.to_i.zero?
      end

      let(:expression) do
        WordMem::DatabaseElement.new(
          expression: 'dummy',
          reviews_b2t: 1,
          reviews_t2b: 1,
          score_b2t: 1,
          score_t2b: 1
        )
      end

      before do
        db = WordMem::Database.new
        db.append(expression)
        db.persist
      end

      after do
        cli.clear_db
      end

      it "resets all expressions in the project's expression database" do
        method_call
        expect(element_reset?).to be true
      end
    end

    context 'with an empty expression database' do
      it "doesn't raise any error" do
        expect { method_call }.not_to raise_error
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

  describe '#add' do
    subject(:method_call) { cli.add(expression) }

    context 'with a non-empty expression database' do
      before do
        cli.add('word_that_was_already_there')
      end

      it "adds an expression to the project's expression database" do
        method_call
        expect(test_db_content.lines.length).to eq(2)
      end

      context 'with multiple words to be added' do
        subject(:method_call) { cli.add('dummy1', 'dummy2') }

        it "adds all expressions to the project's expression database" do
          method_call
          expect(test_db_content.lines.length).to eq(3)
        end
      end
    end

    context 'with an empty expression database' do
      it "adds an expression to the project's expression database" do
        method_call
        expect(test_db_content.lines.length).to eq(1)
      end

      context 'with multiple words to be added' do
        subject(:method_call) { cli.add('dummy1', 'dummy2') }

        it "adds all expressions to the project's expression database" do
          method_call
          expect(test_db_content.lines.length).to eq(2)
        end
      end
    end
  end

  describe '#remove' do
    subject(:method_call) { cli.remove(expression) }

    context 'with a non-empty expression database' do
      context 'with one word to be removed' do
        let(:expression) { 'dummy' }

        before do
          described_class.new.add(expression)
        end

        it "removes an expression from the project's expression database" do
          method_call
          expect(test_db_content.lines.length).to eq(0)
        end
      end

      context 'with multiple words to be removed' do
        subject(:method_call) { cli.remove('dummy1', 'dummy2') }

        before do
          described_class.new.add('dummy1', 'dummy2')
        end

        it "removes all expressions from the project's expression database" do
          method_call
          expect(test_db_content.lines.length).to eq(0)
        end
      end
    end

    context 'with an empty expression database' do
      context 'with one word to be removed' do
        it "doesn't change anything" do
          method_call
          expect(test_db_content.lines.length).to eq(0)
        end

        it "doesn't raise any error" do
          expect { method_call }.not_to raise_error
        end
      end

      context 'with multiple words to be removed' do
        subject(:method_call) { cli.remove('dummy1', 'dummy2') }

        it "doesn't change anything" do
          method_call
          expect(test_db_content.lines.length).to eq(0)
        end

        it "doesn't raise any error" do
          expect { method_call }.not_to raise_error
        end
      end
    end
  end
end
