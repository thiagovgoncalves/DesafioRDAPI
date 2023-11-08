require 'httparty'

class CepInfo
  VIA_CEP_BASE_URL = 'https://viacep.com.br/ws/'

  def initialize(cep)
    @cep = cep
    @url = "#{VIA_CEP_BASE_URL}#{@cep}/json"
  end

  def consultar
    response = HTTParty.get(@url)

    case response.code
    when 200
      parse_and_display_data(response.body)
    when 404
      handle_not_found
    else
      handle_error(response.code)
    end
  end

  private

  def parse_and_display_data(response_body)
    data = JSON.parse(response_body)
    display_logradouro(data['logradouro'])
    display_dd(data['ibge'])
  end

  def display_logradouro(logradouro)
    if logradouro
      puts "Logradouro: #{logradouro}"
    else
      puts "Logradouro não encontrado."
    end
  end

  def display_dd(ibge)
    if ibge
      puts "DD (Código de Discagem Direta): #{ibge[3..4]}"
    else
      puts "DD (Código de Discagem Direta) não encontrado."
    end
  end

  def handle_not_found
    puts "CEP não encontrado."
  end

  def handle_error(response_code)
    puts "Erro ao consultar o CEP. Código de resposta: #{response_code}"
  end
end

# Mude o CEP para efetuar a pesquisa
cep = '84020420'
cep_info = CepInfo.new(cep)
cep_info.consultar