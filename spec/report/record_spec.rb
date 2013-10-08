require 'spec_helper'
require 'query_report/column'
require 'query_report/record'

describe QueryReport::Record do
  class DummyClass
    include QueryReport::Record
  end
  let(:object) { DummyClass.new }

  describe 'rowspan' do
    before do
      @columns = [QueryReport::ColumnModule::Column.new(object, :name, as: 'Name'),
                  QueryReport::ColumnModule::Column.new(object, :email, as: 'Email')]
      object.instance_variable_set(:@columns, @columns)
      object.stub(:records).and_return(
          [
              {'Name' => 'ashraf', 'Email' => 'ashraf@moteel.com'},
              {'Name' => 'ashraf', 'Email' => 'ashraf@tasawr.com'},
              {'Name' => 'zahid',  'Email' => 'zahid@gmail.com'},
              {'Name' => 'zahid',  'Email' => 'zahid@gmail.com'},
              {'Name' => 'zahid',  'Email' => 'zahid@gmail.com'}
          ]
      )
    end

    describe '#rowspan_for' do
      it 'returns rowspan_for' do
        object.rowspan_for(@columns[0], 0).should == 2
        object.rowspan_for(@columns[0], 2).should == 1
      end
    end

    describe '#new_row_for_rowspan' do
      it 'returns new_row_for_rowspan' do
        object.new_row_for_rowspan?(@columns[0], 0).should == true
        object.new_row_for_rowspan?(@columns[0], 1).should == false
        object.new_row_for_rowspan?(@columns[0], 2).should == true
      end
    end
  end
end