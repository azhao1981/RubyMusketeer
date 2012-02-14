module ApplicationHelper
	def render_list(list=[], options={})
    if list.is_a? Hash
      options = list
      list = []
    end
    yield(list) if block_given?

    list_type ||= "ul"

    if options[:type] 
      if ["ul", "dl", "ol"].include?(options[:type])
        list_type = options[:type]
      end
    end
    ul = TagNode.new(list_type, :id => options[:id], :class => options[:class] )
    ul.addClass("unstyled") if (options[:type] && options[:type] == "unstyled")
    list.each_with_index do |content, i|
      item_class = []
      item_class << "first" if i == 0
      item_class << "last" if i == (list.length - 1)
      item_content = content
      item_options = {}
      if content.is_a? Array
        item_content = content[0]
        item_options = content[1]
      end

      if item_options[:class]
        item_class << item_options[:class]
      end

      link = item_content.match(/href=(["'])(.*?)(\1)/)[2] rescue nil

      if ( link && current_page?(link) ) || ( @current && @current.include?(link) )
        item_class << "active"
      end

      item_class = (item_class.empty?)? nil : item_class.join(" ")
      ul << li = TagNode.new('li', :class => item_class )
      li << item_content
    end

    return ul.to_s
  end
  # Composite pattern
  class TagNode
    include ActionView::Helpers::TagHelper

    def initialize(name, options = {})
      @name = name.to_s
      @attributes = options
      @children = []
    end

    def addClass(x)
      if @attributes[:class].blank?
        @attributes[:class] = x.to_s
      else
        @attributes[:class] = @attributes[:class] + " #{x}"
      end
    end

    def to_s
      value = @children.each { |c| c.to_s }.join
      content_tag(@name, value.to_s, @attributes, false)
    end

    def <<(tag_node)
      @children << tag_node
    end
  end
end
