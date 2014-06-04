# Author::    A.K.M. Ashrafuzzaman  (mailto:ashrafuzzaman.g2@gmail.com)
# License::   MIT-LICENSE

# The purpose of the column module is to define columns that are displayed in the views

module QueryReport
  module ColumnModule
    attr_accessor :columns

    # Creates a filter and adds to the filters
    # @param name the column on which the filter is done on
    # @option options [Symbol] :type date | text | whatever
    # @option options [String] :as The title of the column, by default it fetches from the I18n column translation, Model.human_attribute_name(column_name)
    # @option options [Boolean] :show_total set true to calculate total for that column. It will render the total in the footer.
    # @option options [Boolean] :only_on_web the column will appear on the web and not appear in PDF, CSV or JSON if set to true
    # @option options [Boolean] :sortable if set to true then sorts on that column, but if the sorting has to be on a joint table then you have to specify the column on which the sorting will happen
    # @option options :rowspan the rows with same values in the same column will span if set to true
    #
    # @example Row span
    #   column :invoiced_to_name, rowspan: true
    #   column :invoice_title
    #   column :invoice_date, rowspan: :invoiced_to_name
    #   ┌───────────┬────────────┬─────────────────┐
    #   │ Name      │  Invoice   │   Invoiced on   │
    #   ├───────────┼────────────┼─────────────────┤
    #   │           │  Invoice1  │                 │
    #   │ Jitu      ├────────────┤    2-2-2014     │
    #   │           │  Invoice2  │                 │
    #   ├───────────┼────────────┼─────────────────┤
    #   │ Setu      │  Invoice3  │    2-2-2014     │
    #   └───────────┴────────────┴─────────────────┘
    #
    # @example Show total
    #   column :invoiced_to_name, rowspan: true
    #   column :invoice_title
    #   column :total_charged, show_total: true
    #   ┌───────────┬────────────┬─────────────────┐
    #   │ Name      │  Invoice   │   Total charge  │
    #   ├───────────┼────────────┼─────────────────┤
    #   │           │  Invoice1  │      100        │
    #   │ Jitu      ├────────────┼─────────────────┤
    #   │           │  Invoice2  │      120        │
    #   ├───────────┼────────────┼─────────────────┤
    #   │ Setu      │  Invoice3  │       80        │
    #   ├───────────┴────────────┼─────────────────┤
    #   │                  Total │      300        │
    #   └────────────────────────┴─────────────────┘
    # The translation key used for total is 'query_report.total'
    #
    # @example Sorting
    #  column :invoice_date, sortable: true
    #  column :invoice_to, sortable: 'users.name'
    #
    # If you want to sort a column which is a column of the active record model that the query returns,
    # then just set true to make the column sortable.
    # If the column is from another table then you have to specify the column name.
    def column(name, options={}, &block)
      @columns << Column.new(self, name, options, block)
    end

    # @return [Array<Hash>] the footer for the table with total with appropriate colspan and content
    # Sample output
    # [{content: "Total", colspan: '2'}, 200, 300]
    def column_total_with_colspan
      total_with_colspan = []
      colspan = 0
      total_text_printed = false
      columns.each do |column|
        if column.has_total?
          if colspan > 0
            title = total_text_printed ? '' : I18n.t('query_report.total')
            total_with_colspan << (colspan == 1 ? {content: title} : {content: title, colspan: colspan})
          end
          total_with_colspan << {content: column.total, align: column.align}
          total_text_printed = true
          colspan = 0
        else
          colspan += 1
        end
      end
      if colspan > 0
        total_with_colspan << {content: '', colspan: colspan}
      end
      total_with_colspan
    end

    class Column
      include ActionView::Helpers::SanitizeHelper

      attr_reader :report, :name, :options, :type, :data

      def initialize(report, column_name, options={}, block = nil)
        @report, @name, @options = report, column_name, options
        @type = @report.model_class.columns_hash[column_name.to_s].try(:type) || options[:type] || :string rescue :string
        @data = block || column_name.to_sym
      end

      def only_on_web?
        @options[:only_on_web] == true
      end

      def sortable?
        @options[:sortable].present? && @options[:sortable] != false
      end

      def sort_link_attribute
        @options[:sortable] == true ? name : @options[:sortable]
      end

      def rowspan?
        @options[:rowspan] == true || @options[:rowspan].kind_of?(Symbol)
      end

      def rowspan_column_humanized
        return @rowspan_column_humanized if @rowspan_column_humanized
        rowspan_column_name = @options[:rowspan].kind_of?(Symbol) ? @options[:rowspan] : self.name

        report.columns.each do |column|
          if column.name == rowspan_column_name
            @rowspan_column_humanized = column.humanize
            return @rowspan_column_humanized
          end
        end
        @rowspan_column_humanized = self.humanize
      end

      def humanize
        @humanize ||= options[:as] || @report.model_class.human_attribute_name(name)
      end

      def value(record)
        self.data.kind_of?(Symbol) ? (record.respond_to?(self.name) ? record.send(self.name) : record[self.name]) : self.data.call(record)
      end

      def has_total?
        @options[:show_total] == true
      end

      def align
        @options[:align] || (has_total? ? :right : :left)
      end

      def total
        @total ||= begin
          if has_total?
            report.records_with_rowspan.inject(0) do |sum, r|
              r = report.content_from_element(r[humanize])
              r = strip_tags(r) if r.kind_of? String
              sum + r.to_f
            end
          else
            nil
          end
        end
      end
    end
  end
end