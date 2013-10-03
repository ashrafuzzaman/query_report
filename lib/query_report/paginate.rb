# Author::    A.K.M. Ashrafuzzaman  (mailto:ashrafuzzaman.g2@gmail.com)
# License::   MIT-LICENSE

# The purpose of the paginate module is to offer support for pagination

module QueryReport
  module PaginateModule
    def apply_pagination(query, params)
      if paginate?
        page_method_name = Kaminari.config.page_method_name
        query.send(page_method_name, params[:page])
      else
        query
      end
    end
  end
end