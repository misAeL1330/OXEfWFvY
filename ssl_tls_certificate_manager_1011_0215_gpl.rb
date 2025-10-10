# 代码生成时间: 2025-10-11 02:15:23
# SSL/TLS Certificate Manager
# This service manages SSL/TLS certificates using Ruby and Hanami framework.
class SslTlsCertificateManager
  # Initialize a new instance of the SSL/TLS Certificate Manager
  #
  # @param [String] certificate_path the path to the certificate file
  # @param [String] private_key_path the path to the private key file
  def initialize(certificate_path, private_key_path)
    @certificate_path = certificate_path
    @private_key_path = private_key_path
  end

  # Generate a new SSL/TLS certificate
  #
  # @return [OpenSSL::X509::Certificate] the generated certificate
  def generate_certificate
    raise 'Private key file not found' unless File.exist?(@private_key_path)
    raise 'Certificate file path not provided' unless @certificate_path

    certificate = OpenSSL::X509::Certificate.new
    certificate.version = 2
    certificate.serial = OpenSSL::BN.new('1001', 2)
    certificate.subject = OpenSSL::X509::Name.new([['C', 'US'], ['ST', 'New York'], ['L', 'New York'], ['O', 'My Company'], ['CN', 'localhost']])
    certificate.issuer = certificate.subject
    certificate.public_key = OpenSSL::PKey::RSA.new(File.read(@private_key_path))
    certificate.not_before = Time.now
    certificate.not_after = Time.now + 365 * 24 * 60 * 60 # 1 year validity
    ef = OpenSSL::X509::ExtensionFactory.new
    ef.subject_certificate = certificate
    ef.issuer_private_key = OpenSSL::PKey::RSA.new(File.read(@private_key_path))
    certificate.extensions = [ef.create_extension('basicConstraints', 'CA:TRUE', true)]
    certificate.sign(ef.issuer_private_key, OpenSSL::Digest::SHA256.new)

    save_certificate(certificate)
    certificate
  end

  private

  # Save the certificate to a file
  #
  # @param [OpenSSL::X509::Certificate] certificate the certificate to save
  def save_certificate(certificate)
    File.open(@certificate_path, 'wb') do |file|
      file.write certificate.to_pem
    end
  rescue => e
    puts "Failed to save certificate: #{e.message}"
  end

  # Load a certificate from a file
  #
  # @param [String] path the path to the certificate file
  # @return [OpenSSL::X509::Certificate] the loaded certificate
  def load_certificate(path)
    OpenSSL::X509::Certificate.new(File.read(path))
  rescue => e
    puts "Failed to load certificate: #{e.message}"
    nil
  end
end
