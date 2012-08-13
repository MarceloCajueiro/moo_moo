module MooMoo
  class ParseOpenSRS < Faraday::Response::Middleware

    def on_complete(env)
      @env = env

      @env[:body] = parsed_body
    end

    def response_values(env)
      {
        :status  => env[:status],
        :headers => env[:response_headers],
        :body    => env[:body]
      }
    end

  private

    # Parses an XML response from the OpenSRS registry and generates a
    # hash containing all of the data. Elements with child elements
    # are converted into hashes themselves, with the :element_text entry
    # containing any raw text
    def parsed_body
      build_xml_hash(body_elements)
    end

    # Get only REXML elements from OpenSRS registry
    def body_elements
      body_as_document.elements["/OPS_envelope/body/data_block/dt_assoc"].select do |item|
        item.is_a? REXML::Element
      end
    end

    # Convert OpenSRS registry body to a REXML::Document object
    def body_as_document
      @body_as_document ||= REXML::Document.new(@env[:body])
    end

    # Builds a hash from a collection of XML elements
    #
    # ==== Required
    #  * <tt>elements</tt> - collection of elemenents
    def build_xml_hash(elements)
      data_hash = {}

      elements.each do |element|
        key = element.attributes['key']

        if element.elements.size > 0
          if key.nil?
            data_hash.merge!(build_xml_hash(element.elements))
          else
            data_hash[key] = build_xml_hash(element.elements)
          end
        else
          data_hash[key] = element.text unless key.nil?
        end
      end

      data_hash
    end

  end
end
