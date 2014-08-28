require 'spec_helper'
require 'query_report/column_module/dsl'
require 'fake_app/active_record/config'
require 'fake_app/active_record/models'

if defined? ActiveRecord
  describe QueryReport::ColumnModule do
    class DummyClass
      include QueryReport::ColumnModule::DSL

      def array_record?
        false
      end
    end
    let(:object) { DummyClass.new }
    before do
      object.columns = []
      allow(object).to receive(:model_class).and_return(Readership)
    end

    context 'defined columns' do
      before { object.column :user_id }
      subject(:column) { object.columns.first }
      it("returns") { expect(column.name).to be :user_id }
      it("returns") { expect(column.type).to be :integer }
    end

    context 'custom columns' do
      before do
        object.column :user, type: :integer do |obj|
          link_to obj.user.name, obj.user
        end
      end
      subject(:column) { object.columns.first }
      it("returns") { expect(column.name).to be :user }
      it("returns") { expect(column.type).to be :integer }
      it("returns data") { expect(column.data).not_to be_nil }
    end

    describe '#humanize' do
      context 'with built in readable column name' do
        before { object.column :user_id }
        subject(:column) { object.columns.first }
        it("returns") { expect(column.humanize).to eq 'User' }
      end

      context 'with custom column name' do
        before { object.column :user_id, as: 'Admin' }
        subject(:column) { object.columns.first }
        it("returns") { expect(column.humanize).to eq 'Admin' }
      end
    end

    describe '#value' do
      context 'with value from db property' do
        let(:record) { Readership.new(user_id: 1) }
        before { object.column :user_id }
        subject(:column) { object.columns.first }

        it 'fetches property value' do
          expect(subject.value(record)).to eq 1
        end
      end
    end

    describe '#only_on_web?' do
      context 'with set to true' do
        before { object.column :user_id, only_on_web: true }
        subject(:column) { object.columns.first }
        it("returns") { expect(column.only_on_web?).to eq true }
      end

      context 'with not set' do
        before { object.column :user_id }
        subject(:column) { object.columns.first }
        it("returns") { expect(column.only_on_web?).to eq false }
      end
    end

    describe '#sortable?' do
      context 'with set to true' do
        before { object.column :user_id, sortable: true }
        subject(:column) { object.columns.first }
        it("returns") { expect(column.sortable?).to eq true }
      end

      context 'with not set' do
        before { object.column :user_id, sortable: 'users.id' }
        subject(:column) { object.columns.first }
        it("returns") { expect(column.sortable?).to eq true }
      end
    end

    describe '#sort_link_attribute' do
      context 'with set to true' do
        before { object.column :user_id, sortable: true }
        subject(:column) { object.columns.first }
        it("returns") { expect(column.sort_link_attribute).to eq :user_id }
      end

      context 'with not set' do
        before { object.column :user_id, sortable: 'users.id' }
        subject(:column) { object.columns.first }
        it("returns") { expect(column.sort_link_attribute).to eq 'users.id' }
      end
    end
  end
end