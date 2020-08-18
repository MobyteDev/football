class CallPasswordService

  API_KEY_REQUEST = '92c75650440929988fd4c335491d8b9da5a704516d388959'.freeze
  API_REY_SIGN = '0948c86e97c5824b41b4b7e3d3dac5b14e69ce959fa5d37b'.freeze


  require 'uri'
  require 'net/http'

  def initialize(phone_number, pin)
    @phone_number = phone_number.gsub(/[^0-9]+/, '')
    @pin = pin
    @time = Time.now.to_i.to_s
    @method_name = 'call-password/start-password-call'
  end

  def send_request_call_password
    uri = URI('https://api.new-tel.net/call-password/start-password-call') 
    params = {'async': 1, 'dstNumber': @phone_number, 'pin': @pin}.to_json
    headers = {
      'Authorization': "Bearer #{get_request_key(@method_name, API_KEY_REQUEST, params, API_REY_SIGN)}",
      'Content-Type': 'application/json'
    }
    return Net::HTTP.post(uri, params, headers)
  end

  private

  def get_request_key(method_name, access_key, params, signature_key)
    sha256 = Digest::SHA256.hexdigest(method_name + "\n" + @time + "\n" + access_key + "\n" + params + "\n" + API_REY_SIGN)
    return access_key + @time + sha256
  end

end