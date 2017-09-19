class Note
  attr_reader :release

  def initialize(release)
    @release = release
    add_header
    add_list
  end

  def header
    "Release for #{release.name}"
  end

  def to_html
    document.to_html
  end

  def path
    "#{release.path}/#{release.serialization_name}.html"
  end

  def save
    release.init_file_system!

    FS.open_file(path, 'w+') do |f|
      f << to_html
    end
  end

  private
    def document
      @document ||= Nokogiri::HTML::Document.new
    end

    def body
      @body ||= create_element_into(document, 'body')
    end

    def create_element(name, value = nil, **attributes)
      document.create_element(name, value, attributes)
    end

    def create_element_into(element, name, value = nil, **attributes)
      new_element = create_element(name, value, attributes)
      element.add_child(new_element)
      new_element
    end

    def add_header
      create_element_into(body, 'h2', header)
    end

    def add_list
      ul = create_element_into(body, 'ul')

      release.commits.each do |commit|
        li = create_element_into(ul, 'li')

        create_element_into(li, 'div', commit.author)
        create_element_into(li, 'div', commit.pretty_date)
        create_element_into(li, 'div', commit.message)
      end
    end

end
