require 'minitest/autorun'

def macos?
  ENV['RUNNER_OS'] && ENV['RUNNER_OS'] == 'macOS'
end

def arm?
  ENV['ARM']
end

class WithDockerTest < Minitest::Test
  SETUP = begin
            `docker-compose build --no-cache` if !macos?
          end

  def test_with_ubuntu_20
    test_on_x86 with: 'ubuntu_20.04'
  end

  def test_with_ubuntu_22
   test_on_x86 with: 'ubuntu_22.04'
  end

  def test_with_ubuntu_24
    test_on_x86 with: 'ubuntu_24.04'
   end

  private

  def test_on_x86(with:)
    test_on_docker(with: with) if !macos? && !arm?
  end

  def test_on_x86_and_arm(with:)
    test_on_docker(with: with) unless macos?
  end

  def test_on_docker(with:)
    assert_match(/wkhtmltopdf 0\.12\.6(.1)? \(with patched qt\)/, `docker-compose run --rm #{with}`.strip)
  end
end
