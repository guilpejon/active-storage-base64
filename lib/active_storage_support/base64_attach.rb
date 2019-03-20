# Helper method to decode a base64 file and create a StringIO file
module ActiveStorageSupport
  module Base64Attach
    module_function

    def attachment_from_data(attachment)
      fill_attachment_data(attachment, attachment.delete(:data)) if attachment.is_a?(Hash)

      attachment
    end

    def fill_attachment_data(attachment, base64_data)
      return unless base64_data.try(:is_a?, String) && base64_data.strip.start_with?('data')

      headers, data = base64_data.split(',')
      decoded_data  = Base64.decode64(data)

      attachment[:io] = StringIO.new(decoded_data)
      attachment[:content_type] ||= content_type(headers)
    end

    def content_type(headers)
      headers =~ /^data:(.*?)$/
      Regexp.last_match(1).split(';base64').first
    end
  end
end
