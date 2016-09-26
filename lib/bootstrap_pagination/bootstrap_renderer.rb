require "bootstrap_pagination/version"

module BootstrapPagination
  # Contains functionality shared by all renderer classes.
  module BootstrapRenderer
    ELLIPSIS = "&hellip;"

    def to_html
      list_items = pagination.map do |item|
        case item
          when Fixnum
            page_number(item)
          else
            send(item)
        end
      end.join(@options[:link_separator])

      tag("nav", tag("ul", list_items, class: ul_class), "aria-label" => @options[:label], class: @options[:class])
    end

    def container_attributes
      super.except(*[:link_options])
    end

    protected

    def page_number(page)
      link_options = @options[:link_options] || {}

      if page == current_page
        tag("li", tag("span", "#{page} #{tag("span", "(current)", class: "sr-only")}", class: "page-link"), class: "page-item active")
      else
        tag("li", link(page, page, link_options.merge(class: "page-link")), class: "page-item")
      end
    end

    def previous_or_next_page(page, text)
      link_options = @options[:link_options] || {}

      if page
        tag("li", link(text, page, link_options.merge(class: "page-link")), class: "page-item")
      else
        tag("li", tag("span", text, class: "page-link"), class: "%s disabled" % "page-item")
      end
    end

    def gap
      tag("li", tag("span", ELLIPSIS, class: "page-link"), class: "disabled page-item")
    end

    def previous_page
      num = @collection.current_page > 1 && @collection.current_page - 1
      previous_or_next_page(num, tag("span", "&laquo;", "aria-hidden" => "true"))
    end

    def next_page
      num = @collection.current_page < @collection.total_pages && @collection.current_page + 1
      previous_or_next_page(num, tag("span", "&raquo;", "aria-hidden" => "true"))
    end

    def ul_class
      ["pagination", @options[:class]].compact.uniq.join(" ")
    end
  end
end
