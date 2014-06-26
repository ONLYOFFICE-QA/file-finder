module ListDocumentsHelper
  TAGS = %w(paragraph table image shape chart group_shape column section formula)
  TM_PORTAL = 'https://testinfo.teamlab.info'
  USERNAME = 'alexeysemin88@gmail.com'
  PASSWORD = '123456'

  def filter_documents(params)
    @list_documents = ListDocument.all.to_a
    parse_parameters(params)
    return @list_documents if @parsed_params.empty?
    @list_documents.select! { |list_document| compare_document(list_document) }
  end

  private

  def parse_parameters(params)
    @parsed_params = {}
    TAGS.each do |element|
      if params["#{element}_checkbox".to_sym].to_i == 1
        @parsed_params["#{element}s".to_sym] = {from: params["#{element}s_from"].to_i}
        @parsed_params["#{element}s".to_sym][:to] = params["#{element}s_to"].to_i if params["#{element}s_to"]
      end
    end
  end

  def compare_document(list_document)
    result = true
    @parsed_params.each do |key, value|
      list_document_value = list_document.attributes['tags'][key]
      result &&= (list_document_value >= value[:from]) && (value.has_key?(:to) ? (list_document_value <= value) : true)
    end
    result
  end
end