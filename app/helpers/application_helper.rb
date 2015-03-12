module ApplicationHelper

 # Returns the full title on a per-page basis.
   def full_title(page_title)
       base_title = "CUFCQ"
           if page_title.empty?
                 base_title
                     else
                           "#{base_title} | #{page_title}"
                      end
            end
    end

    def sortable(title, column)
        # title ||= column.titleize
        # css_class = column == sort_column ? "current #{sort_direction}" : nil
        direction = ((column == sort_column) || (sort_column == "data -> '#{column}'")) && sort_direction == "asc" ? "desc" : "asc"
        # direction = sort_direction == "asc" ? "desc" : "asc"
        link_to title, {:sort => column, :direction => direction}
    end
